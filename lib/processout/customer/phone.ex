defmodule ProcessOut.Customer.Phone do
  @moduledoc """
  Phone number attached to a customer.
  """

  use ProcessOut.Resource

  field :number
  field :dialing_code
end
