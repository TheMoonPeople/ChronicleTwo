--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_86fb1987 = require("@lib/event/helper_86fb1987")
local helper_97d6e749 = require("@lib/event/helper_97d6e749")
local helper_984193be = require("@lib/event/helper_984193be")
local helper_ce8eaf07 = require("@lib/event/helper_ce8eaf07")

--- Helper function.
local function helper_25a2bce4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	flag = event.get_save_flag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_97d6e749(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 16) or var2
	if var2 == 0 then
		helper_984193be(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_86fb1987(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_ce8eaf07(arg0, arg1)
		return
	end
end

return helper_25a2bce4
