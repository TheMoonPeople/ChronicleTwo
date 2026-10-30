--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_1fc27623 = require("@lib/event/helper_1fc27623")
local helper_3c03bb6f = require("@lib/event/helper_3c03bb6f")
local helper_5ad770bd = require("@lib/event/helper_5ad770bd")
local helper_aee6e67b = require("@lib/event/helper_aee6e67b")

--- Helper function.
local function helper_207da968(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_3c03bb6f(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 14) or var2
	if var2 == 0 then
		helper_aee6e67b(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_5ad770bd(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_1fc27623(arg0, arg1)
		return
	end
end

return helper_207da968
