defmodule Nba.DynamicSupervisorWithPartition do
  use DynamicSupervisor
  alias Store

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_player_store() do
    spec = %{id: Store, start: {Store, :start_link, [:client_player_store]}}

    DynamicSupervisor.start_child(
      {:via, PartitionSupervisor, {__MODULE__, self()}},
      spec
    )
  end

  def start_team_store() do
    spec = %{id: Store, start: {Store, :start_link, [:client_team_store]}}

    DynamicSupervisor.start_child(
      {:via, PartitionSupervisor, {__MODULE__, self()}},
      spec
    )
  end
end
