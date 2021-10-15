defmodule Services.Notification.Schema.Emails do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "emails" do
    field :from, :string
    field :message, :string
    field :status, :string, default: "FALSE"
    field :status_code, :string
    field :to, :string
    field :type, :string
    field :subject, :string
    field :oders_id, :integer
    field :name, :string
    field :mobile, :string
    field :process, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(email, attrs) do
    email
    |> cast(attrs, [:status, :process, :url, :oders_id, :name, :mobile, :subject, :oders_id, :message, :type, :to, :from, :status_code])
    |> validate_required([:status, :type, :to, :from])
  end
end
