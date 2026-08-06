defmodule ProcessOut.NativeAPM.TransactionDetails.Gateway do
  @moduledoc """
  Gateway information attached to a Native APM transaction.
  """

  use ProcessOut.Resource

  field :display_name
  field :logo_url
end
