defmodule SampleApp.UserController do
  use SampleApp.Web, :controller
  alias SampleApp.User

  plug :signined_in?  when action in [:index, :edit, :update]
  plug :correct_user? when action in [:edit, :update]
  plug :admin? when action in [:delete]

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> String.to_integer

    page_info = Pager.new(User, %{page: page, per_page: 10})

    users = Repo.all page_info.entries
    render conn, "index.html", title: "All users", users: users, page_info: page_info
  end

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

  def delete(conn, params) do
    User
    |> Repo.get!(params["id"])
    |> Repo.delete!

    redirect conn, to: user_path(conn, :index)
  end

  # plug
  defp signined_in?(conn, _) do
    case current_user(conn) do
      nil ->
        conn
        |> store_session()
        |> put_flash(:warning, "ログインが必要です")
        |> redirect(to: signin_path(conn, :new))
        |> halt
      _user ->
        conn
    end
  end

  defp store_session(conn) do
    put_session(conn, :return_to, conn.request_path)
  end

  # plug
  defp correct_user?(conn, _) do
    user = Repo.get User, conn.params["id"]
    if user && current_user(conn) == user,
      do:   conn,
      else: redirect(conn, to: home_path(conn, :home)) |> halt
  end

  defp admin?(conn, _) do
    if current_user(conn).admin,
      do:   conn,
      else: redirect conn, to: signin_path(conn, :new)
  end
end
