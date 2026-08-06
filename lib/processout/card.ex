defmodule ProcessOut.Card do
  @moduledoc """
  Cards tokenized through ProcessOut.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :token, cast: ProcessOut.Token
  field :scheme
  field :co_scheme
  field :preferred_scheme
  field :type
  field :bank_name
  field :brand
  field :category
  field :iin
  field :last_4_digits
  field :exp_month
  field :exp_year
  field :cvc_check
  field :avs_check
  field :name
  field :address1
  field :address2
  field :city
  field :state
  field :zip
  field :country_code
  field :ip_address
  field :fingerprint
  field :token_type
  field :used
  field :has_been_authorized
  field :metadata
  field :expires_soon
  field :sandbox
  field :created_at

  @doc "Get all the cards."
  @spec all(Client.t(), keyword()) :: {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def all(%Client{} = client, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/cards", %{}, opts) do
      {:ok, Enum.map(body["cards"] || [], &from_map/1)}
    end
  end

  @doc "Find a card by its ID."
  @spec find(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, card_id, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/cards/#{Request.encode(card_id)}", %{}, opts) do
      {:ok, from_map(body["card"])}
    end
  end

  @doc "Anonymize the card."
  @spec anonymize(Client.t(), String.t(), keyword()) :: :ok | {:error, ProcessOut.Error.t()}
  def anonymize(%Client{} = client, card_id, opts \\ []) do
    with {:ok, _body} <-
           Request.delete(client, "/cards/#{Request.encode(card_id)}", %{}, opts) do
      :ok
    end
  end
end
