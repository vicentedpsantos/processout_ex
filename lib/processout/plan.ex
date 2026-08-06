defmodule ProcessOut.Plan do
  @moduledoc """
  Subscription plans defining recurring billing terms.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :url
  field :name
  field :amount
  field :currency
  field :metadata
  field :interval
  field :trial_period
  field :return_url
  field :cancel_url
  field :sandbox
  field :created_at

  @create_params ~w(id name amount currency interval trial_period metadata return_url
                    cancel_url)a
  @update_params ~w(name trial_period metadata return_url cancel_url)a

  @doc "Get all the plans."
  @spec all(Client.t(), keyword()) :: {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def all(%Client{} = client, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/plans", %{}, opts) do
      {:ok, Enum.map(body["plans"] || [], &from_map/1)}
    end
  end

  @doc "Create a new plan."
  @spec create(Client.t(), map(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def create(%Client{} = client, params, opts \\ []) do
    data = Request.take_params(params, @create_params)

    with {:ok, body} <- Request.post(client, "/plans", data, opts) do
      {:ok, from_map(body["plan"])}
    end
  end

  @doc "Find a plan by its ID."
  @spec find(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, plan_id, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/plans/#{Request.encode(plan_id)}", %{}, opts) do
      {:ok, from_map(body["plan"])}
    end
  end

  @doc """
  Save the updated plan attributes. This action won't affect subscriptions
  already linked to this plan.
  """
  @spec update(Client.t(), String.t(), map(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def update(%Client{} = client, plan_id, params, opts \\ []) do
    data = Request.take_params(params, @update_params)

    with {:ok, body} <- Request.put(client, "/plans/#{Request.encode(plan_id)}", data, opts) do
      {:ok, from_map(body["plan"])}
    end
  end

  @doc "Delete a plan. Subscriptions linked to this plan won't be affected."
  @spec end_plan(Client.t(), String.t(), keyword()) :: :ok | {:error, ProcessOut.Error.t()}
  def end_plan(%Client{} = client, plan_id, opts \\ []) do
    with {:ok, _body} <-
           Request.delete(client, "/plans/#{Request.encode(plan_id)}", %{}, opts) do
      :ok
    end
  end
end
