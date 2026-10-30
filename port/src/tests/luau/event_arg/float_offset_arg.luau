-- A float offset is truncated to its integer part.
return {
	{ command = 1, args = { { type = "float", value = 12.75 } } },
	{ command = 0, args = { { type = "int", value = 3 } } },
}
