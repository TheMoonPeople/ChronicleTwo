--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_31a4b30e = require("@lib/event/helper_31a4b30e")
local helper_44cb1232 = require("@lib/event/helper_44cb1232")
local helper_7d3646f0 = require("@lib/event/helper_7d3646f0")
local helper_ab436480 = require("@lib/event/helper_ab436480")
local helper_b10b8f3d = require("@lib/event/helper_b10b8f3d")

--- Helper function.
local function helper_b0e03639(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_7d3646f0(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_b10b8f3d(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 11) or var3
	if var3 == 0 then
		helper_31a4b30e(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_ab436480(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_44cb1232(arg0, arg1)
		return
	end
end

return helper_b0e03639
