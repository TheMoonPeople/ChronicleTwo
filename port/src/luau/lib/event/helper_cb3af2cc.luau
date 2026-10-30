--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1f0d9c71 = require("@lib/event/helper_1f0d9c71")
local helper_2d25d662 = require("@lib/event/helper_2d25d662")
local helper_64925685 = require("@lib/event/helper_64925685")
local helper_7634be2d = require("@lib/event/helper_7634be2d")
local helper_c246a337 = require("@lib/event/helper_c246a337")

--- Helper function.
local function helper_cb3af2cc(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_64925685(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_7634be2d(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 8) or var3
	if var3 == 0 then
		helper_2d25d662(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_1f0d9c71(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_c246a337(arg0, arg1)
		return
	end
end

return helper_cb3af2cc
