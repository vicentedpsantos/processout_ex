defmodule ProcessOut.Submerchant.Address do
  @moduledoc """
  Address of a submerchant.
  """

  use ProcessOut.Resource

  field :line1
  field :line2
  field :city
  field :state
  field :country_code
  field :zip
  field :county
end
