defmodule ProcessOut.ApplePay.AlternativeMerchantCertificatesTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.ApplePay.AlternativeMerchantCertificate
  alias ProcessOut.ApplePay.AlternativeMerchantCertificates

  describe "fetch/2" do
    test "gets the alternative certificates", %{client: client, stub: stub} do
      stub_success(stub, %{
        "applepay_certificates" => %{
          "count" => 1,
          "alternative_merchant_certificates" => [%{"id" => "cert_1"}]
        }
      })

      assert {:ok,
              %AlternativeMerchantCertificates{
                count: 1,
                alternative_merchant_certificates: certs
              }} =
               AlternativeMerchantCertificates.fetch(client)

      assert [%AlternativeMerchantCertificate{id: "cert_1"}] = certs

      assert_received {:request, conn}
      assert conn.method == "GET"
      assert conn.request_path == "/projects/applepay/alternative-merchant-certificates"
    end
  end
end
