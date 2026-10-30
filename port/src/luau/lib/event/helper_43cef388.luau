--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_a0d546a7 = require("@lib/event/helper_a0d546a7")

--- Helper function.
local function helper_43cef388()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.get_save_flag(250) or flag
	flag_2 = event.get_save_flag(247) or flag_2
	if flag == 0 and flag_2 == 0 then
		helper_a0d546a7()
	end
end

return helper_43cef388
