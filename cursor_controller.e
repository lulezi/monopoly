class
	CURSOR_CONTROLLER

feature -- access

	mcc (a_row, a_col: INTEGER)
		do
			move_console_cursor (a_row, a_col)
		end

	scc (a_fg, a_bg: INTEGER)
		do
			set_console_color (a_fg, a_bg)
		end

feature -- windows

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

feature -- unix

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
