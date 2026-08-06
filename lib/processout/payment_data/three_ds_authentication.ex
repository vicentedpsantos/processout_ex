defmodule ProcessOut.PaymentData.ThreeDSAuthentication do
  @moduledoc """
  3-D Secure authentication data attached to a payment.
  """

  defstruct [:xid]

  @type t :: %__MODULE__{}

  # Hand-rolled instead of `use ProcessOut.Resource` because the API
  # serves this field under the "XID" key, not "xid".
  @doc "Builds a `ProcessOut.PaymentData.ThreeDSAuthentication` from an API response map."
  @spec from_map(map() | nil) :: t() | nil
  def from_map(nil), do: nil
  def from_map(data) when is_map(data), do: %__MODULE__{xid: data["XID"]}
end
