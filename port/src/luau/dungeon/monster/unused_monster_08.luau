--!strict
--- Defines an unreferenced placeholder monster whose handlers are inert.

local vm = require("@lib/vm")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

local unknown_value_0: f32 = 0
local unknown_value_1: f32 = 0
local unknown_value_2: f32 = 0

--- Keeps the monster's looping sound running and clears the second value.
local function keep_loop_sound()
	monster.keep_monster_loop_sound_3(unknown_value_0, unknown_value_1, unknown_value_2) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	unknown_value_1 = 0.0
end

local script = {}

--- Runs once when the script is loaded and has nothing to set up.
function script.setup() end

--- Sets the monster up when it is placed.
script.init = keep_loop_sound

--- Holds the monster idle.
function script.loop()
	monster.call_command(119, 1, 0) -- retail: the handler rejects 2 arguments
	monster.call_command(119, 2, 0) -- retail: the handler rejects 2 arguments
	monster.set_model_lighting(0)
	while true do
		vm.wait()
	end
end

--- Staggers the monster back and recovers when it takes a hit.
function script.on_damage()
	state.stop_and_clear_action_variant()
	monster.set_life("ダメージ", -1, 6)
	monster.call_command(140, 4.0, 0.0, 3) -- retail: the handler rejects 3 arguments
	state.wait_until_alive()
	timer.wait_frames(12)
	-- retail: monster.set_life("立ち") does nothing, since its handler ignores a string as argument 1
	state.do_nothing()
end

--- Knocks the monster down, then lets it get back up.
function script.on_knockdown()
	state.lock_and_face_target_variant()
	monster.set_life("吹っ飛び", -1, 6)
	monster.call_command(140, 3.0, 0.05, 20) -- retail: the handler rejects 3 arguments
	state.wait_until_alive()
	monster.set_model_lighting(1)
	timer.wait_frames(30)
	monster.set_model_lighting(0)
	monster.set_life("起き上がり", -1, 6)
	state.wait_until_alive()
	-- retail: monster.set_life("立ち") does nothing, since its handler ignores a string as argument 1
	state.unlock_variant()
end

--- Plays the guard motions when the monster blocks a hit.
function script.on_guard()
	state.stop_and_reset_motion_variant()
	monster.set_life("歩き", -1, 0)
	movement.turn_toward_target_and_wait_variant(21.0)
	monster.get_attack_power_0()
	monster.set_life("ガードin", -1, 6)
	state.wait_until_alive()
	monster.set_life("ガード", -1, 0)
	monster.call_command(140, 3.0, 0.0, 2) -- retail: the handler rejects 3 arguments
	timer.wait_frames(30)
	monster.set_life("ガードout", -1, 6)
	state.wait_until_alive()
	monster.set_life("立ち", 0)
	state.do_nothing()
end

--- Dodges the first kind of incoming attack.
function script.on_dodge_1()
	local facing_angle: f32 = 0
	state.lock_and_reset_motion_variant()
	monster.call_command(75, facing_angle) -- retail: the handler rejects 1 arguments
	if facing_angle > vm.f32(3.1415927) then
		facing_angle = vm.f32(facing_angle - vm.f32(6.2831855))
	end
	if facing_angle <= vm.f32(-3.1415927) then
		facing_angle = vm.f32(facing_angle + vm.f32(6.2831855))
	end
	monster.call_command(68, 0.0, facing_angle, 0.0) -- retail: command 68 is not registered
	vm.wait()
	monster.set_life("立ち", -1, 0)
	state.unlock_variant()
end

--- Dodges the second kind of incoming attack.
function script.on_dodge_2()
	local facing_angle: f32 = 0
	state.lock_and_reset_motion_variant()
	monster.call_command(75, facing_angle) -- retail: the handler rejects 1 arguments
	if facing_angle > vm.f32(3.1415927) then
		facing_angle = vm.f32(facing_angle - vm.f32(6.2831855))
	end
	if facing_angle <= vm.f32(-3.1415927) then
		facing_angle = vm.f32(facing_angle + vm.f32(6.2831855))
	end
	monster.call_command(68, 0.0, facing_angle, 0.0) -- retail: command 68 is not registered
	vm.wait()
	monster.set_life("立ち", -1, 0)
	state.unlock_variant()
end

--- Plays the death motion and holds the monster.
function script.on_death()
	death.begin_variant()
	monster.set_life("死に", -1, 2)
	state.wait_until_alive()
	monster.call_command(142) -- retail: command 142 is not registered
	while true do
		vm.wait()
	end
	death.play_effects_variant()
end

--- Struggles in place while the monster is held.
function script.on_caught()
	monster.set_life("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Gets the monster back up after it has been thrown and lands.
function script.on_land()
	combat.finish_throw_variant()
	monster.call_command(72) -- retail: the handler rejects 0 arguments
	monster.call_command(143) -- retail: command 143 is not registered
	timer.wait_frames(10)
	monster.get_attack_power_0()
	monster.set_life("起き上がり", -1, 6)
	state.wait_until_alive()
	state.do_nothing_hook()
	return 1
end

--- Knocks the monster over and holds it until the stun ends.
function script.on_stun()
	state.clear_attribute_and_lock_variant()
	monster.set_life("吹っ飛び", -1, 6)
	state.wait_until_alive()
	monster.set_life("起き上がり", -1, 6)
	state.wait_until_alive()
	reaction.stun_until_recovered_variant()
end

return script
