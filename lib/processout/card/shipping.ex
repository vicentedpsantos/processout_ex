defmodule ProcessOut.Card.Shipping do
  @moduledoc """
  Shipping information attached to a card.
  """

  use ProcessOut.Resource

  field :address1
  field :address2
  field :city
  field :state
  field :country_code
  field :zip
  field :phone, cast: ProcessOut.Phone
  field :first_name
  field :last_name
  field :email
end
