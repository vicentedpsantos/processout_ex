defmodule ProcessOut.CustomerTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Customer
  alias ProcessOut.Subscription
  alias ProcessOut.Token
  alias ProcessOut.Transaction

  describe "fetch_subscriptions/3" do
    test "lists the customer's subscriptions", %{client: client, stub: stub} do
      stub_success(stub, %{"subscriptions" => [%{"id" => "sub_1"}, %{"id" => "sub_2"}]})

      assert {:ok, [%Subscription{id: "sub_1"}, %Subscription{id: "sub_2"}]} =
               Customer.fetch_subscriptions(client, "cust_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/customers/cust_1/subscriptions"
    end
  end

  describe "fetch_tokens/3" do
    test "lists the customer's tokens", %{client: client, stub: stub} do
      stub_success(stub, %{"tokens" => [%{"id" => "tok_1"}, %{"id" => "tok_2"}]})

      assert {:ok, [%Token{id: "tok_1"}, %Token{id: "tok_2"}]} =
               Customer.fetch_tokens(client, "cust_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/customers/cust_1/tokens"
    end
  end

  describe "find_token/4" do
    test "gets the customer's token by id", %{client: client, stub: stub} do
      stub_success(stub, %{"token" => %{"id" => "tok_1"}})

      assert {:ok, %Token{id: "tok_1"}} = Customer.find_token(client, "cust_1", "tok_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/customers/cust_1/tokens/tok_1"
    end
  end

  describe "delete_token/4" do
    test "deletes the customer's token", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = Customer.delete_token(client, "cust_1", "tok_1")

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/customers/cust_1/tokens/tok_1"
    end
  end

  describe "fetch_transactions/3" do
    test "lists the customer's transactions", %{client: client, stub: stub} do
      stub_success(stub, %{"transactions" => [%{"id" => "tr_1"}, %{"id" => "tr_2"}]})

      assert {:ok, [%Transaction{id: "tr_1"}, %Transaction{id: "tr_2"}]} =
               Customer.fetch_transactions(client, "cust_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/customers/cust_1/transactions"
    end
  end

  describe "all/2" do
    test "lists customers", %{client: client, stub: stub} do
      stub_success(stub, %{
        "customers" => [%{"id" => "cust_1"}, %{"id" => "cust_2"}]
      })

      assert {:ok, [%Customer{id: "cust_1"}, %Customer{id: "cust_2"}]} =
               Customer.all(client)

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/customers"
    end
  end

  describe "create/3" do
    test "posts allowed params and decodes the customer", %{client: client, stub: stub} do
      stub_success(stub, %{
        "customer" => %{"id" => "cust_1", "email" => "john@smith.com"}
      })

      params = %{email: "john@smith.com", first_name: "John", ignored: "dropped"}

      assert {:ok, %Customer{id: "cust_1", email: "john@smith.com"}} =
               Customer.create(client, params)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/customers"

      assert conn.assigns.json_body ==
               %{"email" => "john@smith.com", "first_name" => "John"}
    end
  end

  describe "find/3" do
    test "gets the customer by id", %{client: client, stub: stub} do
      stub_success(stub, %{"customer" => %{"id" => "cust_1"}})

      assert {:ok, %Customer{id: "cust_1"}} = Customer.find(client, "cust_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/customers/cust_1"
    end
  end

  describe "update/4" do
    test "puts the updatable params", %{client: client, stub: stub} do
      stub_success(stub, %{"customer" => %{"id" => "cust_1", "first_name" => "Jane"}})

      params = %{first_name: "Jane", currency: "USD"}

      assert {:ok, %Customer{first_name: "Jane"}} =
               Customer.update(client, "cust_1", params)

      assert_received {:request, conn}
      assert conn.method == "PUT"
      assert conn.request_path == "/customers/cust_1"
      assert conn.assigns.json_body == %{"first_name" => "Jane"}
    end
  end

  describe "delete/3" do
    test "deletes the customer", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = Customer.delete(client, "cust_1")

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/customers/cust_1"
    end
  end
end
