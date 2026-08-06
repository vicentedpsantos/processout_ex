defmodule ProcessOut.Invoice do
  @moduledoc """
  Invoices are requests for payment issued to customers.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :transaction, cast: ProcessOut.Transaction
  field :transaction_id
  field :customer, cast: ProcessOut.Customer
  field :customer_id
  field :subscription, cast: ProcessOut.Subscription
  field :subscription_id
  field :token, cast: ProcessOut.Token
  field :token_id
  field :details, cast: ProcessOut.Invoice.Detail
  field :submerchant, cast: ProcessOut.Invoice.Submerchant
  field :url
  field :url_qrcode
  field :name
  field :order_id
  field :amount
  field :currency
  field :merchant_initiator_type
  field :statement_descriptor
  field :statement_descriptor_phone
  field :statement_descriptor_city
  field :statement_descriptor_company
  field :statement_descriptor_url
  field :metadata
  field :gateway_data
  field :return_url
  field :cancel_url
  field :webhook_url
  field :require_backend_capture
  field :sandbox
  field :created_at
  field :expires_at
  field :risk, cast: ProcessOut.Invoice.Risk
  field :shipping, cast: ProcessOut.Invoice.Shipping
  field :device, cast: ProcessOut.Invoice.Device
  field :external_fraud_tools, cast: ProcessOut.Invoice.ExternalFraudTools
  field :exemption_reason_3ds2
  field :sca_exemption_reason
  field :challenge_indicator
  field :incremental
  field :tax, cast: ProcessOut.Invoice.Tax
  field :payment_type
  field :native_apm, cast: ProcessOut.NativeAPM.Request
  field :initiation_type
  field :payment_intent
  field :billing, cast: ProcessOut.Invoice.Billing
  field :unsupported_feature_bypass, cast: ProcessOut.UnsupportedFeatureBypass
  field :verification
  field :auto_capture_at
  field :reference_id

  @increment_authorization_params ~w(metadata)a
  @authorize_params ~w(device incremental synchronous retry_drop_liability_shift
                       capture_amount enable_three_d_s_2 allow_fallback_to_sale
                       auto_capture_at metadata override_mac_blocking external_three_d_s
                       save_source)a
  @capture_params ~w(device incremental authorize_only synchronous
                     retry_drop_liability_shift capture_amount auto_capture_at
                     enable_three_d_s_2 metadata capture_statement_descriptor
                     override_mac_blocking external_three_d_s save_source)a
  @payout_params ~w(force_gateway_configuration_id)a
  @process_native_payment_params ~w(gateway_configuration_id native_apm)a
  @initiate_three_d_s_params ~w(enable_three_d_s_2)a
  @void_params ~w(metadata amount)a
  @create_params ~w(customer_id name order_id amount currency metadata details
                    submerchant reference_id exemption_reason_3ds2 sca_exemption_reason
                    challenge_indicator gateway_data merchant_initiator_type
                    initiation_type payment_intent statement_descriptor
                    statement_descriptor_phone statement_descriptor_city
                    statement_descriptor_company statement_descriptor_url return_url
                    cancel_url webhook_url risk shipping device require_backend_capture
                    external_fraud_tools tax payment_type billing
                    unsupported_feature_bypass verification auto_capture_at
                    expires_at)a
  @update_params ~w(amount tax details shipping)a

  @doc "Create an incremental authorization."
  @spec increment_authorization(Client.t(), String.t(), term(), map(), keyword()) ::
          {:ok, ProcessOut.Transaction.t() | nil} | {:error, ProcessOut.Error.t()}
  def increment_authorization(%Client{} = client, invoice_id, amount, params \\ %{}, opts \\ []) do
    data =
      params
      |> Request.take_params(@increment_authorization_params)
      |> Map.put("amount", amount)

    path = "/invoices/#{Request.encode(invoice_id)}/increment_authorization"

    with {:ok, body} <- Request.post(client, path, data, opts) do
      {:ok, ProcessOut.Transaction.from_map(body["transaction"])}
    end
  end

  @doc "Authorize the invoice using the given source (customer or token)."
  @spec authorize(Client.t(), String.t(), term(), map(), keyword()) ::
          {:ok,
           %{
             transaction: ProcessOut.Transaction.t() | nil,
             customer_action: ProcessOut.Customer.Action.t() | nil
           }}
          | {:error, ProcessOut.Error.t()}
  def authorize(%Client{} = client, invoice_id, source, params \\ %{}, opts \\ []) do
    data =
      params
      |> Request.take_params(@authorize_params)
      |> Map.put("source", source)

    path = "/invoices/#{Request.encode(invoice_id)}/authorize"

    with {:ok, body} <- Request.post(client, path, data, opts) do
      {:ok,
       %{
         transaction: ProcessOut.Transaction.from_map(body["transaction"]),
         customer_action: ProcessOut.Customer.Action.from_map(body["customer_action"])
       }}
    end
  end

  @doc "Capture the invoice using the given source (customer or token)."
  @spec capture(Client.t(), String.t(), term(), map(), keyword()) ::
          {:ok,
           %{
             transaction: ProcessOut.Transaction.t() | nil,
             customer_action: ProcessOut.Customer.Action.t() | nil
           }}
          | {:error, ProcessOut.Error.t()}
  def capture(%Client{} = client, invoice_id, source, params \\ %{}, opts \\ []) do
    data =
      params
      |> Request.take_params(@capture_params)
      |> Map.put("source", source)

    path = "/invoices/#{Request.encode(invoice_id)}/capture"

    with {:ok, body} <- Request.post(client, path, data, opts) do
      {:ok,
       %{
         transaction: ProcessOut.Transaction.from_map(body["transaction"]),
         customer_action: ProcessOut.Customer.Action.from_map(body["customer_action"])
       }}
    end
  end

  @doc "Get the customer linked to the invoice."
  @spec fetch_customer(Client.t(), String.t(), keyword()) ::
          {:ok, ProcessOut.Customer.t() | nil} | {:error, ProcessOut.Error.t()}
  def fetch_customer(%Client{} = client, invoice_id, opts \\ []) do
    path = "/invoices/#{Request.encode(invoice_id)}/customers"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, ProcessOut.Customer.from_map(body["customer"])}
    end
  end

  @doc "Assign a customer to the invoice."
  @spec assign_customer(Client.t(), String.t(), String.t(), keyword()) ::
          {:ok, ProcessOut.Customer.t() | nil} | {:error, ProcessOut.Error.t()}
  def assign_customer(%Client{} = client, invoice_id, customer_id, opts \\ []) do
    data = %{"customer_id" => customer_id}
    path = "/invoices/#{Request.encode(invoice_id)}/customers"

    with {:ok, body} <- Request.post(client, path, data, opts) do
      {:ok, ProcessOut.Customer.from_map(body["customer"])}
    end
  end

  @doc "Process the payout invoice using the given source (customer or token)."
  @spec payout(Client.t(), String.t(), String.t(), term(), map(), keyword()) ::
          {:ok, ProcessOut.Transaction.t() | nil} | {:error, ProcessOut.Error.t()}
  def payout(
        %Client{} = client,
        invoice_id,
        gateway_configuration_id,
        source,
        params \\ %{},
        opts \\ []
      ) do
    data =
      params
      |> Request.take_params(@payout_params)
      |> Map.put("gateway_configuration_id", gateway_configuration_id)
      |> Map.put("source", source)

    path = "/invoices/#{Request.encode(invoice_id)}/payout"

    with {:ok, body} <- Request.post(client, path, data, opts) do
      {:ok, ProcessOut.Transaction.from_map(body["transaction"])}
    end
  end

  @doc "Fetches the Native APM payment."
  @spec show_native_payment_transaction(Client.t(), String.t(), String.t(), keyword()) ::
          {:ok, ProcessOut.NativeAPM.TransactionDetails.t() | nil}
          | {:error, ProcessOut.Error.t()}
  def show_native_payment_transaction(
        %Client{} = client,
        invoice_id,
        gateway_configuration_id,
        opts \\ []
      ) do
    path =
      "/invoices/#{Request.encode(invoice_id)}/native-payment/" <>
        Request.encode(gateway_configuration_id)

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, ProcessOut.NativeAPM.TransactionDetails.from_map(body["native_apm"])}
    end
  end

  @doc "Process the Native APM payment flow."
  @spec process_native_payment(Client.t(), String.t(), map(), keyword()) ::
          {:ok,
           %{
             transaction: ProcessOut.Transaction.t() | nil,
             native_apm: ProcessOut.NativeAPM.Response.t() | nil
           }}
          | {:error, ProcessOut.Error.t()}
  def process_native_payment(%Client{} = client, invoice_id, params, opts \\ []) do
    data = Request.take_params(params, @process_native_payment_params)
    path = "/invoices/#{Request.encode(invoice_id)}/native-payment"

    with {:ok, body} <- Request.post(client, path, data, opts) do
      {:ok,
       %{
         transaction: ProcessOut.Transaction.from_map(body["transaction"]),
         native_apm: ProcessOut.NativeAPM.Response.from_map(body["native_apm"])
       }}
    end
  end

  @doc "Initiate a 3-D Secure authentication."
  @spec initiate_three_d_s(Client.t(), String.t(), term(), map(), keyword()) ::
          {:ok, ProcessOut.Customer.Action.t() | nil} | {:error, ProcessOut.Error.t()}
  def initiate_three_d_s(%Client{} = client, invoice_id, source, params \\ %{}, opts \\ []) do
    data =
      params
      |> Request.take_params(@initiate_three_d_s_params)
      |> Map.put("source", source)

    path = "/invoices/#{Request.encode(invoice_id)}/three-d-s"

    with {:ok, body} <- Request.post(client, path, data, opts) do
      {:ok, ProcessOut.Customer.Action.from_map(body["customer_action"])}
    end
  end

  @doc "Get the transaction of the invoice."
  @spec fetch_transaction(Client.t(), String.t(), keyword()) ::
          {:ok, ProcessOut.Transaction.t() | nil} | {:error, ProcessOut.Error.t()}
  def fetch_transaction(%Client{} = client, invoice_id, opts \\ []) do
    path = "/invoices/#{Request.encode(invoice_id)}/transactions"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, ProcessOut.Transaction.from_map(body["transaction"])}
    end
  end

  @doc "Void the invoice."
  @spec void(Client.t(), String.t(), map(), keyword()) ::
          {:ok, ProcessOut.Transaction.t() | nil} | {:error, ProcessOut.Error.t()}
  def void(%Client{} = client, invoice_id, params \\ %{}, opts \\ []) do
    data = Request.take_params(params, @void_params)
    path = "/invoices/#{Request.encode(invoice_id)}/void"

    with {:ok, body} <- Request.post(client, path, data, opts) do
      {:ok, ProcessOut.Transaction.from_map(body["transaction"])}
    end
  end

  @doc "Get all the invoices."
  @spec all(Client.t(), keyword()) :: {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def all(%Client{} = client, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/invoices", %{}, opts) do
      {:ok, Enum.map(body["invoices"] || [], &from_map/1)}
    end
  end

  @doc "Create a new invoice."
  @spec create(Client.t(), map(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def create(%Client{} = client, params, opts \\ []) do
    data = Request.take_params(params, @create_params)

    with {:ok, body} <- Request.post(client, "/invoices", data, opts) do
      {:ok, from_map(body["invoice"])}
    end
  end

  @doc "Find an invoice by its ID."
  @spec find(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, invoice_id, opts \\ []) do
    path = "/invoices/#{Request.encode(invoice_id)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["invoice"])}
    end
  end

  @doc """
  Delete an invoice by its ID. Only invoices that have not been used yet
  can be deleted.
  """
  @spec delete(Client.t(), String.t(), keyword()) :: :ok | {:error, ProcessOut.Error.t()}
  def delete(%Client{} = client, invoice_id, opts \\ []) do
    path = "/invoices/#{Request.encode(invoice_id)}"

    with {:ok, _body} <- Request.delete(client, path, %{}, opts) do
      :ok
    end
  end

  @doc "Refresh invoice by its ID with PSP."
  @spec sync_with_psp(Client.t(), String.t(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def sync_with_psp(%Client{} = client, invoice_id, opts \\ []) do
    path = "/invoices/#{Request.encode(invoice_id)}/sync-with-psp"

    with {:ok, body} <- Request.put(client, path, %{}, opts) do
      {:ok, from_map(body["invoice"])}
    end
  end

  @doc "Update invoice by its ID."
  @spec update(Client.t(), String.t(), map(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def update(%Client{} = client, invoice_id, params, opts \\ []) do
    data = Request.take_params(params, @update_params)
    path = "/invoices/#{Request.encode(invoice_id)}"

    with {:ok, body} <- Request.put(client, path, data, opts) do
      {:ok, from_map(body["invoice"])}
    end
  end
end
