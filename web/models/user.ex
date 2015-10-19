defmodule SampleApp.User do
  use SampleApp.Web, :model
  alias Comeonin.Bcrypt

  before_insert :downcase_email
  before_insert :set_password_degit
  before_insert :create_remember_token

  schema "users" do
    field :name,  :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_digest, :string
    field :remember_token,  :string

    timestamps
  end

  @required_fields ~w(name email password)
  @optional_fields ~w(password_confirmation)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name,  max: 50)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/^[\w+\-.]+@[a-z\d\-.]+\.[a-z]+$/)
    |> validate_password
  end

  def authenticate(model, password) do
    Bcrypt.checkpw(password, model.password_digest)
  end

  defp downcase_email(changeset) do
    Changeset.update_change(changeset, :email, &String.downcase/1)
  end

  defp validate_password(changeset) do
    if has_password?(changeset) do
      add_error(changeset, :password, "指定されたパスワードを確認してください")
    else
      changeset
    end
  end

  defp set_password_degit(changeset) do
    password = Changeset.get_field changeset, :password

    if password do
      password_digest = Bcrypt.hashpwsalt password
      Changeset.put_change changeset, :password_digest, password_digest
    else
      changeset
    end
  end

  defp has_password?(changeset) do
    password   = Changeset.get_field(changeset, :password)
    password_c = Changeset.get_field(changeset, :password_confirmation)

    (password || password_c) && (password != password_c)
  end

  def new_remember_token do
    token = SecureRandom.urlsafe_base64

    if SampleApp.Repo.get_by(__MODULE__, remember_token: token) do
      new_remember_token
    else
      token
    end
  end

  def encrypt(token) do
    # sha1が面倒だったのでmd5で代用
    Base.encode16 token, case: :lower
  end

  defp create_remember_token(changeset) do
    Changeset.put_change changeset, :remember_token, encrypt(new_remember_token)
  end
end
