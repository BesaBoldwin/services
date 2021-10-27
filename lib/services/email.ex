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
    |> from({"Find.co.zm", "boldwin@Find.co.zm"})
    |> subject("Hello, Avengers!")
    |> html_body("<h1>Hello #{user.name}</h1>")
    |> text_body("Hello #{user.name}\n")
    |> render_body("welcome.html", %{username: user.username})
    |> Mailer.deliver()
    |> IO.inspect()
  end


#   {:error,
#  {:send,
#   {:permanent_failure, 'mail.Find.co.zm',
#    "550-Verification failed for <hulk.smash@example.com>\r\n550-The mail server does not recognize hulk.smash@example.com as a valid sender.\r\n550 Sender verify failed\r\n"}}}



   def user_confirmation_mail(data) do
    %{:from => from, :to => to, :url => url} = data
    #  from = data.from
    #  to = data.to
    #  url = data.rul
     names = data.name
     new()
     |> to({names, to})
     |> from({"Find.co.zm", from})
     |> subject("Confirmation!")
     |> text_body("Kindly confirm your account!")
     |> render_body("user_confirmation.html", %{url: url, name: names})
     |> Mailer.deliver()
   end

   def order_email(data, request) do
    send_order_mail(data, request)
   end


   def send_order_mail(%{"order_data" => body, "product" => products}, request) do
      recievers = [%{to: request.to}, %{to: "orders@Find.co.zm"}]
      for item <- recievers do
        new()
        |> to({"#{body.first_name} #{body.last_name}", item.to})
        |> from({"Find.co.zm", request.from})
        |> subject(request.subject)
        |> text_body("Thanks of ordering on our platform!")
        |> render_body("order.html", body: body, products: products)
        |> Mailer.deliver()
        |> IO.inspect(label: "===================== IS IT SENT?? ***************")
        |> Services.Workers.EmailWorker.end_processing(request)
      end
   end

   def contact_us(request) do
     email_to = request.to
     new()
     |> to({"Find.co.zm", "boldwinbesa@gmail.com"})
    #  |> to(request.name, email_to)
     |> from({"CLIENT", request.from})
     |> subject(request.subject)
     |> text_body(request.message)
     |> render_body("contact_us.html", %{request: request})
     |> Mailer.deliver()
     |> IO.inspect(label: "===================== IS IT SENT?? ***************")
   end

   @spec password_reset(%{
           :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
           optional(atom) => any
         }) :: any
   def password_reset(%{"from" => from, "to" => to, "url" => url } = request) do
     new()
     |> to({"", to})
     |> from({"Find.co.zm", from})
     |> subject("PASSWORD RESET REQUEST")
     |> text_body("Thanks for using our platform!")
     |> render_body("recovery_password.html", url: url)
     |> Mailer.deliver()
     |> Services.Workers.EmailWorker.end_processing(request)
   end



 end
