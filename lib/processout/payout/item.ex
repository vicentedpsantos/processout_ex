defmodule ProcessOut.Payout.Item do
  @moduledoc """
  Item linked to a payout.
  """

  use ProcessOut.Resource

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :payout, cast: ProcessOut.Payout
  field :payout_id
  field :transaction, cast: ProcessOut.Transaction
  field :transaction_id
  field :type
  field :gateway_resource_id
  field :amount
  field :fees
  field :metadata
  field :created_at
  field :breakdown, cast: ProcessOut.Payout.Item.AmountBreakdowns
end
