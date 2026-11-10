--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")

--- Helper function.
local function helper_f77fd3b8(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"今はこうしてメイドをして\nますけど、洋服屋さんに\nなるのが小さい頃の夢でした。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "夢は実現しないから\n夢って言うんですよね。")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
end

return helper_f77fd3b8
