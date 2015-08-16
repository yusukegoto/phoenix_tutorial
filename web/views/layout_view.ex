defmodule SampleApp.LayoutView do
  use SampleApp.Web, :view

  def full_title(title) do
    result = "Phoenix!"

    if title && title != "" do
      result = result <> " #{title}"
    end

    result
  end
end
