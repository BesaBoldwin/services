defmodule Find.Admin.Schema.OrderProduct do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset
  alias Find.Admin.Schema.{Products, Order, TblOrder_Product_Attribute}

  @derive {Jason.Encoder, only: [:id, :final_price, :manufacturers_id, :product_model, :products, :product_name, :product_price, :product_quantity, :product_tax, :attributes]}


  schema "order_product" do
    field :final_price, :decimal
    field :manufacturers_id, :integer
#    field :order_id, :integer
#    field :products_id, :integer
    field :product_model, :string
    field :product_name, :string
    field :product_price, :decimal
    field :product_quantity, :integer
    field :product_tax, :decimal
    field :attributes, :string
    belongs_to(:products, Products, foreign_key: :products_id)
    has_one(:order_product_attribute, TblOrder_Product_Attribute, on_delete: :delete_all)
    belongs_to(:order, Order)

    timestamps()
  end

  @doc false
  def changeset(order_product, attrs) do
    order_product
    |> cast(attrs, [:final_price, :attributes, :manufacturers_id, :order_id, :products_id, :product_quantity, :product_tax, :product_model, :product_name, :product_price])
    |> validate_required([:final_price, :order_id, :products_id, :product_quantity, :product_name, :product_price])
  end
end
