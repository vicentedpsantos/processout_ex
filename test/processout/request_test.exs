defmodule ProcessOut.RequestTest do
  use ProcessOut.APICase, async: true

  alias ProcessOut.Request

  describe "headers and auth" do
    test "sends basic auth, api version and custom headers", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert {:ok, _body} =
               Request.post(client, "/x", %{}, idempotency_key: "key-1", disable_logging: true)

      assert_received {:request, conn}

      expected_auth = "Basic " <> Base.encode64("test-project:test-secret")
      assert Plug.Conn.get_req_header(conn, "authorization") == [expected_auth]
      assert Plug.Conn.get_req_header(conn, "api-version") == ["1.4.0.0"]
      assert Plug.Conn.get_req_header(conn, "idempotency-key") == ["key-1"]
      assert Plug.Conn.get_req_header(conn, "disable-logging") == ["true"]
      assert [user_agent] = Plug.Conn.get_req_header(conn, "user-agent")
      assert user_agent =~ "ProcessOut Elixir-Bindings"
    end
  end

  describe "data options" do
    test "merges expand and filter into the POST body", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert {:ok, _body} =
               Request.post(client, "/x", %{"a" => 1}, expand: ["customer"], filter: "f")

      assert_received {:request, conn}
      assert conn.assigns.json_body == %{"a" => 1, "expand" => ["customer"], "filter" => "f"}
    end

    test "merges options into the GET query string", %{client: client, stub: stub} do
      stub_success(stub, %{})

      assert {:ok, _body} = Request.get(client, "/x", %{}, expand: ["customer"], limit: 5)

      assert_received {:request, conn}
      query = Plug.Conn.fetch_query_params(conn).query_params
      assert query["limit"] == "5"
      assert query["expand"] == ["customer"]
    end
  end

  describe "error mapping" do
    for {status, type} <- [
          {400, :validation},
          {401, :authentication},
          {404, :not_found},
          {500, :internal},
          {402, :generic}
        ] do
      test "maps HTTP #{status} to #{inspect(type)}", %{client: client, stub: stub} do
        stub_error(stub, unquote(status), %{"error_type" => "code", "message" => "msg"})

        assert {:error, error} = Request.get(client, "/x")
        assert error.type == unquote(type)
        assert error.status == unquote(status)
      end
    end

    test "treats success: false with 200 as generic error", %{client: client, stub: stub} do
      stub_error(stub, 200, %{"error_type" => "oops", "message" => "bad"})

      assert {:error, error} = Request.get(client, "/x")
      assert error.type == :generic
      assert error.code == "oops"
    end

    test "returns a transport error when the request fails", %{client: client, stub: stub} do
      Req.Test.stub(stub, fn conn -> Req.Test.transport_error(conn, :econnrefused) end)

      assert {:error, error} = Request.get(client, "/x")
      assert error.type == :transport
    end
  end

  describe "take_params/2" do
    test "picks atom and string keys, drops the rest" do
      params = %{"a" => 1, :b => 2, :c => 3}
      assert Request.take_params(params, [:a, :b]) == %{"a" => 1, "b" => 2}
    end
  end
end
