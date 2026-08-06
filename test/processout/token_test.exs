defmodule ProcessOut.TokenTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Customer.Action
  alias ProcessOut.Token

  describe "fetch_customer_tokens/3" do
    test "lists the customer's tokens", %{client: client, stub: stub} do
      stub_success(stub, %{"tokens" => [%{"id" => "tok_1"}, %{"id" => "tok_2"}]})

      assert {:ok, [%Token{id: "tok_1"}, %Token{id: "tok_2"}]} =
               Token.fetch_customer_tokens(client, "cust_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/customers/cust_1/tokens"
    end
  end

  describe "find/4" do
    test "gets the customer's token by id", %{client: client, stub: stub} do
      stub_success(stub, %{"token" => %{"id" => "tok_1"}})

      assert {:ok, %Token{id: "tok_1"}} = Token.find(client, "cust_1", "tok_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/customers/cust_1/tokens/tok_1"
    end
  end

  describe "create/4" do
    test "posts allowed params, decodes token and customer action",
         %{client: client, stub: stub} do
      stub_success(stub, %{
        "token" => %{"id" => "tok_1"},
        "customer_action" => %{"type" => "url", "value" => "https://example.com"}
      })

      params = %{return_url: "https://return.example", source: "card_1", ignored: "x"}

      assert {:ok, %{token: %Token{id: "tok_1"}, customer_action: %Action{type: "url"}}} =
               Token.create(client, "cust_1", params)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/customers/cust_1/tokens"

      assert conn.assigns.json_body ==
               %{"return_url" => "https://return.example", "source" => "card_1"}
    end
  end

  describe "update/5" do
    test "puts the updatable params", %{client: client, stub: stub} do
      stub_success(stub, %{})

      params = %{source: "card_1", verify: true, ignored: "x"}

      assert :ok = Token.update(client, "cust_1", "tok_1", params)

      assert_received {:request, conn}
      assert conn.method == "PUT"
      assert conn.request_path == "/customers/cust_1/tokens/tok_1"
      assert conn.assigns.json_body == %{"source" => "card_1", "verify" => true}
    end
  end

  describe "delete/4" do
    test "deletes the customer token", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = Token.delete(client, "cust_1", "tok_1")

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/customers/cust_1/tokens/tok_1"
    end
  end
end
