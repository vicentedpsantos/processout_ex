defmodule ProcessOut.Project.SFTPSettingsTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Project.SFTPSettings

  describe "save_sftp_settings/4" do
    test "puts the allowed params", %{client: client, stub: stub} do
      stub_success(stub, %{})

      params = %{
        endpoint: "sftp://example.com",
        username: "user",
        password: "secret",
        ignored: "dropped"
      }

      assert :ok = SFTPSettings.save_sftp_settings(client, "proj_1", params)

      assert_received {:request, conn}
      assert conn.method == "PUT"
      assert conn.request_path == "/projects/proj_1/sftp-settings"

      assert conn.assigns.json_body ==
               %{
                 "endpoint" => "sftp://example.com",
                 "username" => "user",
                 "password" => "secret"
               }
    end
  end

  describe "delete_sftp_settings/3" do
    test "deletes the settings", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = SFTPSettings.delete_sftp_settings(client, "proj_1")

      assert_received {:request, conn}
      assert conn.method == "DELETE"
      assert conn.request_path == "/projects/proj_1/sftp-settings"
    end
  end
end
