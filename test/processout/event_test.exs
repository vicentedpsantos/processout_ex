defmodule ProcessOut.EventTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Event
  alias ProcessOut.Webhook

  describe "all/2" do
    test "lists events", %{client: client, stub: stub} do
      stub_success(stub, %{
        "events" => [
          %{"id" => "ev_1", "name" => "invoice.captured"},
          %{"id" => "ev_2", "name" => "invoice.voided"}
        ]
      })

      assert {:ok, [%Event{id: "ev_1", name: "invoice.captured"}, %Event{id: "ev_2"}]} =
               Event.all(client)

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/events"
    end
  end

  describe "find/3" do
    test "gets the event by id", %{client: client, stub: stub} do
      stub_success(stub, %{"event" => %{"id" => "ev_1", "name" => "invoice.captured"}})

      assert {:ok, %Event{id: "ev_1", name: "invoice.captured"}} = Event.find(client, "ev_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/events/ev_1"
    end
  end

  describe "fetch_webhooks/3" do
    test "lists the event's webhooks", %{client: client, stub: stub} do
      stub_success(stub, %{
        "webhooks" => [%{"id" => "wh_1", "status" => "delivered"}]
      })

      assert {:ok, [%Webhook{id: "wh_1", status: "delivered"}]} =
               Event.fetch_webhooks(client, "ev_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/events/ev_1/webhooks"
    end
  end
end
