defmodule ServicesWeb.PageController do
  use ServicesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
