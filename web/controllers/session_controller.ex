defmodule SampleApp.SessionController do
  use SampleApp.Web, :controller
  alias SampleApp.User

  def new(conn, _params) do
    render conn, "new.html", title: "Phoenix"
  end

  def create(conn, %{ "login_params" => %{ "email" => email, "password" => password} }) do
    user = Repo.get_by User, email: email

    if user && User.authenticate(user, password) do
      conn
        |> put_session(:user_id, user.id)
        |> put_flash(:notice, "#{user.id}さんようこそ")
        |> redirect(to: user_path(conn, :show, user))
    else
      conn
        |> put_flash(:error, "Invarid email/password combination")
        |> render("new.html", title: "Phoenix")
    end

    render conn, "new.html", title: "Phoenix"
  end

  def destroy(conn, _params) do
    # signout
    conn
      |> put_resp_cookie("remember_token", nil)
      |> redirect(to: home_path(conn, :home))
  end

  # def sign_in(user) do
  # end
end
