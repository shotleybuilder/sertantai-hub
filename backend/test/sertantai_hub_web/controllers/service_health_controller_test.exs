defmodule SertantaiHubWeb.ServiceHealthControllerTest do
  use SertantaiHubWeb.ConnCase

  test "unknown services are rejected", %{conn: conn} do
    assert %{"status" => "error"} = conn |> get("/api/services/nope/health") |> json_response(404)
  end

  test "compliance is a known service and reports offline when unreachable", %{conn: conn} do
    previous = Application.get_env(:sertantai_hub, :compliance_url)
    # Nothing listens on port 1: the proxy reports offline rather than erroring
    Application.put_env(:sertantai_hub, :compliance_url, "http://127.0.0.1:1")
    on_exit(fn -> restore(:compliance_url, previous) end)

    assert %{"status" => "offline"} =
             conn |> get("/api/services/compliance/health") |> json_response(200)
  end

  defp restore(key, nil), do: Application.delete_env(:sertantai_hub, key)
  defp restore(key, value), do: Application.put_env(:sertantai_hub, key, value)
end
