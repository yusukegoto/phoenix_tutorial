defmodule SampleApp.CurrentUser do
  alias SampleApp.Repo
  alias SampleApp.User
  require Ecto.Query

  # plug
  def assign_current_user(conn, _) do
    current_user = current_user(conn)
    Plug.Conn.assign(conn, :current_user, current_user)
  end

  def current_user(conn) do
    remember_token = conn
                     |> Plug.Conn.get_session(:remember_token)
                     |> to_string
                     |> User.encrypt
    Ecto.Query.from(u in User,
      preload: [:micro_posts],
      where: u.remember_token == ^remember_token)
    |> Repo.one
  end
end
