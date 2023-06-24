defmodule Player.Data do
  # defmodule Team do
  #   defstruct [
  #     :full_name,
  #     :abbreviation,
  #     :city,
  #     :conference
  #   ]
  # end

  defstruct [
    :first_name,
    :last_name,
    :position,
    :height_feet,
    :height_inches,
    :team,
    :last_sync
  ]

  def to_player_data(player_json) do
    player = Jason.decode!(player_json)

    %{
      first_name: player["first_name"],
      last_name: player["last_name"],
      position: player["position"],
      height_feet: player["heigh_feet"],
      height_inches: player["height_inches"],
      team: %Team.Data{
        full_name: player["team"]["full_name"],
        abbreviation: player["team"]["abbreviation"],
        city: player["team"]["city"],
        conference: player["team"]["conference"]
      },
      last_sync: :calendar.local_time()
      # followers: 0
    }
  end
end
