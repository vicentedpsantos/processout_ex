defmodule ProcessOut.Subscription do
  @moduledoc """
  Recurring subscriptions billing customers on an interval.
  """

  use ProcessOut.Resource

  alias ProcessOut.Addon
  alias ProcessOut.Client
  alias ProcessOut.Discount
  alias ProcessOut.Request

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :plan, cast: ProcessOut.Plan
  field :plan_id
  field :discounts, cast: ProcessOut.Discount
  field :addons, cast: ProcessOut.Addon
  field :transactions, cast: ProcessOut.Transaction
  field :customer, cast: ProcessOut.Customer
  field :customer_id
  field :token, cast: ProcessOut.Token
  field :token_id
  field :url
  field :name
  field :amount
  field :billable_amount
  field :discounted_amount
  field :addons_amount
  field :currency
  field :metadata
  field :interval
  field :trial_end_at
  field :activated
  field :active
  field :cancel_at
  field :canceled
  field :cancellation_reason
  field :pending_cancellation
  field :return_url
  field :cancel_url
  field :unpaid_state
  field :sandbox
  field :created_at
  field :activated_at
  field :iterate_at

  @delete_addon_params ~w(prorate proration_date preview)a
  @create_params ~w(plan_id cancel_at name amount currency metadata interval trial_end_at
                    customer_id return_url cancel_url source coupon_id)a
  @update_params ~w(plan_id name amount interval trial_end_at metadata coupon_id source
                    prorate proration_date preview)a
  @cancel_params ~w(cancel_at cancellation_reason cancel_at_end)a

  @doc "Get the addons applied to the subscription."
  @spec fetch_addons(Client.t(), String.t(), keyword()) ::
          {:ok, [Addon.t()]} | {:error, ProcessOut.Error.t()}
  def fetch_addons(%Client{} = client, subscription_id, opts \\ []) do
    path = "/subscriptions/#{Request.encode(subscription_id)}/addons"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Enum.map(body["addons"] || [], &Addon.from_map/1)}
    end
  end

  @doc "Find a subscription's addon by its ID."
  @spec find_addon(Client.t(), String.t(), String.t(), keyword()) ::
          {:ok, Addon.t()} | {:error, ProcessOut.Error.t()}
  def find_addon(%Client{} = client, subscription_id, addon_id, opts \\ []) do
    path =
      "/subscriptions/#{Request.encode(subscription_id)}" <>
        "/addons/#{Request.encode(addon_id)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Addon.from_map(body["addon"])}
    end
  end

  @doc "Delete an addon applied to a subscription."
  @spec delete_addon(Client.t(), String.t(), String.t(), map(), keyword()) ::
          :ok | {:error, ProcessOut.Error.t()}
  def delete_addon(%Client{} = client, subscription_id, addon_id, params \\ %{}, opts \\ []) do
    path =
      "/subscriptions/#{Request.encode(subscription_id)}" <>
        "/addons/#{Request.encode(addon_id)}"

    data = Request.take_params(params, @delete_addon_params)

    with {:ok, _body} <- Request.delete(client, path, data, opts) do
      :ok
    end
  end

  @doc "Get the customer owning the subscription."
  @spec fetch_customer(Client.t(), String.t(), keyword()) ::
          {:ok, ProcessOut.Customer.t()} | {:error, ProcessOut.Error.t()}
  def fetch_customer(%Client{} = client, subscription_id, opts \\ []) do
    path = "/subscriptions/#{Request.encode(subscription_id)}/customers"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, ProcessOut.Customer.from_map(body["customer"])}
    end
  end

  @doc "Get the discounts applied to the subscription."
  @spec fetch_discounts(Client.t(), String.t(), keyword()) ::
          {:ok, [Discount.t()]} | {:error, ProcessOut.Error.t()}
  def fetch_discounts(%Client{} = client, subscription_id, opts \\ []) do
    path = "/subscriptions/#{Request.encode(subscription_id)}/discounts"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Enum.map(body["discounts"] || [], &Discount.from_map/1)}
    end
  end

  @doc "Find a subscription's discount by its ID."
  @spec find_discount(Client.t(), String.t(), String.t(), keyword()) ::
          {:ok, Discount.t()} | {:error, ProcessOut.Error.t()}
  def find_discount(%Client{} = client, subscription_id, discount_id, opts \\ []) do
    path =
      "/subscriptions/#{Request.encode(subscription_id)}" <>
        "/discounts/#{Request.encode(discount_id)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Discount.from_map(body["discount"])}
    end
  end

  @doc "Delete a discount applied to a subscription."
  @spec delete_discount(Client.t(), String.t(), String.t(), keyword()) ::
          :ok | {:error, ProcessOut.Error.t()}
  def delete_discount(%Client{} = client, subscription_id, discount_id, opts \\ []) do
    path =
      "/subscriptions/#{Request.encode(subscription_id)}" <>
        "/discounts/#{Request.encode(discount_id)}"

    with {:ok, _body} <- Request.delete(client, path, %{}, opts) do
      :ok
    end
  end

  @doc "Get the subscriptions past transactions."
  @spec fetch_transactions(Client.t(), String.t(), keyword()) ::
          {:ok, [ProcessOut.Transaction.t()]} | {:error, ProcessOut.Error.t()}
  def fetch_transactions(%Client{} = client, subscription_id, opts \\ []) do
    path = "/subscriptions/#{Request.encode(subscription_id)}/transactions"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Enum.map(body["transactions"] || [], &ProcessOut.Transaction.from_map/1)}
    end
  end

  @doc "Get all the subscriptions."
  @spec all(Client.t(), keyword()) :: {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def all(%Client{} = client, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/subscriptions", %{}, opts) do
      {:ok, Enum.map(body["subscriptions"] || [], &from_map/1)}
    end
  end

  @doc "Create a new subscription for the given customer."
  @spec create(Client.t(), map(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def create(%Client{} = client, params, opts \\ []) do
    data = Request.take_params(params, @create_params)

    with {:ok, body} <- Request.post(client, "/subscriptions", data, opts) do
      {:ok, from_map(body["subscription"])}
    end
  end

  @doc "Find a subscription by its ID."
  @spec find(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, subscription_id, opts \\ []) do
    path = "/subscriptions/#{Request.encode(subscription_id)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["subscription"])}
    end
  end

  @doc "Save the updated subscription attributes."
  @spec update(Client.t(), String.t(), map(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def update(%Client{} = client, subscription_id, params, opts \\ []) do
    path = "/subscriptions/#{Request.encode(subscription_id)}"
    data = Request.take_params(params, @update_params)

    with {:ok, body} <- Request.put(client, path, data, opts) do
      {:ok, from_map(body["subscription"])}
    end
  end

  @doc "Cancel a subscription. The reason may be provided as well."
  @spec cancel(Client.t(), String.t(), map(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def cancel(%Client{} = client, subscription_id, params \\ %{}, opts \\ []) do
    path = "/subscriptions/#{Request.encode(subscription_id)}"
    data = Request.take_params(params, @cancel_params)

    with {:ok, body} <- Request.delete(client, path, data, opts) do
      {:ok, from_map(body["subscription"])}
    end
  end
end
