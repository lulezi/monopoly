class
	CHANCE_SQUARE

inherit
	SQUARE
		redefine
			affect
		end

create
	make

feature -- Basic operations

	affect (p: PLAYER)
			-- Apply square's special effect to `p'.
		do
			random.forth
			p.transfer (random.bounded_item (-30, 20)*10)
		end

feature -- Output
	random: V_RANDOM
			-- Random sequence.
		once
			create Result
		end

end
