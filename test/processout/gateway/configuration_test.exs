defmodule ProcessOut.Gateway.ConfigurationTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Gateway.Configuration

  describe "all/2" do
    test "lists gateway configurations", %{client: client, stub: stub} do
      stub_success(stub, %{
        "gateway_configurations" => [
          %{"id" => "gway_conf_1", "enabled" => true},
          %{"id" => "gway_conf_2", "enabled" => false}
        ]
      })

      assert {:ok,
              [
                %Configuration{id: "gway_conf_1", enabled: true},
                %Configuration{id: "gway_conf_2"}
              ]} = Configuration.all(client, expand_merchant_accounts: true)

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/gateway-configurations"
      assert conn.query_string =~ "expand_merchant_accounts=true"
    end
  end

  describe "find/3" do
    test "gets the gateway configuration by id", %{client: client, stub: stub} do
      stub_success(stub, %{"gateway_configuration" => %{"id" => "gway_conf_1"}})

      assert {:ok, %Configuration{id: "gway_conf_1"}} =
               Configuration.find(client, "gway_conf_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/gateway-configurations/gway_conf_1"
    end
  end

  describe "update/4" do
    test "puts the updatable params", %{client: client, stub: stub} do
      stub_success(stub, %{
        "gateway_configuration" => %{"id" => "gway_conf_1", "name" => "sandbox-usd"}
      })

      params = %{name: "sandbox-usd", enabled: true, settings: %{"a" => "b"}, ignored: "x"}

      assert {:ok, %Configuration{id: "gway_conf_1", name: "sandbox-usd"}} =
               Configuration.update(client, "gway_conf_1", params)

      assert_received {:request, conn}
      assert conn.method == "PUT"
      assert conn.request_path == "/gateway-configurations/gway_conf_1"

      assert conn.assigns.json_body ==
               %{"name" => "sandbox-usd", "enabled" => true, "settings" => %{"a" => "b"}}
    end
  end

  describe "delete/3" do
    test "deletes the gateway configuration", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = Configuration.delete(client, "gway_conf_1")

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/gateway-configurations/gway_conf_1"
    end
  end

  describe "create/4" do
    test "posts allowed params under the gateway", %{client: client, stub: stub} do
      stub_success(stub, %{
        "gateway_configuration" => %{"id" => "gway_conf_1", "default_currency" => "USD"}
      })

      params = %{name: "sandbox-usd", default_currency: "USD", ignored: "x"}

      assert {:ok, %Configuration{id: "gway_conf_1", default_currency: "USD"}} =
               Configuration.create(client, "sandbox", params)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/gateways/sandbox/gateway-configurations"

      assert conn.assigns.json_body ==
               %{"name" => "sandbox-usd", "default_currency" => "USD"}
    end
  end
end
