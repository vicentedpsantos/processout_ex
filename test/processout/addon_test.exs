defmodule ProcessOut.AddonTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Addon

  describe "fetch_subscription_addons/3" do
    test "lists the subscription addons", %{client: client, stub: stub} do
      stub_success(stub, %{
        "addons" => [
          %{"id" => "addon_1", "amount" => "5.00"},
          %{"id" => "addon_2", "amount" => "7.00"}
        ]
      })

      assert {:ok, [%Addon{id: "addon_1", amount: "5.00"}, %Addon{id: "addon_2"}]} =
               Addon.fetch_subscription_addons(client, "sub_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/subscriptions/sub_1/addons"
    end
  end

  describe "create/4" do
    test "posts allowed params and decodes the addon", %{client: client, stub: stub} do
      stub_success(stub, %{"addon" => %{"id" => "addon_1", "amount" => "5.00"}})

      params = %{plan_id: "silver", amount: "5.00", prorate: true, ignored: "dropped"}

      assert {:ok, %Addon{id: "addon_1", amount: "5.00"}} =
               Addon.create(client, "sub_1", params)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/subscriptions/sub_1/addons"

      assert conn.assigns.json_body ==
               %{"plan_id" => "silver", "amount" => "5.00", "prorate" => true}
    end
  end

  describe "find/4" do
    test "gets the addon by id", %{client: client, stub: stub} do
      stub_success(stub, %{"addon" => %{"id" => "addon_1"}})

      assert {:ok, %Addon{id: "addon_1"}} = Addon.find(client, "sub_1", "addon_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/subscriptions/sub_1/addons/addon_1"
    end
  end

  describe "update/5" do
    test "puts the updatable params", %{client: client, stub: stub} do
      stub_success(stub, %{"addon" => %{"id" => "addon_1", "quantity" => 2}})

      params = %{quantity: 2, increment_quantity_by: 1, ignored: "dropped"}

      assert {:ok, %Addon{quantity: 2}} =
               Addon.update(client, "sub_1", "addon_1", params)

      assert_received {:request, conn}
      assert conn.method == "PUT"
      assert conn.request_path == "/subscriptions/sub_1/addons/addon_1"
      assert conn.assigns.json_body == %{"quantity" => 2, "increment_quantity_by" => 1}
    end
  end

  describe "delete/5" do
    test "deletes the addon with the allowed query params", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = Addon.delete(client, "sub_1", "addon_1", %{prorate: true})

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/subscriptions/sub_1/addons/addon_1"
      assert conn.query_string =~ "prorate=true"
    end
  end
end
