defmodule ProcessOut.NativeAPM.TransactionDetails do
  @moduledoc """
  Details of a Native APM transaction.
  """

  use ProcessOut.Resource

  field :gateway, cast: ProcessOut.NativeAPM.TransactionDetails.Gateway
  field :invoice, cast: ProcessOut.NativeAPM.TransactionDetails.Invoice
  field :parameters, cast: ProcessOut.NativeAPM.ParameterDefinition
  field :state
end
