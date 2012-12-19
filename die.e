class
	DIE

create
	roll

feature -- Access

	Face_count: INTEGER = 4
			-- Number of faces.

	face_value: INTEGER
			-- Latest value.

feature -- Basic operations

	roll
			-- Roll die.
		do
			random.forth
			face_value := random.bounded_item (1, Face_count)
		end

feature {NONE} -- Implementation

	random: V_RANDOM
			-- Random sequence.
		once
			create Result
		end

invariant
	face_value_valid: face_value >= 1 and face_value <= Face_count
end
