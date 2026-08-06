defmodule ProcessOut.Project.SFTPSettings.Public do
  @moduledoc """
  Public view of the SFTP settings of a project.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :enabled
  field :endpoint
  field :username

  @doc "Fetch the SFTP settings for the project."
  @spec fetch_sftp_settings(Client.t(), String.t(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def fetch_sftp_settings(%Client{} = client, project_id, opts \\ []) do
    path = "/projects/#{Request.encode(project_id)}/sftp-settings"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["sftp_settings"])}
    end
  end
end
