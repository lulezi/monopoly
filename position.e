class
	POSITION

create
	make

feature
	make (a_i, a_j: INTEGER)
		do
			i := a_i
			j := a_j
		end

	i: INTEGER

	j: INTEGER

	affect_i (a_i: INTEGER)
		do
			i := i + a_i
		end

	affect_j (a_j: INTEGER)
		do
			j := j + a_j
		end

end
