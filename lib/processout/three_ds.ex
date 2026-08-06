defmodule ProcessOut.ThreeDS do
  @moduledoc """
  3-D Secure authentication data attached to a transaction.
  """

  use ProcessOut.Resource

  field :version
  field :status
  field :fingerprinted
  field :challenged
  field :ares_trans_status
  field :cres_trans_status
  field :ds_trans_id
  field :fingerprint_completion_indicator
  field :server_trans_id
end
