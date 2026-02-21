defmodule SertantaiHubWeb.LoadFromCookieTest do
  use SertantaiHubWeb.ConnCase, async: true

  alias SertantaiHubWeb.LoadFromCookie

  @cookie_name "sertantai_token"

  defp call_plug(conn) do
    LoadFromCookie.call(conn, LoadFromCookie.init([]))
  end

  describe "call/2" do
    test "promotes cookie to Bearer header when no auth header present", %{conn: conn} do
      conn =
        conn
        |> put_req_cookie(@cookie_name, "my-token-value")
        |> call_plug()

      assert get_req_header(conn, "authorization") == ["Bearer my-token-value"]
    end

    test "does not override existing Bearer header", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer existing-token")
        |> put_req_cookie(@cookie_name, "cookie-token")
        |> call_plug()

      assert get_req_header(conn, "authorization") == ["Bearer existing-token"]
    end

    test "passes through when no cookie and no header", %{conn: conn} do
      conn = call_plug(conn)

      assert get_req_header(conn, "authorization") == []
    end

    test "ignores empty cookie value", %{conn: conn} do
      conn =
        conn
        |> put_req_cookie(@cookie_name, "")
        |> call_plug()

      assert get_req_header(conn, "authorization") == []
    end
  end
end
