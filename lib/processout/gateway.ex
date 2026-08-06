defmodule ProcessOut.Gateway do
  @moduledoc """
  Payment gateway supported by ProcessOut.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Gateway.Configuration
  alias ProcessOut.Request

  field :id
  field :name
  field :display_name
  field :logo_url
  field :url
  field :flows
  field :tags
  field :can_pull_transactions
  field :can_refund
  field :is_oauth_authentication
  field :description

  @doc "Get all the gateway configurations of the gateway."
  @spec fetch_gateway_configurations(Client.t(), String.t(), keyword()) ::
          {:ok, [Configuration.t()]} | {:error, ProcessOut.Error.t()}
  def fetch_gateway_configurations(%Client{} = client, gateway_name, opts \\ []) do
    path = "/gateways/#{Request.encode(gateway_name)}/gateway-configurations"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Enum.map(body["gateway_configurations"] || [], &Configuration.from_map/1)}
    end
  end
end
