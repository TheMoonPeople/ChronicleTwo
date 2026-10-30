--!strict
-- dungeon/act_script/c01a.stb: action script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47e6f5ef = require("@lib/action/helper_47e6f5ef")
local helper_9da84b8b = require("@lib/action/helper_9da84b8b")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")
local helper_c97ab93c = require("@lib/action/helper_c97ab93c")
local helper_cc6c712f = require("@lib/action/helper_cc6c712f")
local helper_d6400fa5 = require("@lib/action/helper_d6400fa5")
local helper_eb0c92cb = require("@lib/action/helper_eb0c92cb")

--- Helper function.
local function helper_17d8()
	local var0: s32 = 0
	local var1: s32 = 0
	local prog: s32 = 0
	local var4: f32 = 0
	local acumu_pad: s32 = 0
	prog = action.get_program_value() or prog
	if prog == 100 then
		action.play_motion("5連続攻撃1", -1, 6)
		var4 = action.get_motion_progress() or var4
		if var4 >= vm.f32(0.143) and var4 <= vm.f32(0.429) then
			action.set_move_impulse(0.6, 0.0, 1)
		end
		if var4 >= vm.f32(0.714) and var4 <= 1.0 then
			action.set_move_impulse(0.8, 0.0, 1)
		end
		acumu_pad = action.get_charge_steps() or acumu_pad
		if acumu_pad > 12 then
			action.reset_charge_steps()
			action.set_program_value(1200)
			return
		end
		if var4 >= vm.f32(0.514) and var4 <= vm.f32(0.571) then
			var0 = action.get_button_history() or var0
			if var0 ~= 0 then
				action.play_motion("5連続攻撃2", -1, 6)
				action.call_command(93) -- retail: the handler rejects 0 arguments
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
		if var4 >= 0.0 and var4 <= vm.f32(0.409) then
			action.set_move_impulse(0.93, 0.0, 1)
		end
		if var4 >= vm.f32(0.518) and var4 <= vm.f32(0.573) then
			var0 = action.get_button_history() or var0
			if var0 ~= 0 then
				action.play_motion("5連続攻撃3", -1, 6)
				action.call_command(93) -- retail: the handler rejects 0 arguments
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
	if prog == 102 then
		var1 = action.get_motion_status() or var1
		var4 = action.get_motion_progress() or var4
		if var4 >= 0.0 and var4 <= 0.375 then
			action.set_move_impulse(0.63, 0.0, 1)
		end
		if var4 >= vm.f32(0.675) and var4 <= 1.0 then
			action.set_move_impulse(0.6, 0.0, 1)
		end
		if var4 >= 0.5 and var4 <= vm.f32(0.55) then
			var0 = action.get_button_history() or var0
			if var0 ~= 0 then
				action.play_motion("5連続攻撃4", -1, 6)
				action.call_command(93) -- retail: the handler rejects 0 arguments
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
		if var4 >= 0.0 and var4 <= vm.f32(0.339) then
			action.set_move_impulse(0.787, 0.0, 1)
		end
		if var4 >= vm.f32(0.47) and var4 <= vm.f32(0.522) then
			var0 = action.get_button_history() or var0
			if var0 ~= 0 then
				action.play_motion("5連続攻撃5", -1, 6)
				action.call_command(93) -- retail: the handler rejects 0 arguments
				action.set_program_value(prog + 1)
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
		if var4 >= 0.0 and var4 <= vm.f32(0.24) then
			action.set_move_impulse(0.85, 0.0, 1)
		end
		if var4 >= vm.f32(0.7) and var4 <= 1.0 then
			action.set_move_impulse(0.4, 0.0, 1)
		end
		var1 = action.get_motion_status() or var1
		if var1 == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Helper function.
local function helper_320c()
	local var0: s32 = 0
	local prog: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	var2 = action.get_button_state_2(56) or var2
	var3 = action.get_button_state_2(53) or var3
	prog = action.get_program_value() or prog
	if prog == 800 then
		action.run_aim_movement("銃狙う", "銃回転")
		if var3 ~= 0 then
			if var2 ~= 0 then
				action.play_motion("発砲", -1, 6)
				action.set_murderous(1, 3)
				action.set_program_value(prog + 1)
			end
		else
			action.set_program_value(0)
		end
		return
	end
	if prog == 801 then
		action.play_motion("発砲", -1, 6)
		var4 = action.get_motion_progress() or var4
		if var4 > vm.f32(0.3) and var4 < vm.f32(0.4) then
			action.fire_shot(6, "n_gun", 2, 5)
		end
		var0 = action.get_motion_status() or var0
		if var0 == 4 then
			action.play_motion("銃狙う", -1, 4)
			action.set_program_value(prog - 1)
		end
	end
end

--- Helper function.
local function helper_376c()
	local result: s32 = 0
	local prog: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local hold_type: s32 = 0
	local var7: f32 = 0
	var2 = action.get_button_state_2(50) or var2
	var3 = action.get_button_state_2(56) or var3
	var4 = action.get_button_state_2(54) or var4
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
		action.play_motion("ガードループ", -1, 4)
		if var3 ~= 0 then
			action.play_motion("持ち上げ", -1, 2)
			action.set_guarding(0)
			action.set_program_value(prog + 1)
			action.set_invulnerable_time(10)
			print("-- CATCH --\n")
		end
		if var4 == 0 then
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
			action.play_motion("投げ", -1, 6)
			action.set_program_value(prog + 1)
			action.call_command(93) -- retail: the handler rejects 0 arguments
			return
		end
		return
	end
	if prog == 904 then
		action.play_motion("投げ", -1, 6)
		var7 = action.get_motion_progress() or var7
		if var7 >= vm.f32(0.289) then
			print(vm.float(var7), "\n")
			action.release_held_object(1)
		end
		result = vm.float_bits(action.is_motion_finished()) or result
		if result ~= 0 then
			action.set_program_value(0)
		end
		return
	end
end

--- Helper function.
local function helper_4574()
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
				return
			end
			action.set_program_value(0)
		end
		return
	end
	if prog == 1102 then
		action.run_carry_movement()
		if var2 ~= 0 then
			action.play_motion("投げ", -1, 6)
			action.set_program_value(prog + 1)
			action.call_command(93) -- retail: the handler rejects 0 arguments
		end
		return
	end
	if prog == 1103 then
		action.play_motion("投げ", -1, 6)
		var5 = action.get_motion_progress() or var5
		if var5 >= vm.f32(0.289) then
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
	action.add_object_frame(0, "dcol00")
	action.add_object_frame(1, "ef00")
	action.add_object_frame(2, "bcol00")
	action.add_object_frame(3, "bcol01")
	action.add_object_frame(4, "keri_R")
	action.add_object_frame(5, "nage")
	action.add_object_frame(6, "gun")
	action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.0, "5連続攻撃1", 0.37, 0.48)
	action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.1, "5連続攻撃2", 0.4, 0.5)
	action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.1, "5連続攻撃3", 0.375, 0.47)
	action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.15, "5連続攻撃4", 0.33, 0.443)
	action.add_motion_damage("dcol00", "dcol01", "ユリス剣強攻撃", 4.0, 1.2, "5連続攻撃5", 0.3, 0.4)
	action.add_motion_damage("dcol00", "dcol01", "ミンツ剣攻撃", 4.0, 1.2, "中距離攻撃", 0.5, 0.85)
	action.add_motion_damage("dcol00", "dcol01", "ユリス溜め攻撃", 15.0, 1.6, "ため攻撃", 0.24, 0.52)
	action.add_motion_damage("keri_R", "", "ミンツ剣攻撃", 4.0, 0.8, "ダウン･蹴り", 0.35, 0.45)
	action.add_body_collision(2, 5.0)
	action.add_body_collision(3, 4.0)
	action.add_sword_effect(0, "5連続攻撃1", 0.34, 0.37, "dcol00", "dcol01", 77, 16, 10)
	action.add_sword_effect(0, "5連続攻撃2", 0.23, 0.26, "dcol00", "dcol01", 77, 12, 12)
	action.add_sword_effect(0, "5連続攻撃3", 0.27, 0.29, "dcol00", "dcol01", 77, 10, 12)
	action.add_sword_effect(0, "5連続攻撃4", 0.33, 0.36, "dcol00", "dcol01", 77, 10, 10)
	action.add_sword_effect(0, "5連続攻撃5", 0.26, 0.28, "dcol00", "dcol01", 77, 12, 15)
	action.add_sword_effect(0, "中距離攻撃", 0.28, 0.32, "dcol00", "dcol01", 77, 10, 16)
	action.set_charge_effect_object(0, 2)
	action.add_motion_sound(-2, "歩き", 0.07, 0.1)
	action.add_motion_sound(-3, "歩き", 0.5, 0.55)
	action.add_motion_sound(-2, "走り", 0.4, 0.5)
	action.add_motion_sound(-3, "走り", 0.9, 1.0)
	action.add_motion_sound(400, "3連続レンチ1", 0.1, 0.2)
	action.add_motion_sound(401, "3連続レンチ2", 0.1, 0.3)
	action.add_motion_sound(402, "3連続レンチ3", 0.2, 0.3)
	action.add_motion_sound(403, "銃攻撃", 0.2, 0.3)
	action.add_motion_sound(400, "中距離攻撃", 0.3, 0.4)
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
	local var7: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local status: s32 = 0
	local var11: s32 = 0
	local hold_type: s32 = 0
	local used_item_action: s32 = 0
	local acumu_pad: s32 = 0
	action.set_program_value(0)
	while true do
		prog = action.get_program_value() or prog
		var1 = action.get_button_state_2(50) or var1
		var2 = action.get_button_state_2(54) or var2
		var3 = action.get_button_state_2(53) or var3
		var4 = action.get_button_state_2(51) or var4
		if prog >= 100 and prog < 199 then
			helper_17d8()
			if var1 ~= 0 then
				var5 = action.is_stick_pointing_back() or var5
				if var5 ~= 0 then
					prog = 1300
					action.set_program_value(prog)
				end
			end
			if var3 ~= 0 then
				var6 = action.get_equipped_item(1) or var6
				if var6 > 0 then
					prog = 800
					action.set_program_value(prog)
				end
			end
			if var2 ~= 0 then
				prog = 900
				action.set_program_value(prog)
			end
		end
		if prog >= 200 and prog < 299 then
			helper_eb0c92cb()
		end
		if prog >= 1200 and prog < 1299 then
			helper_d6400fa5()
		end
		if prog >= 1300 and prog < 1399 then
			helper_cc6c712f()
		end
		if prog >= 300 and prog < 399 then
			action.call_command(93) -- retail: the handler rejects 0 arguments
			helper_47e6f5ef()
		end
		if prog >= 800 and prog < 899 then
			helper_320c()
		end
		if prog >= 900 and prog < 999 then
			helper_376c()
		end
		if prog >= 1000 and prog < 1099 then
			helper_c97ab93c()
		end
		if prog >= 1100 and prog < 1199 then
			helper_4574()
		end
		prog = action.get_program_value() or prog
		if prog == 0 then
			action.run_movement()
			if var1 ~= 0 then
				var7 = action.is_stick_pointing_back() or var7
				if var7 ~= 0 then
					prog = 1300
				else
					var8 = action.get_stick_facing_alignment() or var8
					var9 = action.get_target_distance() or var9
					if var8 > vm.f32(0.85) and (var9 > 40.0 and var9 < 100.0) then
						action.call_command(93) -- retail: the handler rejects 0 arguments
						prog = 200
						action.set_murderous(0, 3)
					else
						status = action.get_target_status() or status
						if status == 1 then
							action.call_command(93) -- retail: the handler rejects 0 arguments
							prog = 300
						else
							action.call_command(93) -- retail: the handler rejects 0 arguments
							action.set_murderous(0, 3)
							prog = 100
						end
					end
				end
				action.reset_button_history()
			end
			if var3 ~= 0 then
				var11 = action.get_equipped_item(1) or var11
				if var11 > 0 then
					prog = 800
				end
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
			if acumu_pad > 12 then
				action.reset_charge_steps()
				prog = 1200
			end
			action.set_program_value(prog)
		end
		vm.wait()
	end
end

--- Reacts to a small hit.
function script.on_small_damage()
	action.start_knockback(5.0, 0.0, 3)
	action.release_held_object(0)
	action.play_motion("ダメージ", -1, 2)
	helper_bac4ec65(4)
	action.set_program_value(0)
end

--- Reacts to a large hit.
function script.on_large_damage()
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
	action.set_move_impulse(0.0, 0.0, 0)
	action.play_motion("ガード後", -1, 2)
	result = 0
	while result == 0 do
		vm.wait()
		result = vm.float_bits(action.is_motion_finished()) or result
	end
end

--- Runs the character's death.
function script.on_death()
	local var0: s32 = 0
	action.release_held_object(0)
	action.play_motion("死に", -1, 6)
	while true do
		var0 = action.get_button_state_2(50) or var0
		if var0 ~= 0 then
			break
		else
			vm.wait()
		end
	end
	action.set_program_value(0)
end

return script
