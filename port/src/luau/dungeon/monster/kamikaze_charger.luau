--!strict
--- Drives a monster that idles and charges at the target in a kamikaze attack.

local vm = require("@lib/vm")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local timer = require("@lib/monster/timer")

--- Dashes at the target's position in a kamikaze charge and then stands.
local function charge_at_target()
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	movement.face_target_instantly()
	do
		local out1, out2, out3 = monster.get_target_position()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	monster.move_toward_position(target_x, target_y, target_z, 5.0, 10.0)
	monster.set_motion("特攻")
	movement.wait_until_move_finished(90)
	monster.set_motion("立ち")
	timer.wait_frames(8)
end

local script = {}

--- Runs when the script is loaded.
function script.setup() end

--- Sets the monster up when it is placed.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default setup.
function script.init() end

--- Idles forever.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
	end
end

--- Staggers back from a hit.
function script.on_damage()
	monster.stop_moving()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	timer.wait_frames(16)
end

--- Staggers back and charges at the target if it has no rage hits left.
function script.on_knockdown()
	local rage_hits_left: s32 = 0
	monster.stop_moving()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(16)
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left == 0 then
		charge_at_target()
	end
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default guard.
function script.on_guard() end

--- Charges at the target if it has no rage hits left.
function script.on_dodge_1()
	local rage_hits_left: s32 = 0
	rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
	if rage_hits_left == 0 then
		charge_at_target()
	end
end

--- Plays the missed-attack motion.
function script.on_dodge_2()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_motion("攻撃外れ", -1, 2)
	motion.wait_until_finished()
end

--- Plays the death motion and effects.
function script.on_death()
	monster.stop_moving()
	movement.stop_turning()
	monster.start_death()
	monster.set_motion("吹っ飛び死に", -1, 6)
	motion.wait_until_finished()
	monster.set_action_status(1)
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
end

return script
