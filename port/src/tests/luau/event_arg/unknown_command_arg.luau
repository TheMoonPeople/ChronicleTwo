-- A command with no handler (7) between two lists does not stop the second list.
return {
	{ command = 0, args = { { type = "int", value = 1 } } },
	{ command = 7, args = { { type = "int", value = 2 } } },
	{ command = 0, args = { { type = "int", value = 3 } } },
}
