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


end
