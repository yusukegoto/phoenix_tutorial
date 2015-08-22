defmodule SampleApp.User do
  use SampleApp.Web, :model
  use Ecto.Model.Callbacks

  before_insert :downcase_email

  schema "users" do
    field :name,  :string
    field :email, :string

    timestamps
  end

  @required_fields ~w(name email)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name,  max: 50)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/^[\w+\-.]+@[a-z\d\-.]+\.[a-z]+$/)
  end

  defp downcase_email(changeset) do
    if get_field(changeset, :email) do
      change(changeset, email: String.downcase(changeset.email))
    end
  end
end
