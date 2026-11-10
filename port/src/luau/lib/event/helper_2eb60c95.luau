--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")

--- Helper function.
local function helper_2eb60c95(arg0: s32, arg1: s32)
	local flag: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	flag = event.get_save_flag(41) or flag
	if flag == 0 then
		event.open_message_window_2(0, "魚は飼い主に似ると言います。")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "あんな弱っちい魚の飼い主と\n話す事なんて、ありません。")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"こっそり見てましたよ。\nすばらしいレースでしたね。<page>あそこまで魚を育て上げるなんて、\n私には出来そうもありません。<page>いっしょに連れて行ってください。\nそして、勉強させてください。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 16, 1)
end

return helper_2eb60c95
