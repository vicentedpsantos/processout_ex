defmodule ProcessOut.ProductTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Product

  describe "create_invoice/3" do
    test "posts and decodes the invoice", %{client: client, stub: stub} do
      stub_success(stub, %{"invoice" => %{"id" => "iv_1", "amount" => "10.00"}})

      assert {:ok, invoice} = Product.create_invoice(client, "prod_1")
      assert invoice.id == "iv_1"
      assert invoice.amount == "10.00"

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/products/prod_1/invoices"
    end
  end

  describe "all/2" do
    test "lists products", %{client: client, stub: stub} do
      stub_success(stub, %{
        "products" => [
          %{"id" => "prod_1", "name" => "Amazing product"},
          %{"id" => "prod_2", "name" => "Other product"}
        ]
      })

      assert {:ok, [%Product{id: "prod_1", name: "Amazing product"}, %Product{id: "prod_2"}]} =
               Product.all(client)

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/products"
    end
  end

  describe "create/3" do
    test "posts allowed params and decodes the product", %{client: client, stub: stub} do
      stub_success(stub, %{"product" => %{"id" => "prod_1", "name" => "Amazing product"}})

      params = %{name: "Amazing product", amount: "10.00", ignored: "dropped"}

      assert {:ok, %Product{id: "prod_1", name: "Amazing product"}} =
               Product.create(client, params)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/products"
      assert conn.assigns.json_body == %{"name" => "Amazing product", "amount" => "10.00"}
    end
  end

  describe "find/3" do
    test "gets the product by id", %{client: client, stub: stub} do
      stub_success(stub, %{"product" => %{"id" => "prod_1"}})

      assert {:ok, %Product{id: "prod_1"}} = Product.find(client, "prod_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/products/prod_1"
    end
  end

  describe "update/4" do
    test "puts the updatable params", %{client: client, stub: stub} do
      stub_success(stub, %{"product" => %{"id" => "prod_1", "name" => "Renamed"}})

      params = %{name: "Renamed", ignored: "dropped"}
      assert {:ok, %Product{name: "Renamed"}} = Product.update(client, "prod_1", params)

      assert_received {:request, conn}
      assert conn.method == "PUT"
      assert conn.request_path == "/products/prod_1"
      assert conn.assigns.json_body == %{"name" => "Renamed"}
    end
  end

  describe "delete/3" do
    test "deletes the product", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = Product.delete(client, "prod_1")

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/products/prod_1"
    end
  end
end
