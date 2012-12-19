class
	STATS

-- tester class to prove probability

inherit
	CURSOR_CONTROLLER

create
	make

feature

	make
			-- Launch the application.
		local
			p1, p2, p3: INTEGER
			games: V_ARRAY [GAME]
		do

			create games.make (1, 100)

			across
				games as g
			loop
				g.put (create {GAME}.make(3))
				g.item.play
				if g.item.winner.number = 1 then
					p1 := p1 + 1
				elseif g.item.winner.number = 2 then
					p2 := p2 + 1
				elseif g.item.winner.number = 3 then
					p3 := p3 + 1
				end
			end

		end

end
