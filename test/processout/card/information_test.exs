defmodule ProcessOut.Card.InformationTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Card.Information

  describe "fetch/3" do
    test "gets the card information by iin", %{client: client, stub: stub} do
      stub_success(stub, %{
        "card_information" => %{"iin" => "424242", "scheme" => "visa"}
      })

      assert {:ok, %Information{iin: "424242", scheme: "visa"}} =
               Information.fetch(client, "424242")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/iins/424242"
    end
  end
end
