--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_5e28cd9d = require("@lib/event/helper_5e28cd9d")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")

--- Helper function.
local function helper_3bb5ecb5(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local photo: s32 = 0
	local photo_2: s32 = 0
	local photo_3: s32 = 0
	local photo_4: s32 = 0
	local photo_5: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_5e28cd9d(arg0, arg1)
		return
	end
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(arg0, 0, 0)
	photo = event.get_photo_count_of_subject(2009) or photo
	photo_2 = event.get_photo_count_of_subject(52, 3) or photo_2
	photo_3 = event.get_photo_count_of_subject(53, 3) or photo_3
	photo_4 = event.get_photo_count_of_subject(54, 3) or photo_4
	photo_5 = event.get_photo_count_of_subject(55, 3) or photo_5
	if vm.i32(vm.i32(vm.i32(vm.i32(photo + photo_2) + photo_3) + photo_4) + photo_5) <= 0 then
		event.open_message_window_2(
			0,
			"めずらしい花の写真は\n撮れたのかしら？<page>私もいろいろな花を\n知ってるから、ちょっとや\nそっとじゃおどろかないわよ。"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "めずらしい花の\n写真が撮れたの？\n見せて、見せて！")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"あはっ、すごい、すごい！！\n外にはこんなにすごい花が\n咲いてるのね。"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "う～ん、\nどうしよう・・・<page>いいわ、私も\n連れて行って！")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 4, 1)
end

return helper_3bb5ecb5
