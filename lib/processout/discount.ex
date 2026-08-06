defmodule ProcessOut.Discount do
  @moduledoc """
  Discounts applied to subscriptions.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :subscription, cast: ProcessOut.Subscription
  field :subscription_id
  field :coupon, cast: ProcessOut.Coupon
  field :coupon_id
  field :name
  field :amount
  field :percent
  field :expires_at
  field :metadata
  field :sandbox
  field :created_at

  @create_params ~w(coupon_id name amount expires_at metadata)a

  @doc "Get the discounts applied to the subscription."
  @spec fetch_subscription_discounts(Client.t(), String.t(), keyword()) ::
          {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def fetch_subscription_discounts(%Client{} = client, subscription_id, opts \\ []) do
    path = "/subscriptions/#{Request.encode(subscription_id)}/discounts"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Enum.map(body["discounts"] || [], &from_map/1)}
    end
  end

  @doc "Create a new discount for the given subscription ID."
  @spec create(Client.t(), String.t(), map(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def create(%Client{} = client, subscription_id, params, opts \\ []) do
    path = "/subscriptions/#{Request.encode(subscription_id)}/discounts"
    data = Request.take_params(params, @create_params)

    with {:ok, body} <- Request.post(client, path, data, opts) do
      {:ok, from_map(body["discount"])}
    end
  end

  @doc "Find a subscription's discount by its ID."
  @spec find(Client.t(), String.t(), String.t(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, subscription_id, discount_id, opts \\ []) do
    path =
      "/subscriptions/#{Request.encode(subscription_id)}" <>
        "/discounts/#{Request.encode(discount_id)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["discount"])}
    end
  end

  @doc "Delete a discount applied to a subscription."
  @spec delete(Client.t(), String.t(), String.t(), keyword()) ::
          :ok | {:error, ProcessOut.Error.t()}
  def delete(%Client{} = client, subscription_id, discount_id, opts \\ []) do
    path =
      "/subscriptions/#{Request.encode(subscription_id)}" <>
        "/discounts/#{Request.encode(discount_id)}"

    with {:ok, _body} <- Request.delete(client, path, %{}, opts) do
      :ok
    end
  end
end
