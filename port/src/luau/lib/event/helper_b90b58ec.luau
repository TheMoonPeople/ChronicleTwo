--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_4a43bcc7 = require("@lib/event/helper_4a43bcc7")
local helper_a143170f = require("@lib/event/helper_a143170f")
local helper_e117a469 = require("@lib/event/helper_e117a469")
local helper_f06e16d8 = require("@lib/event/helper_f06e16d8")

--- Helper function.
local function helper_b90b58ec(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_a143170f(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 2) or var2
	if var2 == 0 then
		helper_e117a469(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_4a43bcc7(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f06e16d8(arg0, arg1)
		return
	end
end

return helper_b90b58ec
