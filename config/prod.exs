use Mix.Config

config :logger,
  backends: [
    {LoggerFileBackend, :info},
    {LoggerFileBackend, :warn},
    {LoggerFileBackend, :error}
  ]

config :logger, :info, path: "/var/log/browse_down/info.log", level: :info
config :logger, :warn, path: "/var/log/browse_down/warn.log", level: :warn
config :logger, :error, path: "/var/log/browse_down/error.log", level: :error
