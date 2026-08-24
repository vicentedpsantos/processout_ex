defmodule ProcessOut.Card.CreateRequestTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Card
  alias ProcessOut.Card.CreateRequest

  describe "create/3" do
    test "posts allowed params and decodes the card", %{client: client, stub: stub} do
      stub_success(stub, %{
        "card" => %{"id" => "card_1", "name" => "John Smith", "token_type" => "card"}
      })

      params = %{
        name: "John Smith",
        number: "4242424242424242",
        exp_month: 12,
        exp_year: 2030,
        ignored: "dropped"
      }

      assert {:ok, %Card{id: "card_1", name: "John Smith", token_type: "card"}} =
               CreateRequest.create(client, params)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/cards"

      assert conn.assigns.json_body == %{
               "name" => "John Smith",
               "number" => "4242424242424242",
               "exp_month" => 12,
               "exp_year" => 2030
             }
    end
  end
end
