--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_077b9d37 = require("@lib/event/helper_077b9d37")
local helper_16df0044 = require("@lib/event/helper_16df0044")
local helper_bb7b691a = require("@lib/event/helper_bb7b691a")
local helper_ebc0255b = require("@lib/event/helper_ebc0255b")

--- Helper function.
local function helper_7bd8f811(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_bb7b691a(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 18) or var2
	if var2 == 0 then
		helper_ebc0255b(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_16df0044(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_077b9d37(arg0, arg1)
		return
	end
end

return helper_7bd8f811
