defmodule SampleApp.MicroPostTest do
  use SampleApp.ModelCase

  alias SampleApp.MicroPost
  require IEx

  test "content min" do
    post = MicroPost.changeset %MicroPost{}, %{content: ""}
    {message, _} = post.errors[:content]
    assert Regex.match?(~r/at least/, message)
  end

  test "content max" do
    over_max = ["."] |> Stream.cycle |> Enum.take(141) |> Enum.join
    post = MicroPost.changeset %MicroPost{}, %{content: over_max}
    IEx.pry
    {message, _} = post.errors[:content]
    assert Regex.match?(~r/at most/, message)
  end
end
