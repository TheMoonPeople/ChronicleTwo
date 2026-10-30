--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_103c2a4c = require("@lib/event/helper_103c2a4c")
local helper_a45cddd4 = require("@lib/event/helper_a45cddd4")
local helper_ee2900aa = require("@lib/event/helper_ee2900aa")
local helper_f553ae31 = require("@lib/event/helper_f553ae31")

--- Helper function.
local function helper_ce97bad2(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_ee2900aa(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 14) or var2
	if var2 == 0 then
		helper_103c2a4c(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_a45cddd4(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f553ae31(arg0, arg1)
		return
	end
end

return helper_ce97bad2
