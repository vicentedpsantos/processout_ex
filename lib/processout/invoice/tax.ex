defmodule ProcessOut.Invoice.Tax do
  @moduledoc """
  Tax information attached to an invoice.
  """

  use ProcessOut.Resource

  field :amount
  field :rate
end
