defmodule SampleApp.UserController do
  use SampleApp.Web, :controller
  alias SampleApp.User

  plug :signined_in?  when action in [:edit, :update]
  plug :correct_user? when action in [:edit, :update]

  def new(conn, _params) do
    changeset = User.changeset %User{}
    render conn, "new.html", title: "Sign up", changeset: changeset
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get User, id
    changeset = User.changeset user
    conn
    |> render("edit.html", title: "Edit #{user.name}", changeset: changeset, user: user)
  end

  def update(conn, %{"id" => id} = params) do
    user = Repo.get(User, id)

    result = user
             |> User.changeset(params["user"])
             |> Repo.update

    case result do
      {:ok, user} ->
        conn
        |> put_flash(:notice, "Update Success!!")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        conn
        |> render("edit.html", title: "Edit #{user.name}", changeset: changeset, user: user)
    end
  end

  # mapのキーは文字列でくる
  def show(conn, %{"id" => id}) do
    user = Repo.get User, id

    conn
    |> render("show.html", user: user, title: user.name)
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

  # plug
  defp signined_in?(conn, _) do
    case current_user(conn) do
      nil ->
        conn
        |> put_flash(:warning, "ログインが必要です")
        |> redirect(to: signin_path(conn, :new))
      _user ->
        conn
    end
  end

  # plug
  defp correct_user?(conn, _) do
    user = Repo.get User, conn.params["id"]
    if user && current_user(conn) == user,
      do:   conn,
      else: redirect(conn, to: home_path(conn, :home))
  end
end
