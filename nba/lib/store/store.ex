defmodule Store do
  use GenServer

  def start_link(:main_store) do
    {_, pid} = GenServer.start_link(__MODULE__, %{}, name: :main_store)
    Player.Synchronizer.start_link({:main, pid})
  end

  def start_link(:client_player_store) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    {:ok, state}
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def get_all(pid) do
    GenServer.call(pid, {:get_all})
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def update(pid, key, new_value) do
    GenServer.cast(pid, {:update, key, new_value})
  end

  def delete(pid, key) do
    GenServer.call(pid, {:delete, key})
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  def handle_call({:get_all}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:delete, key}, _from, state) do
    {:reply, :ok, Map.delete(state, key)}
  end

  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_cast({:update, key, new_value}, state) do
    {:noreply, Map.update(state, key, %{}, fn _ -> new_value end)}
  end
end
