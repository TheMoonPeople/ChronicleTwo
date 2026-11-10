--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_047b31b3 = require("@lib/event/helper_047b31b3")
local helper_556bb47c = require("@lib/event/helper_556bb47c")
local helper_8b1c04f8 = require("@lib/event/helper_8b1c04f8")
local helper_b276e02f = require("@lib/event/helper_b276e02f")
local helper_c1fb4720 = require("@lib/event/helper_c1fb4720")

--- Helper function.
local function helper_7215de68(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		helper_556bb47c(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_8b1c04f8(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 10) or var3
	if var3 == 0 then
		helper_047b31b3(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_b276e02f(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_c1fb4720(arg0, arg1)
		return
	end
end

return helper_7215de68
