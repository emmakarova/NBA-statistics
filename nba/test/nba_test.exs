defmodule NbaTest do
  use ExUnit.Case

  test "Follow player with id = 1" do
    client2 = "client2"
    testPlayerId = "1"

    {:ok, _} = Nba.Client.start_link(client2)
    %{} = Nba.Client.get_players(client2)
    {:no_such_player, "You must follow this player to get his information"} = Nba.Client.get_single_player(client2, testPlayerId)

    {:ok, "Successfully followed player"} = Nba.Client.follow_player(client2, testPlayerId)
    {:ok, "Player is already followed"} = Nba.Client.follow_player(client2, testPlayerId)

    {:ok,  %{} = player} = Nba.Client.get_single_player(client2, testPlayerId)

    assert player.first_name == "Alex"
    assert player.team.abbreviation == "OKC"


  end
end
