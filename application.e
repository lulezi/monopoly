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
			i, p1, p2, p3: INTEGER
			games: V_ARRAY [GAME]
		do

--			from
--				count := {GAME}.Min_player_count - 1
--			until
--				{GAME}.Min_player_count <= count and count <= {GAME}.Max_player_count
--			loop
--				print ("Enter number of players between " + {GAME}.Min_player_count.out + " and " + {GAME}.Max_player_count.out + ": ")
--				io.read_integer
--				count := io.last_integer
--			end

			create games.make (1, 100)

			across
				games as g
			loop
				g.put (create {GAME}.make(3))
				g.item.play
				if g.item.winner.number = 1 then
					p1 := p1 + 1
				elseif g.item.winner.number = 2 then
					p2 := p2 + 1
				elseif g.item.winner.number = 3 then
					p3 := p3 + 1
				end
			end

--			game.board.draw_center_text (game.winner.name + " WINS WITH CHF " + game.winner.money.out + "!")
--			game.board.mcc (game.board.char_rows + 2, 0)
			print ("p1 wins: " + p1.out + "%Np2 wins: " + p2.out + "%Np3 wins: " + p3.out + "%N")

		end

end
