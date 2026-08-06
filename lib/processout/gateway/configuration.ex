defmodule ProcessOut.Gateway.Configuration do
  @moduledoc """
  Configuration of a payment gateway on a project.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :gateway, cast: ProcessOut.Gateway
  field :gateway_id
  field :name
  field :default_currency
  field :enabled
  field :public_keys
  field :created_at
  field :enabled_at
  field :processing_region
  field :metadata

  @all_params ~w(expand_merchant_accounts)a
  @create_params ~w(id name enabled default_currency processing_region metadata settings
                    sub_accounts_enabled)a
  @update_params @create_params

  @doc "Get all the gateway configurations."
  @spec all(Client.t(), keyword()) :: {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def all(%Client{} = client, opts \\ []) do
    data = Request.take_params(Map.new(opts), @all_params)

    with {:ok, body} <- Request.get(client, "/gateway-configurations", data, opts) do
      {:ok, Enum.map(body["gateway_configurations"] || [], &from_map/1)}
    end
  end

  @doc "Find a gateway configuration by its ID."
  @spec find(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, configuration_id, opts \\ []) do
    path = "/gateway-configurations/#{Request.encode(configuration_id)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["gateway_configuration"])}
    end
  end

  @doc "Save the updated gateway configuration attributes and settings."
  @spec update(Client.t(), String.t(), map(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def update(%Client{} = client, configuration_id, params, opts \\ []) do
    data = Request.take_params(params, @update_params)
    path = "/gateway-configurations/#{Request.encode(configuration_id)}"

    with {:ok, body} <- Request.put(client, path, data, opts) do
      {:ok, from_map(body["gateway_configuration"])}
    end
  end

  @doc "Delete the gateway configuration."
  @spec delete(Client.t(), String.t(), keyword()) :: :ok | {:error, ProcessOut.Error.t()}
  def delete(%Client{} = client, configuration_id, opts \\ []) do
    path = "/gateway-configurations/#{Request.encode(configuration_id)}"

    with {:ok, _body} <- Request.delete(client, path, %{}, opts) do
      :ok
    end
  end

  @doc "Create a new gateway configuration."
  @spec create(Client.t(), String.t(), map(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def create(%Client{} = client, gateway_name, params, opts \\ []) do
    data = Request.take_params(params, @create_params)
    path = "/gateways/#{Request.encode(gateway_name)}/gateway-configurations"

    with {:ok, body} <- Request.post(client, path, data, opts) do
      {:ok, from_map(body["gateway_configuration"])}
    end
  end
end
