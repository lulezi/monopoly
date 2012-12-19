class
	PROPERTY_SQUARE

inherit
	SQUARE
		redefine
			affect
		end

create
	make_property

feature
	make_property (a_name, s_name: STRING; a_price, a_rent: INTEGER)
		do
			name := a_name
			short_name := s_name
			price := a_price
			rent := a_rent
		end

feature

	affect (p: PLAYER)
			-- Apply square's special effect to `p'.
		require else
			p_exists: p /= Void
		local
			s: STRING
			ans: CHARACTER
			pos: POSITION
		do
			if owner = Void and p.money >= price then
				p.board.draw_center_text (p.name + ": You wanna buy " + name + " for CHF " + price.out + "? (Y/n) ")
				ans := p.board.read_answer
				if ans /= 'n' and ans /= 'N' then -- anser is yes or default (Y)
					owner := p
					owner.transfer (-price)
					pos := p.board.get_draw_pos (p.position)
					pos.affect_i (1)
					p.board.draw_at_pos (pos, p.number.out + ": CHF " + rent.out)
				end
			elseif owner /= Void and owner.money > 0 then
				create s.make_from_string (p.name + " paid CHF ")
				if p.money >= rent then
					owner.transfer (rent)
					p.transfer (-rent)
					s.append (rent.out)
				else
					owner.transfer (p.money)
					p.transfer (-p.money)
					s.append (p.money.out)
				end
				s.append (" to " + owner.name)
				p.board.draw_center_text (s)
			end
		end

	owner: PLAYER

	rent: INTEGER

end
