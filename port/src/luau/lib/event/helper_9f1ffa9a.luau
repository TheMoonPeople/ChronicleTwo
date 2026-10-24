--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_32c40e53 = require("@lib/event/helper_32c40e53")
local helper_46a3db16 = require("@lib/event/helper_46a3db16")
local helper_89fadc79 = require("@lib/event/helper_89fadc79")
local helper_a11de235 = require("@lib/event/helper_a11de235")

--- Helper function.
local function helper_9f1ffa9a(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_46a3db16(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_32c40e53(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_89fadc79(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_a11de235(arg0, arg1)
		return
	end
end

return helper_9f1ffa9a
