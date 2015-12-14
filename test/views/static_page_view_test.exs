defmodule SampleApp.StaticPageViewTest do
  use SampleApp.ConnCase, async: true

  import Phoenix.View

  defp renderTemplate(action) do
    render_to_string(SampleApp.StaticPageView, action, conn: conn)
  end

  test "renders home.html" do
    actual = renderTemplate("home.html")
    assert Regex.match?(~r/This is the home page for the/, actual)
  end

  test "renders help.html" do
    actual = renderTemplate("help.html")
    assert Regex.match?(~r/help/, actual)
  end

  test "renders about.html" do
    actual = renderTemplate("about.html")
    assert Regex.match?(~r/About Us/, actual)
  end
end
