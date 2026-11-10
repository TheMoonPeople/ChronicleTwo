--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_251c0be5 = require("@lib/event/helper_251c0be5")
local helper_3655639b = require("@lib/event/helper_3655639b")
local helper_777935d5 = require("@lib/event/helper_777935d5")
local helper_7c10c531 = require("@lib/event/helper_7c10c531")
local helper_e062d24d = require("@lib/event/helper_e062d24d")

--- Helper function.
local function helper_a8a46966(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_777935d5(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_3655639b(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 6) or var3
	if var3 == 0 then
		helper_e062d24d(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_7c10c531(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_251c0be5(arg0, arg1)
		return
	end
end

return helper_a8a46966
