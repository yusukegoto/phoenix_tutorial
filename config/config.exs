# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :sample_app, SampleApp.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "HfHmZP0amcuTws7g213J2bvfGZkVoRe/RWwkQnKNdxZKYVTNUdsDGc+k4mIyBudK",
  render_errors: [default_format: "html"],
  pubsub: [name: SampleApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :phoenix, SampleApp.Router,
  session: [store: :cookie,
            key: "SampleApp#{Mix.env}"]
