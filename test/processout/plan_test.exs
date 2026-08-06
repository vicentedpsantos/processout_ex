defmodule ProcessOut.PlanTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Plan

  describe "all/2" do
    test "lists plans", %{client: client, stub: stub} do
      stub_success(stub, %{
        "plans" => [
          %{"id" => "silver", "amount" => "10.00"},
          %{"id" => "gold", "amount" => "20.00"}
        ]
      })

      assert {:ok, [%Plan{id: "silver", amount: "10.00"}, %Plan{id: "gold"}]} =
               Plan.all(client)

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/plans"
    end
  end

  describe "create/3" do
    test "posts allowed params and decodes the plan", %{client: client, stub: stub} do
      stub_success(stub, %{"plan" => %{"id" => "silver", "amount" => "10.00"}})

      params = %{id: "silver", amount: "10.00", currency: "USD", ignored: "dropped"}
      assert {:ok, %Plan{id: "silver", amount: "10.00"}} = Plan.create(client, params)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/plans"

      assert conn.assigns.json_body ==
               %{"id" => "silver", "amount" => "10.00", "currency" => "USD"}
    end
  end

  describe "find/3" do
    test "gets the plan by id", %{client: client, stub: stub} do
      stub_success(stub, %{"plan" => %{"id" => "silver"}})

      assert {:ok, %Plan{id: "silver"}} = Plan.find(client, "silver")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/plans/silver"
    end
  end

  describe "update/4" do
    test "puts the updatable params", %{client: client, stub: stub} do
      stub_success(stub, %{"plan" => %{"id" => "silver", "name" => "Silver"}})

      params = %{name: "Silver", amount: "99.00"}
      assert {:ok, %Plan{name: "Silver"}} = Plan.update(client, "silver", params)

      assert_received {:request, conn}
      assert conn.method == "PUT"
      assert conn.request_path == "/plans/silver"
      assert conn.assigns.json_body == %{"name" => "Silver"}
    end
  end

  describe "end_plan/3" do
    test "deletes the plan", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = Plan.end_plan(client, "silver")

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/plans/silver"
    end
  end
end
