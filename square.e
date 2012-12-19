class
	SQUARE

inherit
	ANY

create
	make

feature
	make (a_name, s_name: STRING)
		do
			name := a_name
			short_name := s_name
		end

feature -- Basic operations

	affect (p: PLAYER)
			-- Apply square's special effect to `p'.
		require
			p_exists: p /= Void
		do

			-- For a normal square do nothing.
		end

	move (p: PLAYER; d1_value, d2_value: INTEGER)
		do
			p.move (d1_value + d2_value)
		end

feature -- Output

	price: INTEGER

	name: STRING

	short_name: STRING

end
