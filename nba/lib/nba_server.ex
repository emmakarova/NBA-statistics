defmodule Nba.Server do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:follow, id}, _, state) do
    resp = follow(Store.get(:main_store, id), id, state)

    {:reply, resp, state}
  end

  def handle_call({:get_all}, _, state) do
    {:reply, Store.get_all(Map.get(state, :p)), state}
  end

  def follow(nil, id, state) do
    player = NBA.API.get_single_player(id)

    Store.put(:main_store, id, player)
    Store.put(Map.get(state, :p), id, player)

    {:ok, "Successfully followed player"}
  end

  def follow(player, id, state) do
    Store.put(Map.get(state, :p), id, player)

    {:ok, "Player already exists in the main store"}
  end

end
