--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_9d86098c = require("@lib/event/helper_9d86098c")

--- Helper function.
local function helper_a960121a()
	local flag: s32 = 0
	local var1: s32 = 0
	if helper_9d86098c() == 0 then
		return 0
	end
	flag = event.GetFlag(368) or flag
	if flag ~= 0 then
		return 0
	end
	var1 = event.CheckEnableCharaChange(1) or var1
	if var1 == 0 then
		return 0
	end
	return 1
end

return helper_a960121a
