defmodule ProcessOut.Invoice.Detail do
  @moduledoc """
  Line item detail attached to an invoice.
  """

  use ProcessOut.Resource

  field :id
  field :name
  field :type
  field :amount
  field :quantity
  field :metadata
  field :reference
  field :description
  field :brand
  field :model
  field :discount_amount
  field :condition
  field :marketplace_merchant
  field :marketplace_merchant_is_business
  field :marketplace_merchant_created_at
  field :category
end
