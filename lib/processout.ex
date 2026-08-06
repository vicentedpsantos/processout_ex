defmodule ProcessOut do
  @moduledoc """
  Elixir bindings for the [ProcessOut](https://processout.com) API.

  Build a client with your project credentials and pass it to any resource
  module:

      client = ProcessOut.new("proj_id", "proj_secret")

      {:ok, invoice} =
        ProcessOut.Invoice.create(client, %{
          name: "Amazing item",
          amount: "4.99",
          currency: "USD"
        })

      {:ok, transaction} = ProcessOut.Invoice.capture(client, invoice.id, "card_token")

  All operations return `{:ok, result}` or `{:error, %ProcessOut.Error{}}`.

  Every operation accepts a trailing keyword list of options:

    * `:expand` - list of nested resources to expand (e.g. `["customer"]`)
    * `:filter` - filter string applied to list operations
    * `:limit` - pagination page size
    * `:start_after` / `:end_before` - cursor pagination markers
    * `:idempotency_key` - sent as the `Idempotency-Key` header
    * `:disable_logging` - sent as the `Disable-Logging` header
  """

  defdelegate new(project_id, project_secret, opts \\ []), to: ProcessOut.Client
end
