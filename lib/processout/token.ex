defmodule ProcessOut.Token do
  @moduledoc """
  Payment tokens attached to a customer.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Customer.Action
  alias ProcessOut.Request

  field :id
  field :customer, cast: ProcessOut.Customer
  field :customer_id
  field :gateway_configuration, cast: ProcessOut.Gateway.Configuration
  field :gateway_configuration_id
  field :card, cast: ProcessOut.Card
  field :card_id
  field :type
  field :metadata
  field :is_subscription_only
  field :is_default
  field :return_url
  field :cancel_url
  field :summary
  field :is_chargeable
  field :created_at
  field :description
  field :invoice, cast: ProcessOut.Invoice
  field :invoice_id
  field :manual_invoice_cancellation
  field :verification_status
  field :can_get_balance
  field :webhook_url

  @create_params ~w(metadata return_url cancel_url description invoice_id
                    manual_invoice_cancellation webhook_url gateway_configuration_id
                    source settings device verify verify_metadata set_default
                    verify_statement_descriptor invoice_return_url summary)a
  @update_params ~w(source settings device verify verify_metadata set_default
                    verify_statement_descriptor invoice_return_url
                    gateway_configuration_id)a

  @doc "Get the customer's tokens."
  @spec fetch_customer_tokens(Client.t(), String.t(), keyword()) ::
          {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def fetch_customer_tokens(%Client{} = client, customer_id, opts \\ []) do
    path = "/customers/#{Request.encode(customer_id)}/tokens"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Enum.map(body["tokens"] || [], &from_map/1)}
    end
  end

  @doc "Find a customer's token by its ID."
  @spec find(Client.t(), String.t(), String.t(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, customer_id, token_id, opts \\ []) do
    path = "/customers/#{Request.encode(customer_id)}/tokens/#{Request.encode(token_id)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["token"])}
    end
  end

  @doc "Create a new token for the given customer ID."
  @spec create(Client.t(), String.t(), map(), keyword()) ::
          {:ok, %{token: t() | nil, customer_action: Action.t() | nil}}
          | {:error, ProcessOut.Error.t()}
  def create(%Client{} = client, customer_id, params, opts \\ []) do
    data = Request.take_params(params, @create_params)
    path = "/customers/#{Request.encode(customer_id)}/tokens"

    with {:ok, body} <- Request.post(client, path, data, opts) do
      {:ok,
       %{
         token: from_map(body["token"]),
         customer_action: Action.from_map(body["customer_action"])
       }}
    end
  end

  @doc "Save the updated customer attributes."
  @spec update(Client.t(), String.t(), String.t(), map(), keyword()) ::
          :ok | {:error, ProcessOut.Error.t()}
  def update(%Client{} = client, customer_id, token_id, params, opts \\ []) do
    data = Request.take_params(params, @update_params)
    path = "/customers/#{Request.encode(customer_id)}/tokens/#{Request.encode(token_id)}"

    with {:ok, _body} <- Request.put(client, path, data, opts) do
      :ok
    end
  end

  @doc "Delete a customer token."
  @spec delete(Client.t(), String.t(), String.t(), keyword()) ::
          :ok | {:error, ProcessOut.Error.t()}
  def delete(%Client{} = client, customer_id, token_id, opts \\ []) do
    path = "/customers/#{Request.encode(customer_id)}/tokens/#{Request.encode(token_id)}"

    with {:ok, _body} <- Request.delete(client, path, %{}, opts) do
      :ok
    end
  end
end
