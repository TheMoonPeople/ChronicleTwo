--!strict
-- map/g/g02/i02/g02i02_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4fba7aa8 = require("@lib/event/helper_4fba7aa8")
local helper_56b874f1 = require("@lib/event/helper_56b874f1")
local helper_76f23193 = require("@lib/event/helper_76f23193")
local helper_852ada6a = require("@lib/event/helper_852ada6a")
local helper_b2dff8b7 = require("@lib/event/helper_b2dff8b7")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_ca092b2d = require("@lib/event/helper_ca092b2d")
local helper_db96f504 = require("@lib/event/helper_db96f504")
local helper_df618068 = require("@lib/event/helper_df618068")
local helper_e118365e = require("@lib/event/helper_e118365e")
local helper_fb2f356e = require("@lib/event/helper_fb2f356e")
local show_message = require("@lib/event/show_message")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_281a4()
	local var0: s32 = 0
	local var1: s32 = 0
	local item: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		var0 = event.get_triggered_event_data_2(6) or var0
		if var0 == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, "Sembra che Lin stia male.\n(Premi (#) per accedere al Menu)")
			at = 1
			var1 = helper_c292fa16(0, -1, 5, 0, 0, var1)
			if var1 == 1 then
				var0 = 2
			end
		end
		if var0 == 2 then
			event.open_use_item_menu(364)
			at = 2
			vm.wait(2)
			item = vmhost.used_item() or item
			if item == 364 then
				event.set_function_point_enabled("", "syumai", 0)
				event.set_function_point_enabled("", "event_550", 0)
				at = 3
				helper_ca092b2d()
				at = 4
				helper_db96f504()
				at = 5
				vm.wait(5)
				now_party_chara_id = event.get_party_npc() or now_party_chara_id
				var4 = event.get_npc_party_status(now_party_chara_id) or var4
				if bit32.band(var4, 4) ~= 0 then
					event.set_npc_party_status(now_party_chara_id, 4)
				else
					event.set_npc_party_status(now_party_chara_id, 2)
				end
				event.set_npc_party_status(26, 128)
				event.set_npc_party_status(26, 1)
			elseif item > 0 then
				at = 6
				helper_df618068()
			end
		end
		return
	end, function(received: { any })
		if at <= 6 then
			if at == 1 then
				var1 = received[2] :: number
			end
			if at <= 1 then
				local _ = var0 == 1
				var0 = 2
			end
			if at <= 2 then
				at = 3
				helper_ca092b2d()
				return vm.continue_with(function()
					at = 4
					helper_db96f504()
					at = 5
					vm.wait(5)
					now_party_chara_id = event.get_party_npc() or now_party_chara_id
					var4 = event.get_npc_party_status(now_party_chara_id) or var4
					if bit32.band(var4, 4) ~= 0 then
						event.set_npc_party_status(now_party_chara_id, 4)
					else
						event.set_npc_party_status(now_party_chara_id, 2)
					end
					event.set_npc_party_status(26, 128)
					event.set_npc_party_status(26, 1)
					return
				end)
			end
			if at <= 3 then
				helper_852ada6a()
			end
			if at <= 5 then
				helper_4fba7aa8()
			end
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_56b874f1

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local now_party_chara_id: s32 = 0
	local var7: s32 = 0
	helper_56b874f1()
	flag = event.get_save_flag(300) or flag
	flag_2 = event.get_save_flag(304) or flag_2
	flag_3 = event.get_save_flag(306) or flag_3
	flag_4 = event.get_save_flag(324) or flag_4
	flag_5 = event.get_save_flag(328) or flag_5
	event.get_save_flag(330)
	if flag == 1 then
		if flag_2 == 0 then
			helper_fb2f356e()
			return
		else
			now_party_chara_id = event.get_party_npc() or now_party_chara_id
			if flag_3 == 0 and now_party_chara_id == 6 then
				helper_e118365e()
				event.set_npc_party_status(6, 2)
				event.skip_next_music_load()
				event.jump_to_map_3(-1, "g02", 503)
				vm.wait(3)
				return
			end
			if flag_4 == 1 and flag_5 == 0 then
				helper_b2dff8b7()
				return
			end
		end
	end
	var7 = event.get_sound_id(2) or var7
	event.play_sound_effect(var7, 61)
	event.set_character_position(0, 8.0, 0.0, 120.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	local now_party_chara_id: s32 = 0
	helper_db96f504()
	vm.wait(2)
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	event.set_npc_party_status(now_party_chara_id, 2)
	event.set_npc_party_status(26, 128)
	event.set_npc_party_status(26, 1)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local now_map_no: s32 = 0
	now_map_no = event.get_current_map() or now_map_no
	if now_map_no == 1 then
		event.go_to_outside_map(-1, "g02", 100)
	else
		event.jump_to_map_3(-1, "g02", 100)
	end
	vm.wait(1)
end

--- Event 500, which map data, a script or the engine runs by number.
script.event_500 = helper_281a4

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	local player_chara: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local flag: s32 = 0
	print("550-------------------------------------------------")
	event.fade_out_screen(1)
	vm.wait(1)
	event.initialize_event()
	event.set_camera_position(9.08, 28.93, -152.07)
	event.set_camera_look_at(11.2, 18.91, -112.52)
	event.fade_in_screen(15)
	player_chara = event.get_player_character_slot() or player_chara
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	do
		local out1, _, out3 = event.get_character_position(player_chara)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	var5 = vm.f32(9.52)
	var7 = vm.f32(-125.12)
	var8 = event.get_look_angle(var5 - var2, var7 - var4) or var8
	helper_76f23193(player_chara, var8)
	event.set_character_rotation(player_chara, 0.0, var8, 0.0)
	event.set_character_motion(player_chara, "立ち")
	flag = event.get_save_flag(306) or flag
	if flag == 0 then
		event.open_message_window_2(0, "Ooooh...\nNnnnn... ahhhh...")
	else
		event.open_message_window_2(0, "Ohhh, ohhh...")
	end
	show_message(0, -1, 4, 256, 312)
	event.fade_out_screen(15)
	wait_frames(15)
	event.reset_follow_camera(1, 3.1415927)
	event.finish_event()
	event.fade_in_screen(15)
end

--- Event 551, which map data, a script or the engine runs by number.
function script.event_551()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	print("551-------------------------------------------------")
	player_chara = event.get_player_character_slot() or player_chara
	var1 = 24
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	do
		local out1, _, out3 = event.get_character_position(player_chara)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	do
		local out1, _, out3 = event.get_character_position(var1)
		var5 = out1 or var5
		var7 = out3 or var7
	end
	var8 = event.get_look_angle(var5 - var2, var7 - var4) or var8
	helper_76f23193(player_chara, var8)
	event.set_character_rotation(player_chara, 0.0, var8, 0.0)
	event.set_character_motion(player_chara, "立ち")
	flag = event.get_save_flag(356) or flag
	if flag ~= 0 then
		event.open_message_window_2(
			0,
			"Lin [UNI00e8] andata a studiare, huu. Ha\ndetto che torner[UNI00e0] solo quando\nsar[UNI00e0] diventata un vero saggio.<page>Ma come si pu[UNI00f2] stabilire\nquando si diventa saggi?<page>Non mi interessa se diventa saggia\noppure no. Voglio solo che torni\na casa prima possibile. Huu."
		)
	else
		flag_2 = event.get_save_flag(330) or flag_2
		if flag_2 ~= 0 then
			event.open_message_window_2(0, "Prendetevi cura di Lin, d'accordo?\nE fate attenzione, huu.")
		else
			flag_3 = event.get_save_flag(324) or flag_3
			if flag_3 ~= 0 then
				event.open_message_window_2(0, "Sbrigati!<page>Dammi uno gnocco,\npresto! Huu!")
			else
				flag_4 = event.get_save_flag(317) or flag_4
				if flag_4 ~= 0 then
					event.open_message_window_2(0, "Non avete ancora trovato\nil Piatto miracoloso?")
					helper_0ffc2526(0, -1, var1, player_chara, 0)
					event.open_message_window_2(0, "Idioti, huu, incapaci!\nSiete dei buoni a nulla, huu!")
				else
					flag_5 = event.get_save_flag(320) or flag_5
					if flag_5 ~= 0 then
						event.open_message_window_2(0, 'Ancora non avete il, huu,\n "Fiore Biancovento"?')
						helper_0ffc2526(0, -1, var1, player_chara, 0)
						event.open_message_window_2(0, "Idioti, huu, incapaci!\nSiete dei buoni a nulla, huu!")
					else
						flag_6 = event.get_save_flag(306) or flag_6
						if flag_6 ~= 0 then
							event.open_message_window_2(0, "Huu! Il Bistrot di Lao Chao\nnon [UNI00e8] stato ancora ricostruito?")
							helper_0ffc2526(0, -1, var1, player_chara, 0)
							event.open_message_window_2(0, "Idioti, huu, incapaci!\nSiete dei buoni a nulla, huu!")
						else
							event.open_message_window_2(0, "Un dottore, presto! Huu!\nChiamate subito un dottore, huu!")
						end
					end
				end
			end
		end
	end
	helper_0ffc2526(0, -1, var1, player_chara, 0)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local player_chara: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	print("KITA-------------------------------\n")
	var0 = event.get_triggered_event_data_2(13) or var0
	player_chara = event.get_player_character_slot() or player_chara
	do
		local out1, _, out3 = event.get_character_position(player_chara)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	do
		local out1, _, out3 = event.get_character_position(var0)
		var5 = out1 or var5
		var7 = out3 or var7
	end
	var8 = event.get_look_angle(var5 - var2, var7 - var4) or var8
	helper_76f23193(player_chara, var8)
	event.set_character_rotation(player_chara, 0.0, var8, 0.0)
	event.set_character_motion(player_chara, "立ち")
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Salve.\nTempo stupendo, vero?")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
end

--- Event 13040, which map data, a script or the engine runs by number.
function script.event_13040()
	event.set_save_flag(304, 0)
	event.set_save_flag(306, 0)
	event.set_save_flag(324, 0)
	event.set_save_flag(330, 0)
	helper_56b874f1()
	helper_fb2f356e()
end

--- Event 13060, which map data, a script or the engine runs by number.
function script.event_13060()
	event.set_save_flag(304, 1)
	event.set_save_flag(306, 0)
	event.set_save_flag(324, 0)
	event.set_save_flag(330, 0)
	event.set_npc_party_status(6, 128)
	event.set_npc_party_status(6, 1)
	helper_56b874f1()
	helper_e118365e()
	event.jump_to_map_3(-1, "g02", 503)
	vm.wait(2)
end

--- Event 13280, which map data, a script or the engine runs by number.
function script.event_13280()
	event.set_save_flag(304, 1)
	event.set_save_flag(306, 1)
	event.set_save_flag(324, 1)
	event.set_save_flag(330, 0)
	helper_56b874f1()
	helper_b2dff8b7()
end

--- Event 13300, which map data, a script or the engine runs by number.
function script.event_13300()
	event.set_save_flag(324, 1)
	event.set_save_flag(330, 0)
	helper_56b874f1()
	helper_ca092b2d()
end

return script
