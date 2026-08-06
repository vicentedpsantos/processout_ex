defmodule ProcessOut.PayoutTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Payout
  alias ProcessOut.Payout.Item

  describe "all/2" do
    test "lists payouts", %{client: client, stub: stub} do
      stub_success(stub, %{
        "payouts" => [
          %{"id" => "payout_1", "amount" => "42.00"},
          %{"id" => "payout_2", "amount" => "10.00"}
        ]
      })

      assert {:ok, [%Payout{id: "payout_1", amount: "42.00"}, %Payout{id: "payout_2"}]} =
               Payout.all(client)

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/payouts"
    end
  end

  describe "find/3" do
    test "gets the payout by id", %{client: client, stub: stub} do
      stub_success(stub, %{"payout" => %{"id" => "payout_1", "status" => "paid"}})

      assert {:ok, %Payout{id: "payout_1", status: "paid"}} = Payout.find(client, "payout_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/payouts/payout_1"
    end
  end

  describe "delete/3" do
    test "deletes the payout", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = Payout.delete(client, "payout_1")

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/payouts/payout_1"
    end
  end

  describe "fetch_items/3" do
    test "lists the payout's items", %{client: client, stub: stub} do
      stub_success(stub, %{
        "items" => [%{"id" => "payout_item_1", "amount" => "4.20"}]
      })

      assert {:ok, [%Item{id: "payout_item_1", amount: "4.20"}]} =
               Payout.fetch_items(client, "payout_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/payouts/payout_1/items"
    end
  end
end
