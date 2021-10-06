 defmodule Services.Email do
   import Bamboo.Email
   alias ServicesWeb.Endpoint
   alias Services.Mailer
   use Bamboo.Phoenix, view: ServicesWeb.EmailView


   def welcome_html_email(email_address) do
     new_email()
     |> to(email_address)
     |> from("hello@find.co.zm")
     |> subject("Welcome!")
     |> text_body("Welcome to MyApp!")
     |> html_body("<strong>Welcome<strong> to MyApp!")
     |> put_html_layout({ServicesWeb.LayoutView, "app.html"})
     |> render("welcome.html", email: email_address)
     |> Mailer.deliver_now(response: true)
   end

   def user_confirmation_mail(data) do
    %{"email" => email, "url" => url, "user" => user} = data
    %{"first_name" => first_name, "last_name" => last_name} = user
     email_to = email
     new_email()
     |> to(email_to)
     |> from("hello@find.co.zm")
     |> subject("Confirmation!")
     |> text_body("Kindly confirm your account!")
     #|> html_body(body)
     |> put_html_layout({ServicesWeb.LayoutView, "app.html"})
     |> render("user_confirmation.html", url: url, name: first_name, last_name: last_name, user: user)
     |> Mailer.deliver_now(response: true)
   end

   def order_email(data, request) do
    send_order_mail(data, request)
   end


   def send_order_mail(%{"order_data" => body, "product" => products}, request) do
    recievers = [%{to: request.to}, %{to: "orders@find.co.zm"}]
    for item <- recievers do
      new_email()
      |> to(item.to)
      |> from(request.from)
      |> subject(request.subject)
      |> text_body("Thanks of ordering on our platform!")
      |> put_html_layout({ServicesWeb.LayoutView, "app.html"})
      |> render("order.html", body: body, products: products)
      |> Mailer.deliver_now(response: true)
      |> Services.Workers.EmailWorker.end_processing(request)
    end

   end

   def contact_us(request) do
     email_to = request.to
     new_email()
     |> to("boldwinbesa@gmail.com")
    #  |> to(email_to)
     |> from(request.from)
     |> subject(request.subject)
     |> text_body(request.message)
     |> put_html_layout({ServicesWeb.LayoutView, "app.html"})
     |> render("contact_us.html", request: request)
     |> Mailer.deliver_now(response: true)
   end

   def password_reset(request) do
    #  email_to = request["user"]["email"]
     %{"user" => user, "url" => url } = request
     %{"email" => email} = user

     image = Endpoint.static_path("/template/mail/Icons/find_icon.png")
     new_email()
     |> to(email)
     |> from("info@find.co.zm")
     |> subject("Password Reset request")
     |> text_body(request["data"])
     |> put_html_layout({ServicesWeb.LayoutView, "app.html"})
     |> render("recovery_password.html", image: image, url: url)
     |> Mailer.deliver_now(response: true)
   end



 end
