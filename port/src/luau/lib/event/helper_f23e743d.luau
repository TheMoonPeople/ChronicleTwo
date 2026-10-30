--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")

--- Helper function.
local function helper_f23e743d(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(0, "僕のこの能力、えんりょなく\n存分に使ってくれ。")
	else
		event.open_message_window_2(0, "絵の世界は本当に奥が深い。\n未だ極めることができない・・・")
	end
	helper_1c04a0eb(arg0, -1, 0, 0)
end

return helper_f23e743d
