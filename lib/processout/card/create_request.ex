defmodule ProcessOut.Card.CreateRequest do
  @moduledoc """
  Request parameters used to create a card.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :device, cast: ProcessOut.Device
  field :name
  field :number
  field :exp_day
  field :exp_month
  field :exp_year
  field :cvc2
  field :preferred_scheme
  field :metadata
  field :token_type
  field :eci
  field :cryptogram
  field :applepay_response
  field :applepay_mid
  field :payment_token
  field :contact, cast: ProcessOut.Card.Contact
  field :shipping, cast: ProcessOut.Card.Shipping

  @create_params ~w(device name number exp_day exp_month exp_year cvc2 preferred_scheme
                    metadata token_type eci cryptogram applepay_response applepay_mid
                    payment_token contact shipping)a

  @doc "Create a new card."
  @spec create(Client.t(), map(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def create(%Client{} = client, params, opts \\ []) do
    data = Request.take_params(params, @create_params)

    with {:ok, body} <- Request.post(client, "/cards", data, opts) do
      {:ok, from_map(body["card"])}
    end
  end
end
