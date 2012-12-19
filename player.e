class
	PLAYER

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER; b: BOARD)
			-- Create a player with name `n' playing on board `b'.
		require
			board_exists: b /= Void
		do
			name := ("Player " + n.out).twin
			number := n
			color := n * 16
			board := b
			position := b.squares.lower
			board.set_position (Current)
			create properties.make (1, board.square_count)
		ensure
			name_set: name ~ ("Player " + n.out)
			board_set: board = b
			at_start: position = b.squares.lower
		end

feature  -- Access
	name: STRING
			-- Player name.

	number: INTEGER
			-- Player ID.

	color: INTEGER

	board: BOARD
			-- Board on which the player is playing.			

	old_position: INTEGER

	position: INTEGER
			-- Current position on the board.

	money: INTEGER
			-- Amount of money.

	properties: V_ARRAY [PROPERTY_SQUARE]
			-- Array of Squares a player owns

	properties_num: INTEGER

feature -- Moving
	move (n: INTEGER)
			-- Advance `n' positions on the board.
		do
			old_position := position
			position := position + n
			from
			until
				position <= board.square_count
			loop
				position := position - board.square_count
			end
			board.set_position (Current)
			board.squares [position].affect (Current)
		end

feature -- Money
	transfer (amount: INTEGER)
			-- Add `amount' to `money'.
		do
			money := (money + amount).max (0)
		ensure
			money_set: money = (old money + amount).max (0)
		end

	go_bankrupt
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > properties_num
			loop
				board.un_highlight_property (properties [i])
				properties [i].unown
				i := i + 1
			end
		end

	buy (square: PROPERTY_SQUARE)
		local
			pos: POSITION
		do
			properties_num := properties_num + 1
			properties.put (square, properties_num)
			transfer (-square.price)
			pos := board.get_draw_pos (square)
			pos.affect_i (1)
			board.draw_at_pos (pos, " CHF " + square.rent.out)
			board.highlight_property (square)
		end

feature -- Basic operations
	play (d1, d2: DIE)
			-- Play a turn with dice `d1', `d2'.
		require
			dice_exist: d1 /= Void and d2 /= Void
		do
			d1.roll
			d2.roll
			board.squares [position].move (Current, d1.face_value, d2.face_value)
			if money = 0 then
				go_bankrupt
			end
		end

feature -- jail
	jail_rounds: INTEGER
			-- Number of rounds, where Player will be in jail
	go_jail
		do
			jail_rounds := 3
		end

	did_jail_round
		do
			jail_rounds := jail_rounds - 1
		end

	exit_jail
		do
			jail_rounds := 0
		end

invariant
	name_exists: name /= Void and then not name.is_empty
	board_exists: board /= Void
	position_valid: position >= board.squares.lower -- Token can go beyond the finish position, but not the start
	money_non_negative: money >= 0
end
