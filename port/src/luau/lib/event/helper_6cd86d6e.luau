--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_611ae120 = require("@lib/event/helper_611ae120")
local helper_83a127c8 = require("@lib/event/helper_83a127c8")
local helper_98e7f7b8 = require("@lib/event/helper_98e7f7b8")
local helper_a3848049 = require("@lib/event/helper_a3848049")

--- Helper function.
local function helper_6cd86d6e(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_98e7f7b8(arg0, arg1, 0)
		return
	end
	var2 = event.get_quest_request_status(0, 13) or var2
	if var2 == 0 then
		helper_83a127c8(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_a3848049(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_611ae120(arg0, arg1)
		return
	end
end

return helper_6cd86d6e
