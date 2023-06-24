defmodule NBA.API do
  @type id :: String
  @type per_page :: String

  def get_all_players(per_page) do
    baseUrl = "https://free-nba.p.rapidapi.com/"
    apiKey = ""

    response = Req.get!(baseUrl <> "players?per_page=" <> per_page, headers: [{"X-RapidAPI-Key", apiKey}])
    Jason.encode!(response.body)
  end

  def get_single_player(id) do
    baseUrl = "https://free-nba.p.rapidapi.com/"
    apiKey = ""

    response = Req.get!(baseUrl <> "players/" <> id, headers: [{"X-RapidAPI-Key", apiKey}])

    Player.Data.to_player_data(Jason.encode!(response.body))
  end

  def get_all_teams(per_page) do
    baseUrl = "https://free-nba.p.rapidapi.com/"
    apiKey = "315817eba3msh30857b1addef0b5p16be2fjsn94769c6bf9e0"

    response = Req.get!(baseUrl <> "teams?per_page=" <> per_page, headers: [{"X-RapidAPI-Key", apiKey}])
    Jason.encode!(response.body)
  end

  def get_single_team(id) do
    baseUrl = "https://free-nba.p.rapidapi.com/"
    apiKey = ""

    response = Req.get!(baseUrl <> "teams/" <> id, headers: [{"X-RapidAPI-Key", apiKey}])
    Team.Data.to_team_data(Jason.encode!(response.body))
  end

  ## /stats
end
