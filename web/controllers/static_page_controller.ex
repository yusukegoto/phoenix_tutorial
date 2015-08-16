defmodule SampleApp.StaticPageController do
  use SampleApp.Web, :controller

  def home(conn, _params) do
    render conn, "home.html", title: "Home"
  end

  def help(conn, _params) do
    render conn, "help.html", title: "Help"
  end

  def about(conn, _params) do
    render conn, "about.html", title: "About Us"
  end
end
