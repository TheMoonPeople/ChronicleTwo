--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0c3ae00b = require("@lib/event/helper_0c3ae00b")
local helper_2af6cedf = require("@lib/event/helper_2af6cedf")
local helper_e53729e0 = require("@lib/event/helper_e53729e0")
local helper_f825d912 = require("@lib/event/helper_f825d912")

--- Helper function.
local function helper_009e0d5d(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_2af6cedf(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 19) or var2
	if var2 == 0 then
		helper_f825d912(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_e53729e0(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_0c3ae00b(arg0, arg1)
		return
	end
end

return helper_009e0d5d
