# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :services,
  ecto_repos: [Services.Repo]

# Configures the endpoint
config :services, ServicesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Juf3gmfiopuWIWmSlm+iCglQ1EcEgAYdebmvJ4I5GDRCoy2IP9bGgc5MwjjCCMXC",
  render_errors: [view: ServicesWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Services.PubSub,
  live_view: [signing_salt: "DmxkRo3V"]

config :services, Services.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  # relay: "smtp.gmail.com",
  # username: "boldwinbesa@gmail.com",
  # password: "amjustlooking@u2",
  relay: "mail.find.co.zm",
  username: "boldwin@find.co.zm",
  password: "amjustlooking@u2",
  # password: "F1nd@2020",
  ssl: false,
  tls: :always,
  auth: :always,
  # port: 465,
  port: 587,
  retries: 3,
  no_mx_lookups: false
  # dkim: [
  #   s: "default", d: "find-uat.find.co.zm",
  #   private_key: {:pem_plain, File.read!("priv/static/keys/private-key.pem")}
  # ]

  # adapter: Bamboo.SMTPAdapter,
  # # server: "smtp-relay.find.co.zm",
  # # hostname: "smtp-relay.find.co.zm",
  # server: "mail.find.co.zm",
  # # port: 2050,
  # port: 587,
  # # or {:system, "SMTP_USERNAME"}
  # username: "hello@find.co.zm",
  # # or {:system, "SMTP_PASSWORD"}
  # password: "F1nd@2020",
  # # can be `:always` or `:never`
  # tls: :if_available,
  # allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  # # can be `true`
  # ssl: false,
  # retries: 3

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :endon,
  repo: Services.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"


config :services, Services.Scheduler,
 overlap: false,
 timeout: 30_000,
 jobs: [
  emails: [
    schedule:  {:extended, "*/5"}, task: {Services.Workers.EmailWorker, :run, []},
  ]
 ]
