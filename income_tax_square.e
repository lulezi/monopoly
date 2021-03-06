class
	INCOME_TAX_SQUARE

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
			p.transfer (-((p.money * .01).floor) * 10)
			p.board.draw_center_text (p.name + " had to pay CHF " + (((p.money * .01).floor) * 10).out + " of income taxes")
		end

end
