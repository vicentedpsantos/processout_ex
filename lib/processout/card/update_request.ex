defmodule ProcessOut.Card.UpdateRequest do
  @moduledoc """
  Request parameters used to update a card.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :preferred_scheme

  @update_params ~w(preferred_scheme)a

  @doc "Update a card by its ID."
  @spec update(Client.t(), String.t(), map(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def update(%Client{} = client, card_id, params, opts \\ []) do
    data = Request.take_params(params, @update_params)

    with {:ok, body} <- Request.put(client, "/cards/#{Request.encode(card_id)}", data, opts) do
      {:ok, from_map(body["card"])}
    end
  end
end
