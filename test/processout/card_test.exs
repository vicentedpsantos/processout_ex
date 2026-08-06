defmodule ProcessOut.CardTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Card

  describe "all/2" do
    test "lists cards", %{client: client, stub: stub} do
      stub_success(stub, %{
        "cards" => [
          %{"id" => "card_1", "last_4_digits" => "4242"},
          %{"id" => "card_2"}
        ]
      })

      assert {:ok, [%Card{id: "card_1", last_4_digits: "4242"}, %Card{id: "card_2"}]} =
               Card.all(client)

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/cards"
    end
  end

  describe "find/3" do
    test "gets the card by id", %{client: client, stub: stub} do
      stub_success(stub, %{"card" => %{"id" => "card_1"}})

      assert {:ok, %Card{id: "card_1"}} = Card.find(client, "card_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/cards/card_1"
    end
  end

  describe "anonymize/3" do
    test "anonymizes the card", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = Card.anonymize(client, "card_1")

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/cards/card_1"
    end
  end
end
