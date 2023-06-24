defmodule Nba.Client do
  use GenServer
  alias Store

  @type id :: String
  @registry :clients_registry

  def start_link(name) do
    GenServer.start_link(__MODULE__, [name], name: via_tuple(name))
  end

  def init(client_name) do
    {_, pid} = Nba.DynamicSupervisorWithPartition.start_player_store()

    Player.Synchronizer.start_link({:client_player_store, pid})

    {:ok, %{p: pid, client: client_name}}
  end

  # player calls

  def follow_player(client_name, id) do
    GenServer.call(via_tuple(client_name), {:follow_player, id})
  end

  def unfollow_player(client_name, id) do
    GenServer.call(via_tuple(client_name), {:unfollow_player, id})
  end

  def get_players(client_name) do
    GenServer.call(via_tuple(client_name), {:get_all_players})
  end

  def get_single_player(client_name, id) do
    GenServer.call(via_tuple(client_name), {:get_player, id})
  end

  # team calls

  def follow_team(client_name, id) do
    GenServer.call(via_tuple(client_name), {:follow_team, id})
  end

  def unfollow_team(client_name, id) do
    GenServer.call(via_tuple(client_name), {:unfollow_team, id})
  end

  def get_teams(client_name) do
    GenServer.call(via_tuple(client_name), {:get_all_teams})
  end

  def get_single_team(client_name, id) do
    GenServer.call(via_tuple(client_name), {:get_team, id})
  end

  # player handle calls

  def handle_call({:follow_player, id}, _, state) do
    resp = follow(Store.get(:main_store, id), id, state)

    {:reply, resp, state}
  end

  def handle_call({:unfollow_player, id}, _, state) do
    Store.delete(Map.get(state, :p), id)

    {:reply, :ok, state}
  end

  def handle_call({:get_player, id}, _, state) do
    response = get_single_player_response(Store.get(Map.get(state, :p), id))

    {:reply, response, state}
  end

  def handle_call({:get_all_players}, _, state) do
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



  def get_single_player_response(nil) do
    {:no_such_player, "You must follow this player to get his information"}
  end

  def get_single_player_response(player) do
    {:ok, player}
  end

  # team handle calls

  # def handle_call({:follow_team, id}, _, state) do
  #   resp = follow(Store.get(:main_store, id), id, state)

  #   {:reply, resp, state}
  # end

  def via_tuple(name) do
    {:via, Registry, {@registry, name}}
  end
end
