defmodule Services.Workers.EmailWorker do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Services.{Email, Repo}
  alias Services.Notification.Schema.Emails



def run() do

    mails = Repo.all(from a in Emails, where: a.status == "FALSE" or a.status == "READY" )
    |> IO.inspect(label: "===============| EMAIL JOBS |========")

    Enum.each(mails, fn email ->

      email_update(email, %{status: "PICKED", process: "processing now"})

      Task.async(fn ->
        case email.type do
          "contact_us" ->
              contact_us(email)
          "order" ->
              order(email)
          "password_reset" ->
            Email.password_reset(email)
          "user_registration" ->
            Email.user_confirmation_mail(email)
        end
      end)


    end)

end


def order(email) do
  order = prepare_order(email)

  prepare_order_products(email)
  |> prepare_email(email, order)
  |> IO.inspect(label: "EMAIL RESPONSE: ----->")
  |> Email.order_email(email)
end

def prepare_order(email) do
  Repo.one(from a in "orders", where: a.id == type(^email.oders_id, :integer),
    select: %{
      id: a.id,
      email: a.email,
      first_name: a.first_name,
      last_name: a.last_name,
      phone_number: a.phone_number,
      country: a.country,
      province: a.province,
      city: a.city,
      shipping: a.shipping_method,
      customer_id: a.customer_id,
      status: a.status,
      shipping_cost: a.shipping_cost,
      currency: a.currency,
      address: a.address,
      coupon_code: a.coupon_code,
      coupon_amount: a.coupon_amount,
      township: a.township,
      order_price: a.order_price,
      comment: a.comment,
      # inserted_at: (fragment("convert(VARCHAR, ?, 107)", a.inserted_at)),
      inserted_at: (fragment("to_char(?, 'DD Mon YYYY HH24:MI:SS')", a.inserted_at)),
      order_information: a.order_information
    }
  )
end

defp prepare_order_products(email) do
  Repo.all(from a in "order_product",
    left_join: b in "products", on: a.products_id == b.id,
    left_join: c in "product_images", on: b.id == c.products_id,
    where: a.order_id  == type(^email.oders_id, :integer),
    order_by: [a.id, a.final_price, b.id, b.name, c.id, c.url],
    select: %{
      product_name: b.name,
      image: c.image,
      price: a.final_price
    }

  )
end

defp prepare_email(product, email, order) do
  %{}
  |> Map.put("email", email)
  |> Map.put("product", product)
  |> Map.put("order_data", order)
  |> Map.put("subject", email.subject)
end

def contact_us(email) do
  Email.contact_us(email)
  |> end_processing(email)
  # IO.inspect(label: "========>>| RESPONSE |<==========")
end


def end_processing(response, email) do
  case response do
    {:ok, response} ->
      email_update(email, %{status: "SENT", process: "-- completed -- #{response} --"})
    {:error, response} ->
      case response do
        {:send, res} ->
          case res do
            {:permanent_failure, _, reason} ->
              email_update(email, %{status: "FAILED", process: "-- Permanent Failure -- #{reason} ---"})
            _ ->
              email_update(email, %{status: "FALSE", process: "-- failed! --"})
          end

          {:retries_exceeded, response} ->
            case response do
              {:network_failure, _, res} ->
                case res do
                  {:error, :timeout} ->
                    email_update(email, %{status: "FALSE", process: "-- Network Failure -- Retries exceeded ---"})
                  _ ->
                    email_update(email, %{status: "FALSE", process: "-- failed! --"})
                end
                _ ->
                  email_update(email, %{status: "FALSE", process: "-- failed! --"})
            end

          _ ->
            email_update(email, %{status: "FALSE", process: "-- failed! --"})

      end

    _ ->
        email_update(email, %{status: "FALSE", process: "-- failed! --"})
   end
end

def email_update(schema, params) do
  IO.inspect(params, label: "===================")
  Ecto.Multi.new()
      |> Ecto.Multi.update(:email_update, Emails.changeset(schema, params))
      |> Repo.transaction()
      |> IO.inspect(label: "*************** TRANSACTION DONE : : : :   ")
end


end
