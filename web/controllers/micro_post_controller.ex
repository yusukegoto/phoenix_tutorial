defmodule SampleApp.MicroPostController do
  use SampleApp.Web, :controller
  alias SampleApp.User
  alias SampleApp.MicroPost

  plug :signined_in?  when action in [:edit, :update]

  def index(conn, _params) do
    conn
  end

  def create(conn, params) do
    changeset = conn
              |> current_user
              |> Ecto.Model.build(:micro_posts)
              |> MicroPost.changeset(params["micro_post"])
    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:notice, "Micropost created!")
        |> redirect(to: page_path(conn, :index))
      {:error, _} ->
        feed_items = conn
                     |> current_user
                     |> User.feed
        conn
        |> render(SampleApp.StaticPageView, "home.html", changeset: changeset, title: "Home", feed_items: feed_items)
    end
  end

  def delete(conn, %{"id" => id}) do
    MicroPost
    |> Repo.get!(id)
    |> Repo.delete!

    conn
    |> redirect to: home_path(conn, :home)
  end
end
