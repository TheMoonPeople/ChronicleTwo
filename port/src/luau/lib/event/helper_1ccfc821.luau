--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1f773bdb = require("@lib/event/helper_1f773bdb")
local helper_c436556b = require("@lib/event/helper_c436556b")
local helper_ed8ded87 = require("@lib/event/helper_ed8ded87")
local helper_f526c22d = require("@lib/event/helper_f526c22d")

--- Helper function.
local function helper_1ccfc821(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_f526c22d(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 14) or var2
	if var2 == 0 then
		helper_ed8ded87(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_1f773bdb(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_c436556b(arg0, arg1)
		return
	end
end

return helper_1ccfc821
