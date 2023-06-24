defmodule Nba.Application do
  use Application

  @registry :clients_registry

  @impl true
  def start(_type, _args) do
    children = [
      {PartitionSupervisor, child_spec: DynamicSupervisor, name: Nba.DynamicSupervisorWithPartition},
      {Registry, [keys: :unique, name: @registry]},
      {Store, :main_store}
    ]

    opts = [strategy: :one_for_one, name: Nba.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
