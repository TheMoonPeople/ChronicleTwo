--!strict
--- Drives the actions of the wolf monster form: a gun shot and a dodging attack.

local vm = require("@lib/vm")
local reaction = require("@lib/action/reaction")

--- Aims and fires a gun shot with muzzle flash and sound.
local function run_gun_attack()
	local motion_status: s32 = 0
	local prog: s32 = 0
	local muzzle_x: f32 = 0
	local muzzle_y: f32 = 0
	local muzzle_z: f32 = 0
	local attack_power: s32 = 0
	local motion_progress: f32 = 0
	prog = action.get_program_value() or prog
	if prog == 100 then
		action.play_motion("攻撃１in", -1, 6)
		vm.wait()
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			attack_power = action.get_weapon_attack(0) or attack_power
			do
				local out1, out2, out3 = action.get_object_position("dcol00")
				muzzle_x = out1 or muzzle_x
				muzzle_y = out2 or muzzle_y
				muzzle_z = out3 or muzzle_z
			end
			action.create_effect_1("fox_銃弾")
			action.set_effect_first_vector(-1, muzzle_x, muzzle_y, muzzle_z)
			action.set_effect_value(-1, 0, attack_power)
			action.create_effect_1("マズルフラッシュ")
			action.play_sound(-1, 5)
			action.set_program_value(101)
		end
		return
	end
	if prog == 101 then
		action.play_motion("攻撃１out", -1, 6)
		vm.wait()
		motion_progress = action.get_motion_progress() or motion_progress
		if motion_progress >= vm.f32(0.224) and motion_progress < vm.f32(0.288) then
			action.play_sound(-1, 6)
		end
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

--- Dodges and then attacks.
local function run_dodge_attack()
	local motion_status: s32 = 0
	local prog: s32 = 0
	prog = action.get_program_value() or prog
	if prog == 200 then
		action.play_motion("避けin", -1, 6)
		vm.wait()
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(201)
		end
		return
	end
	if prog == 201 then
		action.play_motion("避け攻撃", -1, 6)
		vm.wait()
		motion_status = action.get_motion_status() or motion_status
		if motion_status == 4 then
			action.set_program_value(0)
		end
		return
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the attack damage of the wolf form.
function script.init()
	action.add_motion_damage("dcol00", "dcol01", "モンスター剣", 2.5, 1.0, "避け攻撃", 0.43, 0.6)
	action.set_move_speed(3.2)
end

--- Starts the wolf form's attacks when the attack or special button is pressed.
function script.loop()
	local prog: s32 = 0
	local attack_button: s32 = 0
	local special_button: s32 = 0
	action.set_program_value(0)
	while true do
		prog = action.get_program_value() or prog
		if prog >= 100 and prog < 199 then
			action.turn_toward_target(40.0, 5.0)
			run_gun_attack()
		end
		if prog >= 200 and prog < 299 then
			action.turn_toward_target(40.0, 5.0)
			run_dodge_attack()
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
