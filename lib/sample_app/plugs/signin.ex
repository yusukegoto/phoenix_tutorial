defmodule SampleApp.Plugs.Signin do
  import Plug.Conn
  alias SampleApp.Repo
  alias SampleApp.User

  def init(options) do
    options
  end

  def call(conn, _opts) do
    user = Repo.get User, get_session(conn, :user_id)

    remember_token = User.new_remember_token
    permanent = 60 * 60 * 24 * 365 * 20 # 20年

    changeset = User.changeset(user, %{remember_token: User.encrypt(remember_token)})

    Repo.update(changeset)
    conn
    |> put_resp_cookie("remember_token", remember_token, max_age: permanent)
    |> assign(:current_user, user)
  end
end
