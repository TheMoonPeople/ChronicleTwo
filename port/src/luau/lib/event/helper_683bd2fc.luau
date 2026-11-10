--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_6050d30e = require("@lib/event/helper_6050d30e")

--- Helper function.
local function helper_683bd2fc()
	local var0: s32 = 0
	var0 = event.get_save_counter(3) or var0
	if var0 < 7 then
		helper_6050d30e(1)
	else
		helper_6050d30e(0)
	end
end

return helper_683bd2fc
