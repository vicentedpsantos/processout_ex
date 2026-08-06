defmodule ProcessOut.Customer.Action do
  @moduledoc """
  Action the customer must perform to continue a payment flow.
  """

  use ProcessOut.Resource

  field :type
  field :value
  field :metadata
end
