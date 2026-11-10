--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")

--- Helper function.
local function helper_1c113c0e(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"やぁ、ユリス。\n悪いが今は\n手が離せない。<page>町の安全のための\nとても重要な資料を\nまとめている所でね。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "急ぎの用事でなければ、\n明日にしてもらえないか。")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
end

return helper_1c113c0e
