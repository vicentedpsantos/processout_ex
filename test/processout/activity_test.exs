defmodule ProcessOut.ActivityTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Activity

  describe "all/2" do
    test "lists activities", %{client: client, stub: stub} do
      stub_success(stub, %{
        "activities" => [
          %{"id" => "activity_1", "title" => "Payment failed"},
          %{"id" => "activity_2", "title" => "Payment captured"}
        ]
      })

      assert {:ok,
              [%Activity{id: "activity_1", title: "Payment failed"}, %Activity{id: "activity_2"}]} =
               Activity.all(client)

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/activities"
    end
  end

  describe "find/3" do
    test "gets the activity by id", %{client: client, stub: stub} do
      stub_success(stub, %{"activity" => %{"id" => "activity_1", "level" => "warn"}})

      assert {:ok, %Activity{id: "activity_1", level: "warn"}} =
               Activity.find(client, "activity_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/activities/activity_1"
    end
  end
end
