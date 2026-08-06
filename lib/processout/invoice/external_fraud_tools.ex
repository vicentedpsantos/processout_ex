defmodule ProcessOut.Invoice.ExternalFraudTools do
  @moduledoc """
  External fraud tool data attached to an invoice.
  """

  use ProcessOut.Resource

  field :forter
  field :ravelin
  field :signifyd
end
