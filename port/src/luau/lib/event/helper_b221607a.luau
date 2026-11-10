--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_057c9d8b = require("@lib/event/helper_057c9d8b")
local helper_3b5f4472 = require("@lib/event/helper_3b5f4472")
local helper_46eb977e = require("@lib/event/helper_46eb977e")
local helper_bfbd4901 = require("@lib/event/helper_bfbd4901")
local helper_bfd1104b = require("@lib/event/helper_bfd1104b")

--- Helper function.
local function helper_b221607a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_bfd1104b(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_46eb977e(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 3) or var3
	if var3 == 0 then
		helper_bfbd4901(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_057c9d8b(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_3b5f4472(arg0, arg1)
		return
	end
end

return helper_b221607a
