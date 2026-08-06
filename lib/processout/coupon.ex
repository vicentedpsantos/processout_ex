defmodule ProcessOut.Coupon do
  @moduledoc """
  Coupons that can be applied to subscriptions.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :amount_off
  field :percent_off
  field :currency
  field :iteration_count
  field :max_redemptions
  field :expires_at
  field :metadata
  field :redeemed_number
  field :sandbox
  field :created_at

  @create_params ~w(id amount_off percent_off currency iteration_count max_redemptions
                    expires_at metadata)a
  @update_params ~w(metadata)a

  @doc "Get all the coupons."
  @spec all(Client.t(), keyword()) :: {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def all(%Client{} = client, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/coupons", %{}, opts) do
      {:ok, Enum.map(body["coupons"] || [], &from_map/1)}
    end
  end

  @doc "Create a new coupon."
  @spec create(Client.t(), map(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def create(%Client{} = client, params, opts \\ []) do
    data = Request.take_params(params, @create_params)

    with {:ok, body} <- Request.post(client, "/coupons", data, opts) do
      {:ok, from_map(body["coupon"])}
    end
  end

  @doc "Find a coupon by its ID."
  @spec find(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, coupon_id, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/coupons/#{Request.encode(coupon_id)}", %{}, opts) do
      {:ok, from_map(body["coupon"])}
    end
  end

  @doc "Update the coupon attributes."
  @spec update(Client.t(), String.t(), map(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def update(%Client{} = client, coupon_id, params, opts \\ []) do
    data = Request.take_params(params, @update_params)

    with {:ok, body} <- Request.put(client, "/coupons/#{Request.encode(coupon_id)}", data, opts) do
      {:ok, from_map(body["coupon"])}
    end
  end

  @doc "Delete the coupon."
  @spec delete(Client.t(), String.t(), keyword()) :: :ok | {:error, ProcessOut.Error.t()}
  def delete(%Client{} = client, coupon_id, opts \\ []) do
    with {:ok, _body} <-
           Request.delete(client, "/coupons/#{Request.encode(coupon_id)}", %{}, opts) do
      :ok
    end
  end
end
