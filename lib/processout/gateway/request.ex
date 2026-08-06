defmodule ProcessOut.Gateway.Request do
  @moduledoc """
  Gateway request tokens embedding an HTTP request made to a gateway.
  """

  @doc """
  Builds the gateway request token for the given gateway configuration,
  encoding the request definition (`:method`, `:url`, `:headers`,
  `:body`) as a base64 JSON payload.
  """
  @spec token(String.t(), map()) :: String.t()
  def token(gateway_configuration_id, data \\ %{}) do
    payload = %{
      "gateway_configuration_id" => gateway_configuration_id,
      "method" => data[:method],
      "url" => data[:url],
      "headers" => data[:headers] || %{},
      "body" => data[:body]
    }

    "gway_req_" <> Base.encode64(JSON.encode!(payload))
  end
end
