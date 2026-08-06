defmodule ProcessOut.Payout do
  @moduledoc """
  Payout settled to the merchant's bank account.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Payout.Item
  alias ProcessOut.Request

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :status
  field :amount
  field :currency
  field :metadata
  field :bank_name
  field :bank_summary
  field :sales_transactions
  field :sales_volume
  field :refunds_transactions
  field :refunds_volume
  field :chargebacks_transactions
  field :chargebacks_volume
  field :fees
  field :adjustments
  field :reserve
  field :settled_at
  field :created_at

  @doc "Get all the items linked to the payout."
  @spec fetch_items(Client.t(), String.t(), keyword()) ::
          {:ok, [Item.t()]} | {:error, ProcessOut.Error.t()}
  def fetch_items(%Client{} = client, payout_id, opts \\ []) do
    path = "/payouts/#{Request.encode(payout_id)}/items"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Enum.map(body["items"] || [], &Item.from_map/1)}
    end
  end

  @doc "Get all the payouts."
  @spec all(Client.t(), keyword()) :: {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def all(%Client{} = client, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/payouts", %{}, opts) do
      {:ok, Enum.map(body["payouts"] || [], &from_map/1)}
    end
  end

  @doc "Find a payout by its ID."
  @spec find(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, payout_id, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/payouts/#{Request.encode(payout_id)}", %{}, opts) do
      {:ok, from_map(body["payout"])}
    end
  end

  @doc "Delete the payout along with its payout items."
  @spec delete(Client.t(), String.t(), keyword()) :: :ok | {:error, ProcessOut.Error.t()}
  def delete(%Client{} = client, payout_id, opts \\ []) do
    with {:ok, _body} <-
           Request.delete(client, "/payouts/#{Request.encode(payout_id)}", %{}, opts) do
      :ok
    end
  end
end
