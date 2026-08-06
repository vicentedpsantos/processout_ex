defmodule ProcessOut.Card.Contact do
  @moduledoc """
  Contact address attached to a card.
  """

  use ProcessOut.Resource

  field :address1
  field :address2
  field :city
  field :state
  field :country_code
  field :zip
end
