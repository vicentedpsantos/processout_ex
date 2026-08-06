defmodule ProcessOut.Activity do
  @moduledoc """
  Activity log entry of a project.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :title
  field :content
  field :level
  field :created_at

  @doc "Get all the project activities."
  @spec all(Client.t(), keyword()) :: {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def all(%Client{} = client, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/activities", %{}, opts) do
      {:ok, Enum.map(body["activities"] || [], &from_map/1)}
    end
  end

  @doc "Find a specific activity and fetch its data."
  @spec find(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, activity_id, opts \\ []) do
    path = "/activities/#{Request.encode(activity_id)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["activity"])}
    end
  end
end
