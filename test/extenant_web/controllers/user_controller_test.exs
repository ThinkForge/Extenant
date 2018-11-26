defmodule ExtenantWeb.UserControllerTest do
  use ExtenantWeb.ConnCase

  alias Extenant.Accounts
  alias Extenant.Accounts.User

  @valid_attrs %{
    avatar: "some avatar",
    bio: "some bio",
    email: "some email",
    firstname: "some firstname",
    lastname: "some lastname",
    password: "some password",
    title: "some title"
  }
  @create_attrs %{
    avatar: "some avatar2",
    bio: "some bio2",
    email: "some email2",
    firstname: "some firstname2",
    lastname: "some lastname2",
    password: "some password2",
    title: "some title2"
  }
  @update_attrs %{
    avatar: "some updated avatar",
    bio: "some updated bio",
    email: "some updated email",
    firstname: "some updated firstname",
    lastname: "some updated lastname",
    password: "some updated password",
    title: "some updated title"
  }
  @invalid_attrs %{
    avatar: nil,
    bio: nil,
    email: nil,
    firstname: nil,
    lastname: nil,
    password: nil,
    title: nil
  }

  def fixture() do
    {:ok, user} =
      @valid_attrs
      |> Accounts.create_user()

    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}

    Accounts.create_user(@valid_attrs)
    session = User.sign_in(@valid_attrs.email, @valid_attrs.password)
    {:ok,
     conn:
       put_req_header(
         conn,
         "authentication",
         "Bearer " <> session["token"]
       )}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = conn = get(conn, user_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "avatar" => "some avatar",
               "bio" => "some bio",
               "email" => "some email",
               "firstname" => "some firstname",
               "lastname" => "some lastname",
               "title" => "some title"
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, user_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "avatar" => "some updated avatar",
               "bio" => "some updated bio",
               "email" => "some updated email",
               "firstname" => "some updated firstname",
               "lastname" => "some updated lastname",
               "password" => "some updated password",
               "title" => "some updated title"
             }
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, user_path(conn, :show, user))
      end)
    end
  end

  defp create_user(_) do
    user = fixture()
    {:ok, user: user}
  end
end
