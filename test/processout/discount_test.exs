defmodule ProcessOut.DiscountTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Discount

  describe "fetch_subscription_discounts/3" do
    test "lists the subscription discounts", %{client: client, stub: stub} do
      stub_success(stub, %{
        "discounts" => [
          %{"id" => "disc_1", "amount" => "5.00"},
          %{"id" => "disc_2", "amount" => "7.00"}
        ]
      })

      assert {:ok, [%Discount{id: "disc_1", amount: "5.00"}, %Discount{id: "disc_2"}]} =
               Discount.fetch_subscription_discounts(client, "sub_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/subscriptions/sub_1/discounts"
    end
  end

  describe "create/4" do
    test "posts allowed params and decodes the discount", %{client: client, stub: stub} do
      stub_success(stub, %{"discount" => %{"id" => "disc_1", "amount" => "5.00"}})

      params = %{coupon_id: "25off", amount: "5.00", ignored: "dropped"}

      assert {:ok, %Discount{id: "disc_1", amount: "5.00"}} =
               Discount.create(client, "sub_1", params)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/subscriptions/sub_1/discounts"
      assert conn.assigns.json_body == %{"coupon_id" => "25off", "amount" => "5.00"}
    end
  end

  describe "find/4" do
    test "gets the discount by id", %{client: client, stub: stub} do
      stub_success(stub, %{"discount" => %{"id" => "disc_1"}})

      assert {:ok, %Discount{id: "disc_1"}} = Discount.find(client, "sub_1", "disc_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/subscriptions/sub_1/discounts/disc_1"
    end
  end

  describe "delete/4" do
    test "deletes the discount", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = Discount.delete(client, "sub_1", "disc_1")

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/subscriptions/sub_1/discounts/disc_1"
    end
  end
end
