class
	APPLICATION

create
	make

feature

	make
			-- Launch the application.
		local
			count: INTEGER
			game: GAME
			console: CONSOLE
			board: BOARD
		do

			set_console_color (9, 0)
			io.put_string ("It is ")
			set_console_color (1, 0)
			io.put_string ("not ")
			set_console_color (4, 0)
			io.put_string ("so easy to use ")
			set_console_color (3, 0)
			io.put_string ("ANSI codes!%N")

			move_console_cursor (10, 10)

			io.put_string ("noch besser")

			move_console_cursor (2, 2)
			io.read_line

--			from
--				count := {GAME}.Min_player_count - 1
--			until
--				{GAME}.Min_player_count <= count and count <= {GAME}.Max_player_count
--			loop
--				print ("Enter number of players between " + {GAME}.Min_player_count.out + " and " + {GAME}.Max_player_count.out + ": ")
--				io.read_integer
--				count := io.last_integer
--			end

--			create game.make (count)
--			game.play

--			if game.winners.count = 1 then
--				print ("%NAnd the winner is: " + game.winners [1].name)
--			else
--				print ("%NAnd the winners are: ")
--				across
--					game.winners as c
--				loop
--					print (c.item.name + " ")
--				end
--			end

			print ("%N*** Game Over ***")

		end

	move_console_cursor (a_row, a_col: INTEGER)
			--Move the cursor to the 'a_row' and 'a_col' position.
		external
			"C inline use <windows.h>"
		alias
			"[
				COORD coord;
				coord.X = $a_col;
				coord.Y = $a_row;
				SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), coord);
			]"
		end

	set_console_color (a_foreground, a_background: INTEGER)
			-- Set the color of the font and the color of the background.
		external
			"C inline use <windows.h>"
		alias
			"[
				WORD text_color = $a_foreground | $a_background | FOREGROUND_INTENSITY; // | BACKGROUND_INTENSITY;
				SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), text_color);
			]"
		end

	set_console_default_color
			-- Restore Windows defaults.
		external
			"C inline use <windows.h>"
		alias
			"[
				WORD text_color = FOREGROUND_BLUE | FOREGROUND_GREEN| FOREGROUND_RED;
				SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), text_color);
			]"
		end

--	esc_char: CHARACTER
--		do
--			Result := (27).to_character_8
--		end

--	move_console_cursor (a_row, a_col: INTEGER)
--			-- Move the cursor to the 'a_row' and 'a_col' position.
--		require
--			a_row >= 0
--			a_col >= 0
--		do
--			io.put_string (esc_char.out + "[" + a_row.out + ";" + a_col.out + "H")
--		end

--	set_console_color (a_color: INTEGER)
--			-- Set the color of the font.
--		require
--			a_color >= 0 and a_color <= 9 and a_color /= 8
--		do
--			io.put_string (esc_char.out + "[3" + a_color.out + "m")
--		end

end
