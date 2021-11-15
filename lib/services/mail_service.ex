defmodule Services.Workers.MailService do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Services.{Email, Repo}
  alias Services.Notification.Schema.Emails

  def list_emails, do: Repo.all(Emails)

  def get_email(id) do
    email = Repo.get(Emails, id)
    case email.type do
      "contact_us" ->
        {:contact_us, email}
      "order" ->
          {:order, order(email)}

      "password_reset" ->
        {:password_reset, email}

      "user_registration" ->
        {:registration, email}
    end
  end

  def order(email) do
    order = prepare_order(email)

    prepare_order_products(email)
    |> prepare_email(email, order)
    |> IO.inspect(label: "EMAIL RESPONSE: ----->")
    # |> Email.order_email(email)
  end

  defp prepare_email(product, email, order) do
    %{}
    |> Map.put(:product, product)
    |> Map.put(:order_data, order)
    |> Map.put(:subject, email.subject)
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
    # left_join: c in "product_images", on: b.id == c.products_id,
    where: a.order_id  == type(^email.oders_id, :integer),
    group_by: [a.id, a.final_price, b.id, b.name],
    # group_by: [a.id, a.final_price, b.id, b.name, c.id, c.url],
    select: %{
      product_name: b.name,
      image: b.image,
      attributes: a.attributes,
      price: a.final_price,
      qty: a.product_quantity
    }

  )
  end




end
