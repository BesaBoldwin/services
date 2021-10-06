defmodule Services.Schema.Order do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  @fields ~w(id last_name order_status_history first_name order_product email phone_number country province cty comment address order_price township order_information coupon_amount coupon_code payment_method shipping_method shipping_cost customer_id]}
  )a

  @derive {Jason.Encoder, only: @fields}

  schema "orders" do
    field :last_name, :string
    field :first_name, :string
    field :email, :string
    field :phone_number, :string
    field :country, :string
    field :province, :string
    field :city, :string
    field :total_tax, :decimal
    field :shipping_method, :string
    field :shipping_cost, :decimal
    field :customer_id, :integer
    field :currency, :string
    field :payment_method, :string
    field :coupon_code, :string
    field :coupon_amount, :string
    field :order_information, :string
    field :township, :string
    field :order_price, :decimal
    field :address, :string
    field :comment, :string
    field :platform, :string
    field :seen, :boolean, null: false, default: false

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:coupon_amount, :seen, :platform, :address, :order_price, :comment, :township, :customer_id, :phone_number, :currency, :payment_method, :coupon_code, :email, :order_information, :shipping_cost, :country, :province, :city, :shipping_method, :shipping_method, :total_tax, :first_name, :last_name])
    |> validate_required([:email, :shipping_cost, :country, :province, :city, :shipping_method, :shipping_method, :first_name, :last_name])

  end
end
