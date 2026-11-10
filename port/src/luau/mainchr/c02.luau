--!strict
-- mainchr/c02.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_21d040f0 = require("@lib/action/helper_21d040f0")
local helper_2ec4bb16 = require("@lib/action/helper_2ec4bb16")
local helper_969ab7e3 = require("@lib/action/helper_969ab7e3")
local helper_9d1f223a = require("@lib/action/helper_9d1f223a")
local helper_9da84b8b = require("@lib/action/helper_9da84b8b")
local helper_b1d92b97 = require("@lib/action/helper_b1d92b97")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")
local helper_c97ab93c = require("@lib/action/helper_c97ab93c")
local helper_de5acdcc = require("@lib/action/helper_de5acdcc")
local helper_dea24da5 = require("@lib/action/helper_dea24da5")

local global0: s32 = 0
local global1: f32 = 0
local global2: s32 = 0

--- Helper function.
local function helper_2ec()
	action.set_guarding(0)
	if global0 ~= -1 then
		action.delete_effect(global0)
	end
end

--- Helper function.
local function helper_7ef8()
	local var0: s32 = 0
	local var1: s32 = 0
	local prog: s32 = 0
	local var4: f32 = 0
	local acumu_pad: s32 = 0
	local var6: f32 = 0
	prog = action.get_program_value() or prog
	if prog == 100 then
		action.play_motion("5剣1", -1, 6)
		var4 = action.get_motion_progress() or var4
		if var4 >= 0.0 and var4 <= vm.f32(0.3) then
			action.set_move_impulse(0.8, 0.0, 1)
		end
		acumu_pad = action.get_charge_steps() or acumu_pad
		if acumu_pad > 10 then
			action.reset_charge_steps()
			action.set_program_value(1200)
			return
		end
		if var4 >= vm.f32(0.35) and var4 <= vm.f32(0.7) then
			var0 = action.get_button_history() or var0
			if var0 ~= 0 then
				action.play_motion("5剣2", -1, 6)
				action.turn_toward_target(40.0, 2.0)
				action.set_program_value(prog + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			var1 = action.get_motion_status() or var1
			if var1 == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 101 then
		var1 = action.get_motion_status() or var1
		var4 = action.get_motion_progress() or var4
		if var4 >= 0.0 and var4 <= vm.f32(0.4) then
			action.set_move_impulse(1.5, 0.0, 1)
		end
		if var4 >= 0.5 and var4 <= vm.f32(0.8) then
			var0 = action.get_button_history() or var0
			if var0 ~= 0 then
				var6 = action.get_stick_facing_alignment() or var6
				if var6 > vm.f32(0.6) then
					action.play_motion("ふっとばし", -1, 6)
					action.turn_toward_target(40.0, 2.0)
					action.set_program_value(105)
				else
					action.play_motion("5剣3", -1, 6)
					action.turn_toward_target(40.0, 2.0)
					action.set_program_value(prog + 1)
					action.reset_button_history()
					action.set_murderous(0, 3)
				end
			end
		else
			var1 = action.get_motion_status() or var1
			if var1 == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 102 then
		var1 = action.get_motion_status() or var1
		var4 = action.get_motion_progress() or var4
		if var4 >= 0.0 and var4 <= vm.f32(0.49) then
			action.set_move_impulse(1.5, 0.0, 1)
		end
		if var4 >= vm.f32(0.45) and var4 <= vm.f32(0.72) then
			var0 = action.get_button_history() or var0
			if var0 ~= 0 then
				action.play_motion("5剣4", -1, 6)
				action.turn_toward_target(40.0, 2.0)
				action.set_program_value(prog + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			var1 = action.get_motion_status() or var1
			if var1 == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 103 then
		var1 = action.get_motion_status() or var1
		var4 = action.get_motion_progress() or var4
		if var4 >= 0.0 and var4 <= vm.f32(0.19) then
			action.set_move_impulse(0.3, 0.0, 1)
		end
		if var4 >= vm.f32(0.22) and var4 <= vm.f32(0.77) then
			action.set_move_impulse(1.0, 0.0, 1)
		end
		if var4 >= vm.f32(0.35) and var4 <= vm.f32(0.57) then
			var0 = action.get_button_history() or var0
			if var0 ~= 0 then
				action.play_motion("5剣5", -1, 6)
				action.turn_toward_target(40.0, 2.0)
				action.set_program_value(prog + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			var1 = action.get_motion_status() or var1
			if var1 == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 104 then
		var4 = action.get_motion_progress() or var4
		if var4 >= 0.0 and var4 <= 0.5 then
			action.set_move_impulse(1.2, 0.0, 1)
		end
		if var4 >= vm.f32(0.66) and var4 <= 1.0 then
			action.set_move_impulse(0.825, 0.0, 1)
		end
		var1 = action.get_motion_status() or var1
		if var1 == 4 then
			action.set_program_value(0)
		end
		return
	end
	if prog == 105 then
		var1 = action.get_motion_status() or var1
		var4 = action.get_motion_progress() or var4
		if var4 >= vm.f32(0.15) and var4 <= 0.5 then
			action.set_move_impulse(1.8, 0.0, 1)
		end
		var1 = action.get_motion_status() or var1
		if var1 == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Helper function.
local function helper_9c64()
	local var0: s32 = 0
	local prog: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: s32 = 0
	local var15: s32 = 0
	local var16: s32 = 0
	var2 = action.get_button_state_2(53) or var2
	var3 = action.get_button_state_2(50) or var3
	prog = action.get_program_value() or prog
	if prog == 800 then
		action.run_aim_movement("魔法狙う", "魔法回転")
		do
			local out1, out2, out3 = action.get_object_position("item")
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		action.set_effect_first_vector(global0, var4, var5, var6)
		global1 = vm.f32(global1 + vm.f32(0.008333334))
		if global1 >= vm.f32(1.3) then
			global1 = vm.f32(1.3)
		end
		if var2 ~= 0 then
			if var3 ~= 0 then
				action.play_motion("発動", -1, 6)
				action.set_program_value(prog + 1)
			end
		else
			action.set_program_value(0)
			action.delete_effect(global0)
		end
		return
	end
	if prog == 801 then
		action.play_motion("発動", -1, 6)
		do
			local out1, out2, out3 = action.get_object_position("item")
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		action.set_effect_first_vector(global0, var7, var8, var9)
		var10 = action.get_motion_progress() or var10
		if var10 >= 0.25 and var10 < vm.f32(0.3) then
			action.fire_shot(6, "spell01", 2, 5, global1)
			action.finish_effect(global0)
			global1 = vm.f32(0.8)
			return
		end
		if (if var2 ~= 0 then var3 else 0) ~= 0 and var10 > vm.f32(0.65) then
			action.reset_motion()
			action.set_program_value(801)
			return
		end
		var0 = action.get_motion_status() or var0
		if var0 == 4 then
			action.play_motion("魔法狙う", -1, 4)
			do
				local out1, out2, out3 = action.get_object_position("item")
				var11 = out1 or var11
				var12 = out2 or var12
				var13 = out3 or var13
			end
			global0 = action.create_effect_2("モニカ魔法－溜め") or global0
			action.set_effect_first_vector(global0, var11, var12, var13)
			do
				local out1, out2, out3 = action.get_ring_color()
				var14 = out1 or var14
				var15 = out2 or var15
				var16 = out3 or var16
			end
			action.set_effect_second_vector(global0, var14, var15, var16)
			global1 = vm.f32(0.8)
			action.set_program_value(prog - 1)
		end
	end
end

--- Helper function.
local function helper_a6e8()
	local result: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local prog: s32 = 0
	local var5: f32 = 0
	local hold_type: s32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	var3 = action.get_button_state_2(53) or var3
	var1 = action.get_button_state_2(54) or var1
	var2 = action.get_button_state_2(50) or var2
	prog = action.get_program_value() or prog
	if prog == 900 then
		action.play_motion("ガード入り", -1, 6)
		action.set_guarding(1)
		vm.wait()
		result = vm.float_bits(action.is_motion_finished()) or result
		if result ~= 0 then
			action.set_program_value(prog + 1)
		end
		return
	end
	if prog == 901 then
		action.run_aim_movement("ガードループ", "ガードばたばた")
		if (if var3 ~= 0 then var1 else 0) ~= 0 then
			action.set_guarding(0)
			action.set_program_value(910)
			action.play_motion("5剣1", -1, 6)
			return
		end
		if var2 ~= 0 then
			action.play_motion("持ち上げ", -1, 2)
			action.set_guarding(0)
			action.set_program_value(prog + 1)
			action.set_invulnerable_time(10)
		end
		if var1 == 0 then
			action.set_guarding(0)
			action.set_program_value(0)
		end
		return
	end
	if prog == 902 then
		action.play_motion("持ち上げ", -1, 2)
		var5 = action.get_motion_progress() or var5
		if var5 >= vm.f32(0.14) and var5 < vm.f32(0.233) then
			action.catch_or_kick("nage")
		end
		vm.wait()
		result = vm.float_bits(action.is_motion_finished()) or result
		if result ~= 0 then
			hold_type = action.get_held_object_type() or hold_type
			if hold_type == 3 or hold_type == 4 then
				action.set_program_value(prog + 1)
			else
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 903 then
		action.run_carry_movement()
		if var2 ~= 0 then
			action.set_program_value(prog + 1)
			action.turn_toward_target(40.0, 2.0)
		end
		return
	end
	if prog == 904 then
		action.play_motion("投げ", -1, 6)
		vm.wait()
		var7 = action.get_motion_progress() or var7
		if var7 >= vm.f32(0.3) then
			action.release_held_object(1)
		end
		result = vm.float_bits(action.is_motion_finished()) or result
		if result ~= 0 then
			action.set_program_value(0)
		end
		return
	end
	if prog == 910 then
		var8 = action.get_motion_progress() or var8
		if global2 == 1 then
			if var8 >= vm.f32(0.35) and var8 <= vm.f32(0.45) then
				action.fire_magic_sword_shot("dcol01")
			end
		elseif var8 >= vm.f32(0.39) and var8 <= vm.f32(0.42) then
			action.fire_magic_sword_shot("dcol01")
		end
		result = vm.float_bits(action.is_motion_finished()) or result
		if result ~= 0 then
			action.set_program_value(900)
		end
		return
	end
end

--- Helper function.
local function helper_b818()
	local result: s32 = 0
	local prog: s32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local hold_type: s32 = 0
	local var5: f32 = 0
	var2 = action.get_button_state_2(50) or var2
	prog = action.get_program_value() or prog
	if prog == 1100 then
		action.play_motion("持ち上げ", -1, 6)
		action.set_program_value(prog + 1)
		action.set_invulnerable_time(10)
	end
	if prog == 1101 then
		action.play_motion("持ち上げ", -1, 2)
		var3 = action.get_motion_progress() or var3
		if var3 >= vm.f32(0.14) and var3 < vm.f32(0.233) then
			action.catch_or_kick("nage")
		end
		vm.wait()
		result = vm.float_bits(action.is_motion_finished()) or result
		if result ~= 0 then
			hold_type = action.get_held_object_type() or hold_type
			if hold_type == 3 or hold_type == 4 then
				action.set_program_value(prog + 1)
			else
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 1102 then
		action.run_carry_movement()
		if var2 ~= 0 then
			action.play_motion("投げ", -1, 6)
			action.set_program_value(prog + 1)
			action.turn_toward_target(40.0, 2.0)
		end
		return
	end
	if prog == 1103 then
		action.play_motion("投げ", -1, 6)
		vm.wait()
		var5 = action.get_motion_progress() or var5
		if var5 >= vm.f32(0.333) then
			action.release_held_object(1)
		end
		result = vm.float_bits(action.is_motion_finished()) or result
		if result ~= 0 then
			action.set_program_value(0)
		end
		return
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the character up when its script is initialised.
function script.init()
	action.reset_script_entries_0()
	global2 = 0
	global2 = action.get_weapon_model_number() or global2
	global0 = -1
	global1 = 0.0
	action.add_object_frame(0, "dcol01")
	action.add_object_frame(1, "dcol00")
	action.add_object_frame(2, "bcol00")
	action.add_object_frame(3, "bcol01")
	action.add_object_frame(4, "keri_R")
	action.add_object_frame(6, "item")
	if global2 == 0 then
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "5剣1", 0.36, 0.478)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣2", 0.265, 0.371)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.12, "5剣3", 0.27, 0.45)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.15, "5剣4", 0.397, 0.503)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.25, "5剣5", 0.31, 0.45)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.4, "ふっとばし", 0.54, 0.65)
	end
	if global2 == 1 then
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣1", 0.34, 0.53)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.15, "5剣2", 0.21, 0.36)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.2, "5剣3", 0.36, 0.5)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.35, "5剣4", 0.4, 0.52)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.6, "ふっとばし", 0.38, 0.58)
	end
	if global2 == 2 then
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "5剣1", 0.3, 0.48)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "5剣2", 0.27, 0.41)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣3", 0.36, 0.53)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣4", 0.38, 0.54)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.15, "5剣5", 0.25, 0.45)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.2, "5剣6", 0.35, 0.52)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "ふっとばし", 0.14, 0.45)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.3, "ふっとばし", 0.54, 0.65)
	end
	if global2 == 3 then
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "5剣1", 0.225, 0.405)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "5剣2", 0.36, 0.54)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣3", 0.327, 0.45)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.14, "5剣4", 0.257, 0.386)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.3, "5剣5", 0.379, 0.521)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "ふっとばし", 0.173, 0.312)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "ふっとばし", 0.329, 0.415)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.2, "ふっとばし", 0.433, 0.502)
	end
	action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.2, "中距離攻撃", 0.35, 0.46)
	action.add_motion_damage("dcol02", "", "モニカ溜め攻撃", 20.0, 1.2, "ため攻撃", 0.62, 0.72)
	action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 0.8, "ダウン･剣", 0.46, 0.533)
	if global2 == 0 then
		action.add_sword_effect(0, "5剣1", 0.3, 0.33, "dcol00", "dcol01", 77, 10, 16)
		action.add_sword_effect(0, "5剣2", 0.23, 0.26, "dcol00", "dcol01", 77, 4, 12)
		action.add_sword_effect(0, "5剣3", 0.27, 0.3, "dcol00", "dcol01", 77, 5, 12)
		action.add_sword_effect(0, "5剣4", 0.39, 0.42, "dcol00", "dcol01", 77, 5, 10)
		action.add_sword_effect(0, "5剣5", 0.3, 0.33, "dcol00", "dcol01", 77, 12, 20)
		action.add_sword_effect(0, "ふっとばし", 0.2, 0.25, "dcol00", "dcol01", 77, 20, 20)
	end
	if global2 == 1 then
		action.add_sword_effect(0, "5剣1", 0.3, 0.34, "dcol00", "dcol01", 77, 10, 12)
		action.add_sword_effect(0, "5剣2", 0.12, 0.18, "dcol00", "dcol01", 77, 12, 12)
		action.add_sword_effect(0, "5剣3", 0.33, 0.36, "dcol00", "dcol01", 77, 12, 12)
		action.add_sword_effect(0, "ふっとばし", 0.42, 0.45, "dcol00", "dcol01", 77, 20, 20)
	end
	if global2 == 2 then
		action.add_sword_effect(0, "5剣1", 0.26, 0.3, "dcol00", "dcol01", 77, 5, 12)
		action.add_sword_effect(0, "5剣2", 0.24, 0.3, "dcol00", "dcol01", 77, 10, 12)
		action.add_sword_effect(0, "5剣3", 0.22, 0.3, "dcol00", "dcol01", 77, 10, 12)
		action.add_sword_effect(0, "5剣4", 0.25, 0.32, "dcol00", "dcol01", 77, 10, 10)
		action.add_sword_effect(0, "5剣5", 0.25, 0.32, "dcol00", "dcol01", 77, 10, 10)
		action.add_sword_effect(0, "5剣6", 0.33, 0.35, "dcol00", "dcol01", 77, 12, 20)
		action.add_sword_effect(0, "ふっとばし", 0.2, 0.25, "dcol00", "dcol01", 77, 20, 20)
	end
	if global2 == 3 then
		action.add_sword_effect(0, "5剣1", 0.18, 0.26, "dcol00", "dcol01", 77, 8, 10)
		action.add_sword_effect(0, "5剣2", 0.27, 0.32, "dcol00", "dcol01", 77, 12, 12)
		action.add_sword_effect(0, "5剣3", 0.24, 0.3, "dcol00", "dcol01", 77, 8, 10)
		action.add_sword_effect(0, "5剣4", 0.13, 0.19, "dcol00", "dcol01", 77, 10, 12)
		action.add_sword_effect(0, "5剣5", 0.07, 0.13, "dcol00", "dcol01", 77, 12, 20)
		action.add_sword_effect(0, "ふっとばし", 0.2, 0.28, "dcol00", "dcol01", 77, 20, 20)
	end
	action.add_sword_effect(0, "中距離攻撃", 0.28, 0.31, "dcol00", "dcol01", 77, 10, 30)
	action.add_sword_effect(0, "勝利のポーズ", 0.1, 0.2, "dcol00", "dcol01", 77, 50, 30)
end

--- Puts the character back into its normal state.
function script.reset()
	helper_2ec()
	action.release_held_object(0)
end

--- Runs the character's normal behaviour.
function script.loop()
	local prog: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local status: s32 = 0
	local hold_type: s32 = 0
	local used_item_action: s32 = 0
	local acumu_pad: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: s32 = 0
	local var24: s32 = 0
	local var25: s32 = 0
	action.set_program_value(0)
	while true do
		prog = action.get_program_value() or prog
		var1 = action.get_button_state_2(50) or var1
		var2 = action.get_button_state_2(54) or var2
		var3 = action.get_button_state_2(53) or var3
		var4 = action.get_button_state_2(51) or var4
		var5 = action.is_battle_paused_2(8192) or var5
		if var5 ~= 0 then
			while true do
				action.run_movement()
				vm.wait()
			end
		end
		if prog >= 100 and prog < 199 then
			if global2 == 0 then
				helper_9d1f223a()
			end
			if global2 == 1 then
				helper_2ec4bb16()
			end
			if global2 == 2 then
				helper_21d040f0()
			end
			if global2 == 3 then
				helper_7ef8()
			end
			action.apply_slow_status()
			if var1 ~= 0 then
				var6 = action.is_stick_pointing_back() or var6
				if var6 ~= 0 then
					prog = 1300
					action.set_program_value(prog)
				end
			end
			if var2 ~= 0 then
				prog = 900
				action.set_program_value(prog)
			end
			if var3 ~= 0 then
				action.set_murderous(1, 3)
				do
					local out1, out2, out3 = action.get_object_position("item")
					var7 = out1 or var7
					var8 = out2 or var8
					var9 = out3 or var9
				end
				global0 = action.create_effect_2("モニカ魔法－溜め") or global0
				action.set_effect_first_vector(global0, var7, var8, var9)
				do
					local out1, out2, out3 = action.get_ring_color()
					var10 = out1 or var10
					var11 = out2 or var11
					var12 = out3 or var12
				end
				action.set_effect_second_vector(global0, var10, var11, var12)
				global1 = vm.f32(0.8)
				prog = 800
				action.set_program_value(prog)
			end
		end
		if prog >= 200 and prog < 299 then
			helper_969ab7e3()
		end
		if prog >= 1300 and prog < 1399 then
			helper_dea24da5()
			prog = 0
			var1 = 0
		end
		if prog >= 1200 and prog < 1299 then
			helper_de5acdcc()
		end
		if prog >= 300 and prog < 399 then
			action.turn_toward_target(40.0, 2.0)
			helper_b1d92b97()
		end
		if prog >= 800 and prog < 899 then
			helper_9c64()
			action.apply_slow_status()
		end
		if prog >= 900 and prog < 999 then
			helper_a6e8()
			action.apply_slow_status()
		end
		if prog >= 1000 and prog < 1099 then
			helper_c97ab93c()
			action.apply_slow_status()
		end
		if prog >= 1100 and prog < 1199 then
			helper_b818()
			action.apply_slow_status()
		end
		prog = action.get_program_value() or prog
		if prog == 0 then
			action.run_movement()
			if var1 ~= 0 then
				var13 = action.is_stick_pointing_back() or var13
				if var13 ~= 0 then
					prog = 1300
				else
					var14 = action.get_stick_facing_alignment() or var14
					var15 = action.get_target_distance() or var15
					if var14 > vm.f32(0.85) and var15 > 40.0 and var15 < 100.0 then
						action.turn_toward_target(40.0, 2.0)
						prog = 200
						action.set_murderous(0, 3)
					else
						status = action.get_target_status() or status
						if status == 1 and var15 < 28.0 then
							action.turn_toward_target(40.0, 2.0)
							prog = 300
						else
							action.turn_toward_target(40.0, 2.0)
							prog = 100
							action.set_murderous(0, 3)
						end
					end
				end
				action.reset_button_history()
			end
			if var2 ~= 0 then
				prog = 900
			end
			if (if var2 ~= 0 then var1 else 0) ~= 0 then
				prog = 1100
			end
			if var4 ~= 0 then
				hold_type = action.get_held_object_type() or hold_type
				if hold_type == 0 then
					used_item_action = action.use_active_item() or used_item_action
					if used_item_action == 3 then
						prog = 1100
					end
					if used_item_action == 2 then
						prog = 1000
					end
				end
			end
			acumu_pad = action.get_charge_steps() or acumu_pad
			if acumu_pad > 10 then
				action.reset_charge_steps()
				prog = 1200
			end
			if var3 ~= 0 then
				prog = 800
				action.set_murderous(1, 3)
				do
					local out1, out2, out3 = action.get_object_position("item")
					var20 = out1 or var20
					var21 = out2 or var21
					var22 = out3 or var22
				end
				global0 = action.create_effect_2("モニカ魔法－溜め") or global0
				action.set_effect_first_vector(global0, var20, var21, var22)
				do
					local out1, out2, out3 = action.get_ring_color()
					var23 = out1 or var23
					var24 = out2 or var24
					var25 = out3 or var25
				end
				action.set_effect_second_vector(global0, var23, var24, var25)
				global1 = vm.f32(0.8)
				action.set_menu_allowed(0)
			end
			action.set_program_value(prog)
		end
		vm.wait()
	end
end

--- Reacts to a small hit.
function script.on_small_damage()
	helper_2ec()
	action.start_knockback(5.0, 0.0, 3)
	action.release_held_object(0)
	action.play_motion("ダメージ", -1, 2)
	helper_bac4ec65(8)
	action.set_program_value(0)
end

--- Holds the character in place.
function script.on_hold()
	local attributes: s32 = 0
	helper_2ec()
	action.start_knockback(0.0, 0.0, 3)
	action.release_held_object(0)
	action.play_motion("ダメージ", -1, 6)
	attributes = 40
	while bit32.band(attributes, 40) ~= 0 do
		action.set_menu_allowed(1)
		vm.wait()
		attributes = action.get_status_conditions() or attributes
	end
	action.set_program_value(0)
end

--- Reacts to a large hit.
function script.on_large_damage()
	helper_2ec()
	action.start_knockback(4.5, 0.04, 26)
	action.face_against_knockback()
	action.release_held_object(0)
	action.play_motion("吹っ飛び", -1, 6)
	helper_9da84b8b()
	helper_bac4ec65(10)
	action.play_motion("起き上がり", -1, 6)
	helper_9da84b8b()
	helper_bac4ec65(2)
	action.set_program_value(0)
end

--- Follows up a melee hit that the character has landed.
function script.on_melee_hit()
	local result: s32 = 0
	helper_2ec()
	action.start_knockback(0.0, 0.0, 0)
	action.play_motion("ガード後", -1, 2)
	result = 0
	while result == 0 do
		vm.wait()
		result = vm.float_bits(action.is_motion_finished()) or result
	end
end

--- Runs the character's death.
function script.on_death()
	helper_2ec()
	action.release_held_object(0)
	action.play_motion("死に", -1, 6)
	action.set_program_value(0)
end

--- Lands the character after a fall.
function script.on_land()
	helper_2ec()
	action.release_held_object(0)
	helper_9da84b8b()
	action.play_motion("バトル立ち")
	vm.wait()
end

return script
