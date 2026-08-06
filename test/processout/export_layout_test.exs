defmodule ProcessOut.ExportLayoutTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.ExportLayout

  describe "all/2" do
    test "lists export layouts", %{client: client, stub: stub} do
      stub_success(stub, %{
        "export_layouts" => [%{"id" => "el_1"}, %{"id" => "el_2"}]
      })

      assert {:ok, [%ExportLayout{id: "el_1"}, %ExportLayout{id: "el_2"}]} =
               ExportLayout.all(client)

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/exports/layouts"
    end
  end

  describe "find/3" do
    test "gets the export layout by id", %{client: client, stub: stub} do
      stub_success(stub, %{"export_layout" => %{"id" => "el_1", "name" => "Layout"}})

      assert {:ok, %ExportLayout{id: "el_1", name: "Layout"}} =
               ExportLayout.find(client, "el_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/exports/layouts/el_1"
    end
  end

  describe "find_default/3" do
    test "gets the default layout for an export type", %{client: client, stub: stub} do
      stub_success(stub, %{"export_layout" => %{"id" => "el_1", "is_default" => true}})

      assert {:ok, %ExportLayout{id: "el_1", is_default: true}} =
               ExportLayout.find_default(client, "transaction")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/exports/layouts/default/transaction"
    end
  end

  describe "create/3" do
    test "posts allowed params and decodes the layout", %{client: client, stub: stub} do
      stub_success(stub, %{"export_layout" => %{"id" => "el_1", "name" => "Layout"}})

      params = %{name: "Layout", type: "transaction", is_default: true, ignored: "dropped"}

      assert {:ok, %ExportLayout{id: "el_1", name: "Layout"}} =
               ExportLayout.create(client, params)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/exports/layouts"

      assert conn.assigns.json_body ==
               %{"name" => "Layout", "type" => "transaction", "is_default" => true}
    end
  end

  describe "update/4" do
    test "puts the updatable params", %{client: client, stub: stub} do
      stub_success(stub, %{"export_layout" => %{"id" => "el_1", "name" => "Renamed"}})

      params = %{name: "Renamed", type: "dropped"}

      assert {:ok, %ExportLayout{name: "Renamed"}} =
               ExportLayout.update(client, "el_1", params)

      assert_received {:request, conn}
      assert conn.method == "PUT"
      assert conn.request_path == "/exports/layouts/el_1"
      assert conn.assigns.json_body == %{"name" => "Renamed"}
    end
  end

  describe "delete/3" do
    test "deletes the export layout", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = ExportLayout.delete(client, "el_1")

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/exports/layouts/el_1"
    end
  end
end
