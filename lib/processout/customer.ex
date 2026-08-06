defmodule ProcessOut.Customer do
  @moduledoc """
  Customers registered on a project.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request
  alias ProcessOut.Subscription
  alias ProcessOut.Token
  alias ProcessOut.Transaction

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :default_token, cast: ProcessOut.Token
  field :default_token_id
  field :tokens, cast: ProcessOut.Token
  field :subscriptions, cast: ProcessOut.Subscription
  field :transactions, cast: ProcessOut.Transaction
  field :balance
  field :currency
  field :email
  field :first_name
  field :last_name
  field :company_name
  field :address1
  field :address2
  field :city
  field :state
  field :zip
  field :country_code
  field :ip_address
  field :phone_number
  field :phone, cast: ProcessOut.Customer.Phone
  field :legal_document
  field :sex
  field :is_business
  field :metadata
  field :sandbox
  field :created_at
  field :registered_at
  field :date_of_birth
  field :reference_id

  @create_params ~w(balance currency email first_name last_name company_name address1
                    address2 city state zip country_code ip_address phone legal_document
                    date_of_birth is_business sex metadata id reference_id registered_at
                    phone_number)a
  @update_params ~w(balance default_token_id email first_name last_name company_name
                    address1 address2 city state zip country_code ip_address phone
                    legal_document date_of_birth is_business sex metadata registered_at
                    phone_number)a

  @doc "Get the subscriptions belonging to the customer."
  @spec fetch_subscriptions(Client.t(), String.t(), keyword()) ::
          {:ok, [Subscription.t()]} | {:error, ProcessOut.Error.t()}
  def fetch_subscriptions(%Client{} = client, customer_id, opts \\ []) do
    path = "/customers/#{Request.encode(customer_id)}/subscriptions"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Enum.map(body["subscriptions"] || [], &Subscription.from_map/1)}
    end
  end

  @doc "Get the customer's tokens."
  @spec fetch_tokens(Client.t(), String.t(), keyword()) ::
          {:ok, [Token.t()]} | {:error, ProcessOut.Error.t()}
  def fetch_tokens(%Client{} = client, customer_id, opts \\ []) do
    path = "/customers/#{Request.encode(customer_id)}/tokens"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Enum.map(body["tokens"] || [], &Token.from_map/1)}
    end
  end

  @doc "Find a customer's token by its ID."
  @spec find_token(Client.t(), String.t(), String.t(), keyword()) ::
          {:ok, Token.t()} | {:error, ProcessOut.Error.t()}
  def find_token(%Client{} = client, customer_id, token_id, opts \\ []) do
    path = "/customers/#{Request.encode(customer_id)}/tokens/#{Request.encode(token_id)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Token.from_map(body["token"])}
    end
  end

  @doc "Delete a customer's token by its ID."
  @spec delete_token(Client.t(), String.t(), String.t(), keyword()) ::
          :ok | {:error, ProcessOut.Error.t()}
  def delete_token(%Client{} = client, customer_id, token_id, opts \\ []) do
    path = "/customers/#{Request.encode(customer_id)}/tokens/#{Request.encode(token_id)}"

    with {:ok, _body} <- Request.delete(client, path, %{}, opts) do
      :ok
    end
  end

  @doc "Get the transactions belonging to the customer."
  @spec fetch_transactions(Client.t(), String.t(), keyword()) ::
          {:ok, [Transaction.t()]} | {:error, ProcessOut.Error.t()}
  def fetch_transactions(%Client{} = client, customer_id, opts \\ []) do
    path = "/customers/#{Request.encode(customer_id)}/transactions"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, Enum.map(body["transactions"] || [], &Transaction.from_map/1)}
    end
  end

  @doc "Get all the customers."
  @spec all(Client.t(), keyword()) :: {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def all(%Client{} = client, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/customers", %{}, opts) do
      {:ok, Enum.map(body["customers"] || [], &from_map/1)}
    end
  end

  @doc "Create a new customer."
  @spec create(Client.t(), map(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def create(%Client{} = client, params, opts \\ []) do
    data = Request.take_params(params, @create_params)

    with {:ok, body} <- Request.post(client, "/customers", data, opts) do
      {:ok, from_map(body["customer"])}
    end
  end

  @doc "Find a customer by its ID."
  @spec find(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, customer_id, opts \\ []) do
    path = "/customers/#{Request.encode(customer_id)}"

    with {:ok, body} <- Request.get(client, path, %{}, opts) do
      {:ok, from_map(body["customer"])}
    end
  end

  @doc "Save the updated customer attributes."
  @spec update(Client.t(), String.t(), map(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def update(%Client{} = client, customer_id, params, opts \\ []) do
    data = Request.take_params(params, @update_params)
    path = "/customers/#{Request.encode(customer_id)}"

    with {:ok, body} <- Request.put(client, path, data, opts) do
      {:ok, from_map(body["customer"])}
    end
  end

  @doc "Delete the customer."
  @spec delete(Client.t(), String.t(), keyword()) :: :ok | {:error, ProcessOut.Error.t()}
  def delete(%Client{} = client, customer_id, opts \\ []) do
    with {:ok, _body} <-
           Request.delete(client, "/customers/#{Request.encode(customer_id)}", %{}, opts) do
      :ok
    end
  end
end
