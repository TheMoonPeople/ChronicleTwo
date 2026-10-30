--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_448af381 = require("@lib/event/helper_448af381")
local helper_674d4ca5 = require("@lib/event/helper_674d4ca5")
local helper_c6a773ba = require("@lib/event/helper_c6a773ba")
local helper_f0c54bb2 = require("@lib/event/helper_f0c54bb2")

--- Helper function.
local function helper_3b5ab347(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_448af381(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 18) or var2
	if var2 == 0 then
		helper_c6a773ba(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_674d4ca5(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f0c54bb2(arg0, arg1)
		return
	end
end

return helper_3b5ab347
