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
end
