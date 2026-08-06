defmodule ProcessOut.ExternalThreeDS do
  @moduledoc """
  3-D Secure data obtained from an external authentication provider.
  """

  use ProcessOut.Resource

  field :xid
  field :trans_status
  field :eci
  field :cavv
  field :ds_trans_id
  field :version
  field :authentication_flow
end
