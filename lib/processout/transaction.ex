defmodule ProcessOut.Transaction do
  @moduledoc """
  Payment transaction processed within a project.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Refund
  alias ProcessOut.Request

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :invoice, cast: ProcessOut.Invoice
  field :invoice_id
  field :customer, cast: ProcessOut.Customer
  field :customer_id
  field :subscription, cast: ProcessOut.Subscription
  field :subscription_id
  field :token, cast: ProcessOut.Token
  field :token_id
  field :card, cast: ProcessOut.Card
  field :card_id
  field :gateway_configuration, cast: ProcessOut.Gateway.Configuration
  field :external_three_d_s_gateway_configuration, cast: ProcessOut.Gateway.Configuration
  field :gateway_configuration_id
  field :operations, cast: ProcessOut.Transaction.Operation
  field :refunds, cast: ProcessOut.Refund
  field :name
  field :amount
  field :amount_local
  field :authorized_amount
  field :authorized_amount_local
  field :captured_amount
  field :captured_amount_local
  field :refunded_amount
  field :refunded_amount_local
  field :available_amount
  field :available_amount_local
  field :voided_amount
  field :voided_amount_local
  field :currency
  field :error_code
  field :error_message
  field :acquirer_name
  field :gateway_name
  field :three_d_s_status
  field :status
  field :authorized
  field :captured
  field :voided
  field :refunded
  field :chargedback
  field :received_fraud_notification
  field :received_retrieval_request
  field :processout_fee
  field :estimated_fee
  field :gateway_fee
  field :gateway_fee_local
  field :currency_fee
  field :metadata
  field :sandbox
  field :created_at
  field :chargedback_at
  field :refunded_at
  field :authorized_at
  field :captured_at
  field :voided_at
  field :three_d_s, cast: ProcessOut.ThreeDS
  field :cvc_check
  field :avs_check
  field :initial_scheme_transaction_id
  field :scheme_id
  field :payment_type
  field :eci
  field :native_apm, cast: ProcessOut.NativeAPM.Response
  field :external_details

  @doc "Get the transaction's refunds."
  @spec fetch_refunds(Client.t(), String.t(), keyword()) ::
          {:ok, [Refund.t()]} | {:error, ProcessOut.Error.t()}
  def fetch_refunds(%Client{} = client, transaction_id, opts \\ []) do
    path = "/transactions/#{Request.encode(transaction_id)}/refunds"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Enum.map(body["refunds"] || [], &Refund.from_map/1)}
    end
  end

  @doc "Find a transaction's refund by its ID."
  @spec find_refund(Client.t(), String.t(), String.t(), keyword()) ::
          {:ok, Refund.t()} | {:error, ProcessOut.Error.t()}
  def find_refund(%Client{} = client, transaction_id, refund_id, opts \\ []) do
    path =
      "/transactions/#{Request.encode(transaction_id)}/refunds/" <>
        Request.encode(refund_id)

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Refund.from_map(body["refund"])}
    end
  end

  @doc "Get all the transactions."
  @spec all(Client.t(), keyword()) :: {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def all(%Client{} = client, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/transactions", %{}, opts) do
      {:ok, Enum.map(body["transactions"] || [], &from_map/1)}
    end
  end

  @doc "Get full transactions data for specified list of ids."
  @spec list(Client.t(), keyword()) :: {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def list(%Client{} = client, opts \\ []) do
    with {:ok, body} <- Request.post(client, "/transactions", %{}, opts) do
      {:ok, Enum.map(body["transactions"] || [], &from_map/1)}
    end
  end

  @doc "Find a transaction by its ID."
  @spec find(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, transaction_id, opts \\ []) do
    path = "/transactions/#{Request.encode(transaction_id)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["transaction"])}
    end
  end
end
