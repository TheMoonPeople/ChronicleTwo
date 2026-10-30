--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_186669aa = require("@lib/event/helper_186669aa")

--- Helper function.
local function helper_809643bd()
	local flag: s32 = 0
	flag = event.get_save_flag(37) or flag
	helper_186669aa(if flag == 0 then 1 else 0)
end

return helper_809643bd
