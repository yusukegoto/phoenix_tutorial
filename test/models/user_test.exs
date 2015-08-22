defmodule SampleApp.UserTest do
  use SampleApp.ModelCase

  alias SampleApp.User

  @valid_attrs   %{name: "test", email: "test@test.com"}
  @invalid_attrs %{emal: "error"}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    assert !changeset.valid?
  end
end
