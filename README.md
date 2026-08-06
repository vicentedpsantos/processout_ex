# ProcessOut Elixir

Elixir bindings for the [ProcessOut](https://processout.com) API, ported from the
official [processout-ruby](https://github.com/processout/processout-ruby) gem
(API version 1.4.0.0).

## Installation

```elixir
def deps do
  [
    {:processout_ex, "~> 0.1.0"}
  ]
end
```

## Usage

Build a client with your project credentials and pass it to any resource module:

```elixir
client = ProcessOut.new("proj_...", "key_...")

# Create an invoice and capture a payment
{:ok, invoice} =
  ProcessOut.Invoice.create(client, %{
    name: "Amazing item",
    amount: "4.99",
    currency: "USD"
  })

{:ok, %{transaction: transaction, customer_action: action}} =
  ProcessOut.Invoice.authorize(client, invoice.id, "card_token")

# List with pagination and expansion
{:ok, transactions} =
  ProcessOut.Transaction.all(client, limit: 25, expand: ["customer"])

# Errors are typed
{:error, %ProcessOut.Error{type: :not_found}} =
  ProcessOut.Invoice.find(client, "iv_missing")
```

All operations return `{:ok, result}` or `{:error, %ProcessOut.Error{}}` and accept a
trailing keyword list of options: `:expand`, `:filter`, `:limit`, `:start_after`,
`:end_before`, `:idempotency_key`, `:disable_logging`.

## Resources

Top-level API resources: `Invoice`, `Transaction`, `Customer`, `Token`, `Card`,
`Refund`, `Subscription`, `Plan`, `Coupon`, `Discount`, `Addon`, `Product`, `Payout`,
`Event`, `Activity`, `Gateway`, `Gateway.Configuration`, `Project`, `ExportLayout`,
`Balances`, `ErrorCodes`, `ApplePay.AlternativeMerchantCertificate(s)`, `Webhook`.

Nested data structs live under their parent namespace, e.g. `ProcessOut.Invoice.Billing`,
`ProcessOut.Payout.Item`, `ProcessOut.NativeAPM.TransactionDetails`.

## Testing your integration

The client accepts `req_options`, so you can stub HTTP with
[`Req.Test`](https://hexdocs.pm/req/Req.Test.html):

```elixir
client = ProcessOut.new("proj", "secret", req_options: [plug: {Req.Test, MyStub}])

Req.Test.stub(MyStub, fn conn ->
  Req.Test.json(conn, %{"success" => true, "invoice" => %{"id" => "iv_1"}})
end)
```

## Development

```bash
mix deps.get
mix test
mix format
```

## Differences from the Ruby gem

This library is a 1:1 port of the official
[processout-ruby](https://github.com/processout/processout-ruby) SDK: every resource,
field, and endpoint mirrors the Ruby source. The API surface is adapted to Elixir
conventions:

- Stateless, functional API: no mutable resource objects; operations take a client,
  explicit identifiers, and a params map.
- Ruby `save` methods are named `update`; `Plan#end` is `end_plan` (`end` is reserved).
- Multi-value responses (e.g. `Invoice.authorize`) return atom-keyed maps instead of
  variable-length arrays.
- `Project.delete/3` takes the project id explicitly (the Ruby gem requests the
  literal, broken path `/projects/{project_id}`).
- Flat generated class names are namespaced (`InvoiceShipping` ->
  `ProcessOut.Invoice.Shipping`).
