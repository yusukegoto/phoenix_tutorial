defmodule SampleApp.PageController do
  use SampleApp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", title: nil
  end
end
