--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")

--- Helper function.
local function helper_ab39c9ae(arg0: s32, arg1: any, arg2: s32)
	local var3: s32 = 0
	event.apply_message_window_preset(0, 0)
	var3 = event.get_chapter() or var3
	if arg2 ~= 0 and var3 == 8 then
		event.open_message_window_2(0, "これから先も、永久に世界が\n平和でありますように。")
	else
		event.open_message_window_2(0, "正しき事を成そうとするなら、\n賢くあらねばなりません。")
	end
	helper_1c04a0eb(arg0, -1, 0, 0)
end

return helper_ab39c9ae
