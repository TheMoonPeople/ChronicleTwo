--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_c4acb821 = require("@lib/event/helper_c4acb821")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_ab52f372(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local photo: s32 = 0
	local photo_2: s32 = 0
	local photo_3: s32 = 0
	local photo_4: s32 = 0
	local photo_5: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_c4acb821(arg0, arg1)
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
			"Hast du eine ungew[UNI00f6]hnliche\nBlume fotografiert?<page>Ich kenne viele Blumen - wenn's\nnichts Besonderes ist,\ninteressiert es mich nicht."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Hast du eine seltene Blume\nfotografiert? Zeig her, zeig her!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Wow - wie toll! So sehen also\ndie Blumen dort drau[UNI00df]en aus.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Hmm ... Was soll ich machen?<page>Oh, na gut! Nimm mich mit!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 4, 1)
end

return helper_ab52f372
