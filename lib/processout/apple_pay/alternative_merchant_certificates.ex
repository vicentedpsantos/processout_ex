defmodule ProcessOut.ApplePay.AlternativeMerchantCertificates do
  @moduledoc """
  Alternative Apple Pay merchant certificates of a project.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :count

  field :alternative_merchant_certificates,
    cast: ProcessOut.ApplePay.AlternativeMerchantCertificate

  @doc "Fetch the project's alternative certificates by ID"
  @spec fetch(Client.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def fetch(%Client{} = client, opts \\ []) do
    path = "/projects/applepay/alternative-merchant-certificates"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["applepay_certificates"])}
    end
  end
end
