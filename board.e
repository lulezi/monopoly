class
	BOARD

inherit
	ANY
		redefine
			out
		end

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

	brackets: POSITION
	  -- current position of brackets

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
	out: STRING
		do
			Result := ""
			across
				output as output_row
			loop
				across
					output_row.item as output_col
				loop
					Result := Result + output_col.item
				end
				Result := Result + "%N"
			end
			clear_center_text
		end

	output: V_ARRAY [V_ARRAY [STRING]]

	draw_lines
		local
			i, j: INTEGER
		do
			create output.make (1, char_rows)

			i := 0
			from
				i := 1
			until
				i > char_rows
			loop
				output.put (create {V_ARRAY [STRING]}.make (1, char_cols), i)
				from
					j := 1
				until
					j > char_cols
				loop
					if i <= square_h or i > char_rows - square_h or j <= square_w or j > char_cols - square_w then
						if (i - 1) \\ (square_h - 1) = 0 and (j - 1) \\ (square_w - 1) = 0 then
							output.at (i).item.at (j).put ("+")
						elseif (i - 1) \\ (square_h - 1) = 0 then
							output.at (i).item.at (j).put ("-")
						elseif (j - 1) \\ (square_w - 1) = 0 then
							output.at (i).item.at (j).put ("|")
						else
							output.at (i).item.at (j).put (" ")
						end
					else
						output.at (i).item.at (j).put (" ")
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
		local
			p: INTEGER
		do
			from
				p := 1
			until
				p > s.count
			loop
				output.at (pos.i).item.at (pos.j+p-1).put (s.at (p).out)
				p := p + 1
			end

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
			pos: POSITION
			len: INTEGER
			s: STRING
		do
			len := char_cols - (2 * (square_w + 2))
			create s.make_from_string (" ")
			s.multiply (len * 4)
			draw_center_text (s)
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

	set_position (p_id, old_p, new_p: INTEGER)
		local
			i, j, x: INTEGER
			pos: POSITION
		do
			x := p_id
			from
			until
				x >= 1 and x <= 3
			loop
				x := x - 3
			end

			if old_p /= 0 then
				pos := get_draw_pos (old_p)
				i := pos.i + (((p_id - 1) // 3) + 2)
				j := pos.j + 3 * x - 2
				output.at (i).item.at (j).put (" ")
			end

			pos := get_draw_pos (new_p)
			i := pos.i + (((p_id - 1) // 3) + 2)
			j := pos.j + 3 * x - 2

			output.at (i).item.at (j).put (p_id.out)

			set_brackets (create {POSITION}.make(i, j))

		end

	set_brackets (new_brackets: POSITION)
		do
			if brackets /= Void then
				output.at (brackets.i).item.at (brackets.j-1).put (" ")
				output.at (brackets.i).item.at (brackets.j+1).put (" ")
			end

			output.at (new_brackets.i).item.at (new_brackets.j-1).put ("[")
			output.at (new_brackets.i).item.at (new_brackets.j+1).put ("]")

			brackets := new_brackets
		end

feature  -- user interaction
	read_answer: CHARACTER
		do
			print (out)
			print ("%N")
			io.read_character
			Result := io.last_character
		end


--invariant
--	squares_exists: squares /= Void
--	squares_count_valid: squares.count = Square_count
end
