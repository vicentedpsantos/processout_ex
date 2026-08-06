defmodule ProcessOut.Transaction.Operation do
  @moduledoc """
  Operation performed on a transaction.
  """

  use ProcessOut.Resource

  field :id
  field :transaction, cast: ProcessOut.Transaction
  field :transaction_id
  field :token, cast: ProcessOut.Token
  field :token_id
  field :card, cast: ProcessOut.Card
  field :card_id
  field :gateway_configuration, cast: ProcessOut.Gateway.Configuration
  field :gateway_configuration_id
  field :amount
  field :currency
  field :is_attempt
  field :has_failed
  field :is_accountable
  field :type
  field :gateway_operation_id
  field :arn
  field :error_code
  field :error_message
  field :gateway_data
  field :payment_data_three_d_s_request, cast: ProcessOut.PaymentData.ThreeDSRequest

  field :payment_data_three_d_s_authentication, cast: ProcessOut.PaymentData.ThreeDSAuthentication

  field :payment_data_network_authentication, cast: ProcessOut.PaymentData.NetworkAuthentication

  field :initial_scheme_transaction_id
  field :scheme_id
  field :processed_with_network_token
  field :payment_type
  field :metadata
  field :gateway_fee
  field :created_at
end
