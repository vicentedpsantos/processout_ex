defmodule ProcessOut.Balances do
  @moduledoc """
  Balances of a customer token.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :vouchers, cast: ProcessOut.Balance
  field :available_balance, cast: ProcessOut.Balance
  field :customer_action, cast: ProcessOut.Balances.CustomerAction

  @doc "Fetch a customer token's balance"
  @spec find(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, token_id, opts \\ []) do
    path = "/balances/tokens/#{Request.encode(token_id)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["balances"])}
    end
  end
end
