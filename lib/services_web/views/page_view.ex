defmodule ServicesWeb.PageView do
  use ServicesWeb, :view




  def get_image("/uploads" <> _path = full_path) do
    Application.app_dir(:find, "priv/static" <> full_path)
    #    |> (fn  end)
    |> File.read!
    |> Base.encode64
  end

  def get_image("/template" <> _path = full_path) do
    Application.app_dir(:find, "priv/static" <> full_path)
    #    |> (fn  end)
    |> File.read!
    |> Base.encode64
  end

  def get_image("/icons" <> _path = full_path) do
    Application.app_dir(:find, "mail/images" <> full_path)
    #    |> (fn  end)
    |> File.read!
    |> Base.encode64
  end

  def find_image() do
    # Routes.static_path(Endpoint, "/images/icons/findicon.png")
    Application.app_dir(:services, "priv/static" <> "/images/icons/findicon.png")
    |> File.read!
    |> Base.encode64
  end

  def find_image_logo() do
    # Routes.static_path(Endpoint, "/images/icons/findicon.png")
    Application.app_dir(:services, "priv/static" <> "/images/icons/logo.png")
    |> File.read!
    |> Base.encode64
  end

  def put_image(request) do
    images = request.products.product_images
    image = Enum.at(images, 0)

    image.url
  end

  def fields() do
    # all = "access_key=#{},profile_id,transaction_uuid,signed_field_names,unsigned_field_names,signed_date_time,locale,transaction_type,reference_number,amount,currency,bill_to_company_name,bill_to_address_city,bill_to_address_country,bill_to_address_line1,bill_to_address_postal_code,bill_to_address_state,bill_to_email,bill_to_forename,bill_to_surname,bill_to_phone"

    # %{
    #   access_key: "access_key",
    #   profile_id: "profile_id",
    #   transaction_uuid: "transaction_uuid",
    #   signed_field_names: "signed_field_names",
    #   unsigned_field_names: "unsigned_field_names",
    #   signed_date_time: "signed_date_time",
    #   locale: "locale",
    #   transaction_type: "transaction_type",
    #   reference_number: "reference_number",
    #   amount: "amount",
    #   currency: "currency",
    #   bill_to_company_name: "bill_to_company_name",
    #   bill_to_address_city: "bill_to_address_city",
    #   bill_to_address_country: "bill_to_address_country",
    #   bill_to_address_line1: "bill_to_address_line1",
    #   bill_to_address_postal_code: "bill_to_address_postal_code",
    #   bill_to_address_state: "bill_to_address_state",
    #   bill_to_email: "bill_to_email",
    #   bill_to_forename: "bill_to_forename",
    #   bill_to_surname: "bill_to_surname",
    #   bill_to_phone: "bill_to_phone",
    #   all: all
    # }

  end


  def sign(request) do
    IO.inspect(request, label: "=====================")
   all = "access_key=#{request[:access_key]},profile_id=#{request.profile_id},transaction_uuid=#{request.transaction_uuid},signed_field_names=#{request.signed_field_names},unsigned_field_names=#{request.unsigned_field_names},signed_date_time=#{request.signed_date_time},locale=#{request.locale},transaction_type=#{request.transaction_type},reference_number=#{request.reference_number},amount=#{request.amount},currency=#{request.currency},bill_to_company_name=#{request.bill_to_company_name},bill_to_address_city=#{request.bill_to_address_city},bill_to_address_country=#{request.bill_to_address_country},bill_to_address_line1=#{request.bill_to_address_line1},bill_to_address_postal_code=#{request.bill_to_address_postal_code},bill_to_address_state=#{request.bill_to_address_state},bill_to_email=#{request.bill_to_email},bill_to_forename=#{request.bill_to_forename},bill_to_surname=#{request.bill_to_surname},bill_to_phone=#{request.bill_to_phone},signed_field_names=#{request.signed_field_names}"

    secret_key = "4958a70b42ae41e6a236b507f66d25dc5e79740da6524d9997e15d12d468ce234320867673604a838bf4bc4e748624dda851213317384aa2b9b0d15dd65e0c49eeff6e13f02a4604a798d523534267e2cd92453b553d4885ad3588bed7a2ebf5f7fe4abab320494abd7e8807cadb2916e5a83f425b594e44a2f640ad0b7e0420"
    # fields = fields()
    :crypto.mac(:hmac, :sha256, secret_key, all)
      |> Base.encode64
  end
end
