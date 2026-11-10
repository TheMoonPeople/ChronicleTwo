--!strict
-- map/i/i01/h01/i01h01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_24bece14 = require("@lib/event/helper_24bece14")
local helper_3936899e = require("@lib/event/helper_3936899e")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_7428e09f = require("@lib/event/helper_7428e09f")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_d61bc810 = require("@lib/event/helper_d61bc810")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local set_window_mode = require("@lib/event/set_window_mode")

--- Helper function.
local function helper_e6e4(arg0: s32, arg1: any)
	local flag: s32 = 0
	local var3: s32 = 0
	local player_chara: s32 = 0
	local var5: any = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	event.set_character_motion(0, "立ち", 0)
	helper_888ab2a3(9)
	flag = event.get_save_flag(7) or flag
	if flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		set_window_mode(0, 1)
		helper_4e93f9fc(arg0, 0, 0)
		player_chara = event.get_player_character_slot() or player_chara
		event.open_message_window_2(0, "スティーブの調子はどうじゃ？")
		helper_0ffc2526(0, -1, arg0, player_chara, 0)
		event.set_character_motion(arg0, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "ねんりょう補給\nコアのパワーアップ")
		var5 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_bubble_tail(0, 1)
		if var5 == 0 then
			event.set_save_data_value(2)
			event.open_message_window_2(0, "よし、これで\n修理完了じゃ！")
			helper_0ffc2526(0, -1, arg0, player_chara, 0)
		end
		if var5 == 1 then
			event.fade_out_screen(25)
			helper_888ab2a3(30)
			event.open_event_menu(6, 23)
			vm.wait(7)
			event.fade_in_screen(25)
		end
		event.set_villager_ai_enabled(1, 24)
		return
	end
	flag = event.get_save_flag(107) or flag
	if flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		event.open_message_window_2(
			0,
			"こんなことであきらめるのか？\nなにごともネバーギブアップじゃ。"
		)
		helper_1c04a0eb(arg0, -1, 0, 0)
		event.set_villager_ai_enabled(1, 24)
		return
	end
	flag = event.get_save_flag(20) or flag
	if flag == 1 then
		vm.wait(9)
		event.load_event_script("i01h01/i01h01c.stb", 500)
		return
	end
	var3 = event.get_item_count(165) or var3
	if var3 > 0 then
		event.set_save_flag(20, 1)
		vm.wait(10)
		event.load_event_script("i01h01/i01h01b.stb", 520)
		return
	end
	argc = event.get_item_count(224) or argc
	argc_2 = event.get_item_count(245) or argc_2
	argc_3 = event.get_item_count(227) or argc_3
	var3 = event.is_invention_created(165) or var3
	if argc >= 20 and argc_2 >= 1 and argc_3 >= 2 and var3 ~= -1 then
		vm.wait(11)
		event.load_event_script("i01h01/i01h01b.stb", 520)
		return
	end
	flag = event.get_save_flag(19) or flag
	if flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		event.open_message_window_2(
			0,
			"ここをでて、目の前にあるかぼちゃの\nかんばんの店がアイテム屋じゃ。<page>鉄クズ２０個、銅のかたまり２個、\nそれとぶあつい皮じゃぞ。\n早く買ってくるのじゃ。"
		)
		helper_1c04a0eb(arg0, -1, 0, 0)
		event.set_villager_ai_enabled(1, 24)
		return
	end
	var3 = event.is_invention_created(165) or var3
	if var3 ~= -1 then
		vm.wait(13)
		event.load_event_script("i01h01/i01h01b.stb", 520)
		return
	end
	var3 = event.has_invention_ideas(165) or var3
	if var3 == 1 then
		vm.wait(14)
		event.load_event_script("i01h01/i01h01b.stb", 520)
		return
	end
	flag = event.get_save_flag(17) or flag
	if flag == 1 then
		vm.wait(15)
		event.load_event_script("i01h01/i01h01b.stb", 510)
		return
	end
	flag = event.get_save_flag(105) or flag
	if flag == 0 then
		event.open_message_window_2(0, "ユリス、バイトをサボるんじゃないぞ。\nわかったな！")
		helper_1c04a0eb(arg0, -1, 0, 0)
		return
	end
	event.set_villager_ai_enabled(0, 24)
	event.open_message_window_2(0, "まずは自分の力で、\nやってみるのじゃ。")
	helper_1c04a0eb(arg0, -1, 0, 0)
	event.open_message_window_2(0, "どうしても解らなければ、\nヒントをだしてやる。")
	helper_1c04a0eb(arg0, -1, 0, 0)
	event.open_message_window_2(0, "さあ、行け！")
	helper_1c04a0eb(arg0, -1, 0, 0)
	event.set_villager_ai_enabled(1, 24)
end

--- Helper function.
local function helper_fbd4()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.set_message_window_mode(0, 1)
	var0 = event.get_triggered_event_data_2(13) or var0
	var1 = event.get_triggered_event_data_2(14) or var1
	print("[talk_chara]", var1, "\n")
	print("[talk_chara_id]", var1, "\n")
	if var1 == 1 then
		helper_e6e4(var0, var1)
	end
	if var1 == -1 then
		flag = event.get_save_flag(6) or flag
		flag_2 = event.get_save_flag(7) or flag_2
		if flag == 1 and flag_2 == 0 then
			vm.wait(2)
			event.load_event_script("i01h01/i01h01c.stb", 520)
		end
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	print("i01h01--------start event----------\n")
	helper_7428e09f()
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	event.load_event_script("i01h01/i01h01c.stb", 151)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	flag = event.get_save_flag(18) or flag
	if flag == 1 then
		flag = event.get_save_flag(17) or flag
		if flag == 0 then
			event.play_music(0)
			event.set_save_flag(17, 1)
		end
	end
	flag_2 = event.get_save_flag(105) or flag_2
	flag_3 = event.get_save_flag(109) or flag_3
	flag = event.get_save_flag(56) or flag
	if flag_2 ~= 0 and flag_3 == 0 and flag == 0 then
		event.skip_next_music_load()
	end
	event.fade_out_screen(1)
	vm.wait(1)
	event.fade_in_screen(30)
	vm.wait(2)
	event.go_to_outside_map(-1, "m01")
	vm.wait(3)
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_24bece14()
	event.set_function_point_enabled("", "fc_event_e108c", 0)
	print("e105a i01h01.stb-------------------\n")
	event.load_event_script("i01h01/i01h01b.stb", 500)
	vm.wait(1)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	local at: number = 0
	return vm.guard(function()
		helper_24bece14()
		event.load_character(4, "event/e100/e105/e105_steve.gltf", "info", 25)
		event.set_character_active(1, 25)
		event.set_character_active(0, 24)
		event.set_character_position(25, -120.88, -13.05, -215.36)
		event.set_character_rotation(25, 0.0, 0.0, 0.0)
		at = 1
		vm.wait(1)
		print("スティーブ読み込んだ-------------\n")
		event.load_event_script("i01h01/i01h01c.stb", 510)
		print("いべんとe108b--------------\n")
		at = 2
		vm.wait(2)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				print("スティーブ読み込んだ-------------\n")
				print("いべんとe108b--------------\n")
			end
			return 0
		end
		return nil
	end)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	helper_24bece14()
	event.load_event_script("i01h01/i01h01c.stb", 520)
	vm.wait(1)
end

--- Event 590, which map data, a script or the engine runs by number.
function script.event_590()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_triggered_event_data_4(10)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.delay_object_sequence_motion_track(0, 10)
	event.set_object_sequence_motion(0, "立ち")
	event.turn_object_sequence_toward(0, var0, var1, var2, 10)
	helper_888ab2a3(10)
	helper_f38eabca(386, 1)
	event.add_inventory_item(386)
	helper_d61bc810(1)
	helper_24bece14()
end

--- Event 610, which map data, a script or the engine runs by number.
function script.event_610()
	print("event_610-------\n")
	helper_24bece14()
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		at = 1
		vm.wait(1)
		at = 2
		helper_fbd4()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_3936899e()
			end
			return 0
		end
		return nil
	end)
end

--- Event 11051, which map data, a script or the engine runs by number.
function script.event_11051()
	vm.wait(1)
	event.load_event_script("i01h01/i01h01b.stb", 500)
	vm.wait(2)
end

--- Event 11052, which map data, a script or the engine runs by number.
function script.event_11052()
	helper_7428e09f()
	event.set_character_active(1, 25)
	vm.wait(1)
	event.load_event_script("i01h01/i01h01b.stb", 510)
	vm.wait(2)
end

--- Event 11053, which map data, a script or the engine runs by number.
function script.event_11053()
	helper_7428e09f()
	event.set_save_flag(20, 0)
	event.set_character_active(1, 25)
	vm.wait(1)
	event.load_event_script("i01h01/i01h01b.stb", 11053)
	vm.wait(2)
end

--- Event 11060, which map data, a script or the engine runs by number.
function script.event_11060()
	helper_7428e09f()
	event.set_character_active(1, 25)
	vm.wait(1)
	event.load_event_script("i01h01/i01h01c.stb", 500)
	vm.wait(2)
end

--- Event 11083, which map data, a script or the engine runs by number.
function script.event_11083()
	event.set_party_member(2, 1)
	event.set_save_flag(25, 1)
	event.set_save_flag(108, 0)
	event.set_save_flag(103, 1)
	event.set_save_flag(107, 1)
	event.set_save_flag(7, 0)
	event.set_save_flag(6, 1)
	vm.wait(1)
	event.load_event_script("i01h01/i01h01c.stb", 520)
	vm.wait(2)
end

return script
