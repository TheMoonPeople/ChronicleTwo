--!strict
--- Controls Linda's Vanguard machine in the scripted fight that ends by requesting the defeat event.

local vm = require("@lib/vm")
local combat = require("@lib/monster/combat")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local sense = require("@lib/monster/sense")
local timer = require("@lib/monster/timer")

local script = {}

--- Runs once when the script is loaded, before any program.
function script.setup() end

--- Registers the machine's body parts, hit data, variables and shockwave effect.
function script.init()
	monster.register_entry_object(0, "bcol00")
	monster.register_entry_object(1, "bcol01")
	monster.register_entry_object(2, "bcol02")
	monster.register_entry_object(3, "bcol03")
	monster.register_entry_object(4, "bcol04")
	monster.register_entry_object(5, "bcol05")
	monster.register_entry_object(6, "dcol00")
	monster.register_entry_object(7, "dcol01")
	monster.register_entry_object(8, "dcol02")
	monster.register_damage_hit("通常攻撃", 8.0, "攻撃１", 0.217, 0.256, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 8.0, "攻撃１", 0.486, 0.524, 0)
	monster.set_body(0, 15.0)
	monster.set_body(1, 5.0)
	monster.set_body(2, 5.0)
	monster.set_body(3, 9.0)
	monster.set_body(4, 5.0)
	monster.set_body(5, 5.0)
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, 2)
	monster.set_variable(3, 7)
	monster.set_variable(4, -1)
	monster.set_variable(5, 20)
	monster.set_variable(6, 0)
	monster.load_effect_script("ヴァンガード衝撃波")
	monster.set_clip_distance(120.0)
	monster.set_motion("立ち", -1, 4)
	monster.set_photo_opportunity("攻撃２", 0.245, 0.531, 1013)
end

--- Repeatedly selects and runs one of the machine's attacks.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_motion("立ち")
	while true do
		sense.store_target_range_flags()
		combat.choose_next_attack()
		combat.run_selected_attack()
		vm.wait()
	end
end

--- Flinches with a knockback while the machine's hit areas are masked.
function script.on_damage()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	movement.stop_turning()
	monster.play_sound(11)
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(8)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Flinches with a knockback while the machine's hit areas are masked.
function script.on_knockdown()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	movement.stop_turning()
	monster.play_sound(11)
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(4.0, 0.0, 3)
	motion.wait_until_finished()
	timer.wait_frames(8)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the machine has no guard reaction.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the machine has no first dodge.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the machine has no second dodge.
function script.on_dodge_2() end

--- Plays the death and requests the defeat event.
function script.on_death()
	monster.stop_moving()
	movement.stop_turning()
	monster.set_monster_attributes(2, 1)
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.start_death()
	vm.wait()
	monster.request_event_script(502)
	vm.wait()
	while true do
		vm.wait()
	end
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the machine has no held reaction.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the machine has no landing reaction.
function script.on_land() end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the machine has no stun reaction.
function script.on_stun() end

return script
