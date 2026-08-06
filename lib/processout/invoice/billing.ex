defmodule ProcessOut.Invoice.Billing do
  @moduledoc """
  Billing address attached to an invoice.
  """

  use ProcessOut.Resource

  field :address1
  field :address2
  field :city
  field :state
  field :country_code
  field :zip
end
