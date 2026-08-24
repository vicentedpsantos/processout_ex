defmodule ProcessOut.InvoiceTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Customer
  alias ProcessOut.Customer.Action
  alias ProcessOut.Invoice
  alias ProcessOut.Transaction

  describe "all/2" do
    test "lists invoices", %{client: client, stub: stub} do
      stub_success(stub, %{
        "invoices" => [
          %{"id" => "iv_1", "amount" => "4.99"},
          %{"id" => "iv_2", "amount" => "9.99"}
        ]
      })

      assert {:ok, [%Invoice{id: "iv_1", amount: "4.99"}, %Invoice{id: "iv_2"}]} =
               Invoice.all(client)

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/invoices"
    end
  end

  describe "create/3" do
    test "posts allowed params and decodes the invoice", %{client: client, stub: stub} do
      stub_success(stub, %{
        "invoice" => %{"id" => "iv_1", "name" => "Order", "amount" => "4.99"}
      })

      params = %{name: "Order", amount: "4.99", currency: "USD", ignored: "dropped"}

      assert {:ok, %Invoice{id: "iv_1", name: "Order", amount: "4.99"}} =
               Invoice.create(client, params)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/invoices"

      assert conn.assigns.json_body ==
               %{"name" => "Order", "amount" => "4.99", "currency" => "USD"}
    end
  end

  describe "find/3" do
    test "gets the invoice by id", %{client: client, stub: stub} do
      stub_success(stub, %{"invoice" => %{"id" => "iv_1"}})

      assert {:ok, %Invoice{id: "iv_1"}} = Invoice.find(client, "iv_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/invoices/iv_1"
    end
  end

  describe "update/4" do
    test "puts the updatable params", %{client: client, stub: stub} do
      stub_success(stub, %{"invoice" => %{"id" => "iv_1", "amount" => "9.99"}})

      params = %{amount: "9.99", tax: %{"amount" => "1.00"}, name: "dropped"}

      assert {:ok, %Invoice{id: "iv_1", amount: "9.99"}} =
               Invoice.update(client, "iv_1", params)

      assert_received {:request, conn}
      assert conn.method == "PUT"
      assert conn.request_path == "/invoices/iv_1"
      assert conn.assigns.json_body == %{"amount" => "9.99", "tax" => %{"amount" => "1.00"}}
    end
  end

  describe "delete/3" do
    test "deletes the invoice", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = Invoice.delete(client, "iv_1")

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/invoices/iv_1"
    end
  end

  describe "authorize/5" do
    test "posts the source and decodes both return values", %{client: client, stub: stub} do
      stub_success(stub, %{
        "transaction" => %{"id" => "tr_1"},
        "customer_action" => %{"type" => "url", "value" => "https://example.com"}
      })

      params = %{synchronous: true, ignored: "dropped"}

      assert {:ok, result} = Invoice.authorize(client, "iv_1", "card_1", params)
      assert %Transaction{id: "tr_1"} = result.transaction
      assert %Action{type: "url", value: "https://example.com"} = result.customer_action

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/invoices/iv_1/authorize"
      assert conn.assigns.json_body == %{"source" => "card_1", "synchronous" => true}
    end
  end

  describe "capture/5" do
    test "posts the source and decodes both return values", %{client: client, stub: stub} do
      stub_success(stub, %{"transaction" => %{"id" => "tr_1"}})

      params = %{authorize_only: true, capture_amount: "4.99"}

      assert {:ok, result} = Invoice.capture(client, "iv_1", "card_1", params)
      assert %Transaction{id: "tr_1"} = result.transaction
      assert result.customer_action == nil

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/invoices/iv_1/capture"

      assert conn.assigns.json_body ==
               %{"source" => "card_1", "authorize_only" => true, "capture_amount" => "4.99"}
    end

    test "omits the source when the invoice is already authorized", %{client: client, stub: stub} do
      stub_success(stub, %{"transaction" => %{"id" => "tr_1", "status" => "completed"}})

      assert {:ok, result} = Invoice.capture(client, "iv_1", nil, %{capture_amount: "4.99"})
      assert %Transaction{id: "tr_1", status: "completed"} = result.transaction

      assert_received {:request, conn}
      assert conn.assigns.json_body == %{"capture_amount" => "4.99"}
    end
  end

  describe "void/4" do
    test "posts void params and decodes the transaction", %{client: client, stub: stub} do
      stub_success(stub, %{"transaction" => %{"id" => "tr_1", "status" => "voided"}})

      assert {:ok, %Transaction{id: "tr_1"}} =
               Invoice.void(client, "iv_1", %{amount: "4.99", ignored: "dropped"})

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/invoices/iv_1/void"
      assert conn.assigns.json_body == %{"amount" => "4.99"}
    end
  end

  describe "increment_authorization/5" do
    test "posts the amount and decodes the transaction", %{client: client, stub: stub} do
      stub_success(stub, %{"transaction" => %{"id" => "tr_1"}})

      assert {:ok, %Transaction{id: "tr_1"}} =
               Invoice.increment_authorization(client, "iv_1", 100, %{
                 metadata: %{"a" => "b"}
               })

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/invoices/iv_1/increment_authorization"
      assert conn.assigns.json_body == %{"amount" => 100, "metadata" => %{"a" => "b"}}
    end
  end

  describe "initiate_three_d_s/5" do
    test "posts the source and decodes the customer action", %{client: client, stub: stub} do
      stub_success(stub, %{
        "customer_action" => %{"type" => "redirect", "value" => "https://3ds.example"}
      })

      assert {:ok, %Action{type: "redirect"}} =
               Invoice.initiate_three_d_s(client, "iv_1", "card_1", %{
                 enable_three_d_s_2: true
               })

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/invoices/iv_1/three-d-s"
      assert conn.assigns.json_body == %{"source" => "card_1", "enable_three_d_s_2" => true}
    end
  end

  describe "assign_customer/4" do
    test "posts the customer id and decodes the customer", %{client: client, stub: stub} do
      stub_success(stub, %{"customer" => %{"id" => "cust_1"}})

      assert {:ok, %Customer{id: "cust_1"}} =
               Invoice.assign_customer(client, "iv_1", "cust_1")

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/invoices/iv_1/customers"
      assert conn.assigns.json_body == %{"customer_id" => "cust_1"}
    end
  end

  describe "fetch_customer/3" do
    test "gets the customer of the invoice", %{client: client, stub: stub} do
      stub_success(stub, %{"customer" => %{"id" => "cust_1"}})

      assert {:ok, %Customer{id: "cust_1"}} = Invoice.fetch_customer(client, "iv_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/invoices/iv_1/customers"
    end
  end

  describe "fetch_transaction/3" do
    test "gets the transaction of the invoice", %{client: client, stub: stub} do
      stub_success(stub, %{"transaction" => %{"id" => "tr_1"}})

      assert {:ok, %Transaction{id: "tr_1"}} = Invoice.fetch_transaction(client, "iv_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/invoices/iv_1/transactions"
    end
  end

  describe "payout/6" do
    test "posts payout data and decodes the transaction", %{client: client, stub: stub} do
      stub_success(stub, %{"transaction" => %{"id" => "tr_1"}})

      assert {:ok, %Transaction{id: "tr_1"}} =
               Invoice.payout(client, "iv_1", "gway_conf_1", "card_1", %{
                 force_gateway_configuration_id: "gway_conf_2"
               })

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/invoices/iv_1/payout"

      assert conn.assigns.json_body == %{
               "gateway_configuration_id" => "gway_conf_1",
               "source" => "card_1",
               "force_gateway_configuration_id" => "gway_conf_2"
             }
    end
  end

  describe "show_native_payment_transaction/4" do
    test "gets the native payment details", %{client: client, stub: stub} do
      stub_success(stub, %{"native_apm" => %{"state" => "PENDING"}})

      assert {:ok, details} =
               Invoice.show_native_payment_transaction(client, "iv_1", "gway_conf_1")

      assert is_struct(details, ProcessOut.NativeAPM.TransactionDetails)
      assert details.state == "PENDING"

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/invoices/iv_1/native-payment/gway_conf_1"
    end
  end

  describe "process_native_payment/4" do
    test "posts native payment data and decodes both return values",
         %{client: client, stub: stub} do
      stub_success(stub, %{
        "transaction" => %{"id" => "tr_1"},
        "native_apm" => %{"state" => "CAPTURED"}
      })

      params = %{gateway_configuration_id: "gway_conf_1", native_apm: %{"a" => "b"}}

      assert {:ok, result} = Invoice.process_native_payment(client, "iv_1", params)
      assert %Transaction{id: "tr_1"} = result.transaction
      assert is_struct(result.native_apm, ProcessOut.NativeAPM.Response)
      assert result.native_apm.state == "CAPTURED"

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/invoices/iv_1/native-payment"

      assert conn.assigns.json_body ==
               %{"gateway_configuration_id" => "gway_conf_1", "native_apm" => %{"a" => "b"}}
    end
  end

  describe "sync_with_psp/3" do
    test "puts to the sync endpoint and decodes the invoice", %{client: client, stub: stub} do
      stub_success(stub, %{"invoice" => %{"id" => "iv_1"}})

      assert {:ok, %Invoice{id: "iv_1"}} = Invoice.sync_with_psp(client, "iv_1")

      assert_received {:request, conn}
      assert conn.method == "PUT"
      assert conn.request_path == "/invoices/iv_1/sync-with-psp"
      assert conn.assigns.json_body == %{}
    end
  end
end
