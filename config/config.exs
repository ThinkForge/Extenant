# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :extenant,
  ecto_repos: [Extenant.Repo]

# Configures the endpoint
config :extenant, ExtenantWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8bAzSTsGSKz8fpHAiHS9iA6wDSxirlso+TA7RKuQUmUeziHhKLaeJ7JRKmFpy/Ds",
  render_errors: [view: ExtenantWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Extenant.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :extenant,
  seed: "aoid231",
  auth_secret: "xVg0A2r6i7BL12kYsTiReG2VtQXSjZ"
  # good way to generate:
  # :crypto.strong_rand_bytes(30)
  # |> Base.url_encode64
  # |> binary_part(0, 30)


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
