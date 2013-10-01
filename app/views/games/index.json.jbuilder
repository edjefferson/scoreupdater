json.array!(@games) do |game|
  json.extract! game, :player_one, :player_two, :score_one, :score_two
  json.url game_url(game, format: :json)
end
