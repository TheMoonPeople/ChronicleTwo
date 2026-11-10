--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_6b2c781b = require("@lib/event/helper_6b2c781b")

--- Helper function.
local function helper_9e1e3514(arg0: s32)
	local var1: s32 = 0
	local flag: s32 = 0
	var1 = 0
	flag = event.get_save_flag(520) or flag
	if flag == 0 then
		event.run_georama_command(3, var1) -- retail: argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	end
	helper_6b2c781b(arg0, var1)
end

return helper_9e1e3514
