defmodule ProcessOut.APICase do
  @moduledoc """
  Test case for resource modules. Provides a `client` bound to a
  `Req.Test` stub named after the test module, plus helpers to stub
  API responses and assert on requests.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import ProcessOut.APICase

      setup context do
        stub = context.module
        Req.Test.set_req_test_from_context(context)
        {:ok, client: ProcessOut.APICase.build_client(stub), stub: stub}
      end
    end
  end

  def build_client(stub) do
    ProcessOut.Client.new("test-project", "test-secret", req_options: [plug: {Req.Test, stub}])
  end

  @doc """
  Stubs the next request with a successful JSON response. The stub also
  captures the request `conn` and sends it to the test process; assert on
  it with `assert_received {:request, conn}`.
  """
  def stub_success(stub, payload) do
    Req.Test.stub(stub, fn conn ->
      conn = read_json_body(conn)
      send(self(), {:request, conn})
      Req.Test.json(conn, Map.put(payload, "success", true))
    end)
  end

  @doc "Stubs the next request with an error response of the given status."
  def stub_error(stub, status, payload \\ %{}) do
    Req.Test.stub(stub, fn conn ->
      conn
      |> Plug.Conn.put_status(status)
      |> Req.Test.json(Map.put(payload, "success", false))
    end)
  end

  defp read_json_body(conn) do
    case Plug.Conn.read_body(conn) do
      {:ok, "", conn} ->
        Plug.Conn.assign(conn, :json_body, nil)

      {:ok, body, conn} ->
        Plug.Conn.assign(conn, :json_body, JSON.decode!(body))
    end
  end
end
