defmodule SampleApp.SessionController do
  use SampleApp.Web, :controller
  alias SampleApp.User

  # @permanent 60 * 60 * 24 * 365 * 20 # 20年

  def new(conn, _params) do
    render conn, "new.html", title: "Phoenix"
  end

  def create(conn, %{ "login_params" => %{ "email" => email, "password" => password} }) do
    user = Repo.get_by User, email: email

    if user && User.authenticate(user, password) do
      conn
      |> sign_in(user)
      |> put_flash(:notice, "#{user.name}さんようこそ")
      |> redirect(to: user_path(conn, :show, user))
    else
      conn
      |> put_flash(:error, "Invarid email/password combination")
      |> render("new.html", title: "Phoenix")
    end

    render conn, "new.html", title: "Phoenix"
  end

  def destroy(conn, _params) do
    conn
    |> sign_out
    |> redirect(to: home_path(conn, :home))
  end

  # もともとhelperのやつ
  defp sign_in(conn, user) do
    new_remember_token  = User.new_remember_token

    encrypted_token = User.encrypt(new_remember_token)
    changeset = User.changeset4token(user, %{remember_token: encrypted_token})
    {:ok, _} = Repo.update(changeset)

    conn
    |> put_session(:remember_token, new_remember_token)
  end

  defp sign_out(conn) do
    conn
    |> put_session(:remember_token, nil)
  end
end
