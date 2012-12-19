class CONSOLE_BUFFER

feature {ANY} -- Console commands
        clear
                        -- Clear console screen.
                do
                        io.put_string("%/27/[2J%/27/[1;1H")
                end

        set_xy (x, y: INTEGER)
                        -- Set cursor position to row x and column y.
                do
                        io.put_string("%/27/[" + x.out + ";" + y.out + "H")
                end

        put_string_xy (x, y: INTEGER; s: STRING)
                        -- Print s starting at position x, y.
                do
                        set_xy(x, y)
                        io.put_string(s)
                end

        set_color (foreground, background: INTEGER)
                        -- Set foreground and background color of what's
                        -- going to be written.
                        -- This might not work on some consoles.
                        -- If you inherit this class, you can use this feature
                        -- as in the following example:
                        -- set_color (red, green)
                require
                        foreground_between_0_and_7: foreground >= 0 and foreground <= 7
                        background_between_0_and_7: background >= 0 and background <= 7
                do
                        io.put_string("%/27/[3" + foreground.out + ";4" + background.out + "m")
                end

feature {ANY} -- Colors
        black: INTEGER = 0

        red: INTEGER = 1

        green: INTEGER = 2

        yellow: INTEGER = 3

        blue: INTEGER = 4

        magenta: INTEGER = 5

        cyan: INTEGER = 6

        white: INTEGER = 7

end
