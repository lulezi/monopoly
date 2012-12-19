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
			board := b
			position := b.squares.lower
			board.set_position (n, 0, 1)
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

	board: BOARD
			-- Board on which the player is playing.			

	position: INTEGER
			-- Current position on the board.

	money: INTEGER
			-- Amount of money.

	properties: V_ARRAY [SQUARE]
			-- Array of Squares a player owns

feature -- Moving
	move (n: INTEGER)
			-- Advance `n' positions on the board.
		local
			old_pos: INTEGER
		do
			old_pos := position
			position := position + n
			from
			until
				position <= board.square_count
			loop
				position := position - board.square_count
			end
			board.set_position (number, old_pos, position)
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

feature -- Basic operations
	play (d1, d2: DIE)
			-- Play a turn with dice `d1', `d2'.
		require
			dice_exist: d1 /= Void and d2 /= Void
		do
			d1.roll
			d2.roll
			board.squares [position].move (Current, d1.face_value, d2.face_value)
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
