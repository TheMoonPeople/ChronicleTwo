--!strict
-- dungeon/monster/e214a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2c50af1c = require("@lib/monster/helper_2c50af1c")
local helper_4b32ee99 = require("@lib/monster/helper_4b32ee99")
local helper_7c50ce86 = require("@lib/monster/helper_7c50ce86")

--- Helper function.
local function helper_db88()
	local no_damage_cnt: s32 = 0
	local timer: s32 = 0
	local value: s32 = 0
	no_damage_cnt = monster.get_no_damage_hit_count() or no_damage_cnt
	timer = monster.get_dungeon_timer() or timer
	value = monster.get_variable(6) or value
	if value == 0 and no_damage_cnt >= 1 and timer >= 900 then
		monster.set_variable(6, 1)
		monster.request_event_script(501)
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
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

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_motion("立ち")
	while true do
		helper_db88()
		helper_7c50ce86()
		helper_2c50af1c()
		helper_4b32ee99()
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_damage() end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
function script.on_knockdown() end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
function script.on_guard() end

--- Dodges the target's first kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_1() end

--- Dodges the target's second kind of attack.
-- Defined empty, so the engine runs this instead of its default.
function script.on_dodge_2() end

--- Runs the monster's death.
-- Defined empty, so the engine runs this instead of its default.
function script.on_death() end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
function script.on_land() end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
function script.on_stun() end

return script
