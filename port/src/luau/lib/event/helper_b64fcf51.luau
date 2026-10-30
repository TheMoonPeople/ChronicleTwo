--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_1927bb5a = require("@lib/event/helper_1927bb5a")
local helper_5c290992 = require("@lib/event/helper_5c290992")
local helper_736fa717 = require("@lib/event/helper_736fa717")
local helper_cb592060 = require("@lib/event/helper_cb592060")
local helper_cfdd3041 = require("@lib/event/helper_cfdd3041")
local helper_de8c8659 = require("@lib/event/helper_de8c8659")
local helper_f77fd3b8 = require("@lib/event/helper_f77fd3b8")

--- Helper function.
local function helper_b64fcf51(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_de8c8659(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_f77fd3b8(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 7) or var3
	if var3 == 0 then
		helper_1927bb5a(arg0, arg1)
		return
	end
	if var3 == 1 then
		var4 = event.get_save_counter(8) or var4
		if var4 == 0 then
			helper_cb592060(arg0, arg1)
		end
		if var4 == 1 then
			helper_736fa717(arg0, arg1)
		end
		if var4 == 2 then
			helper_5c290992(arg0, arg1)
		end
		return
	end
	if var3 == 2 then
		helper_cfdd3041(arg0, arg1)
		return
	end
end

return helper_b64fcf51
