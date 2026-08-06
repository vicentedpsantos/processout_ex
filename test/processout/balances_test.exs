defmodule ProcessOut.BalancesTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Balance
  alias ProcessOut.Balances

  describe "find/3" do
    test "gets the balances for a token", %{client: client, stub: stub} do
      stub_success(stub, %{
        "balances" => %{
          "vouchers" => [%{"amount" => "10.00", "currency" => "USD"}],
          "available_balance" => %{"amount" => "10.00", "currency" => "USD"}
        }
      })

      assert {:ok, %Balances{vouchers: [voucher], available_balance: available}} =
               Balances.find(client, "tok_1")

      assert %Balance{amount: "10.00", currency: "USD"} = voucher
      assert %Balance{amount: "10.00", currency: "USD"} = available

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/balances/tokens/tok_1"
    end
  end
end
