defmodule SampleApp.UserController do
  use SampleApp.Web, :controller

  def new(conn, _params) do
    render conn, "new.html", title: "Sign up"
  end
end
