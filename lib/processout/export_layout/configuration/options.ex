defmodule ProcessOut.ExportLayout.Configuration.Options do
  @moduledoc """
  Available configuration options for an export layout.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :columns
  field :time, cast: ProcessOut.ExportLayout.Configuration.Options.Time
  field :amount, cast: ProcessOut.ExportLayout.Configuration.Options.Amount

  @doc "Fetch export layout configuration options."
  @spec fetch(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def fetch(%Client{} = client, export_type, opts \\ []) do
    path = "/exports/layouts/options/#{Request.encode(export_type)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["export_layout_configuration_options"])}
    end
  end
end
