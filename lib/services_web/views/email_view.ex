defmodule ServicesWeb.EmailView do
  use ServicesWeb, :view
  alias ServicesWeb.Endpoint

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

  def put_image(request) do
    images = request.products.product_images
    image = Enum.at(images, 0)

    image.url
  end



end
