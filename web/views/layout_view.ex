defmodule SampleApp.LayoutView do
  use SampleApp.Web, :view

  def full_title(title) do
    result = if title && title != "" do
               title
             else
               "Phoenix!"
             end
    result
  end
end
