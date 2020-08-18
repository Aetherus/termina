# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :termina,
  ecto_repos: [Termina.Repo]

# Configures the endpoint
config :termina, TerminaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pAIl2IgWON6UhY6F2kfM5JKx3hxF9rnA+LNFL5Pfsg6U9wT7kSpJew9NTnZCJzrS",
  render_errors: [view: TerminaWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Termina.PubSub,
  live_view: [signing_salt: "UQIL7Lam"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
