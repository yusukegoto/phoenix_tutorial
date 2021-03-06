defmodule SampleApp.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use SampleApp.Web, :controller
      use SampleApp.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Model
      use Ecto.Model.Callbacks
      import Ecto.Query
      alias Ecto.Changeset
      alias SampleApp.Repo
      require IEx
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias SampleApp.Repo
      import Ecto.Model
      import Ecto.Query

      import SampleApp.Router.Helpers
      import SampleApp.CurrentUser
      alias SampleApp.Paging.Pager
      require IEx

      defp store_session(conn) do
        put_session(conn, :return_to, conn.request_path)
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
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML
      alias Phoenix.HTML.Link

      import SampleApp.Router.Helpers
      alias SampleApp.Repo
      import SampleApp.Paging.HTML
      require IEx

      # TODO: module
      def current_user(conn) do
        conn.assigns[:current_user]
      end

      def current_user?(conn, user) do
        current_user(conn).id == user.id
      end
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import SampleApp.CurrentUser
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias SampleApp.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 2]

    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
