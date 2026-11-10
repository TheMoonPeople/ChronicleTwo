-- ID_OFFSET ignores the extra value: the first one (40) sets the next identifier.
return {
	{ command = 1, args = { { type = "int", value = 40 }, { type = "int", value = 99 } } },
	{ command = 0, args = { { type = "int", value = 17 } } },
	{ command = 0, args = { { type = "int", value = 18 } } },
}
