--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_26da5ab1 = require("@lib/event/helper_26da5ab1")
local helper_4524c68a = require("@lib/event/helper_4524c68a")
local helper_90b678d2 = require("@lib/event/helper_90b678d2")
local helper_d0c0b6aa = require("@lib/event/helper_d0c0b6aa")

--- Helper function.
local function helper_9959bbdb(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_4524c68a(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 12) or var2
	if var2 == 0 then
		helper_26da5ab1(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_d0c0b6aa(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_90b678d2(arg0, arg1)
		return
	end
end

return helper_9959bbdb
