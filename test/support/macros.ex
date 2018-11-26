defmodule Extenant.TestMacros do
  alias TestMacros.Router

  import Plug.Conn, only: [delete_req_header: 2]
  import Phoenix.ConnTest, only: [dispatch: 5, json_response: 2]

  defmacro test_authentication_required_for(method, path_name, action) do
    quote do
      test "requires authentication", %{conn: conn} do
        method    = unquote(method)
        path_name = unquote(path_name)
        action    = unquote(action)
        assert make_unauthenticated_request(conn, @endpoint, method, path_name, action)
      end
    end
  end

  def make_unauthenticated_request(conn, endpoint, method, path_name, action) do
    path = apply(Router.Helpers, path_name, [conn, action])
    conn = conn |> delete_req_header("authorization")
    dispatch(conn, endpoint, method, path, nil) |> json_response(401)
  end
end
