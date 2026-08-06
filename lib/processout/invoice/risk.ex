defmodule ProcessOut.Invoice.Risk do
  @moduledoc """
  Risk information attached to an invoice.
  """

  use ProcessOut.Resource

  field :score
  field :is_legit
  field :skip_gateway_rules
end
