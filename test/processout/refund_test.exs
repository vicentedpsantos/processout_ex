defmodule ProcessOut.RefundTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Refund

  describe "create/4" do
    test "posts allowed params and returns :ok", %{client: client, stub: stub} do
      stub_success(stub, %{})

      params = %{amount: "4.20", reason: "customer_request", ignored: "dropped"}
      assert :ok = Refund.create(client, "tr_1", params)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/transactions/tr_1/refunds"

      assert conn.assigns.json_body ==
               %{"amount" => "4.20", "reason" => "customer_request"}
    end
  end

  describe "create_for_invoice/4" do
    test "posts allowed params and returns :ok", %{client: client, stub: stub} do
      stub_success(stub, %{})

      params = %{amount: "4.20", information: "duplicate", metadata: %{"a" => "b"}}
      assert :ok = Refund.create_for_invoice(client, "iv_1", params)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/invoices/iv_1/refunds"

      assert conn.assigns.json_body ==
               %{
                 "amount" => "4.20",
                 "information" => "duplicate",
                 "metadata" => %{"a" => "b"}
               }
    end
  end

  describe "find/4" do
    test "gets the refund by id", %{client: client, stub: stub} do
      stub_success(stub, %{"refund" => %{"id" => "refund_1", "amount" => "4.20"}})

      assert {:ok, %Refund{id: "refund_1", amount: "4.20"}} =
               Refund.find(client, "tr_1", "refund_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/transactions/tr_1/refunds/refund_1"
    end
  end

  describe "fetch_transaction_refunds/3" do
    test "lists the transaction's refunds", %{client: client, stub: stub} do
      stub_success(stub, %{
        "refunds" => [
          %{"id" => "refund_1", "amount" => "4.20"},
          %{"id" => "refund_2", "amount" => "1.00"}
        ]
      })

      assert {:ok, [%Refund{id: "refund_1"}, %Refund{id: "refund_2"}]} =
               Refund.fetch_transaction_refunds(client, "tr_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/transactions/tr_1/refunds"
    end
  end
end
