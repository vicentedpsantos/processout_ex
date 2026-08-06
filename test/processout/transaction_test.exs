defmodule ProcessOut.TransactionTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Refund
  alias ProcessOut.Transaction

  describe "all/2" do
    test "lists transactions", %{client: client, stub: stub} do
      stub_success(stub, %{
        "transactions" => [
          %{"id" => "tr_1", "amount" => "4.20"},
          %{"id" => "tr_2", "amount" => "1.00"}
        ]
      })

      assert {:ok, [%Transaction{id: "tr_1", amount: "4.20"}, %Transaction{id: "tr_2"}]} =
               Transaction.all(client)

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/transactions"
    end
  end

  describe "list/2" do
    test "posts and lists transactions", %{client: client, stub: stub} do
      stub_success(stub, %{"transactions" => [%{"id" => "tr_1"}]})

      assert {:ok, [%Transaction{id: "tr_1"}]} = Transaction.list(client)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/transactions"
      assert conn.assigns.json_body == %{}
    end
  end

  describe "find/3" do
    test "gets the transaction by id", %{client: client, stub: stub} do
      stub_success(stub, %{"transaction" => %{"id" => "tr_1", "status" => "completed"}})

      assert {:ok, %Transaction{id: "tr_1", status: "completed"}} =
               Transaction.find(client, "tr_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/transactions/tr_1"
    end
  end

  describe "fetch_refunds/3" do
    test "lists the transaction's refunds", %{client: client, stub: stub} do
      stub_success(stub, %{"refunds" => [%{"id" => "refund_1", "amount" => "4.20"}]})

      assert {:ok, [%Refund{id: "refund_1", amount: "4.20"}]} =
               Transaction.fetch_refunds(client, "tr_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/transactions/tr_1/refunds"
    end
  end

  describe "find_refund/4" do
    test "gets the refund by id", %{client: client, stub: stub} do
      stub_success(stub, %{"refund" => %{"id" => "refund_1", "reason" => "customer_request"}})

      assert {:ok, %Refund{id: "refund_1", reason: "customer_request"}} =
               Transaction.find_refund(client, "tr_1", "refund_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/transactions/tr_1/refunds/refund_1"
    end
  end
end
