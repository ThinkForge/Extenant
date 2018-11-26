defmodule Extenant.AccountsTest do
  use Extenant.DataCase

  alias Extenant.Accounts

  describe "users" do
    alias Extenant.Accounts.User

    @valid_attrs %{avatar: "some avatar", bio: "some bio", email: "some email", firstname: "some firstname", lastname: "some lastname", password: "some password", title: "some title"}
    @update_attrs %{avatar: "some updated avatar", bio: "some updated bio", email: "some updated email", firstname: "some updated firstname", lastname: "some updated lastname", password: "some updated password", title: "some updated title"}
    @invalid_attrs %{avatar: nil, bio: nil, email: nil, firstname: nil, lastname: nil, password: nil, title: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user_fixture()
      assert Enum.count(Accounts.list_users()) == 1
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id).email == user.email
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.avatar == "some avatar"
      assert user.bio == "some bio"
      assert user.email == "some email"
      assert user.firstname == "some firstname"
      assert user.lastname == "some lastname"
      assert user.password == "some password"
      assert user.password_hash != nil
      assert user.title == "some title"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.avatar == "some updated avatar"
      assert user.bio == "some updated bio"
      assert user.email == "some updated email"
      assert user.firstname == "some updated firstname"
      assert user.lastname == "some updated lastname"
      assert user.password == "some updated password"
      assert user.password_hash != nil
      assert user.title == "some updated title"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user.email == Accounts.get_user!(user.id).email
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
