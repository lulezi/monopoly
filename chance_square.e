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
		local
			amount: INTEGER
		do
			random.forth
			amount := random.bounded_item (-30, 20)*10
			p.transfer (amount)
			if amount > 0 then
				p.board.draw_center_text (p.name + " won CHF " + amount.out + " in the lottery")
			else
				p.board.draw_center_text (p.name + " had to pay CHF " + (-amount).out + " of lottery taxes")
			end

		end

feature -- Output
	random: V_RANDOM
			-- Random sequence.
		once
			create Result
		end

end
