--!strict
--- Variant of Monica's action script handling sword combos, spell casting, guarding, catching and throwing for three weapon models.

local vm = require("@lib/vm")
local attack = require("@lib/action/attack")
local movement = require("@lib/action/movement")
local timing = require("@lib/action/timing")

local charge_effect: s32 = 0
local spell_charge: f32 = 0
local weapon_model_number: s32 = 0

--- Clears the guarding state and deletes the spell charge effect if one exists.
local function stop_guarding_and_delete_charge_effect()
	action.set_guarding(0)
	if charge_effect ~= -1 then
		action.delete_effect(charge_effect)
	end
end

--- Aims the staff, charges the spell effect and fires the spell when the cast motion reaches its release point.
local function aim_and_cast_spell()
	local motion_status: s32 = 0
	local program_value: s32 = 0
	local is_aim_held: s32 = 0
	local is_cast_pressed: s32 = 0
	local aim_staff_x: f32 = 0
	local aim_staff_y: f32 = 0
	local aim_staff_z: f32 = 0
	local cast_staff_x: f32 = 0
	local cast_staff_y: f32 = 0
	local cast_staff_z: f32 = 0
	local motion_progress: f32 = 0
	local recharge_staff_x: f32 = 0
	local recharge_staff_y: f32 = 0
	local recharge_staff_z: f32 = 0
	local recharge_ring_red: s32 = 0
	local recharge_ring_green: s32 = 0
	local recharge_ring_blue: s32 = 0
	is_aim_held = action.get_button_state_2(53) or is_aim_held
	is_cast_pressed = action.get_button_state_2(50) or is_cast_pressed
	program_value = action.get_program_value() or program_value
	if program_value == 800 then
		action.run_aim_movement("魔法狙う", "魔法回転")
		do
			local out1, out2, out3 = action.get_object_position("item")
			aim_staff_x = out1 or aim_staff_x
			aim_staff_y = out2 or aim_staff_y
			aim_staff_z = out3 or aim_staff_z
		end
		action.set_effect_first_vector(charge_effect, aim_staff_x, aim_staff_y, aim_staff_z)
		spell_charge = vm.f32(spell_charge + vm.f32(0.008333334))
		if spell_charge >= vm.f32(1.3) then
			spell_charge = vm.f32(1.3)
		end
		if is_aim_held ~= 0 then
			if is_cast_pressed ~= 0 then
				action.play_motion("発動", -1, 6)
				action.set_program_value(program_value + 1)
			end
		else
			action.set_program_value(0)
			action.delete_effect(charge_effect)
		end
		return
	end
	if program_value == 801 then
		action.play_motion("発動", -1, 6)
		do
			local out1, out2, out3 = action.get_object_position("item")
			cast_staff_x = out1 or cast_staff_x
			cast_staff_y = out2 or cast_staff_y
			cast_staff_z = out3 or cast_staff_z
		end
		action.set_effect_first_vector(charge_effect, cast_staff_x, cast_staff_y, cast_staff_z)
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= 0.25 and motion_progress < vm.f32(0.3) then
			action.fire_shot(6, "spell01", 2, 5, spell_charge)
			action.finish_effect(charge_effect)
			spell_charge = vm.f32(0.8)
			return
		end
		if (if is_aim_held ~= 0 then is_cast_pressed else 0) ~= 0 and motion_progress > vm.f32(0.65) then
			action.reset_motion()
			action.set_program_value(801)
			return
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.play_motion("魔法狙う", -1, 4)
			do
				local out1, out2, out3 = action.get_object_position("item")
				recharge_staff_x = out1 or recharge_staff_x
				recharge_staff_y = out2 or recharge_staff_y
				recharge_staff_z = out3 or recharge_staff_z
			end
			charge_effect = action.create_effect_2("モニカ魔法－溜め") or charge_effect
			action.set_effect_first_vector(charge_effect, recharge_staff_x, recharge_staff_y, recharge_staff_z)
			do
				local out1, out2, out3 = action.get_ring_color()
				recharge_ring_red = out1 or recharge_ring_red
				recharge_ring_green = out2 or recharge_ring_green
				recharge_ring_blue = out3 or recharge_ring_blue
			end
			action.set_effect_second_vector(charge_effect, recharge_ring_red, recharge_ring_green, recharge_ring_blue)
			spell_charge = vm.f32(0.8)
			action.set_program_value(program_value - 1)
		end
	end
end

--- Runs the guard stance, the magic sword shot from guard, and catching and throwing an object.
local function run_guard_catch_and_throw()
	local is_motion_finished: s32 = 0
	local is_guard_held: s32 = 0
	local is_attack_held: s32 = 0
	local is_aim_held: s32 = 0
	local program_value: s32 = 0
	local catch_progress: f32 = 0
	local held_object_type: s32 = 0
	local throw_progress: f32 = 0
	local sword_progress: f32 = 0
	is_aim_held = action.get_button_state_2(53) or is_aim_held
	is_guard_held = action.get_button_state_2(54) or is_guard_held
	is_attack_held = action.get_button_state_2(50) or is_attack_held
	program_value = action.get_program_value() or program_value
	if program_value == 900 then
		action.play_motion("ガード入り", -1, 6)
		action.set_guarding(1)
		vm.wait()
		is_motion_finished = vm.float_bits(action.is_motion_finished()) or is_motion_finished
		if is_motion_finished ~= 0 then
			action.set_program_value(program_value + 1)
		end
		return
	end
	if program_value == 901 then
		action.run_aim_movement("ガードループ", "ガードばたばた")
		if (if is_aim_held ~= 0 then is_guard_held else 0) ~= 0 then
			action.set_guarding(0)
			action.set_program_value(910)
			action.play_motion("5剣1", -1, 6)
			return
		end
		if is_attack_held ~= 0 then
			action.play_motion("持ち上げ", -1, 2)
			action.set_guarding(0)
			action.set_program_value(program_value + 1)
			action.set_invulnerable_time(10)
		end
		if is_guard_held == 0 then
			action.set_guarding(0)
			action.set_program_value(0)
		end
		return
	end
	if program_value == 902 then
		action.play_motion("持ち上げ", -1, 2)
		catch_progress = action.get_motion_progress() or catch_progress
		if catch_progress >= vm.f32(0.14) and catch_progress < vm.f32(0.233) then
			action.catch_or_kick("nage")
		end
		vm.wait()
		is_motion_finished = vm.float_bits(action.is_motion_finished()) or is_motion_finished
		if is_motion_finished ~= 0 then
			held_object_type = action.get_held_object_type() or held_object_type
			if held_object_type == 3 or held_object_type == 4 then
				action.set_program_value(program_value + 1)
			else
				action.set_program_value(0)
			end
		end
		return
	end
	if program_value == 903 then
		action.run_carry_movement()
		if is_attack_held ~= 0 then
			action.set_program_value(program_value + 1)
			action.turn_toward_target(40.0, 2.0)
		end
		return
	end
	if program_value == 904 then
		action.play_motion("投げ", -1, 6)
		vm.wait()
		throw_progress = action.get_motion_progress() or throw_progress
		if throw_progress >= vm.f32(0.3) then
			action.release_held_object(1)
		end
		is_motion_finished = vm.float_bits(action.is_motion_finished()) or is_motion_finished
		if is_motion_finished ~= 0 then
			action.set_program_value(0)
		end
		return
	end
	if program_value == 910 then
		sword_progress = action.get_motion_progress() or sword_progress
		if weapon_model_number == 1 then
			if sword_progress >= vm.f32(0.35) and sword_progress <= vm.f32(0.45) then
				action.fire_magic_sword_shot("dcol01")
			end
		elseif sword_progress >= vm.f32(0.39) and sword_progress <= vm.f32(0.42) then
			action.fire_magic_sword_shot("dcol01")
		end
		is_motion_finished = vm.float_bits(action.is_motion_finished()) or is_motion_finished
		if is_motion_finished ~= 0 then
			action.set_program_value(900)
		end
		return
	end
end

--- Catches a nearby object without guarding first and throws it.
local function catch_and_throw_from_standing()
	local is_motion_finished: s32 = 0
	local program_value: s32 = 0
	local is_attack_held: s32 = 0
	local catch_progress: f32 = 0
	local held_object_type: s32 = 0
	local throw_progress: f32 = 0
	is_attack_held = action.get_button_state_2(50) or is_attack_held
	program_value = action.get_program_value() or program_value
	if program_value == 1100 then
		action.play_motion("持ち上げ", -1, 6)
		action.set_program_value(program_value + 1)
		action.set_invulnerable_time(10)
	end
	if program_value == 1101 then
		action.play_motion("持ち上げ", -1, 2)
		catch_progress = action.get_motion_progress() or catch_progress
		if catch_progress >= vm.f32(0.14) and catch_progress < vm.f32(0.24) then
			action.catch_or_kick("nage")
		end
		vm.wait()
		is_motion_finished = vm.float_bits(action.is_motion_finished()) or is_motion_finished
		if is_motion_finished ~= 0 then
			held_object_type = action.get_held_object_type() or held_object_type
			if held_object_type == 3 or held_object_type == 4 then
				action.set_program_value(program_value + 1)
			else
				action.set_program_value(0)
			end
		end
		return
	end
	if program_value == 1102 then
		action.run_carry_movement()
		if is_attack_held ~= 0 then
			action.play_motion("投げ", -1, 6)
			action.set_program_value(program_value + 1)
			action.turn_toward_target(40.0, 2.0)
		end
		return
	end
	if program_value == 1103 then
		action.play_motion("投げ", -1, 6)
		vm.wait()
		throw_progress = action.get_motion_progress() or throw_progress
		if throw_progress >= vm.f32(0.333) then
			action.release_held_object(1)
		end
		is_motion_finished = vm.float_bits(action.is_motion_finished()) or is_motion_finished
		if is_motion_finished ~= 0 then
			action.set_program_value(0)
		end
		return
	end
end

local script = {}

--- Runs when the script is loaded and needs no setup.
function script.setup() end

--- Registers the collision frames, sword damage windows and sword trails for the equipped weapon.
function script.init()
	action.reset_script_entries_0()
	weapon_model_number = 0
	weapon_model_number = action.get_weapon_model_number() or weapon_model_number
	charge_effect = -1
	spell_charge = 0.0
	action.add_object_frame(0, "dcol01")
	action.add_object_frame(1, "dcol00")
	action.add_object_frame(2, "bcol00")
	action.add_object_frame(3, "bcol01")
	action.add_object_frame(4, "keri_R")
	action.add_object_frame(6, "item")
	if weapon_model_number == 0 then
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "5剣1", 0.36, 0.478)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣2", 0.265, 0.371)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.12, "5剣3", 0.27, 0.45)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.15, "5剣4", 0.397, 0.503)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.25, "5剣5", 0.31, 0.45)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.4, "ふっとばし", 0.54, 0.65)
	end
	if weapon_model_number == 1 then
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣1", 0.34, 0.53)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.15, "5剣2", 0.21, 0.36)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.2, "5剣3", 0.36, 0.5)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.35, "5剣4", 0.4, 0.52)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.6, "ふっとばし", 0.38, 0.58)
	end
	if weapon_model_number == 2 then
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "5剣1", 0.3, 0.48)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "5剣2", 0.27, 0.41)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣3", 0.36, 0.53)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣4", 0.38, 0.54)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.15, "5剣5", 0.25, 0.45)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.2, "5剣6", 0.35, 0.52)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "ふっとばし", 0.14, 0.45)
		action.add_motion_damage("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.3, "ふっとばし", 0.54, 0.65)
	end
	action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.2, "中距離攻撃", 0.35, 0.46)
	action.add_motion_damage("dcol02", "", "モニカ溜め攻撃", 20.0, 1.2, "ため攻撃", 0.62, 0.72)
	action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 0.8, "ダウン･剣", 0.46, 0.533)
	if weapon_model_number == 0 then
		action.add_sword_effect(0, "5剣1", 0.3, 0.34, "dcol00", "dcol01", 77, 10, 16)
		action.add_sword_effect(0, "5剣2", 0.23, 0.26, "dcol00", "dcol01", 77, 4, 12)
		action.add_sword_effect(0, "5剣3", 0.27, 0.3, "dcol00", "dcol01", 77, 5, 12)
		action.add_sword_effect(0, "5剣4", 0.39, 0.43, "dcol00", "dcol01", 77, 5, 10)
		action.add_sword_effect(0, "5剣5", 0.3, 0.33, "dcol00", "dcol01", 77, 12, 20)
		action.add_sword_effect(0, "ふっとばし", 0.2, 0.25, "dcol00", "dcol01", 77, 20, 20)
	end
	if weapon_model_number == 1 then
		action.add_sword_effect(0, "5剣1", 0.3, 0.34, "dcol00", "dcol01", 77, 10, 12)
		action.add_sword_effect(0, "5剣2", 0.12, 0.18, "dcol00", "dcol01", 77, 12, 12)
		action.add_sword_effect(0, "5剣3", 0.33, 0.36, "dcol00", "dcol01", 77, 12, 12)
		action.add_sword_effect(0, "ふっとばし", 0.42, 0.45, "dcol00", "dcol01", 77, 20, 20)
	end
	if weapon_model_number == 2 then
		action.add_sword_effect(0, "5剣1", 0.26, 0.3, "dcol00", "dcol01", 77, 5, 12)
		action.add_sword_effect(0, "5剣2", 0.24, 0.3, "dcol00", "dcol01", 77, 10, 12)
		action.add_sword_effect(0, "5剣3", 0.22, 0.3, "dcol00", "dcol01", 77, 10, 12)
		action.add_sword_effect(0, "5剣4", 0.25, 0.32, "dcol00", "dcol01", 77, 10, 10)
		action.add_sword_effect(0, "5剣5", 0.25, 0.32, "dcol00", "dcol01", 77, 10, 10)
		action.add_sword_effect(0, "5剣6", 0.33, 0.35, "dcol00", "dcol01", 77, 12, 20)
		action.add_sword_effect(0, "ふっとばし", 0.2, 0.25, "dcol00", "dcol01", 77, 20, 20)
	end
	action.add_sword_effect(0, "中距離攻撃", 0.28, 0.31, "dcol00", "dcol01", 77, 10, 30)
	action.add_sword_effect(0, "勝利のポーズ", 0.1, 0.2, "dcol00", "dcol01", 77, 50, 30)
end

--- Releases guarding and any held object when the character is reset.
function script.reset()
	stop_guarding_and_delete_charge_effect()
	action.release_held_object(0)
end

--- Reads the buttons each frame and dispatches to the combo, spell, guard, catch and item programs.
function script.loop()
	local program_value: s32 = 0
	local is_attack_held: s32 = 0
	local is_guard_held: s32 = 0
	local is_aim_held: s32 = 0
	local is_item_pressed: s32 = 0
	local is_battle_paused: s32 = 0
	local is_stick_pointing_back_in_combo: s32 = 0
	local combo_charge_x: f32 = 0
	local combo_charge_y: f32 = 0
	local combo_charge_z: f32 = 0
	local combo_ring_red: s32 = 0
	local combo_ring_green: s32 = 0
	local combo_ring_blue: s32 = 0
	local is_stick_pointing_back: s32 = 0
	local stick_alignment: f32 = 0
	local target_distance: f32 = 0
	local target_status: s32 = 0
	local held_object_type: s32 = 0
	local item_action: s32 = 0
	local charge_steps: s32 = 0
	local idle_charge_x: f32 = 0
	local idle_charge_y: f32 = 0
	local idle_charge_z: f32 = 0
	local idle_ring_red: s32 = 0
	local idle_ring_green: s32 = 0
	local idle_ring_blue: s32 = 0
	action.set_program_value(0)
	while true do
		program_value = action.get_program_value() or program_value
		is_attack_held = action.get_button_state_2(50) or is_attack_held
		is_guard_held = action.get_button_state_2(54) or is_guard_held
		is_aim_held = action.get_button_state_2(53) or is_aim_held
		is_item_pressed = action.get_button_state_2(51) or is_item_pressed
		is_battle_paused = action.is_battle_paused_2(8192) or is_battle_paused
		if is_battle_paused ~= 0 then
			while true do
				action.run_movement()
				vm.wait()
			end
		end
		if program_value >= 100 and program_value < 199 then
			if weapon_model_number == 0 then
				attack.monica_sword_combo_c()
			end
			if weapon_model_number == 1 then
				attack.monica_sword_combo_b()
			end
			if weapon_model_number == 2 then
				attack.monica_sword_combo_a()
			end
			action.apply_slow_status()
			if is_attack_held ~= 0 then
				is_stick_pointing_back_in_combo = action.is_stick_pointing_back() or is_stick_pointing_back_in_combo
				if is_stick_pointing_back_in_combo ~= 0 then
					program_value = 1300
					action.set_program_value(program_value)
				end
			end
			if is_guard_held ~= 0 then
				program_value = 900
				action.set_program_value(program_value)
			end
			if is_aim_held ~= 0 then
				action.set_murderous(1, 3)
				do
					local out1, out2, out3 = action.get_object_position("item")
					combo_charge_x = out1 or combo_charge_x
					combo_charge_y = out2 or combo_charge_y
					combo_charge_z = out3 or combo_charge_z
				end
				charge_effect = action.create_effect_2("モニカ魔法－溜め") or charge_effect
				action.set_effect_first_vector(charge_effect, combo_charge_x, combo_charge_y, combo_charge_z)
				do
					local out1, out2, out3 = action.get_ring_color()
					combo_ring_red = out1 or combo_ring_red
					combo_ring_green = out2 or combo_ring_green
					combo_ring_blue = out3 or combo_ring_blue
				end
				action.set_effect_second_vector(charge_effect, combo_ring_red, combo_ring_green, combo_ring_blue)
				spell_charge = vm.f32(0.8)
				program_value = 800
				action.set_program_value(program_value)
			end
		end
		if program_value >= 200 and program_value < 299 then
			attack.monica_mid_range_attack()
		end
		if program_value >= 1300 and program_value < 1399 then
			movement.monica_backflip_dodge()
			program_value = 0
			is_attack_held = 0
		end
		if program_value >= 1200 and program_value < 1299 then
			attack.monica_charge_attack()
		end
		if program_value >= 300 and program_value < 399 then
			action.turn_toward_target(40.0, 2.0)
			attack.monica_slash_downed_enemy()
		end
		if program_value >= 800 and program_value < 899 then
			aim_and_cast_spell()
			action.apply_slow_status()
		end
		if program_value >= 900 and program_value < 999 then
			run_guard_catch_and_throw()
			action.apply_slow_status()
		end
		if program_value >= 1000 and program_value < 1099 then
			attack.throw_item()
			action.apply_slow_status()
		end
		if program_value >= 1100 and program_value < 1199 then
			catch_and_throw_from_standing()
			action.apply_slow_status()
		end
		program_value = action.get_program_value() or program_value
		if program_value == 0 then
			action.run_movement()
			if is_attack_held ~= 0 then
				is_stick_pointing_back = action.is_stick_pointing_back() or is_stick_pointing_back
				if is_stick_pointing_back ~= 0 then
					program_value = 1300
				else
					stick_alignment = action.get_stick_facing_alignment() or stick_alignment
					target_distance = action.get_target_distance() or target_distance
					if stick_alignment > vm.f32(0.85) and target_distance > 40.0 and target_distance < 100.0 then
						action.turn_toward_target(40.0, 2.0)
						program_value = 200
						action.set_murderous(0, 3)
					else
						target_status = action.get_target_status() or target_status
						if target_status == 1 and target_distance < 28.0 then
							action.turn_toward_target(40.0, 2.0)
							program_value = 300
						else
							action.turn_toward_target(40.0, 2.0)
							program_value = 100
							action.set_murderous(0, 3)
						end
					end
				end
				action.reset_button_history()
			end
			if is_guard_held ~= 0 then
				program_value = 900
			end
			if (if is_guard_held ~= 0 then is_attack_held else 0) ~= 0 then
				program_value = 1100
			end
			if is_item_pressed ~= 0 then
				held_object_type = action.get_held_object_type() or held_object_type
				if held_object_type == 0 then
					item_action = action.use_active_item() or item_action
					if item_action == 3 then
						program_value = 1100
					end
					if item_action == 2 then
						program_value = 1000
					end
				end
			end
			charge_steps = action.get_charge_steps() or charge_steps
			if charge_steps > 10 then
				action.reset_charge_steps()
				program_value = 1200
			end
			if is_aim_held ~= 0 then
				program_value = 800
				action.set_murderous(1, 3)
				do
					local out1, out2, out3 = action.get_object_position("item")
					idle_charge_x = out1 or idle_charge_x
					idle_charge_y = out2 or idle_charge_y
					idle_charge_z = out3 or idle_charge_z
				end
				charge_effect = action.create_effect_2("モニカ魔法－溜め") or charge_effect
				action.set_effect_first_vector(charge_effect, idle_charge_x, idle_charge_y, idle_charge_z)
				do
					local out1, out2, out3 = action.get_ring_color()
					idle_ring_red = out1 or idle_ring_red
					idle_ring_green = out2 or idle_ring_green
					idle_ring_blue = out3 or idle_ring_blue
				end
				action.set_effect_second_vector(charge_effect, idle_ring_red, idle_ring_green, idle_ring_blue)
				spell_charge = vm.f32(0.8)
				action.set_menu_allowed(0)
			end
			action.set_program_value(program_value)
		end
		vm.wait()
	end
end

--- Knocks the character back a short way and plays the flinch motion.
function script.on_small_damage()
	stop_guarding_and_delete_charge_effect()
	action.start_knockback(5.0, 0.0, 3)
	action.release_held_object(0)
	action.play_motion("ダメージ", -1, 2)
	timing.wait_frames(8)
	action.set_program_value(0)
end

--- Holds the character in the damage pose until the binding status conditions clear.
function script.on_hold()
	local status_conditions: s32 = 0
	stop_guarding_and_delete_charge_effect()
	action.start_knockback(0.0, 0.0, 3)
	action.release_held_object(0)
	action.play_motion("ダメージ", -1, 6)
	status_conditions = 40
	while bit32.band(status_conditions, 40) ~= 0 do
		action.set_menu_allowed(1)
		vm.wait()
		status_conditions = action.get_status_conditions() or status_conditions
	end
	action.set_program_value(0)
end

--- Knocks the character down, then plays the get-up motion.
function script.on_large_damage()
	stop_guarding_and_delete_charge_effect()
	action.start_knockback(4.5, 0.04, 26)
	action.face_against_knockback()
	action.release_held_object(0)
	action.play_motion("吹っ飛び", -1, 6)
	timing.wait_motion_finished()
	timing.wait_frames(10)
	action.play_motion("起き上がり", -1, 6)
	timing.wait_motion_finished()
	timing.wait_frames(2)
	action.set_program_value(0)
end

--- Plays the post-guard motion after a melee hit lands.
function script.on_melee_hit()
	local is_motion_finished: s32 = 0
	stop_guarding_and_delete_charge_effect()
	action.start_knockback(0.0, 0.0, 0)
	action.play_motion("ガード後", -1, 2)
	is_motion_finished = 0
	while is_motion_finished == 0 do
		vm.wait()
		is_motion_finished = vm.float_bits(action.is_motion_finished()) or is_motion_finished
	end
end

--- Plays the death motion.
function script.on_death()
	stop_guarding_and_delete_charge_effect()
	action.release_held_object(0)
	action.play_motion("死に", -1, 6)
	action.set_program_value(0)
end

--- Returns to the battle stance after landing.
function script.on_land()
	stop_guarding_and_delete_charge_effect()
	action.release_held_object(0)
	timing.wait_motion_finished()
	action.play_motion("バトル立ち")
	vm.wait()
end

return script
