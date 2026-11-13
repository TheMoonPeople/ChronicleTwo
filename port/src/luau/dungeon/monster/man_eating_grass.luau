--!strict
--- Behaviour for the Man-Eating Grass family, a rooted plant that spits poison and bites nearby targets.

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the clip distance when the monster is placed.
local function configure_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Stands facing the target until it comes within range.
local function wait_until_target_near()
	local target_distance: f32 = 0
	while true do
		monster.set_motion("立ち", -1, 0)
		vm.wait()
		behavior.try_face_transformed_player_plain_speed_4()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 250.0 then
			vm.wait()
			return
		end
	end
end

--- Spits poison at the target or attacks it while it is at medium range.
local function spit_or_attack_at_mid_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	vm.wait()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 120.0 then
			monster.set_motion("立ち", -1, 0)
			movement.turn_toward_target_and_wait(10.0)
			combat.spit_poison(6.0, 30.0, 0.5, 27)
		else
			monster.set_motion("立ち", -1, 0)
			movement.turn_toward_target_and_wait(10.0)
			combat.spit_poison(7.0, 45.0, 0.5, 27)
		end
		monster.set_motion("立ち", -1, 0)
		timer.wait_frames(3)
	else
		roll = monster.get_random(100) or roll
		if roll < 50 then
			monster.set_motion("立ち", -1, 0)
			movement.turn_toward_target_and_wait(10.0)
			combat.play_primary_attack()
		else
			monster.set_motion("立ち", -1, 0)
			movement.turn_toward_target_and_wait(10.0)
			motion.play_fidget()
		end
	end
end

--- Attacks the target and follows with a repeated attack when it stays close.
local function attack_at_close_range()
	local roll: s32 = 0
	local target_distance: f32 = 0
	monster.get_life_int()
	roll = monster.get_random(100) or roll
	if roll < 50 then
		monster.set_motion("立ち", -1, 0)
		movement.turn_toward_target_and_wait(10.0)
		combat.play_primary_attack()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance < 50.0 then
			roll = monster.get_random(3) or roll
			combat.repeat_attack_then_tire(vm.i32(1 + roll))
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Fights the target by distance each frame until it moves away or no rage hits remain.
local function fight_with_rage_hits_left()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		vm.wait()
		behavior.try_face_transformed_player_plain_speed_4()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 250.0 then
			vm.wait()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 4 then
			behavior.choose_idle_action()
			continue
		end
		if target_distance < 250.0 and target_distance >= 150.0 then
			behavior.choose_spit_or_idle()
		elseif target_distance < 150.0 and target_distance >= 50.0 then
			spit_or_attack_at_mid_range()
		else
			attack_at_close_range()
		end
		vm.wait()
	end
end

--- Fights the target by distance each frame until rage hits are available.
local function fight_without_rage_hits()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local close_distance: f32 = 0
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 250.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 5 then
			behavior.choose_idle_action()
			continue
		end
		if target_distance < 50.0 then
			monster.set_motion("立ち", -1, 0)
			movement.turn_toward_target_and_wait(10.0)
			combat.play_primary_attack()
			close_distance = monster.get_target_distance() or close_distance
			if close_distance < 50.0 then
				roll = monster.get_random(3) or roll
				combat.repeat_attack_then_tire(vm.i32(1 + roll))
				monster.set_motion("立ち", -1, 0)
			end
		elseif target_distance <= 250.0 and target_distance > 150.0 then
			monster.set_motion("立ち", -1, 0)
			movement.turn_toward_target_and_wait(10.0)
			combat.spit_poison(9.0, 45.0, 0.5, 27)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(2)
		else
			monster.set_motion("立ち", -1, 0)
			movement.turn_toward_target_and_wait(10.0)
			combat.spit_poison(7.0, 45.0, 0.5, 27)
			monster.set_motion("立ち", -1, 0)
			timer.wait_frames(2)
		end
	end
end

local script = {}

--- Does nothing; the monster needs no load-time setup.
function script.setup() end

--- Registers the bite attacks, photo pose and poison effects when the monster is placed.
function script.init()
	local grade: s32 = 0
	local texture_block: s32 = 0
	local poison_spit_loaded: s32 = 0
	local poison_splash_loaded: s32 = 0
	monster.register_damage_hit("Ｍ連撃１", 6.6, "攻撃１", 0.25, 0.38, 0)
	monster.register_damage_hit("Ｍ連撃１", 6.6, "攻撃１", 0.438, 0.59, 1)
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.set_photo_opportunity("遊び", 0.0, 1.0, 1012)
	end
	texture_block = monster.get_free_texture_block() or texture_block
	if texture_block ~= -1 then
		poison_spit_loaded = monster.load_effect_script("毒液2L", texture_block) or poison_spit_loaded
		poison_splash_loaded = monster.load_effect_script("毒液H", texture_block) or poison_splash_loaded
		if (if poison_spit_loaded ~= 0 then 1 else poison_splash_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	configure_clip_distance()
end

--- Runs the behaviour update every frame.
function script.loop()
	local rage_hits_left: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	monster.set_monster_attributes(128, 1)
	while true do
		vm.wait()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			behavior.try_face_transformed_player_plain_speed_4()
			wait_until_target_near()
			fight_with_rage_hits_left()
		else
			fight_without_rage_hits()
		end
	end
end

--- Plays the damage pose until the status ailment ends.
function script.on_status_hit()
	local ailments: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	ailments = 1
	while ailments ~= 0 do
		ailments = monster.get_status_ailments(40) or ailments
		vm.wait()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Staggers and recovers after a normal hit.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the knockdown, lies on the ground and gets back up.
function script.on_knockdown()
	state.lock_and_face_target()
	monster.set_motion("ダメージ", -1, 6)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Raises a guard against a hit.
function script.on_guard()
	state.lock_and_stop_moving()
	monster.reset_motion()
	monster.set_motion("ガード入り", -1, 6)
	motion.wait_until_finished()
	monster.set_motion("ガード", -1, 0)
	monster.start_knockback(3.0, 0.0, 2)
	timer.wait_frames(8)
	monster.set_motion("立ち")
	state.unlock()
end

--- Does nothing besides locking and unlocking the monster.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Lunges forward when the target is far away.
function script.on_dodge_2()
	local target_distance: f32 = 0
	state.lock_and_reset_motion()
	target_distance = monster.get_target_distance() or target_distance
	if target_distance > 170.0 then
		monster.set_monster_attributes(32, 1)
		monster.reset_motion()
		monster.set_motion("攻撃１", 0.1, 6)
		timer.wait_frames(42)
		monster.set_monster_attributes(32, 0)
	end
	state.unlock()
end

--- Plays the death animation and effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the empty handler stops the engine's default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the empty handler stops the engine's default.
function script.on_land() end

--- Plays the stun recovery.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_recovered()
end

return script
