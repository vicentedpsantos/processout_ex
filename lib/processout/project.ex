defmodule ProcessOut.Project do
  @moduledoc """
  Project on the ProcessOut platform.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :id
  field :supervisor_project, cast: ProcessOut.Project
  field :supervisor_project_id
  field :api_version, cast: ProcessOut.APIVersion
  field :name
  field :logo_url
  field :email
  field :default_currency
  field :private_key
  field :dunning_configuration, cast: ProcessOut.DunningAction
  field :created_at

  @create_supervised_params ~w(id name default_currency dunning_configuration
                               applepay_settings public_metadata)a

  @doc "Fetch the current project information."
  @spec fetch(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def fetch(%Client{} = client, project_id, opts \\ []) do
    with {:ok, body} <-
           Request.get(client, "/projects/#{Request.encode(project_id)}", %{}, opts) do
      {:ok, from_map(body["project"])}
    end
  end

  @doc "Save the updated project's attributes."
  @spec update(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def update(%Client{} = client, project_id, opts \\ []) do
    with {:ok, body} <-
           Request.put(client, "/projects/#{Request.encode(project_id)}", %{}, opts) do
      {:ok, from_map(body["project"])}
    end
  end

  @doc """
  Delete the project. Be careful! Executing this request will prevent any further
  interaction with the API that uses this project.
  """
  @spec delete(Client.t(), String.t(), keyword()) :: :ok | {:error, ProcessOut.Error.t()}
  def delete(%Client{} = client, project_id, opts \\ []) do
    path = "/projects/#{Request.encode(project_id)}"

    with {:ok, _body} <- Request.delete(client, path, %{}, opts) do
      :ok
    end
  end

  @doc "Get all the supervised projects."
  @spec fetch_supervised(Client.t(), keyword()) ::
          {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def fetch_supervised(%Client{} = client, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/supervised-projects", %{}, opts) do
      {:ok, Enum.map(body["projects"] || [], &from_map/1)}
    end
  end

  @doc "Create a new supervised project."
  @spec create_supervised(Client.t(), map(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def create_supervised(%Client{} = client, params, opts \\ []) do
    data = Request.take_params(params, @create_supervised_params)

    with {:ok, body} <- Request.post(client, "/supervised-projects", data, opts) do
      {:ok, from_map(body["project"])}
    end
  end
end
