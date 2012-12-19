class
	APPLICATION

inherit
	CURSOR_CONTROLLER

create
	make

feature

	make
			-- Launch the application.
		local
			count: INTEGER
			game: GAME
		do

			from
				count := {GAME}.Min_player_count - 1
			until
				{GAME}.Min_player_count <= count and count <= {GAME}.Max_player_count
			loop
				print ("Enter number of players between " + {GAME}.Min_player_count.out + " and " + {GAME}.Max_player_count.out + ": ")
				io.read_integer
				count := io.last_integer
			end

			create game.make (count)
			game.play
			
			game.board.draw_center_text (game.winner.name + " WINS WITH CHF " + game.winner.money.out + "!")
			game.board.mcc (game.board.char_rows + 2, 0)

		end

end
