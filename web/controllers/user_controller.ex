defmodule SampleApp.UserController do
  use SampleApp.Web, :controller
  alias SampleApp.User
  plug SampleApp.Plugs.Signin

  def new(conn, _params) do
    changeset = User.changeset %User{}
    render conn, "new.html", title: "Sign up", changeset: changeset
  end

  # mapのキーは文字列でくる
  def show(conn, %{"id" => id}) do
    user = conn.assigns[:current_user]

    render conn, "show.html", user: user, title: user.name
  end

  def create(conn, params) do
    changeset = User.changeset(%User{}, params["user"])

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:notice, "success!!")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset, title: "Sign up"
    end
  end
end
