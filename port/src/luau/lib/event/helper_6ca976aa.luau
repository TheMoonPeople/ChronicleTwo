--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_6ca976aa(arg0: s32, arg1: s32)
	local var2: any = 0
	local var3: s32 = 0
	local var7: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	while true do
		event.open_message_window_2(0, "Une fois, je lui ai offert une\nbroche avec son signe astrologique.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"C'est Holly qui l'avait achet[UNI00e9]e\npour moi, mais je crois me souvenir\nque c'[UNI00e9]tait un animal [UNI00e0] 4 pattes..."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Quel genre de cadeaux\nd'anniversaire je lui offre ?<page>Humm... beaucoup de manteaux et\nd'[UNI00e9]charpes il me semble.<page>Je ne sais jamais quoi lui offrir.\nEt tous les ans, c'est pire."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Ah [UNI00e7]a ! Son anniversaire, c'est\ntoujours p[UNI00e9]nible. C'est un jour de\nramassage des d[UNI00e9]chets combustibles<page>et non-combustibles. C'est moi qui\nsort les poubelles chez nous."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Les d[UNI00e9]chets non-combustibles sont\nramass[UNI00e9]s les jours divisibles par 7<page>et les d[UNI00e9]chets combustibles, les\njours divisibles par 3."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Tu n'oublierais quand m[UNI00ea]me pas [UNI00e7]a,\nhein ?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.open_message_window_2(
			0,
			"J'ai compris ! Myst[UNI00e8]re r[UNI00e9]solu !\nLa combinaison est...<page>Je ne sais pas... Attends un peu."
		)
		var2 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
		if var2 == 0 then
			break
		else
			if var2 == -1 then
				event.finish_event()
				return
			end
			event.set_character_motion(arg0, "会話")
		end
	end
	event.set_menu_value(0, "Saisis le num[UNI00e9]ro du code secret.", "2112", 0)
	event.open_event_menu(5)
	vm.wait(9)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		var3 = out1 or var3
	end
	if var3 == -1 then
		event.finish_event()
		return
	end
	event.fade_out_screen(15)
	wait_frames(15)
	var7 = event.get_sound_id(2) or var7
	do
		local out1, out2, out3 = event.get_character_position(arg0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = event.get_character_rotation(arg0)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	event.set_character_position(arg0, -100.0, 0.0, -110.0)
	event.set_character_rotation(arg0, 0.0, 3.1415927, 0.0)
	event.set_character_motion(arg0, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.get_character_rotation(0)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	var20 = event.get_arc_tangent(-100.0 - var14, -110.0 - var16) or var20
	event.set_character_rotation(0, 0.0, var20, 0.0)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.set_camera_position(64.64, 46.9, 92.64)
	event.set_camera_look_at(-100.0, 20.0, -110.0)
	event.fade_in_screen(15)
	wait_frames(30)
	if var3 == 0 then
		event.set_character_motion(arg0, "会話")
		event.open_message_window_2(
			0,
			"Humm, [UNI00e7]a s'ouvre pas. Oh la la...<page>Il y a des documents vraiment\nimportants l[UNI00e0]-dedans..."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.fade_out_screen(15)
		wait_frames(15)
		event.set_character_rotation(0, var17, var18, var19)
		event.set_character_position(arg0, var8, var9, var10)
		event.set_character_rotation(arg0, var11, var12, var13)
		event.set_camera_position(pos_x, pos_y, pos_z)
		event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
		event.fade_in_screen(15)
		event.finish_event()
		return
	end
	event.set_character_motion(arg0, "会話")
	event.open_message_window_2(0, "Euh... Mmm...\n2,<page>1,<page>1,<page>2...")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.play_sound_effect(var7, 66)
	event.open_message_window_2(0, "Ouaaaaouh !<page>Formidable,\n[UNI00e7]a a march[UNI00e9] !")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.attach_object_handle_to_character(0, arg0)
	event.clear_object_sequence(0, arg0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, var14, var15, var16, 30)
	wait_objects(0)
	event.set_character_motion(arg0, "会話")
	event.open_message_window_2(0, "Formidable ! Je peux enfin\nsortir mes documents importants !<page>Oh, merci !")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.fade_out_screen(15)
	wait_frames(15)
	event.set_character_rotation(0, var17, var18, var19)
	event.set_character_position(arg0, var8, var9, var10)
	event.set_character_rotation(arg0, var11, var12, var13)
	event.set_camera_position(pos_x, pos_y, pos_z)
	event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	event.fade_in_screen(15)
	wait_frames(15)
	event.set_character_motion(arg0, "会話")
	event.open_message_window_2(
		0,
		"Quels documents ? Des dossiers<page>qui aideront Morton, mon adjoint,\n[UNI00e0] me remplacer en mon absence.<page>[UNI00c7]a m'inqui[UNI00e8]te un peu,\nmais je suis s[UNI00fb]r que [UNI00e7]a ira."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Je suis pr[UNI00ea]t [UNI00e0] quitter la ville.<page>C[UNI00e9]dric m'a tout expliqu[UNI00e9].<page>Allez, on y va."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 12, 1)
end

return helper_6ca976aa
