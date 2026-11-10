--!strict
-- dungeon/monster/b07a_atora_red.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02ce7891 = require("@lib/monster/helper_02ce7891")
local helper_1029a353 = require("@lib/monster/helper_1029a353")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_783c61dc = require("@lib/monster/helper_783c61dc")
local helper_aa93a1aa = require("@lib/monster/helper_aa93a1aa")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_e306f388 = require("@lib/monster/helper_e306f388")

--- Helper function.
local function helper_1a1bc()
	local value: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local scale: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	monster.set_variable(27, 1)
	value = monster.get_variable(31) or value
	do
		local out1, out2, out3 = monster.get_monster_position(value)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	monster.get_monster_yaw_2(value)
	do
		local out1, out2, out3 = monster.get_position_3()
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	var8 = var2
	var9 = vm.f32(var3 + 100.0)
	var10 = var4
	scale = helper_783c61dc(scale, var8, var9, var10, 60.0)
	do
		local out1, out2, out3 = monster.copy_vector(var8, var9, var10)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var14, var15, var16, var5, var6, var7)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var14, var15, var16)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = monster.scale_vector(var14, var15, var16, scale)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	var1 = 0
	while var1 < vm.ftoi(60.0) do
		do
			local out1, out2, out3 = monster.add_vectors(var5, var6, var7, var14, var15, var16)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		monster.set_position(var5, var6, var7)
		vm.wait()
		var1 = var1 + 1
	end
	monster.set_variable(27, 2)
end

--- Helper function.
local function helper_1995c()
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var12: f32 = 0
	local scale: f32 = 0
	monster.set_variable(27, 8)
	do
		local out1, out2, out3 = monster.get_position_3()
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	var5 = vm.f32(var2 + vm.f32(vm.sin(0.0) * 30.0))
	var6 = var3
	var7 = vm.f32(var4 + vm.f32(vm.cos(0.0) * 30.0))
	var12 = monster.get_distance_between(var5, var6, var7, var2, var3, var4) or var12
	scale = vm.f32(var12 / 45.0)
	do
		local out1, out2, out3 = monster.copy_vector(var5, var6, var7)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var8, var9, var10, var2, var3, var4)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var8, var9, var10)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = monster.scale_vector(var8, var9, var10, scale)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	var1 = 0
	while var1 < vm.ftoi(45.0) do
		do
			local out1, out2, out3 = monster.add_vectors(var2, var3, var4, var8, var9, var10)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		monster.set_position(var2, var3, var4)
		vm.wait()
		var1 = var1 + 1
	end
	monster.set_variable(27, 16)
end

--- Helper function.
local function helper_19020()
	local value: s32 = 0
	local slot: s32 = 0
	local chara_type: s32 = 0
	local value_2: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local rot_y: f32 = 0
	monster.set_variable(27, 32)
	value = monster.get_variable(31) or value
	do
		local out1, out2, out3 = monster.get_monster_position(value)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	rot_y = monster.get_monster_yaw_2(value) or rot_y
	monster.get_position_3()
	chara_type = monster.get_character_number() or chara_type
	value_2 = monster.get_variable(31) or value_2
	slot = monster.create_effect_2("アトラの光") or slot
	monster.set_variable(24, slot)
	monster.set_effect_owner(slot, chara_type)
	monster.set_effect_value(slot, 0, 0)
	monster.set_effect_value(slot, 1, value_2)
	monster.set_effect_value(slot, 7, 1)
	var11 = var5
	var12 = vm.f32(var6 + 100.0)
	var13 = var7
	rot_y = 0.0
	for var1 = 0, 149 do
		rot_y = vm.f32(rot_y + vm.f32(0.19634955))
		var5 = vm.f32(var11 + vm.f32(vm.sin(rot_y) * 30.0))
		var6 = var12
		var7 = vm.f32(var13 + vm.f32(vm.cos(rot_y) * 30.0))
		monster.set_position(var5, var6, var7)
		vm.wait()
	end
	monster.finish_effect(slot)
	monster.set_variable(27, 64)
end

--- Helper function.
local function helper_1aa34()
	local value: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local scale: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	do
		local out1, out2, _ = monster.copy_vector(0.0, 0.0, 0.0)
		var5 = out1 or var5
		var6 = out2 or var6
	end
	value = monster.get_variable(31) or value
	var5 = monster.get_variable_float(0) or var5
	var6 = monster.get_variable_float(1) or var6
	monster.get_variable_float(2)
	do
		local out1, out2, out3 = monster.get_monster_position(value)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	var18 = vm.f32(vm.sin(var5) * 50.0)
	var19 = vm.f32(vm.cos(var5) * 50.0)
	var20 = vm.f32(vm.sin(var6) * 50.0)
	var21 = vm.f32(vm.cos(var6) * 50.0)
	var8 = vm.f32(var2 + var20)
	var9 = vm.f32(vm.f32(var3 + 50.0) + var18)
	var10 = vm.f32(vm.f32(var4 + var19) + var21)
	scale = helper_783c61dc(scale, var8, var9, var10, 60.0)
	do
		local out1, out2, out3 = monster.copy_vector(var8, var9, var10)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var14, var15, var16, var11, var12, var13)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var14, var15, var16)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = monster.scale_vector(var14, var15, var16, scale)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	var1 = 0
	while var1 < vm.ftoi(60.0) do
		do
			local out1, out2, out3 = monster.add_vectors(var11, var12, var13, var14, var15, var16)
			var11 = out1 or var11
			var12 = out2 or var12
			var13 = out3 or var13
		end
		monster.set_position(var11, var12, var13)
		vm.wait()
		var1 = var1 + 1
	end
end

--- Helper function.
local function helper_1b680(arg0: f32)
	local value: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	do
		local out1, out2, _ = monster.copy_vector(0.0, 0.0, 0.0)
		var8 = out1 or var8
		var9 = out2 or var9
	end
	value = monster.get_variable(31) or value
	var8 = monster.get_variable_float(0) or var8
	var9 = monster.get_variable_float(1) or var9
	do
		local out1, out2, out3 = monster.get_monster_position(value)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var11 = vm.f32(vm.sin(var8) * 50.0)
	var12 = vm.f32(vm.cos(var8) * 50.0)
	var13 = vm.f32(vm.sin(var9) * 50.0)
	var14 = vm.f32(vm.cos(var9) * 50.0)
	pos_x = vm.f32(var2 + var13)
	pos_y = vm.f32(vm.f32(var3 + 50.0) + var11)
	pos_z = vm.f32(vm.f32(var4 + var12) + var14)
	monster.set_position(pos_x, pos_y, pos_z)
	var8 = vm.f32(var8 + arg0)
	var9 = vm.f32(var9 + arg0)
	helper_e306f388(var8, var9, 0.0)
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	helper_1029a353()
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(8, 1)
	monster.set_variable_float(0, 0.0)
	monster.set_variable_float(1, 0.0)
	monster.set_variable_float(2, 0.0)
	monster.get_variable(31)
	monster.load_effect_script("アトラの光")
	monster.set_clip_distance(9999.9)
	monster.set_monster_attributes(512, 1)
	monster.set_monster_attributes(16, 1)
	monster.set_variable(27, 0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local value: s32 = 0
	local value_2: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	monster.set_motion("ループ", -1, 0)
	var2 = vm.f32(0.049087387)
	var3 = vm.f32(0.0002)
	while true do
		value = monster.get_variable(30) or value
		if value == 4 then
			if var2 < vm.f32(0.0004) or var2 > vm.f32(-0.0004) then
				helper_1a1bc()
			end
		end
		value_2 = monster.get_variable(27) or value_2
		if value_2 == 2 then
			helper_1995c()
			monster.set_variable(27, 16)
		end
		value_2 = monster.get_variable(27) or value_2
		if value_2 == 16 then
			helper_19020()
		end
		value_2 = monster.get_variable(27) or value_2
		if value_2 == 64 then
			helper_1aa34()
			monster.set_variable(27, 4)
			var2 = 0.0
			var3 = vm.f32(0.0002)
		end
		var2 = vm.f32(var2 + var3)
		if var2 > vm.f32(0.09817477) then
			var2 = vm.f32(0.09817477)
			var3 = vm.f32(var3 * -1.0)
		end
		if var2 < vm.f32(-0.09817477) then
			var2 = vm.f32(-0.09817477)
			var3 = vm.f32(var3 * -1.0)
		end
		helper_1b680(var2)
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
function script.on_death()
	local value: s32 = 0
	helper_02ce7891()
	monster.set_variable(27, 128)
	monster.set_monster_attributes(2, 1)
	monster.set_monster_attributes(4, 0)
	monster.set_monster_attributes(8, 0)
	monster.set_monster_attributes(16, 0)
	value = monster.get_variable(24) or value
	monster.finish_effect(value)
	monster.set_motion("死に入り", -1, 6)
	helper_56d63eae()
	monster.set_motion("死に", -1, 4)
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
	helper_193f5239()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	monster.set_motion("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_aa93a1aa()
	monster.stop_moving()
	monster.end_throw()
	helper_c3e8ae39(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
-- Defined empty, so the engine runs this instead of its default.
function script.on_stun() end

return script
