defmodule SampleApp.StaticPageController do
  use SampleApp.Web, :controller
  alias SampleApp.MicroPost
  alias SampleApp.User

  def home(conn, _params) do
    current_user = current_user(conn)
    if current_user do
      changeset = current_user
                  |> Ecto.Model.build(:micro_posts)
                  |> MicroPost.changeset
      feed_items = current_user
                   |> User.feed
    end
    render conn, "home.html", title: "Home", changeset: changeset, feed_items: (feed_items || [])
  end

  def help(conn, _params) do
    render conn, "help.html", title: "Help"
  end

  def about(conn, _params) do
    render conn, "about.html", title: "About Us"
  end
end
