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
		do
			if owner = Void and p.money >= price then
				p.board.draw_center_text (p.name + ": You wanna buy " + name + " for CHF " + price.out + "?")
				if p.board.read_answer (p) then
					owner := p
					p.buy (Current)
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

	unown
		do
			owner := Void
		end

	rent: INTEGER

end
