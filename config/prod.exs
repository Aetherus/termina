use Mix.Config

config :termina, TerminaWeb.Endpoint,
  server: true,
  url: [host: "example.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info

config :termina, Termina.Repo,
  username: "postgres",
  password: "postgres",
  database: "termina_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :libcluster, topologies: [
  local: [
    strategy: Cluster.Strategy.DNSPoll,
    config: [
      polling_interval: 5_000,
      query: "tasks.app",
      node_basename: "termina"
    ]
  ]
]
