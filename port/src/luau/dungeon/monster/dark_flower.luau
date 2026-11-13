--!strict
--- Controls the Dark Flower plant monster: it turns toward the player to spit poison, strike and fidget, spitting from farther away once enraged.

local vm = require("@lib/vm")
local behavior = require("@lib/monster/behavior")
local combat = require("@lib/monster/combat")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local sense = require("@lib/monster/sense")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Sets the clip distance, using an unlimited distance for bosses.
local function apply_default_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Spits poison from a distance that depends on the player's range, strikes or fidgets.
local function act_at_mid_range()
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

--- Strikes with a repeated follow-up when the player is close, or spits poison at the player.
local function act_at_close_range()
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
	else
		monster.set_motion("立ち", -1, 0)
		movement.turn_toward_target_and_wait(10.0)
		combat.spit_poison(4.0, 0.0, 0.5, 32)
		monster.set_motion("立ち", -1, 0)
	end
end

--- Picks a spit or strike by distance while the player is in range, until the player leaves range or the flower enrages.
local function fight_in_range()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local rage_hits_left: s32 = 0
	while true do
		vm.wait()
		behavior.try_face_transformed_player_plain_speed_4()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 280.0 then
			vm.wait()
			return
		end
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 5 then
			behavior.choose_idle_action()
			continue
		end
		if target_distance < 280.0 and target_distance >= 150.0 then
			behavior.choose_spit_or_idle()
		elseif target_distance < 150.0 and target_distance >= 80.0 then
			act_at_mid_range()
		else
			act_at_close_range()
		end
		vm.wait()
	end
end

--- Strikes at close range and spits poison at longer range while the player is in range.
local function fight_while_enraged()
	local target_distance: f32 = 0
	local priority: s32 = 0
	local roll: s32 = 0
	local strike_target_distance: f32 = 0
	while true do
		vm.wait()
		target_distance = monster.get_target_distance() or target_distance
		if target_distance > 280.0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 6 then
			behavior.choose_idle_action()
			continue
		end
		if target_distance < 80.0 then
			roll = monster.get_random(100) or roll
			if roll < 40 then
				monster.set_motion("立ち", -1, 0)
				movement.turn_toward_target_and_wait(10.0)
				combat.play_primary_attack()
				strike_target_distance = monster.get_target_distance() or strike_target_distance
				if strike_target_distance < 50.0 then
					roll = monster.get_random(3) or roll
					combat.repeat_attack_then_tire(vm.i32(1 + roll))
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_motion("立ち", -1, 0)
				movement.turn_toward_target_and_wait(10.0)
				combat.spit_poison(4.0, 0.0, 0.5, 32)
				monster.set_motion("立ち", -1, 0)
			end
		elseif target_distance <= 280.0 and target_distance > 150.0 then
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

--- Does nothing because the monster needs no load-time setup.
function script.setup() end

--- Registers the plant's attack hit windows, loads the poison effects and applies the clip-distance default.
function script.init()
	local free_texture_block: s32 = 0
	local low_effect_handle: s32 = 0
	local high_effect_handle: s32 = 0
	monster.register_damage_hit("Ｍ連撃１", 6.6, "攻撃１", 0.25, 0.38, 0)
	monster.register_damage_hit("Ｍ連撃１", 6.6, "攻撃１", 0.438, 0.59, 1)
	free_texture_block = monster.get_free_texture_block() or free_texture_block
	if free_texture_block ~= -1 then
		low_effect_handle = monster.load_effect_script("毒液2L", free_texture_block) or low_effect_handle
		high_effect_handle = monster.load_effect_script("毒液H", free_texture_block) or high_effect_handle
		if (if low_effect_handle ~= 0 then 1 else high_effect_handle) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	apply_default_clip_distance()
end

--- Clears the mask flags and repeatedly picks between the normal and enraged routines.
function script.loop()
	local rage_hits_left: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_monster_attributes(128, 1)
	while true do
		vm.wait()
		rage_hits_left = vm.float_bits(monster.get_rage_hits_left()) or rage_hits_left
		if rage_hits_left > 0 then
			behavior.try_face_transformed_player_plain_speed_4()
			sense.wait_until_target_near()
			fight_in_range()
		else
			fight_while_enraged()
		end
	end
end

--- Plays the damage motion and waits until the status ailment wears off.
function script.on_status_hit()
	local status_ailments: s32 = 0
	state.stop_and_clear_action()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	status_ailments = 1
	while status_ailments ~= 0 do
		status_ailments = monster.get_status_ailments(40) or status_ailments
		vm.wait()
	end
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the damage motion and stays staggered briefly.
function script.on_damage()
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Plays the damage motion, waits and recovers.
function script.on_knockdown()
	state.lock_and_face_target()
	monster.set_motion("ダメージ", -1, 6)
	motion.wait_until_finished()
	timer.wait_frames(12)
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Plays the guard-in and guard motions, knocking the flower back slightly.
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

--- Locks and unlocks the monster without dodging.
function script.on_dodge_1()
	state.lock_and_reset_motion()
	state.unlock()
end

--- Lunges briefly at a distant player with a temporary attribute, then unlocks.
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

--- Plays the death motion and then the death effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine's default is not used.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine's default is not used.
function script.on_land() end

--- Plays the damage motion and stays stunned until it recovers.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("ダメージ", -1, 6)
	motion.wait_until_finished()
	reaction.stun_until_recovered()
end

return script
