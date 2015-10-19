defmodule SampleApp.UserTest do
  use SampleApp.ModelCase

  alias SampleApp.User

  @valid_attrs   %{ name: "test",
                    email: "TEST@test.com",
                    password: "password",
                    password_confirmation: "password"}
  @invalid_attrs %{ emal: "error",
                    password: "" }

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "valid before insert" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
    {:ok, expected} = Repo.insert(changeset)

    assert Comeonin.Bcrypt.checkpw("password", expected.password_digest)
    assert "test@test.com" == expected.email

    refute to_string(expected.remember_token) == ""
    refute is_nil(expected.remember_token)
  end

  test "invalid before insert" do
    changeset = User.changeset %User{}, @invalid_attrs
    {:error, changeset} = Repo.insert(changeset)
    expected = Dict.get changeset.errors, :password

    assert expected =~ ~r/パスワードを確認/
  end

  test "authenticate ok" do
    user = Repo.insert! User.changeset(%User{}, @valid_attrs)
    assert User.authenticate(user, "password")
  end

  test "authenticate ng" do
    user = Repo.insert! User.changeset(%User{}, @valid_attrs)
    refute User.authenticate(user, "")
  end
end
