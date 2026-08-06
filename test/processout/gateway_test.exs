defmodule ProcessOut.GatewayTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Gateway
  alias ProcessOut.Gateway.Configuration

  describe "fetch_gateway_configurations/3" do
    test "lists the configurations of the gateway", %{client: client, stub: stub} do
      stub_success(stub, %{
        "gateway_configurations" => [
          %{"id" => "gway_conf_1", "name" => "sandbox-usd"},
          %{"id" => "gway_conf_2", "name" => "sandbox-eur"}
        ]
      })

      assert {:ok,
              [
                %Configuration{id: "gway_conf_1", name: "sandbox-usd"},
                %Configuration{id: "gway_conf_2"}
              ]} = Gateway.fetch_gateway_configurations(client, "sandbox")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/gateways/sandbox/gateway-configurations"
    end
  end
end
