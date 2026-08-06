defmodule ProcessOut.Project.SFTPSettings do
  @moduledoc """
  SFTP settings of a project.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :endpoint
  field :username
  field :password
  field :private_key

  @save_sftp_settings_params ~w(endpoint username password private_key)a

  @doc "Save the SFTP settings for the project."
  @spec save_sftp_settings(Client.t(), String.t(), map(), keyword()) ::
          :ok | {:error, ProcessOut.Error.t()}
  def save_sftp_settings(%Client{} = client, project_id, params, opts \\ []) do
    data = Request.take_params(params, @save_sftp_settings_params)
    path = "/projects/#{Request.encode(project_id)}/sftp-settings"

    with {:ok, _body} <- Request.put(client, path, data, opts) do
      :ok
    end
  end

  @doc "Delete the SFTP settings for the project."
  @spec delete_sftp_settings(Client.t(), String.t(), keyword()) ::
          :ok | {:error, ProcessOut.Error.t()}
  def delete_sftp_settings(%Client{} = client, project_id, opts \\ []) do
    path = "/projects/#{Request.encode(project_id)}/sftp-settings"

    with {:ok, _body} <- Request.delete(client, path, %{}, opts) do
      :ok
    end
  end
end
