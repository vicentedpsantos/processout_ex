defmodule ProcessOut.ApplePay.AlternativeMerchantCertificate do
  @moduledoc """
  Alternative Apple Pay merchant certificate of a project.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :id

  @doc "Save new alternative apple pay certificates"
  @spec update(Client.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def update(%Client{} = client, opts \\ []) do
    path = "/projects/applepay/alternative-merchant-certificates"

    with {:ok, body} <- Request.post(client, path, %{}, opts) do
      {:ok, from_map(body["alternative_merchant_certificate"])}
    end
  end

  @doc "Delete a given alternative merchant certificate"
  @spec delete(Client.t(), String.t(), keyword()) :: :ok | {:error, ProcessOut.Error.t()}
  def delete(%Client{} = client, certificate_id, opts \\ []) do
    path =
      "/projects/applepay/alternative-merchant-certificates/" <>
        Request.encode(certificate_id)

    with {:ok, _body} <- Request.delete(client, path, %{}, opts) do
      :ok
    end
  end
end
