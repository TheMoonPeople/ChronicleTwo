--!strict
-- map/i/i03/h04/i03h04_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_22a04edc = require("@lib/event/helper_22a04edc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_6a61b74b = require("@lib/event/helper_6a61b74b")
local helper_6bc9eefc = require("@lib/event/helper_6bc9eefc")
local helper_772d6241 = require("@lib/event/helper_772d6241")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_81437291 = require("@lib/event/helper_81437291")
local helper_87260223 = require("@lib/event/helper_87260223")
local helper_8aa6dccc = require("@lib/event/helper_8aa6dccc")
local helper_9aa8a95a = require("@lib/event/helper_9aa8a95a")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_bb522b21 = require("@lib/event/helper_bb522b21")
local helper_bc9be28d = require("@lib/event/helper_bc9be28d")
local helper_c7fcb51a = require("@lib/event/helper_c7fcb51a")
local helper_fd981dba = require("@lib/event/helper_fd981dba")
local show_message = require("@lib/event/show_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_12ddc()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: any = 0
	local var3: any = 0
	local at: number = 0
	return vm.guard(function()
		var0 = 24
		var1 = event.get_gyorace_value(3) or var1
		if var1 == 0 then
			event.open_message_window_2(0, "Elige la pecera de calentamiento.")
		end
		if var1 == 1 then
			event.open_message_window_2(0, "[UNI00a1]Muy bien!\nVenga, a por la segunda eliminatoria.")
			at = 1
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(0, "Elige la pecera de\ncalentamiento para la 2[UNI00aa] eliminatoria.")
		end
		if var1 == 2 then
			event.open_message_window_2(
				0,
				"[UNI00a1]Guau! [UNI00a1]Enhorabuena! Has llegado\na la final. Elige bien la pecera\nde calentamiento."
			)
		end
		at = 2
		helper_1c04a0eb(var0, -1, 0, 0)
		while true do
			event.set_message_window_mode(0, 8)
			event.set_message_window_option(0, 0, 0)
			event.open_message_window_2(
				0,
				"1[UNI00aa] pecera: Ritmo constante\n2[UNI00aa] pecera: A toda pastilla\n3[UNI00aa] pecera: Sal con u[UNI00f1]as y dientes\n4[UNI00aa] pecera: los [UNI00fa]ltimos ser[UNI00e1]n los primeros\n5[UNI00aa] pecera: Pasa por el aro\n6[UNI00aa] pecera: Qu[UNI00e9]date en el medio"
			)
			event.set_message_selection_top_line(0, 0)
			at = 3
			var2 = helper_bac0e30d(0, -1, 8, 0, 0, 6, 0)
			if var2 == -1 then
				if var1 == 0 then
					event.set_message_window_mode(0, 1)
					event.set_message_selection_top_line(0, 0)
					event.set_message_window_option(0, 0, 0)
					event.set_message_window_option(0, 4, -1, -1)
					return -1
				else
					event.set_message_selection_top_line(0, 0)
					event.set_message_window_mode(0, 5)
					event.set_message_draw_speed(0, 1)
					event.open_message_window_2(
						0,
						"Si no eliges una pecera, ser[UNI00e1]s\nexpulsado de la carrera.\n[UNI00bf]Est[UNI00e1]s decidido?"
					)
					at = 4
					var3 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
					event.set_message_window_mode(0, 1)
					if var3 == 0 then
						event.set_gyorace_value(3, 0)
						event.set_message_window_mode(0, 1)
						event.set_message_selection_top_line(0, 0)
						event.set_message_window_option(0, 0, 0)
						event.set_message_window_option(0, 4, -1, -1)
						at = 5
						vm.wait(5)
						return -1
					end
				end
			else
				break
			end
		end
		event.set_gyorace_value(0, var2)
		event.set_message_window_mode(0, 1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 4, -1, -1)
		if var1 == 0 then
			event.open_message_window_2(
				0,
				"A por la primera eliminatoria.\nTienes que quedar el primero para pasar a la segunda eliminatoria.\n [UNI00a1]Suerte!"
			)
			event.set_gyorace_value(3, 0)
			event.set_gyorace_value(4)
		end
		if var1 == 1 then
			event.open_message_window_2(
				0,
				"A por la 2[UNI00aa] eliminatoria.\nTienes que quedar 2[UNI00ba] o mejor para pasar\na la final. [UNI00a1]Suerte!"
			)
		end
		if var1 == 2 then
			event.open_message_window_2(
				0,
				"Bueno, ya est[UNI00e1]n hechos los preparativos. [UNI00a1]Es\nhora de correr la final! Llega el 3[UNI00ba] o mejor si quieres\nganar un premio.<page>[UNI00a1]Pero t[UNI00fa] apunta siempre\na lo m[UNI00e1]s alto!"
			)
		end
		at = 6
		helper_1c04a0eb(var0, -1, 0, 0)
		event.set_message_window_mode(0, 1)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_window_option(0, 4, -1, -1)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 7
		wait_frames(30)
		event.stop_music(0)
		helper_81437291()
		at = 8
		vm.wait(8)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 3 then
				var2 = received[1] :: number
			end
			if at <= 1 then
				helper_9aa8a95a(var0, -1, 0, 0)
			end
			if at <= 2 then
				var2 = helper_7d54f41c(0, -1, 8, 0, 0, 6, 0)
			end
			return -1
		end
		if at <= 5 then
			if at == 4 then
				var3 = received[1] :: number
			end
			return -1
		end
		if at <= 8 then
			if at <= 6 then
				wait_frames_skipping(30)
			end
			if at <= 7 then
				helper_1ef0d4b2()
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_1669c()
	-- retail: a computed index here may leave its array, so the frame's slots live in one table and such an index reaches the neighbouring variables, as it does on the PS2
	local frame: { s32 } = table.create(49, 0)
	local at: number = 0
	return vm.guard(function()
		helper_bc9be28d()
		frame[8] = event.get_gyorace_value(1) or frame[8]
		event.set_character_position(0, 126.15, 0.0, -376.23)
		event.set_character_rotation(0, 0.0, -2.88, 0.0)
		event.set_character_motion(0, "立ち", 0)
		event.set_camera_position(136.75, 46.57, -242.89)
		event.set_camera_look_at(101.62, 35.0, -367.91)
		event.fade_in_screen(30)
		frame[9] = event.get_gyorace_value(3) or frame[9]
		if frame[9] == 0 then
			if 0 < frame[8] then
				return 0
			end
			event.set_gyorace_value(3, 1)
			at = 1
			if helper_12ddc() == -1 then
				return -1
			end
		end
		if frame[9] == 1 then
			if 1 < frame[8] then
				return 0
			end
			event.set_gyorace_value(3, 2)
			at = 2
			if helper_12ddc() == -1 then
				return -1
			end
		end
		if frame[9] == 2 then
			if 2 < frame[8] then
				return 0
			end
			event.set_gyorace_value(3, 0)
		end
		event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
		event.set_object_handle_visible(8, 0)
		event.play_sound_effect(global0, 0)
		event.set_camera_sequence_position(-5.99, 55.55, -213.4)
		event.set_camera_sequence_look_at(0.0, 55.55, -471.19)
		at = 3
		wait_frames(30)
		event.move_camera_sequence(-5.99, 181.46, -213.4, 0.0, 181.46, -471.19, 180)
		at = 4
		wait_camera()
		event.stop_sound_effect(global0, 0)
		event.play_sound_effect(global0, 3)
		frame[6] = 1
		event.set_message_window_mode(1, 0)
		event.set_message_window_option(1, 7, 20, 100, 20, 128)
		event.set_message_window_option(1, 8, 0)
		frame[6] = 0
		frame[12] = 0
		frame[13] = 0
		frame[14] = 0
		frame[45] = event.get_language() or frame[45]
		if frame[45] == 1 then
			event.set_message_window_option(1, 2, 0.5)
		end
		while frame[6] < 6 do
			event.set_gyorace_value(5, 1, vm.i32(1 + frame[6]), frame[6])
			event.set_gyorace_value(6, 1, vm.i32(7 + frame[6]), frame[6])
			if frame[6] == frame[8] then
				frame[12] = 1
			else
				frame[7] = vm.float_bits(event.get_random_number(24)) or frame[7]
				while true do
					frame[46] = 0
					while frame[14] > frame[46] do
						if frame[vm.index(vm.i32(frame[46] + 14), 49)] == frame[7] then
							break
						else
							frame[46] = vm.i32(frame[46] + 1)
						end
					end
					if frame[14] == frame[46] then
						break
					else
						frame[7] = vm.float_bits(event.get_random_number(24)) or frame[7]
					end
				end
				frame[vm.index(vm.i32(frame[14] + 14), 49)] = frame[7]
				frame[14] = vm.i32(frame[14] + 1)
				if vm.i32(frame[6] + 1) <= 3 then
					if frame[13] == 0 then
						event.load_npc_character(0, 4, vm.i32(frame[7] + 1), 15)
					end
					if frame[13] == 1 then
						event.load_npc_character(0, 4, vm.i32(frame[7] + 1), 16)
					end
					frame[13] = vm.i32(frame[13] + 1)
				end
			end
			frame[6] = vm.i32(frame[6] + 1)
		end
		event.play_sound_effect(global0, 4)
		event.open_message_window_2(
			1,
			"          PUESTO      Nombre            Tiempo\n          ──────────────────────\n\n\n\n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
		)
		at = 5
		helper_6bc9eefc(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(global0, 4)
		event.open_message_window_2(
			1,
			"          Puesto      Nombre            Tiempo\n          ──────────────────────\n\n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
		)
		at = 6
		helper_6bc9eefc(1, -1, 4, 0, 0, 60)
		event.play_sound_effect(global0, 4)
		event.open_message_window_2(
			1,
			"          Puesto      Nombre            Tiempo\n          ──────────────────────\n          １  [文字列１]  [文字列７] \n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n                              "
		)
		at = 7
		helper_6bc9eefc(1, -1, 4, 0, 0, 90)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		event.set_character_rotation(16, 0.0, 0.0, 0.0)
		if frame[8] == 0 then
			event.set_character_active(1, 8)
			event.set_character_position(8, 0.0, 68.97, -470.0)
			event.set_save_flag(41, 1)
			event.set_character_position(15, 30.0, 20.0, -470.0)
			event.set_character_position(16, -30.0, 16.0, -470.0)
			event.set_character_position(0, 0.0, 36.0, -470.0)
			event.set_character_motion(0, "1位", 0)
		end
		if frame[8] == 1 then
			event.set_character_position(15, 0.0, 36.0, -470.0)
			event.set_character_position(16, -30.0, 16.0, -470.0)
			event.set_character_position(0, 30.0, 20.0, -470.0)
			event.set_character_motion(0, "2位", 0)
		end
		if frame[8] == 2 then
			event.set_character_position(15, 0.0, 36.0, -470.0)
			event.set_character_position(16, 30.0, 20.0, -470.0)
			event.set_character_position(0, -30.0, 16.0, -470.0)
			event.set_character_motion(0, "3位", 0)
		end
		event.set_character_active(15)
		event.set_character_active(16)
		event.set_camera_sequence_position(-1.26, 25.59, -336.37)
		event.set_camera_sequence_look_at(0.0, 36.39, -471.19)
		event.start_crossfade(60)
		at = 8
		wait_frames(90)
		event.set_object_handle_visible(8, 1)
		frame[49] = event.get_gyorace_value(2) or frame[49]
		do
			local out1, out2 = event.get_gyorace_value(4, frame[49], vm.i32(frame[8] + 1))
			frame[47] = out1 or frame[47]
			frame[48] = out2 or frame[48]
		end
		event.play_sound_effect(global1, 0)
		at = 9
		helper_772d6241(0, vm.i32(frame[8] + 1), frame[47], frame[48])
		event.add_inventory_item(frame[47], frame[48])
		at = 10
		helper_a87eb945(1)
		if frame[8] == 0 then
			event.set_gyorace_value(7)
		end
		event.fade_out_screen(30)
		at = 11
		wait_frames(30)
		if frame[45] == 1 then
			event.set_message_window_option(1, 2, -1)
		end
		event.set_character_active(0, 8)
		event.delete_character(15)
		event.delete_character(16)
		event.set_character_position(0, 126.15, 0.0, -376.23)
		event.set_character_rotation(0, 0.0, -2.88, 0.0)
		event.set_character_motion(0, "立ち", 0)
		event.set_camera_position(136.75, 46.57, -242.89)
		event.set_camera_look_at(101.62, 35.0, -367.91)
		event.fade_in_screen(30)
		at = 12
		wait_frames(30)
		return 1
	end, function(received: { any })
		if at <= 1 then
			return -1
		end
		if at <= 2 then
			return -1
		end
		if at <= 12 then
			if at <= 3 then
				helper_344d6cd8()
			end
			if at <= 4 then
				frame[6] = 1
				frame[6] = 0
				frame[12] = 0
				frame[13] = 0
				frame[14] = 0
				local _ = frame[45] == 1
				local _ = frame[6] < 6
				local _ = frame[6] == frame[8]
				frame[12] = 1
				frame[46] = 0
				local _ = frame[14] > frame[46]
				local _ = frame[vm.index(vm.i32(frame[46] + 14), 49)] == frame[7]
				frame[46] = vm.i32(frame[46] + 1)
				local _ = frame[14] == frame[46]
				frame[vm.index(vm.i32(frame[14] + 14), 49)] = frame[7]
				frame[14] = vm.i32(frame[14] + 1)
				local _ = vm.i32(frame[6] + 1) <= 3
				local _ = frame[13] == 0
				local _ = frame[13] == 1
				frame[13] = vm.i32(frame[13] + 1)
				frame[6] = vm.i32(frame[6] + 1)
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
				helper_c7fcb51a(0, vm.i32(frame[8] + 1), frame[47], frame[48])
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
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_14054()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local omake_flag: s32 = 0
	local var3: s32 = 0
	local var7: s32 = 0
	local var8: any = 0
	local var9: any = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local var14: s32 = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: s32 = 0
	local var20: s32 = 0
	local var21: any = 0
	var0 = event.get_triggered_event_data_2(13) or var0
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(0, "立ち", 0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no ~= 0 then
		event.open_message_window_2(0, "[UNI00bf]Quiere probar usted tambi[UNI00e9]n, se[UNI00f1]orita?")
		helper_1c04a0eb(var0, -1, 0, 0)
		event.open_message_window_2(0, "Gracias, pero no.<page>Esto es cosa de Max.")
		helper_0ffc2526(0, -1, 0, var0, 0)
		return
	end
	omake_flag = event.is_extra_mode() or omake_flag
	if omake_flag ~= 0 then
		event.open_event_menu(23, 0)
		vm.wait(3)
		event.fade_in_screen(15)
		do
			local out1, _, _, _ = event.get_menu_results_4()
			var3 = out1 or var3
		end
		if var3 == 1000 then
			event.fade_out_music(30)
			event.fade_out_screen(30)
			wait_frames(30)
			event.stop_music(0)
			helper_81437291()
		end
		return
	end
	var7 = event.get_gyorace_value(5) or var7
	if var7 >= 3 then
		event.open_message_window_2(0, "Y as[UNI00ed] acaba el Finny Frenzy.\n[UNI00a1]Espero veros la pr[UNI00f3]xima vez!")
		helper_1c04a0eb(var0, -1, 0, 0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait_frames(30)
		event.stop_music(0)
		event.set_menu_value(1)
		helper_fd981dba()
		event.fade_in_screen(30)
		event.jump_to_map_2(-1, "s45")
		vm.wait(7)
	end
	event.open_message_window_2(0, "Est[UNI00e1] a punto de empezar el Finny Frenzy.\n[UNI00bf]Quieres participar?")
	helper_1c04a0eb(var0, -1, 0, 0)
	while true do
		event.open_message_window_2(
			0,
			"Participar\n[UNI00bf]De qu[UNI00e9] se trata?\n[UNI00bf]Qu[UNI00e9] premios dan?\nNo, gracias"
		)
		var8 = helper_8aa6dccc(0, -1, 0, var0, 4, 3)
		if var8 == -1 or var8 == 3 then
			event.open_message_window_2(
				0,
				"Ver las carreras es divertido.\n[UNI00a1]Pero si compites se te dispara\nel coraz[UNI00f3]n de la emoci[UNI00f3]n!"
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			return
		end
		if var8 == 1 then
			event.open_message_window_2(
				0,
				"En cada torneo de Finny Frenzy\nhay 3 carreras.<page>Cuando un pez gana un premio,\nno puede participar en ninguna otra carrera\ndel mismo torneo."
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(
				0,
				'Habla conmigo y dime\nsi quieres participar. Luego elige\nel pez con el que quieras competir.<page>El pez debe estar en\nla "Pecera de preparaci[UNI00f3]n".'
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Cuando hayas elegido al pez, elige\nla categor[UNI00ed]a.<page>Escoge la m[UNI00e1]s apropiada,\ndesde Novato hasta Profesional, seg[UNI00fa]n el nivel\ndel pez.<page>Si un pez gana en\nuna categor[UNI00ed]a, s[UNI00f3]lo podr[UNI00e1] participar\nen la inmediatamente superior."
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Pero si un pez gana en la categor[UNI00ed]a\nProfesional, podr[UNI00e1] seguir\nparticipando en ella indefinidamente.<page>Luego, elige la pecera para\nhacer los [UNI00fa]ltimos preparativos antes de la carrera.<page>El agua de las peceras es\n,diferente e influir[UNI00e1] en\nel rendimiento del pez."
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(
				0,
				"Si metes un pez en una pecera\nque potencie sus habilidades, a lo mejor\nobtienes unos resultados sorprendentes.<page>Cuando hayas acabado con los preparativos,\ns[UNI00f3]lo habr[UNI00e1] que esperar al comienzo de la carrera.\nPonte c[UNI00f3]modo y anima a tu pez."
			)
			helper_1c04a0eb(var0, -1, 0, 0)
			event.open_message_window_2(
				0,
				"La competici[UNI00f3]n consta\nde dos eliminatorias m[UNI00e1]s la final.\nPara ganar un premio,<page>tu pez debe quedar 1[UNI00ba] en la 1[UNI00aa] eliminatoria,\n2[UNI00ba] o mejor en la 2[UNI00aa] eliminatoria\ny 3[UNI00ba] o mejor en la final.<page>Claro que lo m[UNI00e1]s conveniente es quedar\nprimero en todas las carreras.\n[UNI00a1]Suerte!"
			)
			helper_1c04a0eb(var0, -1, 0, 0)
		end
		if var8 == 2 then
			event.open_message_window_2(0, "Novato\nAficionado\nExperto\nProfesional")
			var9 = helper_8aa6dccc(0, -1, 0, var0, 4, 0)
			if var9 ~= -1 then
				event.open_message_window_2(0, "Los premios de esta carrera son...")
				helper_1c04a0eb(var0, -1, 0, 0)
				do
					local out1, out2 = event.get_gyorace_value(4, var9, 1)
					var10 = out1 or var10
					var13 = out2 or var13
				end
				do
					local out1, out2 = event.get_gyorace_value(4, var9, 2)
					var11 = out1 or var11
					var14 = out2 or var14
				end
				do
					local out1, out2 = event.get_gyorace_value(4, var9, 3)
					var12 = out1 or var12
					var15 = out2 or var15
				end
				helper_6a61b74b(var10, var13, var11, var14, var12, var15)
			end
		end
		if var8 == 0 then
			break
		end
	end
	var16 = event.get_gyorace_value(3) or var16
	var17 = event.get_message_window_option(0, 2) or var17
	if var17 < 1 then
		event.open_message_window_2(
			0,
			"[UNI00a1]Vaya! Parece que no tienes\nning[UNI00fa]n pez que valga.<page>Vuelve cuando hayas cogido\nalguno."
		)
		helper_1c04a0eb(var0, -1, 0, 0)
		return
	end
	var7 = event.get_gyorace_value(5) or var7
	event.set_message_number(0, 1, vm.i32(var7 + 1))
	event.open_message_window_2(0, "A por todas[数値１].\nElige un pez.")
	helper_1c04a0eb(var0, -1, 0, 0)
	while true do
		event.open_event_menu(15, 0)
		vm.wait(22)
		do
			local out1, out2, out3 = event.get_menu_results_3()
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		if var18 == -1 then
			return
		elseif var20 ~= 0 then
			event.open_message_window_2(0, "Ese pez ya ha ganado un premio.\nElige otro.")
			helper_1c04a0eb(var0, -1, 0, 0)
		else
			break
		end
	end
	if var16 == 0 then
		event.open_message_window_2(0, "Ahora elige una categor[UNI00ed]a.")
		helper_1c04a0eb(var0, -1, 0, 0)
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(0, "Novato\nAficionado\nExperto\nProfesional")
		event.set_message_selection_top_line(0, 0)
		var21 = helper_bac0e30d(0, -1, 8, 0, 0, 4, 0)
	else
		var21 = event.get_gyorace_value(2) or var21
	end
	event.set_message_window_mode(0, 1)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 0)
	event.set_message_window_option(0, 4, -1, -1)
	if var21 == -1 then
		return
	end
	if var21 == 0 and bit32.band(var19, 1) == 0 then
		event.open_message_window_2(
			0,
			"El pez ya ha ganado en la categor[UNI00ed]a Principiante.\n[UNI00bf]Por qu[UNI00e9] no pruebas en otra?"
		)
		helper_1c04a0eb(var0, -1, 0, 0)
		return
	end
	if var21 == 1 and bit32.band(var19, 2) == 0 then
		event.open_message_window_2(
			0,
			"El pez ya ha ganado en la categor[UNI00ed]a Aficionado.\n[UNI00bf]Por qu[UNI00e9] no pruebas en otra?"
		)
		helper_1c04a0eb(var0, -1, 0, 0)
		return
	end
	if var21 == 2 and bit32.band(var19, 4) == 0 then
		event.open_message_window_2(
			0,
			"El pez ya ha ganado en la categor[UNI00ed]a Experto.\n[UNI00bf]Por qu[UNI00e9] no pruebas en otra?"
		)
		helper_1c04a0eb(var0, -1, 0, 0)
		return
	end
	if var16 == 0 then
		event.set_gyorace_value(2, var21)
	end
	helper_12ddc()
	vm.wait(30)
end

--- Helper function.
local function helper_e3dc()
	local var1: s32 = 0
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local var4: s32 = 0
	local omake_flag: s32 = 0
	event.get_player_character_slot()
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, var1)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
	active_chr_no = event.get_playable_character() or active_chr_no
	var4 = event.get_chapter() or var4
	omake_flag = event.is_extra_mode() or omake_flag
	if var2 == 161 then
		if var4 < 6 then
			event.open_message_window_2(
				0,
				"[UNI00bf]Por qu[UNI00e9] no le ver[UNI00e1] mi mujer\nla gracia a esto? [UNI00a1]No hay nada mejor\nque el Finny Frenzy!"
			)
		else
			event.open_message_window_2(
				0,
				"Mi pez est[UNI00e1] entre los ganadores\nde la categor[UNI00ed]a profesional.<page>T[UNI00fa] f[UNI00ed]ate de m[UNI00ed], tambi[UNI00e9]n va a arrasar\nen esta carrera."
			)
		end
	end
	if var2 == 171 then
		event.open_message_window_2(
			0,
			"Yo he venido a buscar\na mi marido. Siempre est[UNI00e1] aqu[UNI00ed].<page>[UNI00a1]Oh! Qu[UNI00e9] emocionante parece esto..."
		)
	end
	if var2 == 169 then
		if omake_flag == 0 then
			event.open_message_window_2(
				0,
				"Los resultados de la carrera dependen\nen gran medida del calentamiento.\nElige bien la pecera.<page>Aunque, de todas formas, no conseguir[UNI00e1]s\nganar a mi equipo..."
			)
		else
			event.open_message_window_2(
				0,
				"[UNI00bf]T[UNI00fa] otra vez?\n[UNI00bf]Es que nunca aprendes?<page>Si quieres participar,\npor m[UNI00ed] vale, pero ten cuidado\ncon mi pez."
			)
		end
	end
	if var2 == 167 then
		if var4 < 7 then
			if active_chr_no ~= 1 then
				event.open_message_window_2(
					0,
					"Max, [UNI00bf]t[UNI00fa] no compites?\nSi participas, av[UNI00ed]same.\nTe animar[UNI00e9]."
				)
			else
				event.open_message_window_2(
					0,
					"M[UNI00f3]nica, [UNI00bf]t[UNI00fa] no compites?\nSi participas, av[UNI00ed]same.\nTe animar[UNI00e9]."
				)
			end
		elseif active_chr_no ~= 1 then
			event.open_message_window_2(
				0,
				"No me gusta el pescado.\n[UNI00a1]Vamos a casa!<page>[UNI00bf]Por qu[UNI00e9] a los mayores les\ngusta tanto esto? [UNI00bf]Max?"
			)
		else
			event.open_message_window_2(
				0,
				"No me gusta el pescado.\n[UNI00a1]Vamos a casa!<page>[UNI00bf]Por qu[UNI00e9] a los mayores les\ngusta tanto esto? [UNI00bf]M[UNI00f3]nica?"
			)
		end
	end
	if var2 == 166 then
		event.open_message_window_2(
			0,
			"Yo nunca apuesto, la verdad.<page>Es que mi novia insisti[UNI00f3] tanto que claro... Pero s[UNI00f3]lo por eso..."
		)
	end
	if var2 == 165 then
		if var4 < 7 then
			event.open_message_window_2(
				0,
				"No s[UNI00e9] por qu[UNI00e9], pero ver nadar\na los peces me pone el coraz[UNI00f3]n a cien.<page>Es como mi\nfuente de juventud particular."
			)
		else
			event.open_message_window_2(
				0,
				"Me he tra[UNI00ed]do a mi nieta conmigo.\n[UNI00bf]Pero d[UNI00f3]nde se ha metido esta criatura?<page>Es que te descuidas un momento..."
			)
		end
	end
	if var2 == 160 then
		event.open_message_window_2(
			0,
			"Mi pez brilla\ncon luz propia en las rectas.<page>[UNI00bf]Que cu[UNI00e1]l es?\nJi, ji...\nEs un secreto."
		)
	end
	if var2 == 172 then
		if omake_flag == 0 then
			event.open_message_window_2(
				0,
				"[UNI00a1]Mira qu[UNI00e9] escamas tiene el n[UNI00fa]mero 3!\n[UNI00a1]C[UNI00f3]mo brillan! [UNI00a1]Y qu[UNI00e9] lisas!<page>Tiene madera de ganador. [UNI00a1]Ya lo ver[UNI00e1]s!"
			)
		else
			event.open_message_window_2(
				0,
				"Yo s[UNI00f3]lo quer[UNI00ed]a probar por probar,\npero luego me enganch[UNI00e9].\nAhora no me pierdo ni una carrera.<page>(suspiro) La he fastidiado\nen el [UNI00fa]ltimo calentamiento..."
			)
		end
	end
	if var2 == 158 then
		if var4 < 7 then
			event.open_message_window_2(
				0,
				"Yo voy mucho de pesca con mi padre,\npero aqu[UNI00ed] hay montones de peces que no hab[UNI00ed]a visto nunca."
			)
		else
			event.open_message_window_2(
				0,
				"[UNI00a1]Guau! [UNI00a1]Mira qu[UNI00e9] peces\ntan bonitos! Corcho, [UNI00a1]ese parece\nun caballo!<page>[UNI00bf]Eh? [UNI00bf]D[UNI00f3]nde est[UNI00e1]s\nabuelo? [UNI00a1]Abuelito!"
			)
		end
	end
	if var2 == 159 then
		event.open_message_window_2(
			0,
			"Esto es la competici[UNI00f3]n Finny\nFrenzy.<page>[UNI00a1]Es el momento!\nQue se calmen los [UNI00e1]nimos..."
		)
	end
	if var2 == 162 then
		event.open_message_window_2(
			0,
			"Est[UNI00e1]s en las carreras Finny Frenzy.<page>[UNI00a1]Su[UNI00e9]ltate el pelo\ny disfruta!"
		)
	end
	if var2 == 168 then
		if omake_flag == 0 then
			event.open_message_window_2(
				0,
				"Para m[UNI00ed] todos los peces son iguales.\n[UNI00bf]C[UNI00f3]mo los diferencio?<page>Me fiar[UNI00e9] de lo que me diga\nel instinto."
			)
		else
			event.open_message_window_2(
				0,
				"El pez de mi novio corre\nen la siguiente carrera. [UNI00a1]Qu[UNI00e9]\nemoci[UNI00f3]n! [UNI00a1]Ya no aguanto m[UNI00e1]s!"
			)
		end
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
	event.set_save_control_bits(1, 1)
	helper_bc9be28d()
	event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
	event.set_object_handle_visible(8, 1)
	event.set_gyorace_value(7)
	event.set_character_position(0, 0.0, 0.0, 450.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.fade_in_screen(30)
	event.reset_follow_camera(1, 3.14)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.open_message_window_2(
		0,
		"Qu[UNI00e9] pena. Aunque tendr[UNI00ed]as que estar contento\nde haber llegado hasta la final. Te estar[UNI00e9]\nobservando la pr[UNI00f3]xima vez, [UNI00a1]sigue intent[UNI00e1]ndolo!"
	)
	helper_0ffc2526(0, -1, 24, 0, 0)
	global0 = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or global0
	global1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or global1
	event.set_character_position(0, 126.15, 0.0, -376.23)
	event.set_character_rotation(0, 0.0, -2.88, 0.0)
	event.set_character_motion(0, "立ち", 0)
	event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
	event.set_object_handle_visible(8, 0)
	event.play_sound_effect(global0, 0)
	event.set_camera_sequence_position(-5.99, 181.46, -213.4)
	event.set_camera_sequence_look_at(0.0, 181.46, -471.19)
	event.fade_in_screen(30)
	wait_frames(90)
	event.stop_sound_effect(global0, 0)
	event.play_sound_effect(global0, 3)
	event.set_message_window_mode(1, 0)
	event.set_message_window_option(1, 7, 20, 100, 20, 128)
	event.set_message_window_option(1, 8, 0)
	for var0 = 0, 5 do
		event.set_message_inserted_string(1, 1 + var0, "０１２３４５６７８９ ")
		event.set_message_inserted_string(1, 7 + var0, "９９：９９：９９")
	end
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"          PUESTO      Nombre            Tiempo\n          ──────────────────────\n\n\n\n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	helper_6bc9eefc(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"          Puesto      Nombre            Tiempo\n          ──────────────────────\n\n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	helper_6bc9eefc(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"          Puesto      Nombre            Tiempo\n          ──────────────────────\n          １  [文字列１]  [文字列７] \n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n                              "
	)
	show_message(1, -1, 4, 0, 0)
	event.fade_out_screen(30)
	wait_frames(35)
	event.delete_character_extension_packs(0)
	event.set_object_handle_visible(8, 1)
	event.fade_in_screen(30)
end

--- Event 202, which map data, a script or the engine runs by number.
function script.event_202()
	local omake_flag: s32 = 0
	local var1: s32 = 0
	local var2: any = 0
	omake_flag = event.is_extra_mode() or omake_flag
	var1 = event.get_gyorace_value(5) or var1
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	vm.wait(1)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	if omake_flag == 0 then
		if var1 <= 0 then
			event.open_message_window_2(0, "[UNI00bf]Salir de Finny Frenzy?")
		else
			event.open_message_window_2(0, "Si te vas, termina el Finny Frenzy.\n[UNI00bf]Seguro que quieres irte?")
		end
	else
		event.fade_out_screen(10)
		wait_frames(10)
		event.open_event_menu(26)
		vm.wait(3)
		event.fade_in_screen(10)
		event.open_message_window_2(0, "[UNI00bf]Volver a la pantalla de T[UNI00ed]tulo?")
	end
	var2 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
	event.set_message_window_mode(0, 1)
	if var2 == 0 then
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait_frames(30)
		event.stop_music(0)
		if 0 < var1 then
			event.set_menu_value(1)
		end
		helper_fd981dba()
		event.fade_in_screen(30)
		if omake_flag == 0 then
			event.jump_to_map_2(-1, "s45")
			vm.wait(6)
		else
			event.set_scene_exit_flag(1)
		end
	end
	return 1
end

--- Event 401, which map data, a script or the engine runs by number.
function script.event_401()
	print("---401----------------------------\n")
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	local var0: s32 = 0
	local var1: s32 = 0
	event.initialize_event()
	event.set_save_control_bits(1, 1)
	event.load_music(193)
	global0 = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or global0
	global1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or global1
	var0 = helper_1669c()
	event.play_music(0)
	if var0 == 0 then
		event.set_character_motion(0, "がっかりL", 0)
		var1 = event.get_gyorace_value(3) or var1
		if var1 == 0 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(0, "[UNI00a1]Qu[UNI00e9] mal!\nNo te rindas. [UNI00a1]Int[UNI00e9]ntalo otra vez!")
		end
		if var1 == 1 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(
				0,
				"[UNI00a1]Ah! La competencia es muy dura\nen la 2[UNI00aa] eliminatoria. Bueno, no importa.\nNo te rindas. [UNI00a1]Sigue intent[UNI00e1]ndolo!"
			)
		end
		if var1 == 2 then
			event.set_gyorace_value(3, 0)
			event.open_message_window_2(
				0,
				"Qu[UNI00e9] pena. Aunque tendr[UNI00ed]as que estar contento\nde haber llegado hasta la final. Te estar[UNI00e9]\nobservando la pr[UNI00f3]xima vez, [UNI00a1]sigue intent[UNI00e1]ndolo!"
			)
		end
		helper_0ffc2526(0, -1, 24, 0, 0)
	end
	event.delete_character_extension_packs(0)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	local var0: s32 = 0
	local language_code: s32 = 0
	event.set_save_control_bits(1, 1)
	event.initialize_event()
	event.load_music(193)
	helper_bc9be28d()
	global0 = event.load_sound_effect_file_3(5, "snd2/mon/en_903.sound.json") or global0
	global1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or global1
	event.set_character_position(0, 126.15, 0.0, -376.23)
	event.set_character_rotation(0, 0.0, -2.88, 0.0)
	event.set_character_motion(0, "立ち", 0)
	event.attach_object_handle_to_map_part_2(8, "p07_i03h04")
	event.set_object_handle_visible(8, 0)
	event.play_sound_effect(global0, 0)
	event.set_camera_sequence_position(-5.99, 181.46, -213.4)
	event.set_camera_sequence_look_at(0.0, 181.46, -471.19)
	event.fade_in_screen(30)
	wait_frames(90)
	event.stop_sound_effect(global0, 0)
	event.play_sound_effect(global0, 3)
	var0 = 1
	event.set_message_window_mode(1, 0)
	event.set_message_window_option(1, 7, 20, 100, 20, 128)
	event.set_message_window_option(1, 8, 0)
	var0 = 0
	language_code = event.get_language() or language_code
	if language_code == 1 then
		event.set_message_window_option(1, 2, 0.5)
	end
	while var0 < 6 do
		event.set_gyorace_value(5, 1, 1 + var0, var0)
		event.set_gyorace_value(6, 1, 7 + var0, var0)
		var0 = var0 + 1
	end
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"          PUESTO      Nombre            Tiempo\n          ──────────────────────\n\n\n\n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	helper_6bc9eefc(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"          Puesto      Nombre            Tiempo\n          ──────────────────────\n\n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n"
	)
	helper_6bc9eefc(1, -1, 4, 0, 0, 60)
	event.play_sound_effect(global0, 4)
	event.open_message_window_2(
		1,
		"          Puesto      Nombre            Tiempo\n          ──────────────────────\n          １  [文字列１]  [文字列７] \n\n          ２  [文字列２]  [文字列８] \n\n          ３  [文字列３]  [文字列９] \n\n          ４  [文字列４]  [文字列１０] \n\n          ５  [文字列５]  [文字列１１] \n\n          ６  [文字列６]  [文字列１２] \n                              "
	)
	show_message(1, -1, 4, 0, 0)
	event.fade_out_screen(30)
	wait_frames(35)
	event.play_music(0)
	if language_code == 1 then
		event.set_message_window_option(1, 2, -1)
	end
	event.delete_character_extension_packs(0)
	event.set_object_handle_visible(8, 1)
	event.fade_in_screen(30)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_triggered_event_data_2(13) or var0
		if var0 == 24 then
			at = 1
			helper_14054()
		else
			at = 2
			helper_e3dc()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_87260223()
			end
			return 0
		end
		return nil
	end)
end

return script
