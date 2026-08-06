defmodule ProcessOut.Card.Information do
  @moduledoc """
  Card information resolved from an IIN.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :iin
  field :scheme
  field :type
  field :bank_name
  field :brand
  field :category
  field :country

  @doc "Fetch card information from the IIN."
  @spec fetch(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def fetch(%Client{} = client, iin, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/iins/#{Request.encode(iin)}", %{}, opts) do
      {:ok, from_map(body["card_information"])}
    end
  end
end
