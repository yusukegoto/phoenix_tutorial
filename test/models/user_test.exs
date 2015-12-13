defmodule SampleApp.UserTest do
  use SampleApp.ModelCase

  alias SampleApp.User

  @valid_attrs   %{ name: "test",
                    email: "TEST@test.com",
                    password: "password",
                    password_confirmation: "password"}
  @invalid_attrs %{ email: "error",
                    password: "a",
                    password_confirmation: "b" }

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
    expected = changeset.errors[:password]

    assert Regex.match?(~r/パスワード/, expected)
  end

  test "authenticate ok" do
    user = Repo.insert! User.changeset(%User{}, @valid_attrs)
    assert User.authenticate(user, "password")
  end

  test "authenticate ng" do
    user = Repo.insert! User.changeset(%User{}, @valid_attrs)
    refute User.authenticate(user, "")
  end

  test "token update" do
    changeset = User.changeset %User{}, @valid_attrs
    {:ok, user} = Repo.insert changeset
    old_token = user.remember_token

    new_token = User.new_remember_token |> User.encrypt
    new_changeset = User.changeset4token(user, %{remember_token: new_token})
    {:ok, expected} = Repo.update new_changeset

    refute expected.remember_token == old_token
    assert expected.remember_token == new_token
  end

  test "has many micro_posts" do
    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, user} = Repo.insert(changeset)

    post = Ecto.Model.build(user, :micro_posts, content: "test")
    Repo.insert! post

    posts = user
            |> Repo.preload(:micro_posts)
            |> Map.get(:micro_posts)

    assert length(posts) == 1

    Repo.delete! user

    posts = Ecto.Query.from(mp in SampleApp.MicroPost,
              where: mp.user_id == ^user.id)
            |> Repo.all
    refute Repo.get(User, user.id)
    assert length(posts) == 0
  end
end
