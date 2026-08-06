defmodule ProcessOut.ExportLayout.Configuration.OptionsTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.ExportLayout.Configuration.Options

  describe "fetch/3" do
    test "gets the options for an export type", %{client: client, stub: stub} do
      stub_success(stub, %{
        "export_layout_configuration_options" => %{
          "columns" => ["id", "amount"],
          "time" => %{"format" => ["unix"]},
          "amount" => %{"precision" => [2], "separator" => ["."]}
        }
      })

      assert {:ok, %Options{columns: ["id", "amount"], time: time}} =
               Options.fetch(client, "transaction")

      assert time.format == ["unix"]

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/exports/layouts/options/transaction"
    end
  end
end
