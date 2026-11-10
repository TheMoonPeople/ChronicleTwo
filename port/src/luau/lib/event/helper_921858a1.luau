--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")

--- Helper function.
local function helper_921858a1(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		event.apply_message_window_preset(0, 0)
		helper_4e93f9fc(arg0, 0, 0)
		event.open_message_window_2(0, "やぁ、こんにちは。<page>君は、確かモニカと\n言ったね。")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "僕はパトリ。\n魔法絵師をしているんだ。")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"やぁ、ユリス、\nこんにちは。<page>いつも元気そうで\nうらやましいよ。"
	)
	helper_1c04a0eb(arg0, -1, 0, 0)
end

return helper_921858a1
