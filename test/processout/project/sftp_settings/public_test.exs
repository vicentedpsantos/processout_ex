defmodule ProcessOut.Project.SFTPSettings.PublicTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Project.SFTPSettings.Public

  describe "fetch_sftp_settings/3" do
    test "gets the settings for the project", %{client: client, stub: stub} do
      stub_success(stub, %{
        "sftp_settings" => %{
          "enabled" => true,
          "endpoint" => "sftp://example.com",
          "username" => "user"
        }
      })

      assert {:ok,
              %Public{
                enabled: true,
                endpoint: "sftp://example.com",
                username: "user"
              }} = Public.fetch_sftp_settings(client, "proj_1")

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/projects/proj_1/sftp-settings"
    end
  end
end
