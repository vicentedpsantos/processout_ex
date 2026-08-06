defmodule ProcessOut.Error do
  @moduledoc """
  Error returned by the ProcessOut API or the HTTP transport.

  The `:type` field mirrors the error classes of the official SDKs:

    * `:validation` - HTTP 400
    * `:authentication` - HTTP 401
    * `:not_found` - HTTP 404
    * `:internal` - HTTP >= 500
    * `:generic` - any other unsuccessful response
    * `:transport` - the request never reached the API (timeouts, DNS, ...)

  `:code` carries the ProcessOut `error_type` string (e.g.
  `"card.declined"`) when the API provided one.
  """

  defexception [:type, :code, :message, :status]

  @type t :: %__MODULE__{
          type: :validation | :authentication | :not_found | :internal | :generic | :transport,
          code: String.t() | nil,
          message: String.t() | nil,
          status: non_neg_integer() | nil
        }

  @impl true
  def message(%__MODULE__{} = error) do
    "#{error.type} error (#{error.code || "unknown"}): #{error.message || "no message"}"
  end
end
