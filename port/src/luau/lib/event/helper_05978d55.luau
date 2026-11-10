--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_05978d55(arg0: s32, arg1: s32)
	local flag: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	flag = event.get_save_flag(41) or flag
	if flag == 0 then
		event.open_message_window_2(0, "Un pesce rispecchia il padrone.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Non parler[UNI00f2] mai col padrone \ndi un pesce tanto imbranato!")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Stavo guardando, sai.\n[UNI00c8] stata una bella corsa.<page>Non avrei mai potuto allevare\nun pesce simile!<page>Ti prego, portami con te.\nTi prego, insegnami quel che sai!"
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 16, 1)
end

return helper_05978d55
