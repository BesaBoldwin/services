 defmodule Services.Email do
  #  import Bamboo.Email
   import Swoosh.Email
   alias ServicesWeb.Endpoint
   alias Services.Mailer
  #  use Bamboo.Phoenix, view: ServicesWeb.EmailView
   use Phoenix.Swoosh, view: ServicesWeb.EmailView, layout: {ServicesWeb.LayoutView, :app}


  def welcome() do
    user = %{name: "Boldwin", email: "boldwinbesa@gmail.com", username: "Testing"}
    new()
    |> to({user.name, user.email})
    |> from({"FIND.CO.ZM", "boldwin@find.co.zm"})
    |> subject("Hello, Avengers!")
    |> html_body("<h1>Hello #{user.name}</h1>")
    |> text_body("Hello #{user.name}\n")
    |> render_body("welcome.html", %{username: user.username})
    |> Mailer.deliver()
    |> IO.inspect()
  end


#   {:error,
#  {:send,
#   {:permanent_failure, 'mail.find.co.zm',
#    "550-Verification failed for <hulk.smash@example.com>\r\n550-The mail server does not recognize hulk.smash@example.com as a valid sender.\r\n550 Sender verify failed\r\n"}}}



   def user_confirmation_mail(data) do
    %{"email" => email, "url" => url, "user" => user} = data
    %{"first_name" => first_name, "last_name" => last_name} = user
     email_to = email
     names = "#{first_name} #{last_name}"
     new()
     |> to({names, email_to})
     |> from({"FIND.CO.ZM", "hello@find.co.zm"})
     |> subject("Confirmation!")
     |> text_body("Kindly confirm your account!")
     |> render_body("user_confirmation.html", %{url: url, name: first_name, last_name: last_name, user: user})
     |> Mailer.deliver()
   end

   def order_email(data, request) do
    send_order_mail(data, request)
   end


   def send_order_mail(%{"order_data" => body, "product" => products}, request) do
      recievers = [%{to: request.to}, %{to: "orders@find.co.zm"}]
      for item <- recievers do
        new()
        |> to({"#{body.first_name} #{body.last_name}", item.to})
        |> from({"FIND.CO.ZM", request.from})
        |> subject(request.subject)
        |> text_body("Thanks of ordering on our platform!")
        |> render_body("order.html", body: body, products: products)
        |> Mailer.deliver()
        |> IO.inspect(label: "===================== IS IT SENT ***************")
        |> Services.Workers.EmailWorker.end_processing(request)
      end
   end

   def contact_us(request) do
     email_to = request.to
     new()
     |> to({"FIND.CO.ZM", "boldwinbesa@gmail.com"})
    #  |> to(email_to)
     |> from({"CLIENT", request.from})
     |> subject(request.subject)
     |> text_body(request.message)
     |> render_body("contact_us.html", %{request: request})
     |> Mailer.deliver()
   end

  #  def password_reset(request) do
  #   #  email_to = request["user"]["email"]
  #    %{"user" => user, "url" => url } = request
  #    %{"email" => email} = user

  #    image = Endpoint.static_path("/template/mail/Icons/find_icon.png")
  #    new_email()
  #    |> to(email)
  #    |> from("info@find.co.zm")
  #    |> subject("Password Reset request")
  #    |> text_body(request["data"])
  #    |> put_html_layout({ServicesWeb.LayoutView, "app.html"})
  #    |> render("recovery_password.html", image: image, url: url)
  #    |> Mailer.deliver_now(response: true)
  #  end



 end
