--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_2c20ac62 = require("@lib/event/helper_2c20ac62")
local helper_2f61e008 = require("@lib/event/helper_2f61e008")
local helper_6dd153ae = require("@lib/event/helper_6dd153ae")
local helper_c964ce0e = require("@lib/event/helper_c964ce0e")

--- Helper function.
local function helper_9ec16a27(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2f61e008(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_c964ce0e(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_6dd153ae(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_2c20ac62(arg0, arg1)
		return
	end
end

return helper_9ec16a27
