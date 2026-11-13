--!strict
--- Drives the actions of the Himarra monster form: a spin attack and a sticky goo spit.

local vm = require("@lib/vm")
local reaction = require("@lib/action/reaction")
local timing = require("@lib/action/timing")

--- Runs the wind-up, spin and recovery of the spin attack.
local function run_spin_attack()
	local motion_status: s32 = 0
	local prog: s32 = 0
	local attack_power: s32 = 0
	prog = action.get_program_value() or prog
	if prog == 100 then
		action.play_motion("攻撃１in", -1, 6)
		vm.wait()
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			attack_power = action.get_weapon_attack(0) or attack_power
			action.create_effect_1("ヒマーラ回転攻撃")
			action.set_effect_value(-1, 0, attack_power)
			action.set_program_value(prog + 1)
		end
		return
	end
	if prog == 101 then
		action.play_motion("攻撃１", -1, 6)
		vm.wait()
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(prog + 1)
		end
		return
	end
	if prog == 102 then
		action.play_motion("攻撃１out", -1, 6)
		vm.wait()
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Spits a sticky goo effect from the monster's mouth.
local function spit_sticky_goo()
	local goo_x: f32 = 0
	local goo_y: f32 = 0
	local goo_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local attack_power: s32 = 0
	action.play_motion("攻撃２", -1, 2)
	timing.wait_motion_progress_between(vm.f32(0.39), vm.f32(0.42))
	do
		local out1, out2, out3 = action.get_object_position("dcol01")
		goo_x = out1 or goo_x
		goo_y = out2 or goo_y
		goo_z = out3 or goo_z
	end
	do
		local out1, out2, out3 = action.get_rotation()
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	attack_power = action.get_weapon_attack(0) or attack_power
	action.create_effect_1("ねばねばＬ")
	action.set_effect_first_vector(-1, goo_x, goo_y, goo_z)
	action.set_effect_second_vector(-1, rot_x, rot_y, rot_z)
	action.set_effect_value(-1, 0, attack_power)
	timing.wait_motion_finished()
	action.set_program_value(0)
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the attack damage of the Himarra form.
function script.init()
	action.add_object_frame(0, "dcol00")
	action.add_object_frame(2, "bcol00")
	action.add_motion_damage("dcol00", "", "モンスター攻撃", 2.5, 1.0, "攻撃１in", 0.1, 0.9)
	action.add_body_collision(2, 5.0)
end

--- Starts the Himarra form's attacks when the attack or special button is pressed.
function script.loop()
	local prog: s32 = 0
	local attack_button: s32 = 0
	local special_button: s32 = 0
	action.set_program_value(0)
	while true do
		prog = action.get_program_value() or prog
		if prog >= 100 and prog < 199 then
			action.turn_toward_target(40.0, 5.0)
			run_spin_attack()
		end
		if prog >= 200 and prog < 299 then
			action.turn_toward_target(40.0, 5.0)
			spit_sticky_goo()
		end
		prog = action.get_program_value() or prog
		if prog == 0 then
			action.run_movement()
			attack_button = action.get_button_state_2(50) or attack_button
			special_button = action.get_button_state_2(51) or special_button
			if attack_button ~= 0 then
				prog = 100
			end
			if special_button ~= 0 then
				prog = 200
			end
			action.set_program_value(prog)
		end
		vm.wait()
	end
end

--- Reacts to a small hit.
script.on_small_damage = reaction.take_damage

--- Holds the character in place.
script.on_hold = reaction.take_damage

--- Reacts to a large hit.
script.on_large_damage = reaction.get_blown_away

--- Follows up a melee hit that the character has landed.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, replacing the engine's default melee hit reaction.
function script.on_melee_hit() end

--- Runs the character's death.
script.on_death = reaction.die

return script
