--!strict
-- dungeon/monster/rin.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_5f4a60e2 = require("@lib/monster/helper_5f4a60e2")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_a004bd11 = require("@lib/monster/helper_a004bd11")
local helper_f683d690 = require("@lib/monster/helper_f683d690")

--- Helper function.
local function helper_1f6c()
	local value: s32 = 0
	local nearest_pos_x: f32 = 0
	local nearest_pos_y: f32 = 0
	local nearest_pos_z: f32 = 0
	local nearest_dist: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	value = 0
	do
		local out1, out2, out3, out4 = monster.get_nearest_monster_position()
		nearest_pos_x = out1 or nearest_pos_x
		nearest_pos_y = out2 or nearest_pos_y
		nearest_pos_z = out3 or nearest_pos_z
		nearest_dist = out4 or nearest_dist
	end
	if nearest_dist ~= -1.0 and nearest_dist < 6.0 then
		value = vm.i32(bit32.bor(value, 8))
	end
	if nearest_dist ~= -1.0 and nearest_dist < 100.0 then
		value = vm.i32(bit32.bor(value, 1))
	end
	if nearest_dist ~= -1.0 and nearest_dist > 260.0 then
		value = vm.i32(bit32.bor(value, 2))
	end
	do
		local _, out2, _ = monster.get_rotation()
		var7 = out2 or var7
	end
	var5 = monster.get_angle_to_position(nearest_pos_x, nearest_pos_y, nearest_pos_z) or var5
	if helper_8971d3b6(var5, var7, vm.f32(0.2)) ~= 0 then
		value = vm.i32(bit32.bor(value, 4))
	end
	monster.set_variable(0, value)
end

--- Helper function.
local function helper_24d8()
	local value: s32 = 0
	local value_2: s32 = 0
	local value_3: s32 = 0
	value = monster.get_variable(0) or value
	if bit32.band(value, 8) ~= 0 then
		monster.set_variable(1, 1)
		return
	end
	value_2 = monster.get_variable(2) or value_2
	if value_2 ~= -1 then
		if bit32.band(value, 1) ~= 0 and value_2 == 6 then
			monster.set_variable(1, 6)
			monster.set_variable(2, 6)
			return
		end
		value_3 = monster.get_variable(3) or value_3
		monster.set_variable(1, value_2)
		monster.set_variable(2, value_3)
		monster.set_variable(3, -1)
		return
	end
	if bit32.band(value, 8) ~= 0 then
		monster.set_variable(1, 1)
		return
	end
	if bit32.band(value, 1) ~= 0 then
		monster.set_variable(1, 5)
		monster.set_variable(2, 6)
		return
	else
		if bit32.band(value, 2) ~= 0 then
			monster.set_variable(1, 4)
			monster.set_variable(2, 2)
		end
		if bit32.band(value, 4) ~= 0 then
			monster.set_variable(1, 4)
			monster.set_variable(2, 0)
			monster.set_variable(3, 2)
			return
		end
	end
	monster.set_variable(1, 3)
end

--- Helper function.
local function helper_1ec8()
	monster.request_event_script(520)
	vm.wait()
end

--- Helper function.
local function helper_7b0(arg0: f32, arg1: f32)
	local var3: f32 = 0
	while true do
		vm.wait()
		do
			local _, out2, _ = monster.get_rotation()
			var3 = out2 or var3
		end
		if vm.f32(arg0 + arg1) > var3 and vm.f32(arg0 - arg1) < var3 then
			break
		end
	end
end

--- Helper function.
local function helper_1bec()
	local nearest_pos_x: f32 = 0
	local nearest_pos_y: f32 = 0
	local nearest_pos_z: f32 = 0
	local var4: f32 = 0
	do
		local out1, out2, out3, _ = monster.get_nearest_monster_position()
		nearest_pos_x = out1 or nearest_pos_x
		nearest_pos_y = out2 or nearest_pos_y
		nearest_pos_z = out3 or nearest_pos_z
	end
	var4 = monster.get_angle_to_position(nearest_pos_x, nearest_pos_y, nearest_pos_z) or var4
	monster.turn_toward_angle(var4, 0.06981317)
	monster.set_motion("歩き")
	helper_7b0(var4, vm.f32(0.13962634))
	monster.set_motion("おびえ立ち")
end

--- Helper function.
local function helper_1adc()
	local value: s32 = 0
	value = monster.get_variable(4) or value
	helper_5f4a60e2(value)
	monster.set_variable(4, 30)
end

--- Helper function.
local function helper_2ce4()
	local value: s32 = 0
	value = monster.get_variable(1) or value
	if value == 1 then
		helper_1ec8()
	end
	if value == 4 then
		monster.set_motion("キョロキョロ", -1, 2)
		helper_56d63eae()
	end
	if value == 5 then
		monster.set_motion("驚く", -1, 2)
		vm.wait()
		helper_f683d690()
	end
	if value == 6 then
		monster.set_motion("驚くL", -1, 4)
	end
	if value == 0 then
		helper_1bec()
	end
	if value == 2 then
		monster.set_motion("おびえ立ち")
		helper_1adc()
	end
	if value == 3 then
		monster.set_motion("おびえ立ち")
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, -1)
	monster.set_variable(3, -1)
	monster.set_variable(4, 30)
	monster.set_motion("おびえ立ち", -1, 4)
	monster.set_monster_attributes(33, 1)
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_motion("おびえ立ち")
	while true do
		helper_1f6c()
		helper_24d8()
		helper_2ce4()
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
script.on_damage = helper_a004bd11

--- Reacts to a hit that knocks it over.
script.on_knockdown = helper_a004bd11

--- Guards against a hit.
script.on_guard = helper_a004bd11

--- Dodges the target's first kind of attack.
script.on_dodge_1 = helper_a004bd11

--- Dodges the target's second kind of attack.
script.on_dodge_2 = helper_a004bd11

--- Runs the monster's death.
function script.on_death()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	monster.stop_moving()
	helper_442b9962()
	monster.start_death()
	monster.set_motion("死に", -1, 6)
	helper_56d63eae()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
function script.on_land() end

--- Stuns the monster.
function script.on_stun()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	helper_442b9962()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

return script
