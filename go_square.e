class
	GO_SQUARE

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
			p.transfer (200)
		end

end
