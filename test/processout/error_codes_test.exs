defmodule ProcessOut.ErrorCodesTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.CategoryErrorCodes
  alias ProcessOut.ErrorCodes

  describe "all/2" do
    test "gets all error codes", %{client: client, stub: stub} do
      stub_success(stub, %{
        "gateway" => %{"card" => ["card.declined"], "generic" => ["gateway.unknown-error"]}
      })

      assert {:ok, %ErrorCodes{gateway: gateway}} = ErrorCodes.all(client)

      assert %CategoryErrorCodes{
               card: ["card.declined"],
               generic: ["gateway.unknown-error"]
             } = gateway

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/error-codes"
    end
  end
end
