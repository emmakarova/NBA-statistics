defmodule Team.Data do
  defstruct [
      :full_name,
      :abbreviation,
      :city,
      :conference
    ]

    def to_team_data(team_json) do
      team = Jason.decode!(team_json)

      %{
        full_name: team["full_name"],
        abbreviation: team["abbreviation"],
        city: team["city"],
        conference: team["conference"]
      }
    end
end
