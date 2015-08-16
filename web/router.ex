defmodule SampleApp.Router do
  use SampleApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SampleApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/static_page/home", StaticPageController, :home
    get "/static_page/help", StaticPageController, :help
  end

  # Other scopes may use custom stacks.
  # scope "/api", SampleApp do
  #   pipe_through :api
  # end
end
