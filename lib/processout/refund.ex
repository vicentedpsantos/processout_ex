defmodule ProcessOut.Refund do
  @moduledoc """
  Refund applied to a transaction.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :id
  field :transaction, cast: ProcessOut.Transaction
  field :transaction_id
  field :amount
  field :reason
  field :information
  field :has_failed
  field :metadata
  field :sandbox
  field :created_at
  field :invoice_detail_ids

  @create_for_invoice_params ~w(amount reason information invoice_detail_ids metadata)a
  @create_params ~w(amount reason information invoice_detail_ids metadata)a

  @doc "Create a refund for an invoice."
  @spec create_for_invoice(Client.t(), String.t(), map(), keyword()) ::
          :ok | {:error, ProcessOut.Error.t()}
  def create_for_invoice(%Client{} = client, invoice_id, params, opts \\ []) do
    data = Request.take_params(params, @create_for_invoice_params)
    path = "/invoices/#{Request.encode(invoice_id)}/refunds"

    with {:ok, _body} <- Request.post(client, path, data, opts) do
      :ok
    end
  end

  @doc "Get the transaction's refunds."
  @spec fetch_transaction_refunds(Client.t(), String.t(), keyword()) ::
          {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def fetch_transaction_refunds(%Client{} = client, transaction_id, opts \\ []) do
    path = "/transactions/#{Request.encode(transaction_id)}/refunds"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Enum.map(body["refunds"] || [], &from_map/1)}
    end
  end

  @doc "Find a transaction's refund by its ID."
  @spec find(Client.t(), String.t(), String.t(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, transaction_id, refund_id, opts \\ []) do
    path =
      "/transactions/#{Request.encode(transaction_id)}/refunds/" <>
        Request.encode(refund_id)

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["refund"])}
    end
  end

  @doc "Create a refund for a transaction."
  @spec create(Client.t(), String.t(), map(), keyword()) ::
          :ok | {:error, ProcessOut.Error.t()}
  def create(%Client{} = client, transaction_id, params, opts \\ []) do
    data = Request.take_params(params, @create_params)
    path = "/transactions/#{Request.encode(transaction_id)}/refunds"

    with {:ok, _body} <- Request.post(client, path, data, opts) do
      :ok
    end
  end
end
