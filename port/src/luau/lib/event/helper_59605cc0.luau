--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_445112f6 = require("@lib/event/helper_445112f6")
local helper_e9a5633a = require("@lib/event/helper_e9a5633a")
local helper_ebe78895 = require("@lib/event/helper_ebe78895")
local helper_ff9b8cca = require("@lib/event/helper_ff9b8cca")

--- Helper function.
local function helper_59605cc0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_445112f6(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 4) or var2
	if var2 == 0 then
		helper_ebe78895(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_e9a5633a(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_ff9b8cca(arg0, arg1)
		return
	end
end

return helper_59605cc0
