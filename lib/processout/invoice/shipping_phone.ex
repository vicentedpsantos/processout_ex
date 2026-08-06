defmodule ProcessOut.Invoice.ShippingPhone do
  @moduledoc """
  Phone number for the shipping information attached to an invoice.
  """

  use ProcessOut.Resource

  field :number
  field :dialing_code
end
