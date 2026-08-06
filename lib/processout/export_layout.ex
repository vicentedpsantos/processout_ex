defmodule ProcessOut.ExportLayout do
  @moduledoc """
  Layout used when exporting data from the API.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :created_at
  field :name
  field :type
  field :is_default
  field :configuration, cast: ProcessOut.ExportLayout.Configuration

  @create_params ~w(name type is_default configuration)a
  @update_params ~w(name is_default configuration)a

  @doc "Get all the export layouts."
  @spec all(Client.t(), keyword()) :: {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def all(%Client{} = client, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/exports/layouts", %{}, opts) do
      {:ok, Enum.map(body["export_layouts"] || [], &from_map/1)}
    end
  end

  @doc "Find an export layout by its ID."
  @spec find(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, export_layout_id, opts \\ []) do
    path = "/exports/layouts/#{Request.encode(export_layout_id)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["export_layout"])}
    end
  end

  @doc "Find the default export layout for given export type."
  @spec find_default(Client.t(), String.t(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find_default(%Client{} = client, export_type, opts \\ []) do
    path = "/exports/layouts/default/#{Request.encode(export_type)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["export_layout"])}
    end
  end

  @doc "Create a new export layout."
  @spec create(Client.t(), map(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def create(%Client{} = client, params, opts \\ []) do
    data = Request.take_params(params, @create_params)

    with {:ok, body} <- Request.post(client, "/exports/layouts", data, opts) do
      {:ok, from_map(body["export_layout"])}
    end
  end

  @doc "Update the export layout."
  @spec update(Client.t(), String.t(), map(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def update(%Client{} = client, export_layout_id, params, opts \\ []) do
    data = Request.take_params(params, @update_params)
    path = "/exports/layouts/#{Request.encode(export_layout_id)}"

    with {:ok, body} <- Request.put(client, path, data, opts) do
      {:ok, from_map(body["export_layout"])}
    end
  end

  @doc "Delete the export layout."
  @spec delete(Client.t(), String.t(), keyword()) :: :ok | {:error, ProcessOut.Error.t()}
  def delete(%Client{} = client, export_layout_id, opts \\ []) do
    path = "/exports/layouts/#{Request.encode(export_layout_id)}"

    with {:ok, _body} <- Request.delete(client, path, %{}, opts) do
      :ok
    end
  end
end
