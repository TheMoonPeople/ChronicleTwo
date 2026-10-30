--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_b3ede7cc = require("@lib/event/helper_b3ede7cc")

--- Helper function.
local function helper_d216348b()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local active_chr_no_2: s32 = 0
	local var5: s32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 then
		event.set_character_motion(0, "故障", 6)
		event.initialize_effect_manager(5)
		event.load_effect_base("ロボ故障")
		event.create_effect_work_buffer(5)
	end
	var1 = event.get_event_sound_bank(4) or var1
	event.stop_sound_effect(var1, 0)
	event.set_dungeon_pause_flags(17, 1)
	event.create_effect("ロボ故障")
	var2 = event.get_active_music_number() or var2
	var3 = vm.bits_float(event.get_music_master_volume()) or var3
	event.stop_music(0)
	event.start_background_file_loads_1("snd2/bgm/bg_060.sound.json")
	helper_888ab2a3(4)
	helper_479dc9e9()
	event.load_music_pack(60)
	event.play_music(0)
	active_chr_no_2 = event.get_playable_character() or active_chr_no_2
	helper_b3ede7cc(active_chr_no_2)
	if active_chr_no == 2 or active_chr_no == 3 then
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.clear_effect_manager()
		event.open_dungeon_character_change_menu(-1)
		vm.wait(5)
	else
		var5 = event.is_e3_version() or var5
		if var5 == 1 then
			event.fade_out_screen(30)
			helper_888ab2a3(30)
			event.set_scene_exit_flag(1)
			return
		else
			event.run_dungeon_debug_command(0)
		end
	end
	event.stop_music(0)
	event.clear_effect_manager()
	event.set_dungeon_pause_flags(17, 1)
	helper_888ab2a3(4)
	event.load_music(var2)
	event.play_music(0)
	event.set_music_master_volume(var3)
	event.play_sound_effect(var1, 0)
	event.set_dungeon_pause_flags(17, 0)
	event.finish_event()
end

return helper_d216348b
