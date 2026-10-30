--!strict
-- dungeon/monster/b11a_moon.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_6a21fe95 = require("@lib/monster/helper_6a21fe95")
local helper_7000e3dd = require("@lib/monster/helper_7000e3dd")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_d8cf1050 = require("@lib/monster/helper_d8cf1050")
local helper_dbfe0a16 = require("@lib/monster/helper_dbfe0a16")

--- Helper function.
local function helper_1b98()
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

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	helper_1b98()
	monster.set_clip_distance(999999.9)
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(8, 1)
	monster.set_monster_attributes(16, 1)
	monster.set_monster_attributes(1, 1)
	monster.set_variable(0, 0)
	monster.link_map_part("p06_d06b03-0")
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local scale: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local stopwatch_limit: s32 = 0
	local value_2: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	do
		local out1, out2, out3 = monster.get_position_3()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = monster.copy_vector(var0, var1, var2)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var9, var10, var11)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = monster.scale_vector(var9, var10, var11, 5000.0)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	var6 = monster.get_distance_between(var9, var10, var11, var0, var1, var2) or var6
	scale = vm.f32(vm.fdiv(var6, 9000))
	do
		local out1, out2, out3 = monster.copy_vector(var9, var10, var11)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var3, var4, var5, var0, var1, var2)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var3, var4, var5)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = monster.scale_vector(var3, var4, var5, scale)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	while true do
		do
			local out1, out2, out3 = monster.add_vectors(var0, var1, var2, var3, var4, var5)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		monster.get_variable(0)
		var6 = monster.get_distance_between(var9, var10, var11, var0, var1, var2) or var6
		value_2 = monster.get_variable(0) or value_2
		stopwatch_limit = monster.get_event_info_2(0) or stopwatch_limit
		if stopwatch_limit <= 0 and value_2 == 0 then
			monster.set_variable(0, 1)
			do
				local out1, out2, out3 = monster.copy_vector(0.0, 0.0, 0.0)
				var3 = out1 or var3
				var4 = out2 or var4
				var5 = out3 or var5
			end
			monster.request_event_script(1201)
		end
		monster.set_position(var0, var1, var2)
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_5d37e9f4()
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_d8cf1050()
	helper_6a21fe95()
end

--- Guards against a hit.
function script.on_guard()
	helper_dbfe0a16()
	helper_7000e3dd()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	helper_49610f43()
	helper_a551797e()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_49610f43()
	helper_a551797e()
end

--- Runs the monster's death.
-- Defined empty, so the engine runs this instead of its default.
function script.on_death() end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
function script.on_land() end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
function script.on_stun() end

return script
