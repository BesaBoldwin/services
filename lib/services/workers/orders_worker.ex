# defmodule Find.Workers.OrdersWorker do
#   @moduledoc false
#   use Oban.Worker
#   import Ecto.Query, warn: false
#   alias Find.Repo
#   alias Find.Email
#   alias Find.Admin.Schema.{Order, OrderProduct}

#   def perform(%Oban.Job{} = req) do

#     request =
#       if is_bitstring(req.args) == true do
#         req.args |> Poison.decode!()
#       else
#         req.args
#       end
#     %{"key" => key, "email" => email, "order_id" => order_id} = request
#     cond do
#       key == "orders_mail" ->

#        order = Repo.get(Order, order_id)


#         product =
#           OrderProduct
#           |> where([m], m.order_id == type(^order_id, :integer))
#           |> Repo.all()
#           |> Repo.preload(products: :product_images)

#       send =
#         %{}
#         |> Map.put("email", email)
#         |> Map.put("product", product)
#         |> Map.put("order_data", order)


#         Email.order_email(send)
#       key == "contact_us_email" ->
#         Email.contact_us(request)
#     end
#   end

# end
