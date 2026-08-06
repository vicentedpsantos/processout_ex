defmodule ProcessOut.PaymentData.ThreeDSRequest do
  @moduledoc """
  3-D Secure request data attached to a payment.
  """

  use ProcessOut.Resource

  field :acs_url
  field :pareq
  field :md
  field :term_url
end
