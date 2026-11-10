--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_00fbd5eb = require("@lib/event/helper_00fbd5eb")
local helper_65be25dc = require("@lib/event/helper_65be25dc")
local helper_73301bcd = require("@lib/event/helper_73301bcd")
local helper_de0d272c = require("@lib/event/helper_de0d272c")

--- Helper function.
local function helper_674eb7db(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(314) or flag
	if flag == 0 then
		helper_65be25dc(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 17) or var3
	if var3 == 0 then
		helper_de0d272c(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_73301bcd(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_00fbd5eb(arg0, arg1)
		return
	end
end

return helper_674eb7db
