defmodule ProcessOut.Addon do
  @moduledoc """
  Addons applied to subscriptions.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :subscription, cast: ProcessOut.Subscription
  field :subscription_id
  field :plan, cast: ProcessOut.Plan
  field :plan_id
  field :type
  field :name
  field :amount
  field :quantity
  field :metadata
  field :sandbox
  field :created_at

  @create_params ~w(plan_id type name amount quantity metadata prorate proration_date
                    preview)a
  @update_params ~w(plan_id type name amount quantity metadata prorate proration_date
                    preview increment_quantity_by)a
  @delete_params ~w(prorate proration_date preview)a

  @doc "Get the addons applied to the subscription."
  @spec fetch_subscription_addons(Client.t(), String.t(), keyword()) ::
          {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def fetch_subscription_addons(%Client{} = client, subscription_id, opts \\ []) do
    path = "/subscriptions/#{Request.encode(subscription_id)}/addons"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Enum.map(body["addons"] || [], &from_map/1)}
    end
  end

  @doc "Create a new addon to the given subscription ID."
  @spec create(Client.t(), String.t(), map(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def create(%Client{} = client, subscription_id, params, opts \\ []) do
    path = "/subscriptions/#{Request.encode(subscription_id)}/addons"
    data = Request.take_params(params, @create_params)

    with {:ok, body} <- Request.post(client, path, data, opts) do
      {:ok, from_map(body["addon"])}
    end
  end

  @doc "Find a subscription's addon by its ID."
  @spec find(Client.t(), String.t(), String.t(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, subscription_id, addon_id, opts \\ []) do
    path =
      "/subscriptions/#{Request.encode(subscription_id)}" <>
        "/addons/#{Request.encode(addon_id)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["addon"])}
    end
  end

  @doc "Save the updated addon attributes."
  @spec update(Client.t(), String.t(), String.t(), map(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def update(%Client{} = client, subscription_id, addon_id, params, opts \\ []) do
    path =
      "/subscriptions/#{Request.encode(subscription_id)}" <>
        "/addons/#{Request.encode(addon_id)}"

    data = Request.take_params(params, @update_params)

    with {:ok, body} <- Request.put(client, path, data, opts) do
      {:ok, from_map(body["addon"])}
    end
  end

  @doc "Delete an addon applied to a subscription."
  @spec delete(Client.t(), String.t(), String.t(), map(), keyword()) ::
          :ok | {:error, ProcessOut.Error.t()}
  def delete(%Client{} = client, subscription_id, addon_id, params \\ %{}, opts \\ []) do
    path =
      "/subscriptions/#{Request.encode(subscription_id)}" <>
        "/addons/#{Request.encode(addon_id)}"

    data = Request.take_params(params, @delete_params)

    with {:ok, _body} <- Request.delete(client, path, data, opts) do
      :ok
    end
  end
end
