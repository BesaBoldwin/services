# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

# database_url =
#   System.get_env("DATABASE_URL") ||
#     raise """
#     environment variable DATABASE_URL is missing.
#     For example: ecto://USER:PASS@HOST/DATABASE
#     """



config :services, Services.Repo,
      username: "find",
      password: "F1nd@2020",
      database: "find",
      hostname: "202.61.204.157",
      show_sensitive_data_on_connection_error: true,
      pool_size: 10


# config :services, Services.Repo,
#   # ssl: true,
#   # url: database_url,
#   # pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
#   username: "postgres",
#   password: "qwerty12",
#   database: "find",
#   hostname: "192.248.165.187",
#   show_sensitive_data_on_connection_error: true,
#   pool_size: 10

secret_key_base = "Juf3gmfiopuWIWmSlm+iCglQ1EcEgAYdebmvJ4I5GDRCoy2IP9bGgc5MwjjCCMXC"
  # System.get_env("SECRET_KEY_BASE") ||
  #   raise """
  #   environment variable SECRET_KEY_BASE is missing.
  #   You can generate one by calling: mix phx.gen.secret
  #   """

config :services, ServicesWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4010"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base


# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :services, ServicesWeb.Endpoint, server: true

#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
