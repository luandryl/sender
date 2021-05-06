defmodule Sender do
  use Tesla

  @payload %{
    "internal_transaction_id" => "F084B5F54406DAA800481771650424B0",
    "account_holder_id" => "f9641bd3-2ae9-4c9f-a581-728470a63e24",
    "billing_amount_authorized" => 746,
    "currency" => 986,
    "added_time" => "2021-02-12T13:33:55+00:00",
    "msg_type" => 1100,
    "pan_entry_mode" => "typed",
    "pin_sent" => false,
    "pos" => %{
      "id" => "12345678",
      "pin_entry_capability" => false,
      "magnetic_stripe_capability" => false,
      "contactless_capability" => false,
      "chip_capability" => false
    },
    "acquiring_id" => "009685",
    "merchant_id" => "ID-Code03",
    "merchant_name" => "Computer Software",
    "merchant_city" => "Vegas",
    "acquiring_country_code" => "840",
    "merchant_country" => "USA",
    "mcc" => "5045",
    "brand" => "mastercard",
    "card_issuance_date" => "2020-09-14T16:25:59+00:00",
    "expiry_mm_yyyy" => "2021-09-30",
    "pan_masked" => "223362******0461",
    "txn_amount" => 746,
    "billing_currency" => 986,
    "txn_type" => 0,
    "card_id" => "533D51B2B710DCA24C971B2DE8D8C032",
    "balance_account_group_id" => "bcbc8947-8030-4b87-bf3f-eca926f8269b",
    "treasury_account_holder_id" => "87e1f273-1510-4ef4-849a-0acf074345b6",
    "realm" => "vee"
  }

  def multiple_sender do
    Enum.map(1..5_000, &do_request/1)
  end

  def do_request(id) do
    :timer.sleep(500)

    "http://localhost:5000/test/#{id}"
    |> client()
    |> Tesla.put("", @payload)
    |> response()
  end

  defp client(url) do
    middleware_list(url)
    |> Tesla.client()
  end

  defp response({:error, reason}), do: "Error: #{reason}"
  defp response({:ok, %Tesla.Env{status: status}}), do: "Status #{status}"

  defp middleware_list(url),
    do: [
      Tesla.Middleware.JSON,
      {Tesla.Middleware.BaseUrl, url},
      {Tesla.Middleware.Timeout, timeout: 1_000}
    ]
end
