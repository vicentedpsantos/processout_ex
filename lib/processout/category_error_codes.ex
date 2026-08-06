defmodule ProcessOut.CategoryErrorCodes do
  @moduledoc """
  Error codes grouped by category.
  """

  use ProcessOut.Resource

  field :generic
  field :service
  field :gateway
  field :card
  field :check
  field :shipping
  field :customer
  field :payment
  field :refund
  field :wallet
  field :request
end
