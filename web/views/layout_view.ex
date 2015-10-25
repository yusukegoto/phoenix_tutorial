defmodule SampleApp.LayoutView do
  use SampleApp.Web, :view
  alias SampleApp.User

  def full_title(title) do
    result = if title && title != "" do
               title
             else
               "Phoenix!"
             end
    result
  end

  def signed_in?(conn) do
    !!current_user(conn)
  end

  def current_user(conn) do
    conn.assigns[:current_user]
  end

  def link_to_session_action(conn) do
    if signed_in?(conn) do
      link "Sigin out", to: signout_path(conn, :destroy), method: :delete
    else
      link "Sigin in",  to: signin_path(conn, :new)
    end
  end
end
