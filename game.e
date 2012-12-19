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
			print_board
		end

feature -- Basic operations

	play
			-- Start a game.
		local
			round, i, pig: INTEGER
		do
			pig := -1
			from
				round := 1
				print ("The game begins.%N")
			until
				pig = 0 or round > 100
			loop
				pig := 0
				from
					i := 1
				until
					i > players.count
				loop
					if players [i].money > 0 then
						players [i].play (die_1, die_2)
						board.sync_leaderboard (players)
						pig := pig + 1
					end
					i := i + 1
				end
--				if round \\ 10 = 0 then
					print_board
--				end
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

	die_1: DIE
			-- The first die.

	die_2: DIE
			-- The second die.

feature {NONE} -- Implementation
 	print_board
			-- Output players positions on the board.
		do
			print (board.out)
		end

invariant
	board_exists: board /= Void
	players_exist: players /= Void
	all_players_exist: across players as p all p.item /= Void end
	number_of_players_consistent: Min_player_count <= players.count and players.count <= Max_player_count
	dice_exist: die_1 /= Void and die_2 /= Void
end
