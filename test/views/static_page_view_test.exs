defmodule SampleApp.StaticPageViewTest do
  use SampleApp.ConnCase, async: true

  import Phoenix.View

  defp renderTemplate(action) do
    render_to_string(SampleApp.StaticPageView, action, %{})
  end

  test "renders home.html" do
    actual = renderTemplate("home.html")
    assert Regex.match?(~r/home sweet/, actual)
  end

  test "renders help.html" do
    actual = renderTemplate("help.html")
    assert Regex.match?(~r/help/, actual)
  end
end
