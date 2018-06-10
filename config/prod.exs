use Mix.Config

config :logger,
  backends: [
    {LoggerFileBackend, :info},
    {LoggerFileBackend, :warn},
    {LoggerFileBackend, :error}
  ]

home_dir = System.get_env("HOME")
config :logger, :info, path: "#{home_dir}/.browse_down/info.log", level: :info
config :logger, :warn, path: "#{home_dir}/.browse_down/warn.log", level: :warn
config :logger, :error, path: "#{home_dir}/.browse_down/error.log", level: :error
