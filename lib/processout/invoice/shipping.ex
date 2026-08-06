defmodule ProcessOut.Invoice.Shipping do
  @moduledoc """
  Shipping information attached to an invoice.
  """

  use ProcessOut.Resource

  field :amount
  field :method
  field :provider
  field :delay
  field :address1
  field :address2
  field :city
  field :state
  field :country_code
  field :zip
  field :phone_number
  field :phone, cast: ProcessOut.Invoice.ShippingPhone
  field :expects_shipping_at
  field :relay_store_name
  field :first_name
  field :last_name
  field :email
end
