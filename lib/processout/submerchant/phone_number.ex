defmodule ProcessOut.Submerchant.PhoneNumber do
  @moduledoc """
  Phone number of a submerchant.
  """

  use ProcessOut.Resource

  field :dialing_code
  field :number
end
