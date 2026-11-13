--!strict
--- Controls Gaja Ein, one of two twin swordsman bosses.

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
local camera = require("@lib/monster/camera")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets a short clip distance for ordinary monsters and an effectively unlimited one for bosses.
local function apply_boss_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

local script = {}

--- Runs once when the script loads.
function script.setup() end

--- Registers the attack hit windows and sword trails and loads the shockwave effect.
function script.init()
	monster.register_damage_hit("通常攻撃", 2.5, "攻撃１", 0.5, 0.75, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 3.0, "攻撃１", 0.5, 0.75, 1)
	monster.register_damage_hit("通常攻撃", 2.5, "攻撃２", 0.5, 0.8, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 3.0, "攻撃２", 0.5, 0.8, 1)
	monster.register_damage_hit("通常攻撃", 6.0, "攻撃２", 0.15, 0.8, 2)
	monster.add_sword_trail(0, "攻撃１", 0.32, 0.37, "dcol1", "dcol0", 77, 20, 20)
	monster.add_sword_trail(0, "攻撃２", 0.5, 0.53, "dcol1", "dcol0", 77, 20, 20)
	monster.set_variable(64, 0)
	monster.load_effect_script("ＳウェーブＬ")
	apply_boss_clip_distance()
end

--- Fights the target when near and chases it otherwise.
function script.loop()
	local target_distance: f32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 240.0 then
			behavior.run_combat_loop()
		else
			monster.set_motion("歩き", 0.65, 0)
			movement.turn_toward_target_and_wait(4.0)
			monster.set_motion("歩き", 0.6, 0)
			movement.chase_target(vm.f32(2.4), 4.0, 49.0, 90)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Stays staggered while a status ailment lasts.
function script.on_status_hit()
	local has_status_ailment: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	has_status_ailment = 1
	while has_status_ailment ~= 0 do
		has_status_ailment = monster.get_status_ailments(40) or has_status_ailment
		vm.wait()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers back from a hit and recovers.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Is thrown back, lies down and gets up.
function script.on_knockdown()
	state.lock_and_face_target()
	monster.set_motion("吹っ飛び", -1, 6)
	monster.start_knockback(3.0, 0.05, 20)
	motion.wait_until_finished()
	monster.set_action_status(1)
	timer.wait_frames(3)
	monster.set_action_status(0)
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Guards the hit and recovers.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(8)
	monster.set_motion("ガードout", -1, 2)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	state.unlock()
end

--- Sidesteps or steps back to dodge.
function script.on_dodge_1()
	local target_angle: f32 = 0
	local roll: s32 = 0
	state.lock_and_reset_motion()
	target_angle = monster.get_target_angle() or target_angle
	monster.set_rotation(0.0, target_angle, 0.0)
	vm.wait()
	roll = monster.get_random(20) or roll
	if roll < 20 then
		monster.set_motion("歩き", 0.65, 0)
		movement.turn_toward_target_and_wait(4.0)
		movement.sidestep()
		monster.set_motion("歩き", 0.65, 0)
		movement.turn_toward_target_and_wait(4.0)
		monster.set_motion("立ち", -1, 0)
	else
		target_angle = monster.get_target_angle() or target_angle
		monster.set_rotation(0.0, target_angle, 0.0)
		vm.wait()
		movement.step_backward_by_progress()
		monster.set_motion("歩き", 0.65, 0)
		movement.turn_toward_target_and_wait(4.0)
		monster.set_motion("立ち", -1, 0)
	end
	state.unlock()
end

--- Guards in place to avoid the attack.
function script.on_dodge_2()
	state.lock_and_reset_motion()
	monster.set_motion("ガードin", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(8)
	monster.set_motion("ガードout", -1, 2)
	motion.wait_until_finished()
	monster.set_motion("立ち")
	state.unlock()
end

--- Plays its death and starts the ending cutscene once both twins are dead.
function script.on_death()
	local dead_twin_count: s32 = 0
	dead_twin_count = monster.get_variable(64) or dead_twin_count
	monster.set_variable(64, vm.i32(dead_twin_count + 1))
	death.begin()
	monster.set_motion("死に", -1, 2)
	motion.wait_until_finished()
	monster.spawn_death_effects()
	timer.wait_frames(30)
	dead_twin_count = monster.get_variable(64) or dead_twin_count
	if dead_twin_count == 2 then
		camera.reset_mode()
		monster.request_event_script(504)
	end
	while true do
		vm.wait()
	end
	death.play_effects()
end

--- Struggles forever while caught.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Recovers from a throw and gets up.
function script.on_land()
	combat.finish_throw_delayed()
	monster.stop_moving()
	monster.end_throw()
	timer.wait_frames(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	state.do_nothing_hook()
	return 1
end

--- Falls over, gets up and waits out the stun.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("起き上がり", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_recovered()
end

return script
