defmodule ProcessOut.ProjectTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Project

  describe "fetch/3" do
    test "gets the project by id", %{client: client, stub: stub} do
      stub_success(stub, %{"project" => %{"id" => "proj_1", "name" => "Test"}})

      assert {:ok, %Project{id: "proj_1", name: "Test"}} = Project.fetch(client, "proj_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/projects/proj_1"
    end
  end

  describe "update/3" do
    test "puts the project", %{client: client, stub: stub} do
      stub_success(stub, %{"project" => %{"id" => "proj_1", "name" => "Renamed"}})

      assert {:ok, %Project{id: "proj_1", name: "Renamed"}} = Project.update(client, "proj_1")

      assert_received {:request, conn}
      assert conn.method == "PUT"
      assert conn.request_path == "/projects/proj_1"
      assert conn.assigns.json_body == %{}
    end
  end

  describe "delete/3" do
    test "deletes the project", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = Project.delete(client, "proj_1")

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/projects/proj_1"
    end
  end

  describe "fetch_supervised/2" do
    test "lists the supervised projects", %{client: client, stub: stub} do
      stub_success(stub, %{
        "projects" => [%{"id" => "proj_1"}, %{"id" => "proj_2"}]
      })

      assert {:ok, [%Project{id: "proj_1"}, %Project{id: "proj_2"}]} =
               Project.fetch_supervised(client)

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/supervised-projects"
    end
  end

  describe "create_supervised/3" do
    test "posts allowed params and decodes the project", %{client: client, stub: stub} do
      stub_success(stub, %{"project" => %{"id" => "proj_1", "name" => "Supervised"}})

      params = %{
        id: "proj_1",
        name: "Supervised",
        default_currency: "USD",
        ignored: "dropped"
      }

      assert {:ok, %Project{id: "proj_1", name: "Supervised"}} =
               Project.create_supervised(client, params)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/supervised-projects"

      assert conn.assigns.json_body ==
               %{"id" => "proj_1", "name" => "Supervised", "default_currency" => "USD"}
    end
  end
end
