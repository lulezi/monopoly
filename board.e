class
	BOARD

inherit
	ANY

create
	make

feature {NONE} -- Initialization
	make
			-- Initialize squares.
		do

			draw_lines

			create squares.make (1, Square_count)

			squares [2]  := create {PROPERTY_SQUARE}.make_property ("Dübendorfstrasse", "DUBENDORF", 60, 2)
			squares [3]  := create {PROPERTY_SQUARE}.make_property ("Winterthurerstrasse", "WINTERT.", 60, 4)
			squares [5]  := create {PROPERTY_SQUARE}.make_property ("Schwamendingerplatz", "SCHWAMEND", 80, 4)
			squares [7]  := create {PROPERTY_SQUARE}.make_property ("Josefwiese", "JOSEFWIES", 100, 6)
			squares [8]  := create {PROPERTY_SQUARE}.make_property ("Escher-Wyss-Platz", "E.-W.-PL.", 120, 8)
			squares [10] := create {PROPERTY_SQUARE}.make_property ("Langstrasse", "LANGSTR.", 160, 12)
			squares [12] := create {PROPERTY_SQUARE}.make_property ("Schaffhauserplatz", "SCHAFFH.", 220, 18)
			squares [14] := create {PROPERTY_SQUARE}.make_property ("Universitätsstrasse", "UNI.STR.", 260, 22)
			squares [15] := create {PROPERTY_SQUARE}.make_property ("Irchelpark", "IRCHELP.", 260, 22)
			squares [17] := create {PROPERTY_SQUARE}.make_property ("Bellevue", "BELLEVUE", 320, 28)
			squares [18] := create {PROPERTY_SQUARE}.make_property ("Niederdorf", "NIEDERD.", 350, 35)
			squares [20] := create {PROPERTY_SQUARE}.make_property ("Bahnhofstrasse", "BAHNHOF", 400, 50)

			squares [1]  := create {GO_SQUARE}.make ("GO!", "   GO!")

			squares [4]  := create {INCOME_TAX_SQUARE}.make ("Income Tax", "   TAX")

			squares [11] := create {SQUARE}.make ("parkin'", " PARKIN'")

			squares [6]  := create {JAIL_SQUARE}.make ("just visitin'", "  JAIL")
			squares [16] := create {JAIL_SQUARE}.make ("go to jail!", "GO JAIL!")

			squares [9]  := create {CHANCE_SQUARE}.make ("Chance", " CHANCE!")
			squares [13] := create {CHANCE_SQUARE}.make ("Chance", " CHANCE!")
			squares [19] := create {CHANCE_SQUARE}.make ("Chance", " CHANCE!")

			draw_square_names

		end

feature -- Access
	squares: V_ARRAY [SQUARE]
			-- Container for squares

feature -- Constants
	Square_count: INTEGER = 20
			-- Number of squares.

	square_w: INTEGER = 11

	square_h: INTEGER = 6

	center_text_pos: POSITION
		do
			create Result.make (square_h + 2, square_w + 3)
		end

	char_rows: INTEGER
		do
			Result := (Square_count // 4 + 1) * square_h - (Square_count // 4)
		end

	char_cols: INTEGER
		do
			Result := (Square_count // 4 + 1) * square_w - (Square_count // 4)
		end

feature -- Output
	draw_lines
		local
			i, j: INTEGER
		do
			i := 0
			from
				i := 1
			until
				i > char_rows
			loop
				from
					j := 1
				until
					j > char_cols
				loop
					if i <= square_h or i > char_rows - square_h or j <= square_w or j > char_cols - square_w then
						if (i - 1) \\ (square_h - 1) = 0 and (j - 1) \\ (square_w - 1) = 0 then
							mcc (i, j)
							io.put_string ("+")
						elseif (i - 1) \\ (square_h - 1) = 0 then
							mcc (i, j)
							io.put_string ("-")
						elseif (j - 1) \\ (square_w - 1) = 0 then
							mcc (i, j)
							io.put_string ("|")
						end
					end
					j := j + 1
				end
				i := i + 1
			end
		end

	get_draw_pos (square_id: INTEGER): POSITION
		local
			i, j: INTEGER
		do
			if square_id >= 1 and square_id <= (Square_count // 4) + 1 then
				i := 2
				j := 2 + ((square_id - 1) * (square_w - 1))
			elseif square_id > (Square_count // 4) + 1 and square_id < (Square_count // 2) + 1 then
				i := 2 + ((square_id - (Square_count // 4) - 1) * (square_h - 1))
				j := 2 + ((Square_count // 4) * (square_w - 1))
			elseif square_id >= (Square_count // 2) + 1 and square_id <= (3 * (Square_count // 4)) + 1 then
				i := 2 + ((Square_count // 4) * (square_h - 1))
				j := 2 + (((3 * (Square_count // 4)) + 1 - square_id) * (square_w - 1))
			else
				i := 2 + ((Square_count - square_id + 1) * (square_h - 1))
				j := 2
			end
			create Result.make(i, j)
		end

	draw_at_pos (pos: POSITION; s: STRING)
		require
			pos /= Void
		do
			mcc (pos.i, pos.j)
			io.put_string (s)
		end

	draw_square_names
		local
			i: INTEGER
			pos: POSITION
		do
			i := 1
			across
				squares as square
			loop
				pos := get_draw_pos (i)
				draw_at_pos (pos, square.item.short_name)
				if square.item.price /= 0 then
					pos.affect_i (1)
					draw_at_pos (pos, " CHF " + square.item.price.out)
				end
				i := i + 1
			end
		end

	draw_center_text (s: STRING)
		do
			clear_center_text
			draw_center_text_draw (s)
		end

	draw_center_text_draw (s: STRING)
		local
			pos: POSITION
			i, j, len: INTEGER
		do
			len := char_cols - (2 * (square_w + 2))
			pos := center_text_pos
			from
				i := 1
				j := len
			until
				i > s.count
			loop
				draw_at_pos (pos, s.substring (i, j.min (s.count)))
				pos.affect_i (1)
				i := j + 1
				j := j + len
			end
		end

	clear_center_text
		local
			len: INTEGER
			s: STRING
		do
			len := char_cols - (2 * (square_w + 2))
			create s.make_from_string (" ")
			s.multiply (len * 5)
			draw_center_text_draw (s)
		end

	sync_leaderboard (players: V_ARRAY [PLAYER])
		local
			pos: POSITION
			i: INTEGER
		do
			create pos.make ((char_rows - square_h - players.count), center_text_pos.j)
			across
				players as p
			loop
				draw_at_pos (pos, p.item.name + " CHF " + p.item.money.out + "          ")
				pos.affect_i (1)
			end
		end

feature  -- player positions

	set_position (p: PLAYER)
		local
			i, j, x: INTEGER
			pos: POSITION
		do
			x := p.number
			from
			until
				x >= 1 and x <= 3
			loop
				x := x - 3
			end

			if p.old_position /= 0 then
				pos := get_draw_pos (p.old_position)
				pos.affect_i (((p.number - 1) // 3) + 2)
				pos.affect_j (3 * x - 3)
				draw_at_pos (pos, "   ")
			end

			pos := get_draw_pos (p.position)
			pos.affect_i (((p.number - 1) // 3) + 2)
			pos.affect_j (3 * x - 3)
			scc (0, p.color)
			draw_at_pos (pos, "[" + p.number.out + "]")
			scc (7, 0)

		end

feature  -- user interaction
	read_answer: CHARACTER
		do
			print ("%N")
			io.read_character
			Result := io.last_character
		end

feature
	mcc (a_row, a_col: INTEGER)
		do
			cc.mcc (a_row, a_col)
		end

	scc (a_fg, a_bg: INTEGER)
		do
			cc.scc (a_fg, a_bg)
		end

	cc: CURSOR_CONTROLLER
		once
			create Result
		end

--invariant
--	squares_exists: squares /= Void
--	squares_count_valid: squares.count = Square_count
end
