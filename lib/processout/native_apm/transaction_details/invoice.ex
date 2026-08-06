defmodule ProcessOut.NativeAPM.TransactionDetails.Invoice do
  @moduledoc """
  Invoice information attached to a Native APM transaction.
  """

  use ProcessOut.Resource

  field :amount
  field :currency_code
end
