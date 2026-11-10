--!strict
-- map/i/i03/h03/i03h03_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_22a04edc = require("@lib/event/helper_22a04edc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_3e725f33 = require("@lib/event/helper_3e725f33")
local helper_6bc9eefc = require("@lib/event/helper_6bc9eefc")
local helper_772d6241 = require("@lib/event/helper_772d6241")
local helper_8aa6dccc = require("@lib/event/helper_8aa6dccc")
local helper_9aa8a95a = require("@lib/event/helper_9aa8a95a")
local helper_9d8581fa = require("@lib/event/helper_9d8581fa")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_b440871b = require("@lib/event/helper_b440871b")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_bb522b21 = require("@lib/event/helper_bb522b21")
local helper_c137370d = require("@lib/event/helper_c137370d")
local helper_c7fcb51a = require("@lib/event/helper_c7fcb51a")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d3c729c9 = require("@lib/event/helper_d3c729c9")
local helper_f6e6d413 = require("@lib/event/helper_f6e6d413")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0

--- Helper function.
local function helper_10678()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character(4, "event/e00/e70/cup.gltf", "info", 13)
	event.set_character_active(0, 13)
	event.load_character(4, "chara/p01_28a.gltf", "info", 8)
	helper_c137370d(8, 156, vm.f32(-54.41), vm.f32(43.91), vm.f32(29.63), vm.f32(0.36))
	global0 = event.load_event_image_4(4, "textures/event/e00/e75/suuji_1.json", 0) or global0
	global1 = event.load_event_image_4(4, "textures/event/e00/e75/gyoname_1.json", 1) or global1
	helper_c137370d(10, 163, -105.0, 0.0, -340.0, vm.f32(-2.81))
	helper_c137370d(11, 170, -432.0, 0.0, 25.0, vm.f32(-1.4))
	helper_c137370d(12, 166, vm.f32(-206.4), 0.0, vm.f32(100.9), vm.f32(1.8))
	helper_c137370d(14, 172, -199.5, 0.0, vm.f32(126.9), vm.f32(1.63))
	helper_c137370d(15, 164, vm.f32(48.9), 0.0, vm.f32(376.2), vm.f32(3.11))
	helper_c137370d(16, 157, vm.f32(214.9), 0.0, vm.f32(-103.6), vm.f32(-1.15))
end

--- Event 503, which map data, a script or the engine runs by number.
local function event_503()
	event.initialize_event()
	event.set_menu_value(1)
	event.fade_out_music(30)
	event.fade_out_screen(30)
	wait_frames(30)
	event.stop_music(0)
	helper_b440871b()
	event.fade_in_screen(30)
	event.jump_to_map_2(-1, "s45")
	vm.wait(2)
end

--- Helper function.
local function helper_11798()
	-- retail: a computed index here may leave its array, so the frame's slots live in one table and such an index reaches the neighbouring variables, as it does on the PS2
	local frame: { s32 } = table.create(48, 0)
	local at: number = 0
	return vm.guard(function()
		event.load_character_motion_pack(4, "event/e00/e70/e70_mints.gltf", "info", 0)
		global3 = 0
		global3 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or global3
		event.set_object_handle_rotation(9, 0.0, 0.0, 0.0)
		event.play_sound_effect(global2, 0)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-76.78, 102.98, 360.23, -174.91, 58.62, 77.17)
		event.add_camera_sequence_path_point(-76.78, 102.98, 360.23, 62.03, 58.62, 92.93)
		event.start_camera_sequence_path()
		at = 1
		wait_camera()
		event.attach_object_handle_to_map_part_2(8, "p16_i03h03")
		event.set_object_handle_visible(8, 0)
		event.set_camera_sequence_position(-5.99, 55.55, -213.4)
		event.set_camera_sequence_look_at(0.0, 55.55, -471.19)
		at = 2
		wait_frames(30)
		event.move_camera_sequence(-5.99, 181.46, -213.4, 0.0, 181.46, -471.19, 180)
		at = 3
		wait_camera()
		event.stop_sound_effect(global2, 0)
		event.play_sound_effect(global2, 3)
		at = 4
		wait_frames(20)
		event.get_fishing_tournament_info_2(4, frame[2]) -- retail: argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		frame[1] = 0
		frame[8] = 1
		event.get_fishing_tournament_info_2(3, frame[11]) -- retail: argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		event.set_message_window_mode(1, 0)
		event.set_message_window_option(1, 7, 20, 100, 20, 128)
		event.set_message_window_option(1, 8, 0)
		frame[12] = event.get_language() or frame[12]
		if frame[12] == 1 then
			event.set_message_window_option(1, 2, 0.5)
		end
		frame[9] = vm.float_bits(event.get_random_number(1000)) or frame[9]
		frame[3] = vm.i32(vm.i32(15000 + vm.i32(frame[2] * 1000)) + frame[9])
		if frame[3] > frame[11] then
			frame[1] = vm.i32(frame[1] + 1)
		end
		while frame[8] < 5 do
			frame[9] = vm.float_bits(event.get_random_number(vm.idiv(frame[vm.index(vm.i32(frame[8] + 1), 48)], 3))) or frame[9]
			frame[vm.index(vm.i32(frame[8] + 2), 48)] =
				vm.i32(frame[vm.index(vm.i32(frame[8] + 1), 48)] - vm.i32(frame[9] + 1))
			if frame[vm.index(vm.i32(frame[8] + 2), 48)] < 0 then
				frame[vm.index(vm.i32(frame[8] + 2), 48)] = 0
			end
			if frame[vm.index(vm.i32(frame[8] + 2), 48)] > frame[11] then
				frame[1] = vm.i32(frame[1] + 1)
			end
			frame[8] = vm.i32(frame[8] + 1)
		end
		frame[8] = 0
		frame[13] = 0
		frame[14] = 0
		frame[15] = 0
		while frame[8] < 6 do
			if frame[8] == frame[1] then
				event.set_message_item_system_message(1, vm.i32(frame[1] + 1), 33110)
				event.set_message_number(1, vm.i32(frame[1] + 1), frame[11])
				frame[13] = 1
			else
				frame[9] = vm.float_bits(event.get_random_number(24)) or frame[9]
				while true do
					frame[46] = 0
					while frame[15] > frame[46] do
						if frame[vm.index(vm.i32(frame[46] + 15), 48)] == frame[9] then
							break
						else
							frame[46] = vm.i32(frame[46] + 1)
						end
					end
					if frame[15] == frame[46] then
						break
					else
						frame[9] = vm.float_bits(event.get_random_number(24)) or frame[9]
					end
				end
				frame[vm.index(vm.i32(frame[15] + 15), 48)] = frame[9]
				frame[15] = vm.i32(frame[15] + 1)
				frame[10] = event.get_npc_message_number_3(vm.i32(frame[9] + 1), 12) or frame[10]
				event.set_message_item_system_message(1, vm.i32(frame[8] + 1), frame[10])
				event.set_message_number(
					1,
					vm.i32(frame[8] + 1),
					frame[vm.index(vm.i32(vm.i32(frame[8] - frame[13]) + 2), 48)]
				)
				if vm.i32(frame[8] + 1) <= 3 then
					if frame[14] == 0 then
						event.load_npc_character(0, 4, vm.i32(frame[9] + 1), 17)
					end
					if frame[14] == 1 then
						event.load_npc_character(0, 4, vm.i32(frame[9] + 1), 18)
					end
					if frame[14] == 2 then
						event.load_npc_character(0, 4, vm.i32(frame[9] + 1), 19)
					end
					frame[14] = vm.i32(frame[14] + 1)
				end
			end
			frame[8] = vm.i32(frame[8] + 1)
		end
		event.play_sound_effect(global2, 4)
		event.open_message_window_2(
			1,
			"              CATEGORIA    Nome                Peso\n          ──────────────────────\n\n\n\n\n              3[UNI00b0]    [アイテム３]  [数値３]g\n\n              4[UNI00b0]    [アイテム４]  [数値４]g\n\n              5[UNI00b0]    [アイテム５]  [数値５]g\n\n              6[UNI00b0]    [アイテム６]  [数値６]g\n"
		)
		at = 5
		helper_6bc9eefc(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(global2, 4)
		event.open_message_window_2(
			1,
			"              CATEGORIA    Nome                Peso\n          ──────────────────────\n\n\n              2[UNI00b0]    [アイテム２]  [数値２]g\n\n              3[UNI00b0]    [アイテム３]  [数値３]g\n\n              4[UNI00b0]    [アイテム４]  [数値４]g\n\n              5[UNI00b0]    [アイテム５]  [数値５]g\n\n              6[UNI00b0]    [アイテム６]  [数値６]g\n"
		)
		at = 6
		helper_6bc9eefc(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(global2, 4)
		event.open_message_window_2(
			1,
			"              CATEGORIA    Nome                Peso\n          ──────────────────────\n              1[UNI00b0]    [アイテム１]  [数値１]g\n\n              2[UNI00b0]    [アイテム２]  [数値２]g\n\n              3[UNI00b0]    [アイテム３]  [数値３]g\n\n              4[UNI00b0]    [アイテム４]  [数値４]g\n\n              5[UNI00b0]    [アイテム５]  [数値５]g\n\n              6[UNI00b0]    [アイテム６]  [数値６]g\n"
		)
		at = 7
		helper_6bc9eefc(1, -1, 4, 0, 0, 90)
		if frame[12] == 1 then
			event.set_message_window_option(1, 2, -1)
		end
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.set_character_rotation(17, 0.0, 0.0, 0.0)
		event.set_character_rotation(18, 0.0, 0.0, 0.0)
		if frame[1] == 0 then
			event.set_fishing_tournament_state(0, vm.i32(frame[2] + 1))
			event.set_character_active(1, 13)
			event.set_character_active(17)
			event.set_character_active(18)
			event.set_character_position(13, 0.0, 68.97, -470.0)
			event.set_character_position(17, 30.0, 20.0, -470.0)
			event.set_character_position(18, -30.0, 16.0, -470.0)
			event.set_character_position(0, 0.0, 36.0, -470.0)
			event.set_character_motion(0, "1位", 0)
			event.set_fishing_tournament_state(3)
		end
		if frame[1] == 1 then
			event.set_character_active(17)
			event.set_character_active(18)
			event.set_character_position(17, 0.0, 36.0, -470.0)
			event.set_character_position(18, -30.0, 16.0, -470.0)
			event.set_character_position(0, 30.0, 20.0, -470.0)
			event.set_character_motion(0, "2位", 0)
		end
		if frame[1] == 2 then
			event.set_character_active(17)
			event.set_character_active(18)
			event.set_character_position(17, 0.0, 36.0, -470.0)
			event.set_character_position(18, 30.0, 20.0, -470.0)
			event.set_character_position(0, -30.0, 16.0, -470.0)
			event.set_character_motion(0, "3位", 0)
		end
		if frame[1] >= 3 then
			event.set_character_active(17)
			event.set_character_active(18)
			event.set_character_active(19)
			event.set_character_position(17, 0.0, 36.0, -470.0)
			event.set_character_position(18, 30.0, 20.0, -470.0)
			event.set_character_position(19, -30.0, 16.0, -470.0)
			event.set_character_position(0, 34.24, 0.0, -432.43)
			event.set_character_rotation(0, 0.0, -2.4, 0.0)
			event.set_character_motion(0, "がっかりL", 0)
		end
		event.set_camera_sequence_position(-1.26, 25.59, -336.37)
		event.set_camera_sequence_look_at(0.0, 36.39, -471.19)
		event.start_crossfade(60)
		at = 8
		wait_frames(90)
		event.set_object_handle_visible(8, 1)
		if frame[1] <= 2 then
			do
				local out1, out2 = event.get_fishing_tournament_info_4(1, vm.i32(frame[1] + 1))
				frame[47] = out1 or frame[47]
				frame[48] = out2 or frame[48]
			end
			event.play_sound_effect(global3, 0)
			at = 9
			helper_772d6241(1, vm.i32(frame[1] + 1), frame[47], frame[48])
			event.add_inventory_item(frame[47], frame[48])
			at = 10
			helper_a87eb945(1)
		end
		event.set_fishing_tournament_state(1)
		at = 11
		wait_frames(30)
		event.fade_out_screen(30)
		at = 12
		wait_frames(30)
		event.set_character_active(0, 13)
		event.delete_character(17)
		event.delete_character(18)
		event.delete_character(19)
		at = 13
		event_503()
		return 0
	end, function(received: { any })
		if at <= 13 then
			if at <= 1 then
				wait_frames_skipping(30)
			end
			if at <= 2 then
				helper_344d6cd8()
			end
			if at <= 3 then
				wait_frames_skipping(20)
			end
			if at <= 4 then
				frame[1] = 0
				frame[8] = 1
				local _ = frame[12] == 1
				frame[3] = vm.i32(vm.i32(15000 + vm.i32(frame[2] * 1000)) + frame[9])
				local _ = frame[3] > frame[11]
				frame[1] = vm.i32(frame[1] + 1)
				local _ = frame[8] < 5
				frame[vm.index(vm.i32(frame[8] + 2), 48)] =
					vm.i32(frame[vm.index(vm.i32(frame[8] + 1), 48)] - vm.i32(frame[9] + 1))
				local _ = frame[vm.index(vm.i32(frame[8] + 2), 48)] < 0
				frame[vm.index(vm.i32(frame[8] + 2), 48)] = 0
				local _ = frame[vm.index(vm.i32(frame[8] + 2), 48)] > frame[11]
				frame[1] = vm.i32(frame[1] + 1)
				frame[8] = vm.i32(frame[8] + 1)
				frame[8] = 0
				frame[13] = 0
				frame[14] = 0
				frame[15] = 0
				local _ = frame[8] < 6
				local _ = frame[8] == frame[1]
				frame[13] = 1
				frame[46] = 0
				local _ = frame[15] > frame[46]
				local _ = frame[vm.index(vm.i32(frame[46] + 15), 48)] == frame[9]
				frame[46] = vm.i32(frame[46] + 1)
				local _ = frame[15] == frame[46]
				frame[vm.index(vm.i32(frame[15] + 15), 48)] = frame[9]
				frame[15] = vm.i32(frame[15] + 1)
				local _ = vm.i32(frame[8] + 1) <= 3
				local _ = frame[14] == 0
				local _ = frame[14] == 1
				local _ = frame[14] == 2
				frame[14] = vm.i32(frame[14] + 1)
				frame[8] = vm.i32(frame[8] + 1)
				helper_22a04edc(1, -1, 4, 0, 0, 60)
			end
			if at <= 5 then
				helper_22a04edc(1, -1, 4, 0, 0, 60)
			end
			if at <= 6 then
				helper_22a04edc(1, -1, 4, 0, 0, 90)
			end
			if at <= 7 then
				wait_frames_skipping(90)
			end
			if at <= 8 then
				helper_c7fcb51a(1, vm.i32(frame[1] + 1), frame[47], frame[48])
			end
			if at <= 9 then
				helper_bb522b21(1)
			end
			if at <= 10 then
				wait_frames_skipping(30)
			end
			if at <= 11 then
				wait_frames_skipping(30)
			end
			if at <= 12 then
				helper_9d8581fa()
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_22d00000()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: { s32 } = table.create(5, 0)
	local var7: s32 = 0
	local var8: s32 = 0
	local var10: s32 = 0
	local var13: s32 = 0
	local var14: s32 = 0
	local var15: { s32 } = table.create(30, 0)
	local var45: s32 = 0
	local var46: s32 = 0
	local var47: s32 = 0
	global3 = 0
	helper_344d6cd8()
	wait_frames_skipping(30)
	helper_344d6cd8()
	wait_frames_skipping(20)
	var0 = 0
	var7 = 1
	var2[1] = 15000 + var1 * 1000 + var8
	var0 = var0 + 1
	local _ = var2[1] > var10
	var2[var7 + 1] = vm.i32(var2[var7] - (var8 + 1))
	local _ = var2[var7 + 1] < 0
	var2[var7 + 1] = 0
	var0 = var0 + 1
	local _ = var7 < 5
	local _ = var2[var7 + 1] > var10
	var7 = var7 + 1
	var7 = 0
	var13 = 0
	var14 = 0
	var45 = 0
	local _ = var14 > var45
	local _ = var15[var45 + 1] == var8
	var45 = var45 + 1
	var15[var14 + 1] = var8
	local _ = var14 == var45
	var14 = var14 + 1
	local _ = var13 == 0
	local _ = var13 == 1
	local _ = var13 == 2
	var13 = var13 + 1
	local _ = var7 < 6
	local _ = var7 == var0
	local _ = var7 + 1 <= 3
	var7 = var7 + 1
	helper_22a04edc(1, -1, 4, 0, 0, 60)
	helper_22a04edc(1, -1, 4, 0, 0, 60)
	helper_22a04edc(1, -1, 4, 0, 0, 90)
	wait_frames_skipping(90)
	helper_c7fcb51a(1, var0 + 1, var46, var47)
	helper_bb522b21(1)
	wait_frames_skipping(30)
	wait_frames_skipping(30)
	helper_9d8581fa()
end

--- Helper function.
local function helper_140fc()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: any = 0
	local var3: s32 = 0
	local var4: any = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: s32 = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: s32 = 0
	local rot_z: f32 = 0
	local var23: f32 = 0
	local var25: f32 = 0
	local var26: s32 = 0
	local var27: s32 = 0
	local language_code: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_triggered_event_data_2(13) or var0
		event.apply_message_window_preset(0, 0)
		event.set_character_motion(0, "立ち", 0)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 0 then
			event.open_message_window_2(
				0,
				"Qui puoi dimostrare la tua abilit[UNI00e0]\nnella pesca. Puoi presentare solo\npesci che hai catturato tu stesso.<page>Come faccio a saperlo?\nAnni e anni di esperienza!"
			)
			at = 1
			helper_1c04a0eb(var0, -1, 0, 0)
			return
		end
		event.open_message_window_2(0, "Inizia il Torneo di Pesca!\nHai portato un pesce?")
		at = 2
		helper_1c04a0eb(var0, -1, 0, 0)
		while true do
			event.open_message_window_2(0, "Pesa il pesce\nAscolta la spiegazione\nEsci")
			at = 3
			var2 = helper_8aa6dccc(0, -1, 0, var0, 3, 2)
			if var2 == -1 or var2 == 2 then
				event.open_message_window_2(0, "Puoi anche pescare solo per\ndivertirti. Ognuno fa come crede!")
				at = 4
				helper_1c04a0eb(var0, -1, 0, 0)
				return
			end
			if var2 == 1 then
				event.open_message_window_2(
					0,
					"In ogni torneo, puoi pesare fino\na 10 pesci e, se ne pesi 3 o pi[UNI00f9],\narriverai al Totale complessivo."
				)
				at = 5
				helper_1c04a0eb(var0, -1, 0, 0)
				event.open_message_window_2(
					0,
					"Se partecipi al torneo con pesci gi[UNI00e0] pesati e selezioni\nTotale complessivo, il punteggio finale\nsar[UNI00e0] il peso totale dei tuoi 3 pesci migliori."
				)
				at = 6
				helper_1c04a0eb(var0, -1, 0, 0)
				event.open_message_window_2(
					0,
					"Sappi che puoi far partecipare\nsolo pesci non allevati.<page>Non puoi pesare un pesce\nche hai nutrito tu stesso."
				)
				at = 7
				helper_1c04a0eb(var0, -1, 0, 0)
			end
			if var2 == 0 then
				break
			end
		end
		event.get_fishing_tournament_info_2(2, var3) -- retail: argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		var0 = 8
		if var3 == 10 then
			event.open_message_window_2(0, "Quale pesce vuoi pesare?")
			at = 8
			helper_1c04a0eb(var0, -1, 0, 0)
		else
			if var3 > 7 then
				event.open_message_window_2(0, "Pesa\nGuarda l'Elenco Pesi")
				event.set_message_selection_top_line(0, 0)
				at = 9
				var4 = helper_8aa6dccc(0, -1, 0, var0, 2, 0)
			else
				event.open_message_window_2(0, "Pesa il pesce\nVisualizza l'Elenco Pesi\nTotale complessivo")
				event.set_message_selection_top_line(0, 0)
				at = 10
				var4 = helper_8aa6dccc(0, -1, 0, var0, 3, 0)
			end
			if var4 == -1 then
				return
			end
			if var4 == 1 then
				at = 11
				helper_f6e6d413()
				at = 12
				vm.wait(12)
				return
			end
			if var4 == 2 then
				event.pause_music()
				at = 13
				helper_11798()
				event.play_music(0)
				return
			end
			event.set_message_window_mode(0, 1)
			event.set_message_selection_top_line(0, 0)
			event.set_message_window_option(0, 0, 0)
			event.set_message_window_option(0, 4, -1, -1)
		end
		event.open_event_menu(22, 0)
		at = 14
		vm.wait(14)
		event.set_message_window_mode(0, 1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 4, -1, -1)
		do
			local out1, out2, out3, out4, out5 = event.get_menu_results_5()
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
			var8 = out4 or var8
			var9 = out5 or var9
		end
		if var5 == 0 then
			return
		end
		if var6 == 0 then
			event.open_message_window_2(0, "Non posso pesare quello!")
			at = 15
			helper_1c04a0eb(var0, -1, 0, 0)
			return
		end
		event.fade_out_screen(30)
		at = 16
		wait_frames(35)
		event.pause_music()
		var10 = vm.i32(var5 - 320)
		if var5 == 310 then
			var10 = 17
		end
		if var10 == 0 then
			event.load_character(4, "menu/aqua/fish/f1a.gltf", "info", 9)
		end
		if var10 == 1 then
			event.load_character(4, "menu/aqua/fish/f2a.gltf", "info", 9)
		end
		if var10 == 2 then
			event.load_character(4, "menu/aqua/fish/f3a.gltf", "info", 9)
		end
		if var10 == 3 then
			event.load_character(4, "menu/aqua/fish/f4a.gltf", "info", 9)
		end
		if var10 == 4 then
			event.load_character(4, "menu/aqua/fish/f5a.gltf", "info", 9)
		end
		if var10 == 5 then
			event.load_character(4, "menu/aqua/fish/f6a.gltf", "info", 9)
		end
		if var10 == 6 then
			event.load_character(4, "menu/aqua/fish/f7a.gltf", "info", 9)
		end
		if var10 == 7 then
			event.load_character(4, "menu/aqua/fish/f8a.gltf", "info", 9)
		end
		if var10 == 8 then
			event.load_character(4, "menu/aqua/fish/f10a.gltf", "info", 9)
		end
		if var10 == 9 then
			event.load_character(4, "menu/aqua/fish/f11a.gltf", "info", 9)
		end
		if var10 == 10 then
			event.load_character(4, "menu/aqua/fish/f12a.gltf", "info", 9)
		end
		if var10 == 11 then
			event.load_character(4, "menu/aqua/fish/f13a.gltf", "info", 9)
		end
		if var10 == 12 then
			event.load_character(4, "menu/aqua/fish/f14a.gltf", "info", 9)
		end
		if var10 == 13 then
			event.load_character(4, "menu/aqua/fish/f15a.gltf", "info", 9)
		end
		if var10 == 14 then
			event.load_character(4, "menu/aqua/fish/f16a.gltf", "info", 9)
		end
		if var10 == 15 then
			event.load_character(4, "menu/aqua/fish/f17a.gltf", "info", 9)
		end
		if var10 == 16 then
			event.load_character(4, "menu/aqua/fish/f18a.gltf", "info", 9)
		end
		if var10 == 17 then
			event.load_character(4, "menu/aqua/fish/f19a.gltf", "info", 9)
		end
		event.reset_follow_camera(1, 3.14)
		event.set_character_active(9)
		event.set_character_position(9, 0.0, 80.0, 25.0)
		event.set_character_rotation(9, -1.57, -1.57, 0.0)
		var12 = var7
		var13 = var9
		var11 = vm.f32(vm.fdiv(var12, var13))
		if var11 > 2.0 then
			var11 = 2.0
		end
		event.set_character_scale(9, var11, var11, var11)
		event.set_camera_sequence_position(43.16, 49.45, 114.86)
		event.set_camera_sequence_look_at(8.48, 50.29, 19.23)
		event.fade_in_screen(30)
		at = 17
		wait_frames(15)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(43.16, 49.45, 114.86, 8.48, 50.29, 19.23)
		event.add_camera_sequence_path_point(43.16, 112.26, 114.86, 8.48, 113.1, 19.23)
		event.start_camera_sequence_path()
		event.play_sound_effect(global2, 0)
		event.attach_object_handle_to_map_part_3(9, "p14_i03h03", "i03h03_14-m")
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 9)
		event.set_object_handle_rotation(9, 0.0, 0.0, -vm.f32(vm.f32(0.0031400002) * var8))
		at = 18
		vm.wait(18)
		var25 = vm.f32(var8 * 0.25)
		var23 = vm.f32(vm.f32(vm.f32(0.0031400002) * var8) * 0.25)
		var26 = 0
		while var23 > vm.f32(0.05) do
			if vm.imod(var26, 2) == 0 then
				rot_z = vm.f32(-vm.f32(vm.f32(0.0031400002) * var8) + var23)
			else
				rot_z = vm.f32(-vm.f32(vm.f32(0.0031400002) * var8) - var23)
			end
			var23 = vm.f32(var23 - vm.f32(var23 / 50.0))
			var25 = vm.f32(var25 - vm.f32(var25 / 50.0))
			event.set_object_handle_rotation(9, 0.0, 0.0, rot_z)
			var27 = event.is_camera_sequence_running() or var27
			if var27 == 0 then
				event.stop_sound_effect(global2, 0)
			end
			var26 = vm.i32(var26 + 1)
			at = 19
			vm.wait(19)
		end
		event.stop_sound_effect(global2, 0)
		event.play_sound_effect(global2, 1)
		event.set_object_handle_rotation(9, 0.0, 0.0, -vm.f32(vm.f32(0.0031400002) * var8))
		language_code = event.get_language() or language_code
		var14 = vm.idiv(var8, 10000)
		var15 = vm.idiv(vm.i32(var8 - vm.i32(var14 * 10000)), 1000)
		var16 = vm.idiv(vm.i32(var8 - vm.i32(vm.i32(var14 * 10000) + vm.i32(var15 * 1000))), 100)
		var17 = vm.idiv(
			vm.i32(var8 - vm.i32(vm.i32(vm.i32(var14 * 10000) + vm.i32(var15 * 1000)) + vm.i32(var16 * 100))),
			10
		)
		var18 = vm.i32(
			var8
				- vm.i32(
					vm.i32(vm.i32(vm.i32(var14 * 10000) + vm.i32(var15 * 1000)) + vm.i32(var16 * 100))
						+ vm.i32(var17 * 10)
				)
		)
		event.reset_event_sprite(10)
		event.set_event_sprite_type(10, 0)
		event.set_event_sprite_texture(10, "suuji", global0)
		event.set_event_sprite_color(10, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(10, vm.i32(40 * var14), 0, 40, 52)
		event.set_event_sprite_size(10, 40, 52)
		event.set_event_sprite_position(10, 256, 344)
		event.set_event_sprite_draw_pass(10, 1)
		event.attach_object_handle_to_sprite(20, 10)
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "suuji", global0)
		event.set_event_sprite_color(0, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(0, vm.i32(40 * var15), 0, 40, 52)
		event.set_event_sprite_size(0, 40, 52)
		event.set_event_sprite_position(0, 296, 344)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(10, 0)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "suuji", global0)
		event.set_event_sprite_color(1, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(1, vm.i32(40 * var16), 0, 40, 52)
		event.set_event_sprite_size(1, 40, 52)
		event.set_event_sprite_position(1, 336, 344)
		event.set_event_sprite_draw_pass(1, 1)
		event.attach_object_handle_to_sprite(11, 1)
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.reset_event_sprite(2)
		event.set_event_sprite_type(2, 0)
		event.set_event_sprite_texture(2, "suuji", global0)
		event.set_event_sprite_color(2, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(2, 0 + vm.i32(40 * var17), 0, 40, 52)
		event.set_event_sprite_size(2, 40, 52)
		event.set_event_sprite_position(2, 376, 344)
		event.set_event_sprite_draw_pass(2, 1)
		event.attach_object_handle_to_sprite(12, 2)
		event.clear_object_sequence(12)
		event.set_object_sequence_object(12, 12)
		event.reset_event_sprite(3)
		event.set_event_sprite_type(3, 0)
		event.set_event_sprite_texture(3, "suuji", global0)
		event.set_event_sprite_color(3, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(3, 0 + vm.i32(40 * var18), 0, 40, 52)
		event.set_event_sprite_size(3, 40, 52)
		event.set_event_sprite_position(3, 416, 344)
		event.set_event_sprite_draw_pass(3, 1)
		event.attach_object_handle_to_sprite(13, 3)
		event.clear_object_sequence(13)
		event.set_object_sequence_object(13, 13)
		event.reset_event_sprite(4)
		event.set_event_sprite_type(4, 0)
		event.set_event_sprite_texture(4, "suuji", global0)
		event.set_event_sprite_color(4, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(4, 484, 0, 28, 42)
		event.set_event_sprite_size(4, 28, 42)
		event.set_event_sprite_position(4, 456, 349)
		if language_code == 5 then
			event.set_event_sprite_position(4, 456, 364)
		end
		event.set_event_sprite_draw_pass(4, 1)
		event.attach_object_handle_to_sprite(14, 4)
		event.clear_object_sequence(14)
		event.set_object_sequence_object(14, 14)
		event.reset_event_sprite(5)
		event.set_event_sprite_type(5, 0)
		event.set_event_sprite_texture(5, "gyoname", global1)
		event.set_event_sprite_color(5, 128, 128, 128, 0)
		if var10 <= 8 then
			event.set_event_sprite_texture_rect(5, 0, vm.i32(var10 * 40), 182, 40)
		else
			event.set_event_sprite_texture_rect(5, 182, vm.i32((var10 - 9) * 40), 182, 40)
		end
		event.set_event_sprite_size(5, 182, 40)
		event.set_event_sprite_position(5, 182, 144)
		event.set_event_sprite_draw_pass(5, 1)
		event.attach_object_handle_to_sprite(15, 5)
		event.clear_object_sequence(15)
		event.set_object_sequence_object(15, 15)
		var16 = vm.idiv(var7, 1000)
		var17 = vm.idiv(vm.i32(var7 - vm.i32(var16 * 1000)), 100)
		var18 = vm.idiv(vm.i32(var7 - vm.i32(vm.i32(var16 * 1000) + vm.i32(var17 * 100))), 10)
		var19 = vm.i32(var7 - vm.i32(vm.i32(vm.i32(var16 * 1000) + vm.i32(var17 * 100)) + vm.i32(var18 * 10)))
		event.reset_event_sprite(6)
		event.set_event_sprite_type(6, 0)
		event.set_event_sprite_texture(6, "suuji", global0)
		event.set_event_sprite_color(6, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(6, vm.i32(26 * var16), 52, 26, 32)
		event.set_event_sprite_size(6, 26, 32)
		event.set_event_sprite_position(6, 299, 144)
		event.set_event_sprite_draw_pass(6, 1)
		event.attach_object_handle_to_sprite(16, 6)
		event.clear_object_sequence(16)
		event.set_object_sequence_object(16, 16)
		event.reset_event_sprite(7)
		event.set_event_sprite_type(7, 0)
		event.set_event_sprite_texture(7, "suuji", global0)
		event.set_event_sprite_color(7, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(7, 0 + vm.i32(26 * var17), 52, 26, 32)
		event.set_event_sprite_size(7, 26, 32)
		event.set_event_sprite_position(7, 325, 144)
		event.set_event_sprite_draw_pass(7, 1)
		event.attach_object_handle_to_sprite(17, 7)
		event.clear_object_sequence(17)
		event.set_object_sequence_object(17, 17)
		event.reset_event_sprite(8)
		event.set_event_sprite_type(8, 0)
		event.set_event_sprite_texture(8, "suuji", global0)
		event.set_event_sprite_color(8, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(8, 0 + vm.i32(26 * var18), 52, 26, 32)
		event.set_event_sprite_size(8, 26, 32)
		event.set_event_sprite_position(8, 351, 144)
		event.set_event_sprite_draw_pass(8, 1)
		event.attach_object_handle_to_sprite(18, 8)
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.reset_event_sprite(12)
		event.set_event_sprite_type(12, 0)
		event.set_event_sprite_texture(12, "suuji", global0)
		event.set_event_sprite_color(12, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(12, 434, 0, 10, 22)
		if language_code == 2 then
			event.set_event_sprite_texture_rect(12, 432, 0, 12, 30)
		end
		if language_code == 4 then
			event.set_event_sprite_texture_rect(12, 434, 0, 10, 26)
		end
		if language_code == 5 then
			event.set_event_sprite_texture_rect(12, 434, 0, 10, 32)
		end
		event.set_event_sprite_size(12, 10, 22)
		event.set_event_sprite_position(12, 369, 149)
		if language_code == 5 then
			event.set_event_sprite_position(12, 369, 142)
		end
		event.set_event_sprite_draw_pass(12, 1)
		event.attach_object_handle_to_sprite(22, 12)
		event.clear_object_sequence(22)
		event.set_object_sequence_object(22, 22)
		event.reset_event_sprite(11)
		event.set_event_sprite_type(11, 0)
		event.set_event_sprite_texture(11, "suuji", global0)
		event.set_event_sprite_color(11, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(11, 0 + vm.i32(26 * var19), 52, 26, 32)
		event.set_event_sprite_size(11, 26, 32)
		event.set_event_sprite_position(11, 387, 144)
		event.set_event_sprite_draw_pass(11, 1)
		event.attach_object_handle_to_sprite(21, 11)
		event.clear_object_sequence(21)
		event.set_object_sequence_object(21, 21)
		event.reset_event_sprite(9)
		event.set_event_sprite_type(9, 0)
		event.set_event_sprite_texture(9, "suuji", global0)
		event.set_event_sprite_color(9, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(9, 444, 0, 40, 22)
		event.set_event_sprite_size(9, 40, 22)
		event.set_event_sprite_position(9, 423, 149)
		event.set_event_sprite_draw_pass(9, 1)
		event.attach_object_handle_to_sprite(19, 9)
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		at = 20
		wait_camera()
		event.move_object_sequence(20, 176, 224, 0.0, 30)
		event.move_object_sequence(10, 216, 224, 0.0, 30)
		event.move_object_sequence(11, 256, 224, 0.0, 30)
		event.move_object_sequence(12, 296, 224, 0.0, 30)
		event.move_object_sequence(13, 336, 224, 0.0, 30)
		if language_code == 5 then
			event.move_object_sequence(14, 376, 244, 0.0, 30)
		else
			event.move_object_sequence(14, 376, 229, 0.0, 30)
		end
		at = 21
		wait_frames(30)
		event.play_sound_effect(global2, 2)
		event.set_object_sequence_color(15, 128.0, 128.0, 128.0, 128.0, 30)
		event.set_object_sequence_color(16, 128.0, 128.0, 128.0, 128.0, 30)
		event.set_object_sequence_color(17, 128.0, 128.0, 128.0, 128.0, 30)
		event.set_object_sequence_color(18, 128.0, 128.0, 128.0, 128.0, 30)
		event.set_object_sequence_color(19, 128.0, 128.0, 128.0, 128.0, 30)
		event.set_object_sequence_color(21, 128.0, 128.0, 128.0, 128.0, 30)
		event.set_object_sequence_color(22, 128.0, 128.0, 128.0, 128.0, 30)
		at = 22
		wait_frames(60)
		event.set_character_position(0, 20.54, 20.0, 96.75)
		event.set_character_rotation(0, 0.0, -2.34, 0.0)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_event_sprite_draw_pass(3, 0)
		event.set_event_sprite_draw_pass(4, 0)
		event.set_event_sprite_draw_pass(5, 0)
		event.set_event_sprite_draw_pass(6, 0)
		event.set_event_sprite_draw_pass(7, 0)
		event.set_event_sprite_draw_pass(8, 0)
		event.set_event_sprite_draw_pass(9, 0)
		event.set_event_sprite_draw_pass(10, 0)
		event.set_event_sprite_draw_pass(11, 0)
		event.set_event_sprite_draw_pass(12, 0)
		event.play_music(0)
		event.set_camera_sequence_position(3.01, 56.77, 312.31)
		event.set_camera_sequence_look_at(1.17, 80.71, 19.28)
		event.set_object_handle_rotation(9, 0.0, 0.0, 0.0)
		at = 23
		wait_frames(5)
		if var7 > 600 then
			event.open_message_window_2(0, "Wow! Questo s[UNI00ec] che [UNI00e8] grosso!\nNon vedo l'ora dei risultati!")
		elseif var7 > 400 then
			event.open_message_window_2(0, "Bravo, niente male!\nMa non puoi ancora riposarti...")
		else
			event.open_message_window_2(0, "Mmh... Niente male, credo.")
		end
		var0 = 8
		at = 24
		helper_1c04a0eb(var0, -1, 0, 0)
		event.set_camera_sequence_position(-34.05, 56.77, 159.14)
		event.set_camera_sequence_look_at(-54.41, 52.31, 29.63)
		at = 25
		wait_frames(1)
		event.set_character_position(0, -43.47, 20.0, 56.19)
		event.set_character_rotation(0, 0.0, -2.7, 0.0)
		event.get_fishing_tournament_info_2(2, var3) -- retail: argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		if var3 <= 0 then
			event.pause_music()
			at = 26
			helper_11798()
			event.play_music(0)
		end
		event.set_message_number(0, 1, var3)
		event.open_message_window_2(0, "Puoi pesare [数値１]pesce/i in pi[UNI00f9].\nBuona fortuna!")
		at = 27
		helper_1c04a0eb(var0, -1, 0, 0)
		at = 28
		wait_frames(30)
		event.delete_character(9)
		event.reset_follow_camera(1, 3.14)
		return
	end, function(received: { any })
		if at <= 1 then
			return 0
		end
		if at <= 4 then
			if at == 3 then
				var2 = received[1] :: number
			end
			if at <= 2 then
				var2 = helper_3e725f33(0, -1, 0, var0, 3, 2)
			end
			if at <= 3 then
				helper_9aa8a95a(var0, -1, 0, 0)
			end
			return 0
		end
		if at <= 10 then
			if at == 9 then
				var4 = received[1] :: number
			end
			if at == 10 then
				var4 = received[1] :: number
			end
			if at <= 5 then
				helper_9aa8a95a(var0, -1, 0, 0)
			end
			if at <= 6 then
				helper_9aa8a95a(var0, -1, 0, 0)
			end
			if at <= 7 then
				var0 = 8
				helper_9aa8a95a(var0, -1, 0, 0)
			end
			if at <= 8 then
				var4 = helper_3e725f33(0, -1, 0, var0, 2, 0)
			end
			if at <= 9 then
				var4 = helper_3e725f33(0, -1, 0, var0, 3, 0)
			end
			return 0
		end
		if at <= 12 then
			return 0
		end
		if at <= 13 then
			return 0
		end
		if at <= 14 then
			return 0
		end
		if at <= 15 then
			return 0
		end
		if at <= 28 then
			if at <= 16 then
				var10 = var5 - 320
				var10 = 17
				var12 = var7
				var13 = var9
				var11 = vm.f32(vm.fdiv(var12, var13))
				local _ = var11 > 2.0
				var11 = 2.0
				wait_frames_skipping(15)
			end
			if at <= 18 then
				var25 = vm.f32(var8 * 0.25)
				var23 = vm.f32(vm.f32(vm.f32(0.0031400002) * var8) * 0.25)
				var26 = 0
				rot_z = vm.f32(-vm.f32(vm.f32(0.0031400002) * var8) + var23)
				rot_z = vm.f32(-vm.f32(vm.f32(0.0031400002) * var8) - var23)
				local _ = var23 > vm.f32(0.05)
				var23 = vm.f32(var23 - vm.f32(var23 / 50.0))
				var25 = vm.f32(var25 - vm.f32(var25 / 50.0))
				local _ = vm.imod(var26, 2) == 0
				var26 = var26 + 1
			end
			if at <= 19 then
				var14 = vm.idiv(var8, 10000)
				var15 = vm.idiv(vm.i32(var8 - vm.i32(var14 * 10000)), 1000)
				var16 = vm.idiv(vm.i32(var8 - vm.i32(vm.i32(var14 * 10000) + vm.i32(var15 * 1000))), 100)
				var17 = vm.idiv(
					vm.i32(var8 - vm.i32(vm.i32(vm.i32(var14 * 10000) + vm.i32(var15 * 1000)) + vm.i32(var16 * 100))),
					10
				)
				var18 = vm.i32(
					var8
						- vm.i32(
							vm.i32(vm.i32(vm.i32(var14 * 10000) + vm.i32(var15 * 1000)) + vm.i32(var16 * 100))
								+ vm.i32(var17 * 10)
						)
				)
				var16 = vm.idiv(var7, 1000)
				var17 = vm.idiv(vm.i32(var7 - vm.i32(var16 * 1000)), 100)
				var18 = vm.idiv(vm.i32(var7 - vm.i32(vm.i32(var16 * 1000) + vm.i32(var17 * 100))), 10)
				var19 = vm.i32(var7 - vm.i32(vm.i32(vm.i32(var16 * 1000) + vm.i32(var17 * 100)) + vm.i32(var18 * 10)))
				helper_344d6cd8()
			end
			if at <= 20 then
				wait_frames_skipping(30)
			end
			if at <= 21 then
				wait_frames_skipping(60)
			end
			if at <= 22 then
				wait_frames_skipping(5)
			end
			if at <= 23 then
				var0 = 8
				helper_9aa8a95a(var0, -1, 0, 0)
			end
			if at <= 24 then
				wait_frames_skipping(1)
			end
			if at <= 25 then
				helper_22d00000()
			end
			if at <= 26 then
				helper_9aa8a95a(var0, -1, 0, 0)
			end
			if at <= 27 then
				wait_frames_skipping(30)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_e3c4()
	local var1: s32 = 0
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	event.get_player_character_slot()
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, var1)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Salve.\nTempo stupendo, vero?")
	if var2 == 164 then
		event.open_message_window_2(
			0,
			"Vivo per questi Tornei di Pesca.\nE questa volta ho un vero campione.\nPodio dei vincitori, eccomi: arrivo!"
		)
	end
	if var2 == 166 then
		event.open_message_window_2(
			0,
			"Questo mi [UNI00e8] costato tempo e fatica.\nLa mia ragazza dice che sono cocciuto.\nStavolta non posso proprio perdere!"
		)
	end
	if var2 == 172 then
		event.open_message_window_2(
			0,
			"Avevamo un appuntamento romantico\noggi e invece mi ha portata qui.<page>*sospiro*\nA me la pesca neanche piace..."
		)
	end
	if var2 == 163 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 1 then
			event.open_message_window_2(
				0,
				"Quando acchiappi il primo,\nnon hai pi[UNI00f9] scampo, eh?<page>Anche tu sei stato preso all’amo,\nMax, eh?"
			)
		else
			event.open_message_window_2(
				0,
				"Quando acchiappi il primo,\nnon hai pi[UNI00f9] scampo, eh?<page>Anche tu sei stata presa all’amo,\nMonica, eh?"
			)
		end
	end
	if var2 == 170 then
		event.open_message_window_2(
			0,
			"Non crederai mai come ho iniziato...<page>[UNI00c8] curioso, ma un giorno,\nvolevo fare del pesce per cena\ne ho deciso di pescarlo da sola.<page>Sai, non sono niente male!"
		)
	end
	if var2 == 157 then
		event.open_message_window_2(
			0,
			"[UNI00c8] il mio primo Torneo di Pesca!\nVedessi il Nonky che ho preso!\n[UNI00c8] veeeramente enorme!"
		)
	end
	helper_1c04a0eb(var1, -1, 0, 0)
	event.set_villager_ai_enabled(1, var1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.initialize_event()
	global0 = 0
	global1 = 0
	global2 = 0
	global3 = 0
	event.set_save_control_bits(1, 1)
	helper_10678()
	event.attach_object_handle_to_map_part_2(8, "p16_i03h03")
	event.set_fishing_tournament_state(2)
	event.set_object_handle_visible(8, 1)
	global2 = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or global2
	event.set_character_position(0, 0.0, 0.0, 450.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.fade_in_screen(30)
	event.reset_follow_camera(1, 3.14)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.do_nothing(0)
	helper_c956b4a2(64)
	event.do_nothing(1)
end

--- Event 202, which map data, a script or the engine runs by number.
function script.event_202()
	local var0: any = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	vm.wait(1)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "Lasciare area torneo?")
	var0 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
	event.set_message_window_mode(0, 1)
	if var0 == 0 then
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait_frames(30)
		event.stop_music(0)
		helper_b440871b()
		event.fade_in_screen(30)
		event.jump_to_map_2(-1, "s45")
		vm.wait(4)
	end
	return 1
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	local _ = helper_11798()
	event.delete_character_extension_packs(0)
end

script.event_503 = event_503

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_triggered_event_data_2(13) or var0
		if var0 == 8 then
			at = 1
			helper_140fc()
		else
			at = 2
			helper_e3c4()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_d3c729c9()
			end
			return 0
		end
		return nil
	end)
end

return script
