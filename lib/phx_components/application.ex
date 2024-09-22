defmodule PhxComponents.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhxComponentsWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:phx_components, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhxComponents.PubSub},
      # Start a worker by calling: PhxComponents.Worker.start_link(arg)
      # {PhxComponents.Worker, arg},
      # Start to serve requests, typically the last entry
      PhxComponentsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhxComponents.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhxComponentsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
