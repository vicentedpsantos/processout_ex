defmodule ProcessOut.Event do
  @moduledoc """
  Event fired within a project.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request
  alias ProcessOut.Webhook

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :name
  field :data
  field :sandbox
  field :fired_at

  @doc "Get all the webhooks of the event."
  @spec fetch_webhooks(Client.t(), String.t(), keyword()) ::
          {:ok, [Webhook.t()]} | {:error, ProcessOut.Error.t()}
  def fetch_webhooks(%Client{} = client, event_id, opts \\ []) do
    path = "/events/#{Request.encode(event_id)}/webhooks"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Enum.map(body["webhooks"] || [], &Webhook.from_map/1)}
    end
  end

  @doc "Get all the events."
  @spec all(Client.t(), keyword()) :: {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def all(%Client{} = client, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/events", %{}, opts) do
      {:ok, Enum.map(body["events"] || [], &from_map/1)}
    end
  end

  @doc "Find an event by its ID."
  @spec find(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, event_id, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/events/#{Request.encode(event_id)}", %{}, opts) do
      {:ok, from_map(body["event"])}
    end
  end
end
