defmodule ProcessOut.RequestTest do
  use ExUnit.Case, async: true

  alias ProcessOut.Customer
  alias ProcessOut.Error

  @hosted_page "https://checkout.processout.com/test-proj_1/iv_1/hosted-payment-page/?source=card_1"

  describe "error responses" do
    test "keeps the customer action of a 3DS soft decline" do
      client =
        stub(410, %{
          "success" => false,
          "error_type" => "card.needs-authentication",
          "message" => "The card requires 3-D Secure validation.",
          "outcome" => "failed",
          "customer_action" => %{"type" => "redirect", "value" => @hosted_page, "metadata" => nil}
        })

      assert {:error, error} = ProcessOut.Invoice.authorize(client, "iv_1", "card_1")

      assert %Error{
               type: :customer_action_required,
               code: "card.needs-authentication",
               status: 410,
               customer_action: %Customer.Action{type: "redirect", value: @hosted_page}
             } = error

      assert error.body["outcome"] == "failed"
    end

    test "classifies plain declines by status" do
      client =
        stub(400, %{
          "success" => false,
          "error_type" => "card.declined",
          "message" => "The card has been declined."
        })

      assert {:error, error} = ProcessOut.Invoice.authorize(client, "iv_1", "card_1")
      assert %Error{type: :validation, code: "card.declined", customer_action: nil} = error
      assert error.body["error_type"] == "card.declined"
    end
  end

  describe "successful responses" do
    test "returns the customer action of a pending outcome" do
      client =
        stub(206, %{
          "success" => true,
          "outcome" => "pending",
          "customer_action" => %{"type" => "redirect", "value" => @hosted_page},
          "transaction" => %{"id" => "tr_1", "status" => "pending"}
        })

      assert {:ok, %{transaction: transaction, customer_action: action}} =
               ProcessOut.Invoice.authorize(client, "iv_1", "card_1")

      assert transaction.id == "tr_1"
      assert action.type == "redirect"
    end
  end

  defp stub(status, body) do
    name = {__MODULE__, System.unique_integer()}

    Req.Test.stub(name, fn conn ->
      conn
      |> Plug.Conn.put_status(status)
      |> Req.Test.json(body)
    end)

    ProcessOut.new("test-proj_1", "key_test_1", req_options: [plug: {Req.Test, name}])
  end
end
