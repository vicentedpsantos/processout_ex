defmodule ProcessOut.Client do
  @moduledoc """
  Configuration for the ProcessOut API client.

  Holds project credentials and connection options. Build one with `new/3`
  and pass it as the first argument to every resource operation.
  """

  @default_host "https://api.processout.com"

  defstruct project_id: nil,
            project_secret: nil,
            host: @default_host,
            req_options: []

  @type t :: %__MODULE__{
          project_id: String.t(),
          project_secret: String.t(),
          host: String.t(),
          req_options: keyword()
        }

  @doc """
  Builds a new client.

  ## Options

    * `:host` - override the API host (defaults to `#{@default_host}`)
    * `:req_options` - extra options merged into the underlying `Req` request;
      useful for testing with `Req.Test` (e.g. `[plug: {Req.Test, MyStub}]`)
  """
  @spec new(String.t(), String.t(), keyword()) :: t()
  def new(project_id, project_secret, opts \\ []) do
    %__MODULE__{
      project_id: project_id,
      project_secret: project_secret,
      host: Keyword.get(opts, :host, @default_host),
      req_options: Keyword.get(opts, :req_options, [])
    }
  end
end
