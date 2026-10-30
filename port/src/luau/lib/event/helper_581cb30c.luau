--!strict
-- Shared event helper used by 301 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_581cb30c(button: s32)
	local var1: s32 = 0
	var1 = event.get_pad_button_state(button) or var1
	return var1
end

return helper_581cb30c
