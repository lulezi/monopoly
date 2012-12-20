class
	GAME

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Create a game with `n' players.
		require
			n_in_bounds: Min_player_count <= n and n <= Max_player_count
		local
			i: INTEGER
			p: PLAYER
		do
			create board.make
			create players.make (1, n)
			from
				i := 1
			until
				i > players.count
			loop
				create p.make (i, board)
				p.transfer (Initial_money)
				players [i] := p
				i := i + 1
			end
			create die_1.roll
			create die_2.roll
			board.sync_leaderboard (players)
		end

feature -- Basic operations

	play
			-- Start a game.
		local
			round, i: INTEGER
			pos: POSITION
			ex_env: EXECUTION_ENVIRONMENT
		do
			pos := board.center_text_pos
			pos.affect_i (-2)
			create ex_env
			from
				round := 1
			until
				winner /= Void or round > 1000
			loop
				board.draw_at_pos (pos, "Round # " + round.out)
				from
					i := 1
				until
					i > players.count or winner /= Void
				loop
					if players [i].money > 0 then
						players [i].play (die_1, die_2)
						board.sync_leaderboard (players)
					end
					ex_env.sleep (1000000000)
--					io.read_line
					i := i + 1
				end
				round := round + 1
			end
		end

feature -- Constants

	Min_player_count: INTEGER = 2
			-- Minimum number of players.

	Max_player_count: INTEGER = 6
			-- Maximum number of players.

	Initial_money: INTEGER = 1500
			-- Initial amount of money of each player.

feature -- Access

	board: BOARD
			-- Board.

	players: V_ARRAY [PLAYER]
			-- Container for players.

	winner: PLAYER
		local
			i: INTEGER
		do
			across
				players as player
			loop
				if player.item.money > 0 then
					Result := player.item
					i := i + 1
				end
			end
			if i > 1 then
				Result := Void
			end
		end

	die_1: DIE
			-- The first die.

	die_2: DIE
			-- The second die.

invariant
	board_exists: board /= Void
	players_exist: players /= Void
	all_players_exist: across players as p all p.item /= Void end
	number_of_players_consistent: Min_player_count <= players.count and players.count <= Max_player_count
	dice_exist: die_1 /= Void and die_2 /= Void
end
