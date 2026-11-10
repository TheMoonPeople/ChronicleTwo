--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0771a536 = require("@lib/event/helper_0771a536")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_744ed4fb(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local photo: s32 = 0
	local photo_2: s32 = 0
	local photo_3: s32 = 0
	local photo_4: s32 = 0
	local photo_5: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_0771a536(arg0, arg1)
		return
	end
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	photo = event.get_photo_count_of_subject(2009) or photo
	photo_2 = event.get_photo_count_of_subject(52, 3) or photo_2
	photo_3 = event.get_photo_count_of_subject(53, 3) or photo_3
	photo_4 = event.get_photo_count_of_subject(54, 3) or photo_4
	photo_5 = event.get_photo_count_of_subject(55, 3) or photo_5
	if vm.i32(vm.i32(vm.i32(vm.i32(photo + photo_2) + photo_3) + photo_4) + photo_5) <= 0 then
		event.open_message_window_2(
			0,
			"Hai fotografato un fiore insolito?<page>So tutto sui fiori... se non [UNI00e8]\ndavvero speciale non mi interessa!"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Hai fotografato un fiore insolito?\nVediamo, vediamo!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Wow! [UNI00c8] incredibile! Allora,\nsi trovano fiori cos[UNI00ec] l[UNI00e0] fuori!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Mmh... cosa dovrei fare?<page>Oh, va bene! Portatemi con voi!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 4, 1)
end

return helper_744ed4fb
