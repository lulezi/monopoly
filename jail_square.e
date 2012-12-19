class
	JAIL_SQUARE

inherit
	SQUARE
		redefine
			affect,
			move
		end

create
	make

feature -- Basic operations

	affect (p: PLAYER)
			-- Apply square's special effect to `p'.
		do
			if p.position = 16 then
				p.move (-10)
				p.go_jail
			end
			p.transfer (200)
		end

	move (p: PLAYER; d1_value, d2_value: INTEGER)
		local
			ans: CHARACTER
		do
			if p.jail_rounds > 0 then
				if p.jail_rounds = 3 and d1_value /= d2_value then
					p.transfer (-50)
					p.exit_jail
					p.move (d1_value + d2_value)
				elseif p.jail_rounds >= 1 and p.jail_rounds <= 2 then
					p.board.draw_center_text (p.name + " in jail: You wanna pay CHF 50 to get out? (Y/n)")
					print (p.board.out)
					ans := p.board.read_answer
					if ans = 'n' or ans = 'N' then
						if d1_value = d2_value then
							p.exit_jail
							p.move (d1_value + d2_value)
						end
					else
						p.transfer (-50)
						p.exit_jail
						p.move (d1_value + d2_value)
					end
				end
			else
				p.move (d1_value + d2_value)
			end
		end

end
