defmodule Termina.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = Application.fetch_env!(:libcluster, :topologies)

    children = [
      {Cluster.Supervisor, [topologies, [name: Termina.ClusterSupervisor]]},
      # Start the Ecto repository
      Termina.Repo,
      # Start the Telemetry supervisor
      TerminaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Termina.PubSub},
      # Start the Endpoint (http/https)
      TerminaWeb.Endpoint
      # Start a worker by calling: Termina.Worker.start_link(arg)
      # {Termina.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Termina.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TerminaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
