--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")

--- Helper function.
local function helper_ceef7029(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	var2 = event.get_save_counter(11) or var2
	if var2 < 1 then
		event.open_message_window_2(0, "あはっ、見つかっちゃった！<page>じゃ、次はどうかしら？")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		event.set_save_counter(11, var2 + 1)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.set_villager_ai_enabled(1, arg0)
		event.set_character_active(0, arg0)
		event.delete_villager(arg0)
		event.fade_in_screen(30)
		return
	end
	event.open_message_window_2(
		0,
		"あぁ、\n見つかっちゃった・・・<page>ふぅ、なんだか\nあきて来ちゃった。<page>なんか、かくれてるのって\n意外とつまんないものね。<page>いいわ、そろそろ冒険に\n出発しましょう！"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 18, 1)
end

return helper_ceef7029
