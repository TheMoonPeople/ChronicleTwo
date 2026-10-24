--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_4598656e = require("@lib/event/helper_4598656e")
local helper_8de795ad = require("@lib/event/helper_8de795ad")
local helper_a4c91de4 = require("@lib/event/helper_a4c91de4")
local helper_bc4c5467 = require("@lib/event/helper_bc4c5467")

--- Helper function.
local function helper_19b3d3e2(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_a4c91de4(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_4598656e(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_bc4c5467(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_8de795ad(arg0, arg1)
		return
	end
end

return helper_19b3d3e2
