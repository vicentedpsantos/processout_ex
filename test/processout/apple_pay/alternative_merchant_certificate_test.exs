defmodule ProcessOut.ApplePay.AlternativeMerchantCertificateTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.ApplePay.AlternativeMerchantCertificate

  describe "update/2" do
    test "posts to the collection path and decodes the certificate",
         %{client: client, stub: stub} do
      stub_success(stub, %{"alternative_merchant_certificate" => %{"id" => "cert_1"}})

      assert {:ok, %AlternativeMerchantCertificate{id: "cert_1"}} =
               AlternativeMerchantCertificate.update(client)

      assert_received {:request, conn}
      assert conn.method == "POST"
      assert conn.request_path == "/projects/applepay/alternative-merchant-certificates"
      assert conn.assigns.json_body == %{}
    end
  end

  describe "delete/3" do
    test "deletes the certificate", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert :ok = AlternativeMerchantCertificate.delete(client, "cert_1")

      assert_received {:request, conn}
      assert conn.method == "DELETE"

      assert conn.request_path ==
               "/projects/applepay/alternative-merchant-certificates/cert_1"
    end
  end
end
