module GamesHelper
	def change_points(player,points)
		if player = 1 
			@game.score_one += points.to_i
		elsif player = 2
			@game.score_two += points.to_i
    end
		@game.save
		edit_game_path
	end
end
