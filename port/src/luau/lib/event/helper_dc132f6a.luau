--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_92c146f3 = require("@lib/event/helper_92c146f3")
local helper_9ad6e9c5 = require("@lib/event/helper_9ad6e9c5")
local helper_a6c058cd = require("@lib/event/helper_a6c058cd")
local helper_a9f78d6f = require("@lib/event/helper_a9f78d6f")
local helper_ff18adf3 = require("@lib/event/helper_ff18adf3")

--- Helper function.
local function helper_dc132f6a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		helper_9ad6e9c5(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_a9f78d6f(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 10) or var3
	if var3 == 0 then
		helper_92c146f3(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_ff18adf3(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_a6c058cd(arg0, arg1)
		return
	end
end

return helper_dc132f6a
