--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_3e047f1d = require("@lib/event/helper_3e047f1d")
local helper_8416a229 = require("@lib/event/helper_8416a229")
local helper_a33b9317 = require("@lib/event/helper_a33b9317")
local helper_abcbb646 = require("@lib/event/helper_abcbb646")
local helper_e21914a3 = require("@lib/event/helper_e21914a3")

--- Helper function.
local function helper_13bc3e74(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_abcbb646(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_8416a229(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 3) or var3
	if var3 == 0 then
		helper_e21914a3(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_3e047f1d(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_a33b9317(arg0, arg1)
		return
	end
end

return helper_13bc3e74
