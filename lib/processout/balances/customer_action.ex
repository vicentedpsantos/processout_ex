defmodule ProcessOut.Balances.CustomerAction do
  @moduledoc """
  Customer action attached to a balances response.
  """

  use ProcessOut.Resource

  field :type
  field :value
end
