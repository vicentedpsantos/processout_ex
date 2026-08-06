defmodule ProcessOut.Payout.Item.AmountBreakdowns do
  @moduledoc """
  Fee breakdown of a payout item amount.
  """

  use ProcessOut.Resource

  field :scheme_fee
  field :interchange_fee
  field :gateway_fee
  field :markup_fee
  field :acquirer_fee
  field :other_fee
end
