defmodule ServicesWeb.PageController do
  use ServicesWeb, :controller
  alias Services.Workers.MailService


  def index(conn, _params) do
    result = MailService.list_emails()
    render(conn, "index.html", result: result)
  end

  def details(conn, %{"id" => id}) do

    case MailService.get_email(id) do
      {:contact_us, result} ->
        conn
        |> render("contact_us.html", request: result)
      {:order, result} ->
        conn
        |> render("order.html", body: result.order_data, products: result.product)

      {:password_reset, result} ->
        conn
        |> render("recovery_password.html", url: result.url, result: result)
      {:registration, result} ->
        conn
        |> render("user_confirmation.html", url: result.url, name: result.name)

    end

  end

  def test(conn, _) do
    conn
    |> render("test.html")
  end

  def confirm(conn, params) do
    IO.inspect(params, label: "==================")
    result = process_params(params)

    conn
    |> render("confirm.html", result: result.list, struct: result.resp_struc)
  end

  def process_params(%{"amount" => amount, "bill_to_address_postal_code" => bill_to_address_postal_code, "bill_to_address_state" => bill_to_address_state,
    "bill_to_address_city" => bill_to_address_city, "bill_to_address_country" => bill_to_address_country, "bill_to_address_line1" => bill_to_address_line1,
    "bill_to_company_name" => bill_to_company_name, "bill_to_email" => bill_to_email, "bill_to_forename" => bill_to_forename, "bill_to_phone" => bill_to_phone, "bill_to_surname" => bill_to_surname, "currency" => currency,
    "profile_id" => profile_id, "reference_number" => reference_number, "unsigned_field_names" => unsigned_field_names, "transaction_type" => transaction_type,
    "signed_date_time" => signed_date_time, "signed_field_names" => signed_field_names, "locale" => locale, "transaction_uuid" => transaction_uuid,
     "access_key" => access_key }) do

     list = [
        %{name: "amount", value: amount },
        %{name: "bill_to_address_postal_code", value: bill_to_address_postal_code },
        %{name: "bill_to_address_city", value: bill_to_address_city },
        %{name: "bill_to_address_country", value: bill_to_address_country },
        %{name: "bill_to_address_line1", value: bill_to_address_line1 },
        %{name: "bill_to_company_name", value: bill_to_company_name },
        %{name: "bill_to_email", value: bill_to_email },
        %{name: "bill_to_forename", value: bill_to_forename },
        %{name: "bill_to_phone", value: bill_to_phone },
        %{name: "transaction_uuid", value: transaction_uuid },
        %{name: "bill_to_surname", value: bill_to_surname },
        %{name: "currency", value: currency },
        %{name: "profile_id", value: profile_id },
        %{name: "reference_number", value: reference_number },
        %{name: "signed_date_time", value: signed_date_time },
        %{name: "signed_field_names", value: signed_field_names },
        %{name: "unsigned_field_names", value: unsigned_field_names },
        %{name: "transaction_type", value: transaction_type },
        %{name: "bill_to_address_state", value: bill_to_address_state },
        %{name: "access_key", value: access_key }
      ]

     resp_struc =  %{
        amount: amount,
        bill_to_address_postal_code: bill_to_address_postal_code,
        bill_to_address_state: bill_to_address_state,
         bill_to_address_city: bill_to_address_city,
        bill_to_address_country: bill_to_address_country,
        bill_to_address_country: bill_to_address_country,
        bill_to_address_line1: bill_to_address_line1,
        bill_to_company_name: bill_to_company_name,
        bill_to_email: bill_to_email,
        bill_to_forename: bill_to_forename,
        bill_to_phone: bill_to_phone,
        transaction_uuid: transaction_uuid,
        bill_to_surname: bill_to_surname,
        currency: currency,
        profile_id: profile_id,
        reference_number: reference_number,
        signed_date_time: signed_date_time,
        signed_field_names: signed_field_names,
        locale: locale, unsigned_field_names: unsigned_field_names,
        transaction_type: transaction_type,
        access_key: access_key
      }

      %{resp_struc: resp_struc, list: list}


  end


end
