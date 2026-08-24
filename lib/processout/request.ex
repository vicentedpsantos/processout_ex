defmodule ProcessOut.Request do
  @moduledoc """
  HTTP layer for the ProcessOut API, built on `Req`.

  Applies authentication, common headers and the shared request options
  (`:expand`, `:filter`, `:limit`, `:start_after`, `:end_before`,
  `:idempotency_key`, `:disable_logging`), then decodes the standard
  response envelope into `{:ok, body}` or `{:error, %ProcessOut.Error{}}`.
  """

  alias ProcessOut.Client
  alias ProcessOut.Error

  @api_version "1.4.0.0"
  @user_agent "ProcessOut Elixir-Bindings/0.1.0"
  @connect_timeout 5_000
  @receive_timeout 65_000

  @data_options ~w(expand filter limit start_after end_before)a

  @type response :: {:ok, map()} | {:error, Error.t()}

  @spec get(Client.t(), String.t(), map(), keyword()) :: response()
  def get(client, path, data \\ %{}, opts \\ []), do: run(client, :get, path, data, opts)

  @spec post(Client.t(), String.t(), map(), keyword()) :: response()
  def post(client, path, data \\ %{}, opts \\ []), do: run(client, :post, path, data, opts)

  @spec put(Client.t(), String.t(), map(), keyword()) :: response()
  def put(client, path, data \\ %{}, opts \\ []), do: run(client, :put, path, data, opts)

  @spec delete(Client.t(), String.t(), map(), keyword()) :: response()
  def delete(client, path, data \\ %{}, opts \\ []), do: run(client, :delete, path, data, opts)

  @doc """
  Escapes a value for interpolation into a URL path segment.
  """
  @spec encode(String.t()) :: String.t()
  def encode(segment), do: URI.encode_www_form(to_string(segment))

  @doc """
  Picks the given `keys` from `params` (atom or string keyed) and returns a
  string-keyed map suitable for a request body. Keys absent from `params`
  are omitted.
  """
  @spec take_params(map(), [atom()]) :: map()
  def take_params(params, keys) do
    for key <- keys,
        {:ok, value} <- [fetch_param(params, key)],
        into: %{},
        do: {to_string(key), value}
  end

  defp fetch_param(params, key) do
    case Map.fetch(params, key) do
      {:ok, value} -> {:ok, value}
      :error -> Map.fetch(params, to_string(key))
    end
  end

  defp run(%Client{} = client, method, path, data, opts) do
    data = merge_data_options(data, opts)

    request =
      [
        method: method,
        base_url: client.host,
        url: path,
        auth: {:basic, "#{client.project_id}:#{client.project_secret}"},
        headers: headers(opts),
        connect_options: [timeout: @connect_timeout],
        receive_timeout: @receive_timeout,
        retry: false
      ]
      |> Keyword.merge(payload(method, data))
      |> Req.new()
      |> Req.merge(client.req_options)

    case Req.request(request) do
      {:ok, %Req.Response{status: status, body: body}} -> check(status, body)
      {:error, exception} -> {:error, transport_error(exception)}
    end
  end

  defp payload(method, data) when method in [:get, :delete], do: [params: flatten_params(data)]
  defp payload(_method, data), do: [json: data]

  # List values (e.g. expand) are encoded as repeated `key[]` params.
  defp flatten_params(data) do
    Enum.flat_map(data, fn
      {key, values} when is_list(values) -> Enum.map(values, &{"#{key}[]", &1})
      {key, value} -> [{key, value}]
    end)
  end

  defp headers(opts) do
    [
      {"content-type", "application/json"},
      {"api-version", @api_version},
      {"user-agent", @user_agent}
    ]
    |> maybe_header("idempotency-key", opts[:idempotency_key])
    |> maybe_header("disable-logging", opts[:disable_logging])
  end

  defp maybe_header(headers, _name, nil), do: headers
  defp maybe_header(headers, name, value), do: [{name, to_string(value)} | headers]

  defp merge_data_options(data, opts) do
    Enum.reduce(@data_options, data, fn key, acc ->
      case Keyword.fetch(opts, key) do
        {:ok, value} -> Map.put(acc, to_string(key), value)
        :error -> acc
      end
    end)
  end

  defp check(status, %{"success" => true} = body), do: success(status, body)

  defp check(status, body) when is_map(body) do
    {:error,
     %Error{
       type: error_type(status, body),
       code: body["error_type"],
       message: body["message"],
       status: status,
       customer_action: ProcessOut.Customer.Action.from_map(body["customer_action"]),
       body: body
     }}
  end

  defp check(status, body) do
    {:error,
     %Error{
       type: error_type(status),
       message: "unexpected response: #{inspect(body)}",
       status: status
     }}
  end

  defp success(status, body) when status in 200..299, do: {:ok, body}

  defp success(status, _body) do
    {:error, %Error{type: error_type(status), message: "unexpected status", status: status}}
  end

  defp error_type(_status, %{"customer_action" => action}) when is_map(action),
    do: :customer_action_required

  defp error_type(status, _body), do: error_type(status)

  defp error_type(400), do: :validation
  defp error_type(401), do: :authentication
  defp error_type(404), do: :not_found
  defp error_type(status) when status >= 500, do: :internal
  defp error_type(_status), do: :generic

  defp transport_error(exception) do
    %Error{type: :transport, message: Exception.message(exception)}
  end
end
