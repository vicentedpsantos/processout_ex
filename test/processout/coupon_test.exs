defmodule ProcessOut.CouponTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Coupon

  describe "all/2" do
    test "lists coupons", %{client: client, stub: stub} do
      stub_success(stub, %{
        "coupons" => [
          %{"id" => "25off", "percent_off" => 25},
          %{"id" => "10off", "percent_off" => 10}
        ]
      })

      assert {:ok, [%Coupon{id: "25off", percent_off: 25}, %Coupon{id: "10off"}]} =
               Coupon.all(client)

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/coupons"
    end

    test "passes pagination options as query params", %{client: client, stub: stub} do
      stub_success(stub, %{"coupons" => []})

      assert {:ok, []} = Coupon.all(client, limit: 10, start_after: "25off")

      assert_received {:request, conn}
      assert conn.query_string =~ "limit=10"
      assert conn.query_string =~ "start_after=25off"
    end
  end

  describe "create/3" do
    test "posts allowed params and decodes the coupon", %{client: client, stub: stub} do
      stub_success(stub, %{"coupon" => %{"id" => "25off", "percent_off" => 25}})

      params = %{id: "25off", percent_off: 25, currency: "USD", ignored: "dropped"}
      assert {:ok, %Coupon{id: "25off", percent_off: 25}} = Coupon.create(client, params)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/coupons"

      assert conn.assigns.json_body ==
               %{"id" => "25off", "percent_off" => 25, "currency" => "USD"}
    end
  end

  describe "find/3" do
    test "gets the coupon by id", %{client: client, stub: stub} do
      stub_success(stub, %{"coupon" => %{"id" => "25off"}})

      assert {:ok, %Coupon{id: "25off"}} = Coupon.find(client, "25off")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/coupons/25off"
    end
  end

  describe "update/4" do
    test "puts the updatable params", %{client: client, stub: stub} do
      stub_success(stub, %{"coupon" => %{"id" => "25off", "metadata" => %{"a" => "b"}}})

      params = %{metadata: %{"a" => "b"}, percent_off: 99}
      assert {:ok, %Coupon{metadata: %{"a" => "b"}}} = Coupon.update(client, "25off", params)

      assert_received {:request, conn}
      assert conn.method == "PUT"
      assert conn.request_path == "/coupons/25off"
      assert conn.assigns.json_body == %{"metadata" => %{"a" => "b"}}
    end
  end

  describe "delete/3" do
    test "deletes the coupon", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = Coupon.delete(client, "25off")

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/coupons/25off"
    end

    test "returns a typed error on failure", %{client: client, stub: stub} do
      stub_error(stub, 404, %{"error_type" => "resource.not-found", "message" => "gone"})

      assert {:error, error} = Coupon.delete(client, "nope")
      assert error.type == :not_found
      assert error.code == "resource.not-found"
      assert error.message == "gone"
      assert error.status == 404
    end
  end
end
