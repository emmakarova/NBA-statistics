defmodule Player.Synchronizer do
  use GenServer

  def start_link({:main, store_pid}) do
    GenServer.start_link(__MODULE__, {:main, store_pid}, name: __MODULE__)
  end

  def start_link({:client_player_store, client_store_pid}) do
    GenServer.start_link(__MODULE__, {:client_player_store, client_store_pid})
  end

  def start_link({:client_team_store, client_store_pid}) do
    GenServer.start_link(__MODULE__, {:client_team_store, client_store_pid})
  end

  def init({:main, store_pid}) do
    sync_main_store()
    {:ok, store_pid}
  end

  def init({:client_player_store, client_store_pid}) do
    sync_client_player_store()

    {:ok, client_store_pid}
  end

  def init({:client_team_store, client_store_pid}) do
    sync_client_team_store()
    {:ok, client_store_pid}
  end

  def sync_main_store() do
    :timer.send_interval(7000, __MODULE__, {:sync_main})
  end

  def sync_client_player_store() do
    :timer.send_interval(5000, {:sync_client_player_store})
  end

  def sync_client_team_store() do
    :timer.send_interval(5000, {:sync_client_team_store})
  end

  def handle_info({:sync_main}, state) do
    Enum.map(Store.get_all(state), fn {id, _} -> sync_with_api(state, id) end)

    {:noreply, state}
  end

  def handle_info({:sync_client_player_store}, state) do
    Enum.map(Store.get_all(state), fn {id, _} -> sync_with_main_store(state, id) end)

    {:noreply, state}
  end

  def handle_info({:sync_client_team_store}, state) do
    {:noreply, state}
  end

  def sync_with_api(store_pid, id) do
    player = NBA.API.get_single_player(id)
    Store.update(store_pid, id, player)
  end

  def sync_with_main_store(store_pid, id) do
    player = Store.get(:main_store, id)

    Store.update(store_pid, id, player)
  end
end

# Nba.Client.get_single_player("client1","1")
# Nba.Client.follow_player("client1", "1")
# Nba.Client.unfollow_player("client1", "1")

# Nba.Client.start_link("client1")
