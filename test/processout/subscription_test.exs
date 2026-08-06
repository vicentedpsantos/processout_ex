defmodule ProcessOut.SubscriptionTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Addon
  alias ProcessOut.Discount
  alias ProcessOut.Subscription

  describe "fetch_addons/3" do
    test "lists the subscription addons", %{client: client, stub: stub} do
      stub_success(stub, %{
        "addons" => [
          %{"id" => "addon_1", "amount" => "5.00"},
          %{"id" => "addon_2", "amount" => "7.00"}
        ]
      })

      assert {:ok, [%Addon{id: "addon_1", amount: "5.00"}, %Addon{id: "addon_2"}]} =
               Subscription.fetch_addons(client, "sub_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/subscriptions/sub_1/addons"
    end
  end

  describe "find_addon/4" do
    test "gets the addon by id", %{client: client, stub: stub} do
      stub_success(stub, %{"addon" => %{"id" => "addon_1"}})

      assert {:ok, %Addon{id: "addon_1"}} =
               Subscription.find_addon(client, "sub_1", "addon_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/subscriptions/sub_1/addons/addon_1"
    end
  end

  describe "delete_addon/5" do
    test "deletes the addon with the allowed query params", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = Subscription.delete_addon(client, "sub_1", "addon_1", %{prorate: true})

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/subscriptions/sub_1/addons/addon_1"
      assert conn.query_string =~ "prorate=true"
    end
  end

  describe "fetch_customer/3" do
    test "gets the customer owning the subscription", %{client: client, stub: stub} do
      stub_success(stub, %{"customer" => %{"id" => "cust_1", "email" => "john@smith.com"}})

      assert {:ok, customer} = Subscription.fetch_customer(client, "sub_1")
      assert customer.id == "cust_1"
      assert customer.email == "john@smith.com"

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/subscriptions/sub_1/customers"
    end
  end

  describe "fetch_discounts/3" do
    test "lists the subscription discounts", %{client: client, stub: stub} do
      stub_success(stub, %{
        "discounts" => [
          %{"id" => "disc_1", "amount" => "5.00"},
          %{"id" => "disc_2", "amount" => "7.00"}
        ]
      })

      assert {:ok, [%Discount{id: "disc_1", amount: "5.00"}, %Discount{id: "disc_2"}]} =
               Subscription.fetch_discounts(client, "sub_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/subscriptions/sub_1/discounts"
    end
  end

  describe "find_discount/4" do
    test "gets the discount by id", %{client: client, stub: stub} do
      stub_success(stub, %{"discount" => %{"id" => "disc_1"}})

      assert {:ok, %Discount{id: "disc_1"}} =
               Subscription.find_discount(client, "sub_1", "disc_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/subscriptions/sub_1/discounts/disc_1"
    end
  end

  describe "delete_discount/4" do
    test "deletes the discount", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = Subscription.delete_discount(client, "sub_1", "disc_1")

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/subscriptions/sub_1/discounts/disc_1"
    end
  end

  describe "fetch_transactions/3" do
    test "lists the subscription transactions", %{client: client, stub: stub} do
      stub_success(stub, %{
        "transactions" => [
          %{"id" => "tr_1", "amount" => "10.00"},
          %{"id" => "tr_2", "amount" => "10.00"}
        ]
      })

      assert {:ok, [transaction1, transaction2]} =
               Subscription.fetch_transactions(client, "sub_1")

      assert transaction1.id == "tr_1"
      assert transaction2.id == "tr_2"

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/subscriptions/sub_1/transactions"
    end
  end

  describe "all/2" do
    test "lists subscriptions", %{client: client, stub: stub} do
      stub_success(stub, %{
        "subscriptions" => [
          %{"id" => "sub_1", "name" => "Amazing subscription"},
          %{"id" => "sub_2", "name" => "Other subscription"}
        ]
      })

      assert {:ok,
              [
                %Subscription{id: "sub_1", name: "Amazing subscription"},
                %Subscription{id: "sub_2"}
              ]} = Subscription.all(client)

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/subscriptions"
    end
  end

  describe "create/3" do
    test "posts allowed params and decodes the subscription", %{client: client, stub: stub} do
      stub_success(stub, %{"subscription" => %{"id" => "sub_1", "plan_id" => "silver"}})

      params = %{
        plan_id: "silver",
        customer_id: "cust_1",
        source: "card_1",
        coupon_id: "25off",
        ignored: "dropped"
      }

      assert {:ok, %Subscription{id: "sub_1", plan_id: "silver"}} =
               Subscription.create(client, params)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/subscriptions"

      assert conn.assigns.json_body == %{
               "plan_id" => "silver",
               "customer_id" => "cust_1",
               "source" => "card_1",
               "coupon_id" => "25off"
             }
    end
  end

  describe "find/3" do
    test "gets the subscription by id", %{client: client, stub: stub} do
      stub_success(stub, %{"subscription" => %{"id" => "sub_1"}})

      assert {:ok, %Subscription{id: "sub_1"}} = Subscription.find(client, "sub_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/subscriptions/sub_1"
    end
  end

  describe "update/4" do
    test "puts the updatable params", %{client: client, stub: stub} do
      stub_success(stub, %{"subscription" => %{"id" => "sub_1", "plan_id" => "gold"}})

      params = %{plan_id: "gold", prorate: true, ignored: "dropped"}

      assert {:ok, %Subscription{plan_id: "gold"}} =
               Subscription.update(client, "sub_1", params)

      assert_received {:request, conn}
      assert conn.method == "PUT"
      assert conn.request_path == "/subscriptions/sub_1"
      assert conn.assigns.json_body == %{"plan_id" => "gold", "prorate" => true}
    end
  end

  describe "cancel/4" do
    test "deletes with the cancellation params and decodes the subscription", %{
      client: client,
      stub: stub
    } do
      stub_success(stub, %{"subscription" => %{"id" => "sub_1", "canceled" => true}})

      params = %{cancellation_reason: "Cancellation reason", cancel_at_end: true}

      assert {:ok, %Subscription{id: "sub_1", canceled: true}} =
               Subscription.cancel(client, "sub_1", params)

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/subscriptions/sub_1"
      assert conn.query_string =~ "cancellation_reason=Cancellation+reason"
      assert conn.query_string =~ "cancel_at_end=true"
    end
  end
end
