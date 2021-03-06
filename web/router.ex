defmodule SampleApp.Router do
  use SampleApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SampleApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/home",  StaticPageController, :home, as: :home
    get "/help",  StaticPageController, :help, as: :help
    get "/about", StaticPageController, :about, as: :about

    resources "/users", UserController
    resources "/micro_posts", MicroPostController, only: [:index, :create, :delete]
    resources "/sessions", SessionController, only: [:new, :create, :destroy]

    get    "/signup",   UserController,    :new,     as: :signup
    get    "/signin",   SessionController, :new,     as: :signin
    delete "/signout",  SessionController, :destroy, as: :signout
  end

  # Other scopes may use custom stacks.
  # scope "/api", SampleApp do
  #   pipe_through :api
  # end
end
