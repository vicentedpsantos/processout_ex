defmodule ProcessOut.Balance do
  @moduledoc """
  Balance of a customer token.
  """

  use ProcessOut.Resource

  field :amount
  field :currency
  field :expiry
end
