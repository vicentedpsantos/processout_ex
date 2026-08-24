defmodule ProcessOut.Error do
  @moduledoc """
  Error returned by the ProcessOut API or the HTTP transport.

  The `:type` field mirrors the error classes of the official SDKs:

    * `:validation` - HTTP 400
    * `:authentication` - HTTP 401
    * `:not_found` - HTTP 404
    * `:internal` - HTTP >= 500
    * `:customer_action_required` - the response carries a `customer_action`
      the customer must complete before the operation can continue (3DS
      soft decline, `card.needs-authentication`, HTTP 410)
    * `:generic` - any other unsuccessful response
    * `:transport` - the request never reached the API (timeouts, DNS, ...)

  `:code` carries the ProcessOut `error_type` string (e.g.
  `"card.declined"`) when the API provided one.

  `:customer_action` is populated whenever the response carries one, and
  `:body` keeps the decoded response so callers can inspect fields this
  struct does not model. An unsuccessful response is not necessarily a dead
  end: a 3DS soft decline is reported as an error but continues the payment
  once the customer completes the action.
  """

  defexception [:type, :code, :message, :status, :customer_action, :body]

  @type t :: %__MODULE__{
          type:
            :validation
            | :authentication
            | :not_found
            | :internal
            | :customer_action_required
            | :generic
            | :transport,
          code: String.t() | nil,
          message: String.t() | nil,
          status: non_neg_integer() | nil,
          customer_action: ProcessOut.Customer.Action.t() | nil,
          body: map() | nil
        }

  @impl true
  def message(%__MODULE__{} = error) do
    "#{error.type} error (#{error.code || "unknown"}): #{error.message || "no message"}"
  end
end
