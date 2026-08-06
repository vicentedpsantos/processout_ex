defmodule ProcessOut.Card.UpdateRequestTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Card.UpdateRequest

  describe "update/4" do
    test "puts the updatable params and decodes the card", %{client: client, stub: stub} do
      stub_success(stub, %{"card" => %{"preferred_scheme" => "carte bancaire"}})

      params = %{preferred_scheme: "carte bancaire", ignored: "dropped"}

      assert {:ok, %UpdateRequest{preferred_scheme: "carte bancaire"}} =
               UpdateRequest.update(client, "card_1", params)

      assert_received {:request, conn}
      assert conn.method == "PUT"
      assert conn.request_path == "/cards/card_1"
      assert conn.assigns.json_body == %{"preferred_scheme" => "carte bancaire"}
    end
  end
end
