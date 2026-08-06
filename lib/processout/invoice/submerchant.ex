defmodule ProcessOut.Invoice.Submerchant do
  @moduledoc """
  Submerchant attached to an invoice.
  """

  use ProcessOut.Resource

  field :id
  field :name
  field :reference
  field :mcc
  field :phone_number, cast: ProcessOut.Submerchant.PhoneNumber
  field :email
  field :address, cast: ProcessOut.Submerchant.Address
  field :tax_reference
  field :service_establishment_number
end
