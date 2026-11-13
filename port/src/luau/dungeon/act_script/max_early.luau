--!strict
--- Drives an earlier revision of Max's dungeon actions, without slow-status handling or the kick finisher.

local vm = require("@lib/vm")
local attack = require("@lib/action/attack")
local movement = require("@lib/action/movement")
local timing = require("@lib/action/timing")

--- Runs Max's five-hit sword combo, advancing a hit when the attack button is pressed in its timing window.
local function run_sword_combo()
	local attack_queued: s32 = 0
	local motion_status: s32 = 0
	local prog: s32 = 0
	local motion_progress: f32 = 0
	local acumu_pad: s32 = 0
	prog = action.get_program_value() or prog
	if prog == 100 then
		action.play_motion("5連続攻撃1", -1, 6)
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.143) and motion_progress <= vm.f32(0.429) then
			action.set_move_impulse(0.6, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.714) and motion_progress <= 1.0 then
			action.set_move_impulse(0.8, 0.0, 1)
		end
		acumu_pad = action.get_charge_steps() or acumu_pad
		if acumu_pad > 12 then
			action.reset_charge_steps()
			action.set_program_value(1200)
			return
		end
		if motion_progress >= vm.f32(0.514) and motion_progress <= vm.f32(0.571) then
			attack_queued = action.get_button_history() or attack_queued
			if attack_queued ~= 0 then
				action.play_motion("5連続攻撃2", -1, 6)
				action.call_command(93) -- retail: the handler rejects 0 arguments
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
		if motion_progress >= 0.0 and motion_progress <= vm.f32(0.409) then
			action.set_move_impulse(0.93, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.518) and motion_progress <= vm.f32(0.573) then
			attack_queued = action.get_button_history() or attack_queued
			if attack_queued ~= 0 then
				action.play_motion("5連続攻撃3", -1, 6)
				action.call_command(93) -- retail: the handler rejects 0 arguments
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
		if motion_progress >= 0.0 and motion_progress <= 0.375 then
			action.set_move_impulse(0.63, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.675) and motion_progress <= 1.0 then
			action.set_move_impulse(0.6, 0.0, 1)
		end
		if motion_progress >= 0.5 and motion_progress <= vm.f32(0.55) then
			attack_queued = action.get_button_history() or attack_queued
			if attack_queued ~= 0 then
				action.play_motion("5連続攻撃4", -1, 6)
				action.call_command(93) -- retail: the handler rejects 0 arguments
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
		if motion_progress >= 0.0 and motion_progress <= vm.f32(0.339) then
			action.set_move_impulse(0.787, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.47) and motion_progress <= vm.f32(0.522) then
			attack_queued = action.get_button_history() or attack_queued
			if attack_queued ~= 0 then
				action.play_motion("5連続攻撃5", -1, 6)
				action.call_command(93) -- retail: the handler rejects 0 arguments
				action.set_program_value(prog + 1)
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
		if motion_progress >= 0.0 and motion_progress <= vm.f32(0.24) then
			action.set_move_impulse(0.85, 0.0, 1)
		end
		if motion_progress >= vm.f32(0.7) and motion_progress <= 1.0 then
			action.set_move_impulse(0.4, 0.0, 1)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Aims Max's gun and fires a shot while the fire button is held.
local function run_gun_attack()
	local motion_status: s32 = 0
	local prog: s32 = 0
	local fire_button: s32 = 0
	local aim_button: s32 = 0
	local motion_progress: f32 = 0
	fire_button = action.get_button_state_2(56) or fire_button
	aim_button = action.get_button_state_2(53) or aim_button
	prog = action.get_program_value() or prog
	if prog == 800 then
		action.run_aim_movement("銃狙う", "銃回転")
		if aim_button ~= 0 then
			if fire_button ~= 0 then
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
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress > vm.f32(0.3) and motion_progress < vm.f32(0.4) then
			action.fire_shot(6, "n_gun", 2, 5)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.play_motion("銃狙う", -1, 4)
			action.set_program_value(prog - 1)
		end
	end
end

--- Runs Max's guard, catches a nearby object and throws it.
local function run_guard_and_catch()
	local result: s32 = 0
	local prog: s32 = 0
	local attack_button: s32 = 0
	local fire_button: s32 = 0
	local guard_button: s32 = 0
	local lift_progress: f32 = 0
	local hold_type: s32 = 0
	local throw_progress: f32 = 0
	attack_button = action.get_button_state_2(50) or attack_button
	fire_button = action.get_button_state_2(56) or fire_button
	guard_button = action.get_button_state_2(54) or guard_button
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
		if fire_button ~= 0 then
			action.play_motion("持ち上げ", -1, 2)
			action.set_guarding(0)
			action.set_program_value(prog + 1)
			action.set_invulnerable_time(10)
			print("-- CATCH --\n")
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
			action.play_motion("投げ", -1, 6)
			action.set_program_value(prog + 1)
			action.call_command(93) -- retail: the handler rejects 0 arguments
			return
		end
		return
	end
	if prog == 904 then
		action.play_motion("投げ", -1, 6)
		throw_progress = action.get_motion_progress() or throw_progress
		if throw_progress >= vm.f32(0.289) then
			print(vm.float(throw_progress), "\n")
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
				return
			end
			action.set_program_value(0)
		end
		return
	end
	if prog == 1102 then
		action.run_carry_movement()
		if attack_button ~= 0 then
			action.play_motion("投げ", -1, 6)
			action.set_program_value(prog + 1)
			action.call_command(93) -- retail: the handler rejects 0 arguments
		end
		return
	end
	if prog == 1103 then
		action.play_motion("投げ", -1, 6)
		throw_progress = action.get_motion_progress() or throw_progress
		if throw_progress >= vm.f32(0.289) then
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

--- Reads Max's buttons each frame and starts the sword combo, gun, guard, catch, item and charge programs.
function script.loop()
	local prog: s32 = 0
	local attack_button: s32 = 0
	local guard_button: s32 = 0
	local aim_button: s32 = 0
	local item_button: s32 = 0
	local is_stick_back_during_combo: s32 = 0
	local equipped_gun: s32 = 0
	local is_stick_back: s32 = 0
	local stick_alignment: f32 = 0
	local target_distance: f32 = 0
	local status: s32 = 0
	local equipped_gun_idle: s32 = 0
	local hold_type: s32 = 0
	local used_item_action: s32 = 0
	local acumu_pad: s32 = 0
	action.set_program_value(0)
	while true do
		prog = action.get_program_value() or prog
		attack_button = action.get_button_state_2(50) or attack_button
		guard_button = action.get_button_state_2(54) or guard_button
		aim_button = action.get_button_state_2(53) or aim_button
		item_button = action.get_button_state_2(51) or item_button
		if prog >= 100 and prog < 199 then
			run_sword_combo()
			if attack_button ~= 0 then
				is_stick_back_during_combo = action.is_stick_pointing_back() or is_stick_back_during_combo
				if is_stick_back_during_combo ~= 0 then
					prog = 1300
					action.set_program_value(prog)
				end
			end
			if aim_button ~= 0 then
				equipped_gun = action.get_equipped_item(1) or equipped_gun
				if equipped_gun > 0 then
					prog = 800
					action.set_program_value(prog)
				end
			end
			if guard_button ~= 0 then
				prog = 900
				action.set_program_value(prog)
			end
		end
		if prog >= 200 and prog < 299 then
			attack.max_mid_range_attack()
		end
		if prog >= 1200 and prog < 1299 then
			attack.max_charge_attack()
		end
		if prog >= 1300 and prog < 1399 then
			movement.max_backflip_dodge()
		end
		if prog >= 300 and prog < 399 then
			action.call_command(93) -- retail: the handler rejects 0 arguments
			attack.max_kick_downed_enemy()
		end
		if prog >= 800 and prog < 899 then
			run_gun_attack()
		end
		if prog >= 900 and prog < 999 then
			run_guard_and_catch()
		end
		if prog >= 1000 and prog < 1099 then
			attack.throw_item()
		end
		if prog >= 1100 and prog < 1199 then
			run_lift_and_throw()
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
					if stick_alignment > vm.f32(0.85) and (target_distance > 40.0 and target_distance < 100.0) then
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
			if aim_button ~= 0 then
				equipped_gun_idle = action.get_equipped_item(1) or equipped_gun_idle
				if equipped_gun_idle > 0 then
					prog = 800
				end
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
			if acumu_pad > 12 then
				action.reset_charge_steps()
				prog = 1200
			end
			action.set_program_value(prog)
		end
		vm.wait()
	end
end

--- Staggers Max briefly.
function script.on_small_damage()
	action.start_knockback(5.0, 0.0, 3)
	action.release_held_object(0)
	action.play_motion("ダメージ", -1, 2)
	timing.wait_frames(4)
	action.set_program_value(0)
end

--- Knocks Max back, then plays the stand-up motion.
function script.on_large_damage()
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
	action.set_move_impulse(0.0, 0.0, 0)
	action.play_motion("ガード後", -1, 2)
	result = 0
	while result == 0 do
		vm.wait()
		result = vm.float_bits(action.is_motion_finished()) or result
	end
end

--- Plays Max's death and waits for the attack button.
function script.on_death()
	local attack_button: s32 = 0
	action.release_held_object(0)
	action.play_motion("死に", -1, 6)
	while true do
		attack_button = action.get_button_state_2(50) or attack_button
		if attack_button ~= 0 then
			break
		else
			vm.wait()
		end
	end
	action.set_program_value(0)
end

return script
