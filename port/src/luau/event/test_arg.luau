--!strict
--- Test data placing characters along a row and starting a walking motion.
return {
	{
		command = 0,
		args = {
			{ type = "int", value = 0 },
			{ type = "float", value = 50.0 },
			{ type = "float", value = 104.2 },
			{ type = "float", value = 0.0 },
		},
	},
	{
		command = 0,
		args = {
			{ type = "int", value = 0 },
			{ type = "float", value = 60.0 },
			{ type = "float", value = 104.2 },
			{ type = "float", value = 0.0 },
		},
	},
	{
		command = 0,
		args = {
			{ type = "int", value = 0 },
			{ type = "float", value = 70.0 },
			{ type = "float", value = 104.2 },
			{ type = "float", value = 0.0 },
		},
	},
	{
		command = 0,
		args = {
			{ type = "int", value = 0 },
			{ type = "float", value = 80.0 },
			{ type = "float", value = 104.2 },
			{ type = "float", value = 0.0 },
		},
	},
	{ command = 1, args = { { type = "int", value = 100 } } },
	{
		command = 0,
		args = { { type = "int", value = 0 }, { type = "string", value = "歩き" }, { type = "int", value = 2 } },
	},
}
