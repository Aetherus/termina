import Config

config :termina, TerminaWeb.Endpoint,
  url: [
    host: System.fetch_env!("TERMINA_HOST"), 
    port: System.get_env("TERMINA_PORT", "4000") |> String.to_integer()
  ]

config :termina, Termina.Repo,
  username: System.fetch_env!("TERMINA_DB_USERNAME"),
  password: System.fetch_env!("TERMINA_DB_PASSWORD"),
  database: System.fetch_env!("TERMINA_DB_DATABASE"),
  hostname: System.fetch_env!("TERMINA_DB_HOSTNAME"),
  show_sensitive_data_on_connection_error: false,
  pool_size: System.get_env("TERMINA_DB_POOL_SIZE", "10") |> String.to_integer()
