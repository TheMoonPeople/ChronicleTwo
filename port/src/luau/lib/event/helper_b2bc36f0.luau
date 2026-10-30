--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_145e17fe = require("@lib/event/helper_145e17fe")
local helper_202d127e = require("@lib/event/helper_202d127e")
local helper_4378afab = require("@lib/event/helper_4378afab")
local helper_d3bd201f = require("@lib/event/helper_d3bd201f")

--- Helper function.
local function helper_b2bc36f0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_4378afab(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 15) or var2
	if var2 == 0 then
		helper_202d127e(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_145e17fe(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_d3bd201f(arg0, arg1)
		return
	end
end

return helper_b2bc36f0
