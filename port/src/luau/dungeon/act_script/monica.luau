--!strict
--- Drives Monica's actions in the dungeon: sword combo, spell charging and casting, guard, catch, item use, charge attack and dodge.

local vm = require("@lib/vm")
local attack = require("@lib/action/attack")
local movement = require("@lib/action/movement")
local timing = require("@lib/action/timing")

local charge_effect: s32 = 0
local charge_power: f32 = 0

--- Deletes the spell charge effect if one exists.
local function delete_charge_effect()
	if charge_effect ~= -1 then
		action.delete_effect(charge_effect)
	end
end

--- Runs Monica's five-hit sword combo, advancing a hit when the attack button is pressed in its timing window.
local function run_sword_combo()
	local attack_queued: s32 = 0
	local motion_status: s32 = 0
	local prog: s32 = 0
	local motion_progress: f32 = 0
	local acumu_pad: s32 = 0
	prog = action.get_program_value() or prog
	if prog == 100 then
		action.play_motion("5剣1", -1, 6)
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.309) and motion_progress <= vm.f32(0.394) then
			action.set_move_impulse(4.75, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.647) and motion_progress <= 1.0 then
			action.set_move_impulse(0.92, 0.0, 1)
		end
		acumu_pad = action.get_charge_steps() or acumu_pad
		if acumu_pad > 10 then
			action.reset_charge_steps()
			action.set_program_value(1200)
			return
		end
		if motion_progress >= 0.5 and motion_progress <= vm.f32(0.562) then
			attack_queued = action.get_button_history() or attack_queued
			if attack_queued ~= 0 then
				action.play_motion("5剣2", -1, 6)
				action.call_command(93, 2.0) -- retail: the handler rejects 1 arguments
				action.set_program_value(prog + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			motion_status = action.get_motion_status() or motion_status
			if motion_status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 101 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.238) and motion_progress <= vm.f32(0.418) then
			action.set_move_impulse(2.56, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.476) and motion_progress <= vm.f32(0.529) then
			attack_queued = action.get_button_history() or attack_queued
			if attack_queued ~= 0 then
				action.play_motion("5剣3", -1, 6)
				action.call_command(93, 2.0) -- retail: the handler rejects 1 arguments
				action.set_program_value(prog + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			motion_status = action.get_motion_status() or motion_status
			if motion_status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 102 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.27) and motion_progress <= vm.f32(0.33) then
			action.set_move_impulse(3.89, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.54) and motion_progress <= 1.0 then
			action.set_move_impulse(-0.919, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.51) and motion_progress <= vm.f32(0.57) then
			attack_queued = action.get_button_history() or attack_queued
			if attack_queued ~= 0 then
				action.play_motion("5剣4", -1, 6)
				action.call_command(93, 2.0) -- retail: the handler rejects 1 arguments
				action.set_program_value(prog + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			motion_status = action.get_motion_status() or motion_status
			if motion_status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 103 then
		motion_status = action.get_motion_status() or motion_status
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.291) and motion_progress <= vm.f32(0.423) then
			action.set_move_impulse(2.25, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.609) and motion_progress <= 1.0 then
			action.set_move_impulse(0.57, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.58) and motion_progress <= vm.f32(0.609) then
			attack_queued = action.get_button_history() or attack_queued
			if attack_queued ~= 0 then
				action.play_motion("5剣5", -1, 6)
				action.call_command(93, 2.0) -- retail: the handler rejects 1 arguments
				action.set_program_value(prog + 1)
				action.reset_button_history()
				action.set_murderous(0, 3)
			end
		else
			motion_status = action.get_motion_status() or motion_status
			if motion_status == 4 then
				action.set_program_value(0)
			end
		end
		return
	end
	if prog == 104 then
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.225) and motion_progress <= vm.f32(0.637) then
			action.set_move_impulse(1.8, 0.0, 1)
		end
		if motion_progress >= 0.75 and motion_progress <= 1.0 then
			action.set_move_impulse(0.825, 0.0, 1)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Aims Monica's spell while charging it and casts it when the attack button is pressed.
local function run_spell_charge()
	local motion_status: s32 = 0
	local prog: s32 = 0
	local aim_button: s32 = 0
	local attack_button: s32 = 0
	local aim_x: f32 = 0
	local aim_y: f32 = 0
	local aim_z: f32 = 0
	local cast_x: f32 = 0
	local cast_y: f32 = 0
	local cast_z: f32 = 0
	local motion_progress: f32 = 0
	local restart_x: f32 = 0
	local restart_y: f32 = 0
	local restart_z: f32 = 0
	aim_button = action.get_button_state_2(53) or aim_button
	attack_button = action.get_button_state_2(50) or attack_button
	prog = action.get_program_value() or prog
	if prog == 800 then
		action.run_aim_movement("魔法狙う", "魔法回転")
		do
			local out1, out2, out3 = action.get_object_position("item")
			aim_x = out1 or aim_x
			aim_y = out2 or aim_y
			aim_z = out3 or aim_z
		end
		action.set_effect_first_vector(charge_effect, aim_x, aim_y, aim_z)
		charge_power = vm.f32(charge_power + vm.f32(0.008333334))
		if charge_power >= vm.f32(1.3) then
			charge_power = vm.f32(1.3)
		end
		if aim_button ~= 0 then
			if attack_button ~= 0 then
				action.play_motion("発動", -1, 6)
				action.set_program_value(prog + 1)
			end
		else
			action.set_program_value(0)
			action.delete_effect(charge_effect)
		end
		return
	end
	if prog == 801 then
		action.play_motion("発動", -1, 6)
		do
			local out1, out2, out3 = action.get_object_position("item")
			cast_x = out1 or cast_x
			cast_y = out2 or cast_y
			cast_z = out3 or cast_z
		end
		action.set_effect_first_vector(charge_effect, cast_x, cast_y, cast_z)
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= 0.25 and motion_progress < vm.f32(0.3) then
			action.fire_shot(6, "spell01", 2, 5, charge_power)
			action.finish_effect(charge_effect)
			charge_power = vm.f32(0.8)
			return
		end
		if (if aim_button ~= 0 then attack_button else 0) ~= 0 and motion_progress > vm.f32(0.65) then
			action.reset_motion()
			action.set_program_value(801)
			return
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.play_motion("魔法狙う", -1, 4)
			do
				local out1, out2, out3 = action.get_object_position("item")
				restart_x = out1 or restart_x
				restart_y = out2 or restart_y
				restart_z = out3 or restart_z
			end
			charge_effect = action.create_effect_2("モニカ魔法－溜め") or charge_effect
			action.set_effect_first_vector(charge_effect, restart_x, restart_y, restart_z)
			action.set_effect_second_vector(charge_effect, 255, 128, 128)
			charge_power = vm.f32(0.8)
			action.set_program_value(prog - 1)
		end
	end
end

--- Runs Monica's guard with magic sword shots, catches a nearby object and throws it.
local function run_guard_and_catch()
	local result: s32 = 0
	local guard_button: s32 = 0
	local attack_button: s32 = 0
	local aim_button: s32 = 0
	local prog: s32 = 0
	local lift_progress: f32 = 0
	local hold_type: s32 = 0
	local throw_progress: f32 = 0
	aim_button = action.get_button_state_2(53) or aim_button
	guard_button = action.get_button_state_2(54) or guard_button
	attack_button = action.get_button_state_2(50) or attack_button
	prog = action.get_program_value() or prog
	if (if aim_button ~= 0 then guard_button else 0) ~= 0 then
		action.fire_magic_sword_shot("dcol01")
	end
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
		if attack_button ~= 0 then
			action.play_motion("持ち上げ", -1, 2)
			action.set_guarding(0)
			action.set_program_value(prog + 1)
			action.set_invulnerable_time(10)
		end
		if guard_button == 0 then
			action.set_guarding(0)
			action.set_program_value(0)
		end
		return
	end
	if prog == 902 then
		action.play_motion("持ち上げ", -1, 2)
		lift_progress = action.get_motion_progress() or lift_progress
		if lift_progress >= vm.f32(0.14) and lift_progress < vm.f32(0.233) then
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
		if attack_button ~= 0 then
			action.set_program_value(prog + 1)
			action.call_command(93, 2.0) -- retail: the handler rejects 1 arguments
		end
		return
	end
	if prog == 904 then
		action.play_motion("投げ", -1, 6)
		vm.wait()
		throw_progress = action.get_motion_progress() or throw_progress
		if throw_progress >= vm.f32(0.3) then
			action.release_held_object(1)
		end
		result = vm.float_bits(action.is_motion_finished()) or result
		if result ~= 0 then
			action.set_program_value(0)
		end
		return
	end
end

--- Lifts a nearby object and throws it.
local function run_lift_and_throw()
	local result: s32 = 0
	local prog: s32 = 0
	local attack_button: s32 = 0
	local lift_progress: f32 = 0
	local hold_type: s32 = 0
	local throw_progress: f32 = 0
	attack_button = action.get_button_state_2(50) or attack_button
	prog = action.get_program_value() or prog
	if prog == 1100 then
		action.play_motion("持ち上げ", -1, 6)
		action.set_program_value(prog + 1)
		action.set_invulnerable_time(10)
	end
	if prog == 1101 then
		action.play_motion("持ち上げ", -1, 2)
		lift_progress = action.get_motion_progress() or lift_progress
		if lift_progress >= vm.f32(0.14) and lift_progress < vm.f32(0.233) then
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
		if attack_button ~= 0 then
			action.play_motion("投げ", -1, 6)
			action.set_program_value(prog + 1)
			action.call_command(93, 2.0) -- retail: the handler rejects 1 arguments
		end
		return
	end
	if prog == 1103 then
		action.play_motion("投げ", -1, 6)
		vm.wait()
		throw_progress = action.get_motion_progress() or throw_progress
		if throw_progress >= vm.f32(0.333) then
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

--- Does nothing at load time.
function script.setup() end

--- Registers the character's frames, attack damage, effects and sounds.
function script.init()
	action.reset_script_entries_0()
	charge_effect = -1
	charge_power = 0.0
	action.add_object_frame(0, "dcol01")
	action.add_object_frame(1, "dcol00")
	action.add_object_frame(2, "bcol00")
	action.add_object_frame(3, "bcol01")
	action.add_object_frame(4, "keri_R")
	action.add_object_frame(6, "item")
	action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.0, "5剣1", 0.36, 0.478)
	action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣2", 0.265, 0.371)
	action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.1, "5剣3", 0.27, 0.45)
	action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.15, "5剣4", 0.397, 0.503)
	action.add_motion_damage("dcol02", "dcol01", "モニカ剣強攻撃", 4.0, 1.2, "5剣5", 0.337, 0.544)
	action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 1.2, "中距離攻撃", 0.35, 0.46)
	action.add_motion_damage("dcol02", "", "モニカ溜め攻撃", 20.0, 1.2, "ため攻撃", 0.62, 0.72)
	action.add_motion_damage("dcol02", "dcol01", "モニカ剣攻撃", 4.0, 0.8, "ダウン･剣", 0.46, 0.533)
	action.add_body_collision(2, 5.0)
	action.add_body_collision(3, 4.0)
	action.add_sword_effect(0, "5剣1", 0.3, 0.33, "dcol00", "dcol01", 77, 10, 16)
	action.add_sword_effect(0, "5剣2", 0.23, 0.26, "dcol00", "dcol01", 77, 4, 12)
	action.add_sword_effect(0, "5剣3", 0.27, 0.3, "dcol00", "dcol01", 77, 5, 12)
	action.add_sword_effect(0, "5剣4", 0.39, 0.42, "dcol00", "dcol01", 77, 5, 10)
	action.add_sword_effect(0, "5剣5", 0.3, 0.33, "dcol00", "dcol01", 77, 12, 20)
	action.add_sword_effect(0, "中距離攻撃", 0.28, 0.31, "dcol00", "dcol01", 77, 10, 30)
	action.add_sword_effect(0, "勝利のポーズ", 0.1, 0.2, "dcol00", "dcol01", 77, 50, 30)
	action.add_motion_sound(-2, "歩き", 0.07, 0.1)
	action.add_motion_sound(-3, "歩き", 0.5, 0.55)
	action.add_motion_sound(-2, "走り", 0.4, 0.5)
	action.add_motion_sound(-3, "走り", 0.9, 1.0)
	action.add_motion_sound(400, "3連続攻撃1", 0.4, 0.5)
	action.add_motion_sound(401, "3連続攻撃2", 0.3, 0.4)
	action.add_motion_sound(402, "3連続攻撃3", 0.4, 0.5)
	action.add_motion_sound(400, "中距離攻撃", 0.3, 0.4)
end

--- Puts Monica back into her normal state.
function script.reset()
	delete_charge_effect()
	action.release_held_object(0)
end

--- Reads Monica's buttons each frame and starts the sword combo, spell, guard, catch, item and charge programs.
function script.loop()
	local prog: s32 = 0
	local attack_button: s32 = 0
	local guard_button: s32 = 0
	local aim_button: s32 = 0
	local item_button: s32 = 0
	local is_stick_back_during_combo: s32 = 0
	local charge_x: f32 = 0
	local charge_y: f32 = 0
	local charge_z: f32 = 0
	local is_stick_back: s32 = 0
	local stick_alignment: f32 = 0
	local target_distance: f32 = 0
	local status: s32 = 0
	local hold_type: s32 = 0
	local used_item_action: s32 = 0
	local acumu_pad: s32 = 0
	local ready_x: f32 = 0
	local ready_y: f32 = 0
	local ready_z: f32 = 0
	action.set_program_value(0)
	while true do
		prog = action.get_program_value() or prog
		attack_button = action.get_button_state_2(50) or attack_button
		guard_button = action.get_button_state_2(54) or guard_button
		aim_button = action.get_button_state_2(53) or aim_button
		item_button = action.get_button_state_2(51) or item_button
		if prog >= 100 and prog < 199 then
			run_sword_combo()
			action.apply_slow_status()
			if attack_button ~= 0 then
				is_stick_back_during_combo = action.is_stick_pointing_back() or is_stick_back_during_combo
				if is_stick_back_during_combo ~= 0 then
					prog = 1300
					action.set_program_value(prog)
				end
			end
			if aim_button ~= 0 then
				action.set_murderous(1, 3)
				do
					local out1, out2, out3 = action.get_object_position("item")
					charge_x = out1 or charge_x
					charge_y = out2 or charge_y
					charge_z = out3 or charge_z
				end
				charge_effect = action.create_effect_2("モニカ魔法－溜め") or charge_effect
				action.set_effect_first_vector(charge_effect, charge_x, charge_y, charge_z)
				action.set_effect_second_vector(charge_effect, 255, 128, 128)
				charge_power = vm.f32(0.8)
				prog = 800
				action.set_program_value(prog)
			end
			if guard_button ~= 0 then
				prog = 900
				action.set_program_value(prog)
			end
		end
		if prog >= 200 and prog < 299 then
			attack.monica_mid_range_attack()
		end
		if prog >= 1300 and prog < 1399 then
			movement.monica_backflip_dodge()
		end
		if prog >= 1200 and prog < 1299 then
			attack.monica_charge_attack()
		end
		if prog >= 300 and prog < 399 then
			action.call_command(93, 2.0) -- retail: the handler rejects 1 arguments
			attack.monica_slash_downed_enemy()
		end
		if prog >= 800 and prog < 899 then
			run_spell_charge()
			action.apply_slow_status()
		end
		if prog >= 900 and prog < 999 then
			run_guard_and_catch()
			action.apply_slow_status()
		end
		if prog >= 1000 and prog < 1099 then
			attack.throw_item()
			action.apply_slow_status()
		end
		if prog >= 1100 and prog < 1199 then
			run_lift_and_throw()
			action.apply_slow_status()
		end
		prog = action.get_program_value() or prog
		if prog == 0 then
			action.run_movement()
			if attack_button ~= 0 then
				is_stick_back = action.is_stick_pointing_back() or is_stick_back
				if is_stick_back ~= 0 then
					prog = 1300
				else
					stick_alignment = action.get_stick_facing_alignment() or stick_alignment
					target_distance = action.get_target_distance() or target_distance
					if stick_alignment > vm.f32(0.85) and target_distance > 40.0 and target_distance < 100.0 then
						action.call_command(93, 2.0) -- retail: the handler rejects 1 arguments
						prog = 200
						action.set_murderous(0, 3)
					else
						status = action.get_target_status() or status
						if status == 1 and target_distance < 28.0 then
							action.call_command(93, 2.0) -- retail: the handler rejects 1 arguments
							prog = 300
						else
							action.call_command(93, 2.0) -- retail: the handler rejects 1 arguments
							prog = 100
							action.set_murderous(0, 3)
						end
					end
				end
				action.reset_button_history()
			end
			if guard_button ~= 0 then
				prog = 900
			end
			if (if guard_button ~= 0 then attack_button else 0) ~= 0 then
				prog = 1100
			end
			if item_button ~= 0 then
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
			if aim_button ~= 0 then
				prog = 800
				action.set_murderous(1, 3)
				do
					local out1, out2, out3 = action.get_object_position("item")
					ready_x = out1 or ready_x
					ready_y = out2 or ready_y
					ready_z = out3 or ready_z
				end
				charge_effect = action.create_effect_2("モニカ魔法－溜め") or charge_effect
				action.set_effect_first_vector(charge_effect, ready_x, ready_y, ready_z)
				action.set_effect_second_vector(charge_effect, 255, 128, 128)
				charge_power = vm.f32(0.8)
			end
			action.set_program_value(prog)
		end
		vm.wait()
	end
end

--- Clears the spell charge and staggers Monica briefly.
function script.on_small_damage()
	delete_charge_effect()
	action.start_knockback(5.0, 0.0, 3)
	action.release_held_object(0)
	action.play_motion("ダメージ", -1, 2)
	timing.wait_frames(8)
	action.set_program_value(0)
end

--- Holds Monica in her damage pose until the hold status clears.
function script.on_hold()
	local attributes: s32 = 0
	delete_charge_effect()
	action.start_knockback(5.0, 0.0, 3)
	action.release_held_object(0)
	action.play_motion("ダメージ", -1, 2)
	attributes = 40
	while bit32.band(attributes, 40) ~= 0 do
		action.set_menu_allowed(1)
		vm.wait()
		attributes = action.get_status_conditions() or attributes
	end
	action.set_program_value(0)
end

--- Knocks Monica back, then plays the stand-up motion.
function script.on_large_damage()
	delete_charge_effect()
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

--- Recoils after the guard bounces a melee hit.
function script.on_melee_hit()
	local result: s32 = 0
	delete_charge_effect()
	action.start_knockback(0.0, 0.0, 0)
	action.play_motion("ガード後", -1, 2)
	result = 0
	while result == 0 do
		vm.wait()
		result = vm.float_bits(action.is_motion_finished()) or result
	end
end

--- Plays Monica's death.
function script.on_death()
	delete_charge_effect()
	action.release_held_object(0)
	action.play_motion("死に", -1, 6)
	action.set_program_value(0)
end

return script
