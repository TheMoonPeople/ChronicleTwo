--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_1e66d9e5 = require("@lib/event/helper_1e66d9e5")
local helper_23b5085f = require("@lib/event/helper_23b5085f")
local helper_3e2462cb = require("@lib/event/helper_3e2462cb")
local helper_de14f188 = require("@lib/event/helper_de14f188")

--- Helper function.
local function helper_f2c96414(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_de14f188(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 1) or var2
	if var2 == 0 then
		helper_1e66d9e5(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_3e2462cb(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_23b5085f(arg0, arg1)
		return
	end
end

return helper_f2c96414
