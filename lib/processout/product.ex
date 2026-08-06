defmodule ProcessOut.Product do
  @moduledoc """
  Products from which invoices can be generated.
  """

  use ProcessOut.Resource

  alias ProcessOut.Client
  alias ProcessOut.Request

  field :id
  field :project, cast: ProcessOut.Project
  field :project_id
  field :url
  field :name
  field :amount
  field :currency
  field :metadata
  field :return_url
  field :cancel_url
  field :sandbox
  field :created_at

  @create_params ~w(name amount currency metadata return_url cancel_url)a
  @update_params ~w(name amount currency metadata return_url cancel_url)a

  @doc "Create a new invoice from the product."
  @spec create_invoice(Client.t(), String.t(), keyword()) ::
          {:ok, ProcessOut.Invoice.t()} | {:error, ProcessOut.Error.t()}
  def create_invoice(%Client{} = client, product_id, opts \\ []) do
    path = "/products/#{Request.encode(product_id)}/invoices"

    with {:ok, body} <- Request.post(client, path, %{}, opts) do
      {:ok, ProcessOut.Invoice.from_map(body["invoice"])}
    end
  end

  @doc "Get all the products."
  @spec all(Client.t(), keyword()) :: {:ok, [t()]} | {:error, ProcessOut.Error.t()}
  def all(%Client{} = client, opts \\ []) do
    with {:ok, body} <- Request.get(client, "/products", %{}, opts) do
      {:ok, Enum.map(body["products"] || [], &from_map/1)}
    end
  end

  @doc "Create a new product."
  @spec create(Client.t(), map(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def create(%Client{} = client, params, opts \\ []) do
    data = Request.take_params(params, @create_params)

    with {:ok, body} <- Request.post(client, "/products", data, opts) do
      {:ok, from_map(body["product"])}
    end
  end

  @doc "Find a product by its ID."
  @spec find(Client.t(), String.t(), keyword()) :: {:ok, t()} | {:error, ProcessOut.Error.t()}
  def find(%Client{} = client, product_id, opts \\ []) do
    with {:ok, body} <-
           Request.get(client, "/products/#{Request.encode(product_id)}", %{}, opts) do
      {:ok, from_map(body["product"])}
    end
  end

  @doc "Save the updated product attributes."
  @spec update(Client.t(), String.t(), map(), keyword()) ::
          {:ok, t()} | {:error, ProcessOut.Error.t()}
  def update(%Client{} = client, product_id, params, opts \\ []) do
    data = Request.take_params(params, @update_params)

    with {:ok, body} <-
           Request.put(client, "/products/#{Request.encode(product_id)}", data, opts) do
      {:ok, from_map(body["product"])}
    end
  end

  @doc "Delete the product."
  @spec delete(Client.t(), String.t(), keyword()) :: :ok | {:error, ProcessOut.Error.t()}
  def delete(%Client{} = client, product_id, opts \\ []) do
    with {:ok, _body} <-
           Request.delete(client, "/products/#{Request.encode(product_id)}", %{}, opts) do
      :ok
    end
  end
end
