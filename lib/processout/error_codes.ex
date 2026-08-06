defmodule ProcessOut.ErrorCodes do
  @moduledoc """
  Error codes exposed by the ProcessOut API.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :gateway, cast: ProcessOut.CategoryErrorCodes

  @doc "Get all error codes."
  @spec all(Client.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def all(%Client{} = client, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/error-codes", %{}, opts) do
      {:ok, from_map(body)}
    end
  end
end
