defmodule ProcessOut.Invoice.Device do
  @moduledoc """
  Device information attached to an invoice.
  """

  use ProcessOut.Resource

  field :channel
  field :ip_address
  field :id
end
