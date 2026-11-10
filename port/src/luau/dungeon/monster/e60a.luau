--!strict
-- dungeon/monster/e60a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_193f5239 = require("@lib/monster/helper_193f5239")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_28faa04b = require("@lib/monster/helper_28faa04b")
local helper_2e729f21 = require("@lib/monster/helper_2e729f21")
local helper_2f2adeb4 = require("@lib/monster/helper_2f2adeb4")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_49610f43 = require("@lib/monster/helper_49610f43")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_57b569a8 = require("@lib/monster/helper_57b569a8")
local helper_57bfae69 = require("@lib/monster/helper_57bfae69")
local helper_595cbf61 = require("@lib/monster/helper_595cbf61")
local helper_59867820 = require("@lib/monster/helper_59867820")
local helper_5d37e9f4 = require("@lib/monster/helper_5d37e9f4")
local helper_704fd595 = require("@lib/monster/helper_704fd595")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_7e925497 = require("@lib/monster/helper_7e925497")
local helper_83dc8947 = require("@lib/monster/helper_83dc8947")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")
local helper_905c94a1 = require("@lib/monster/helper_905c94a1")
local helper_9bdbdfd5 = require("@lib/monster/helper_9bdbdfd5")
local helper_a2d828a7 = require("@lib/monster/helper_a2d828a7")
local helper_a551797e = require("@lib/monster/helper_a551797e")
local helper_aada6ba2 = require("@lib/monster/helper_aada6ba2")
local helper_ab4b367a = require("@lib/monster/helper_ab4b367a")
local helper_ac26cdde = require("@lib/monster/helper_ac26cdde")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_de1504df = require("@lib/monster/helper_de1504df")
local helper_e2fdabb9 = require("@lib/monster/helper_e2fdabb9")

--- Helper function.
local function helper_1ba0()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Helper function.
local function helper_f308(arg0: f32, arg1: f32, arg2: f32, scale: f32, arg4: f32, arg5: f32, arg6: any)
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var22: f32 = 0
	local var23: s32 = 0
	local var24: s32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		var7 = out1 or var7
		var8 = out2 or var8
		var9 = out3 or var9
	end
	var19 = helper_57b569a8(var19)
	arg1 = vm.f32(var19 + arg5)
	do
		local out1, out2, out3 = monster.copy_vector(arg0, arg1, arg2)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var13, var14, var15, var7, var8, var9)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var13, var14, var15)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	do
		local out1, out2, out3 = monster.scale_vector(var13, var14, var15, scale)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	monster.copy_vector(arg0, arg1, arg2)
	var11 = monster.get_angle_to_position(var7 + var13, var8 + var14, var9 + var15) or var11
	var23 = 0
	while var23 < arg6 do
		do
			local out1, out2, out3 = monster.add_vectors(var7, var8, var9, var13, var14, var15)
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		var22 = monster.get_height_above_ground_at(var7, var8, var9) or var22
		if var22 >= 50.0 or var22 <= 0.0 then
			var8 = vm.f32(var8 - var14)
			var14 = 0.0
		end
		var20 = monster.get_distance_between(var7, var8, var9, arg0, arg1, arg2) or var20
		if var20 < vm.f32(scale + arg4) then
			return 1
		end
		var24 = helper_de1504df(var7, var8, var9, scale, var11)
		if var24 ~= 0 then
			return var24
		end
		monster.set_position(var7, var8, var9)
		monster.copy_vector(var7, var8, var9)
		helper_0ba23e4e()
		var23 = vm.i32(var23 + 1)
	end
	return 0
end

--- Helper function.
local function helper_17d7c(arg0: any)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local chara_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	helper_f308(pos_x, 25.0, pos_z, 0.875, 10.0, 5.0, 150)
	while true do
		helper_0ba23e4e()
		chara_id = monster.get_player_transform_id() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(90.0) == 0 then
				monster.set_motion("歩き", -1, 0)
				helper_890ee63a(vm.f32(4.8))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_18160()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	chara_id = monster.get_player_transform_id() or chara_id
	if chara_id > -1 then
		helper_17d7c(monster_id)
	end
end

--- Helper function.
local function helper_11b04(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: s32)
	local target: f32 = 0
	local target_2: f32 = 0
	local target_3: f32 = 0
	local var18: s32 = 0
	target, target_2, target_3 = helper_125e5305(arg2, arg3, target, target_2, target_3)
	arg2 = monster.get_angle_to_position(target, target_2, target_3) or arg2
	if arg2 > vm.f32(3.1415927) then
		arg2 = vm.f32(arg2 - vm.f32(6.2831855))
	end
	if arg2 <= vm.f32(-3.1415927) then
		arg2 = vm.f32(arg2 + vm.f32(6.2831855))
	end
	helper_595cbf61(helper_28452e16(arg2), arg1)
	helper_442b9962()
	var18 = helper_f308(target, target_2, target_3, arg0, arg4, arg5, arg6)
	return var18
end

--- Helper function.
local function helper_18598()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		var3 = monster.get_random_whole_number(30.0) or var3
		var4 = monster.get_random_whole_number(30.0) or var4
		var4 = vm.f32(var4 + 100.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		helper_11b04(1.75, vm.f32(4.8), var3, var4, 50.0, 50.0, 30)
		helper_890ee63a(vm.f32(4.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_7ca8a12f(50.0, 45.0, 30)
	end
end

--- Helper function.
local function helper_fea4(scale: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32)
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var12: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var21: f32 = 0
	local var23: s32 = 0
	var18 = monster.get_target_distance() or var18
	helper_890ee63a(arg1)
	helper_442b9962()
	do
		local out1, out2, out3 = monster.get_target_position()
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		var8 = out1 or var8
		var9 = out2 or var9
		var9 = out3 or var9
	end
	var17 = helper_57b569a8(var17)
	var6 = vm.f32(var17 + arg3)
	do
		local out1, out2, out3 = monster.copy_vector(var5, var6, var7)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var14, var15, var16, var8, var9, var10)
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
	do
		local _, out2, _ = monster.get_rotation()
		var12 = out2 or var12
	end
	for var22 = 0, arg4 - 1 do
		do
			local out1, out2, out3 = monster.add_vectors(var8, var9, var10, var14, var15, var16)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		var21 = monster.get_height_above_ground_at(var8, var9, var10) or var21
		if var21 >= 50.0 or var21 <= 0.0 then
			var9 = vm.f32(var9 - var15)
			var15 = 0.0
		end
		var18 = monster.get_distance_between(var8, var9, var10, var5, var6, var7) or var18
		if var18 < vm.f32(scale + arg2) then
			return
		end
		var23 = helper_de1504df(var8, var9, var10, scale, var12)
		if var23 ~= 0 then
			print("hit------------------\n")
			return
		end
		monster.set_position(var8, var9, var10)
		helper_0ba23e4e()
	end
end

--- Helper function.
local function helper_1b2a8()
	local var0: f32 = 0
	local var1: f32 = 0
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 30 then
		monster.set_motion("立ち", -1, 0)
		helper_7ca8a12f(50.0, 45.0, 45)
	else
		argc = monster.get_random(100) or argc
		if argc < 30 then
			monster.set_motion("歩き", -1, 0)
			var1 = monster.get_target_distance() or var1
			monster.get_random_whole_number(360.0, var0)
			helper_11b04(1.75, vm.f32(4.8), var0, var1, 50.0, 50.0, 50)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			helper_fea4(4.0, vm.f32(4.8), 50.0, 50.0, 30)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_1ada0()
	local var0: f32 = 0
	local var1: f32 = 0
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 70 then
		monster.set_motion("歩き", -1, 0)
		helper_9bdbdfd5(4.0, vm.f32(4.8), 50.0, 40.0, 0, 90)
		monster.set_motion("立ち", -1, 0)
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(50.0, 45.0, 45)
		else
			monster.set_motion("歩き", -1, 0)
			var1 = monster.get_target_distance() or var1
			var0 = monster.get_random_whole_number(360.0) or var0
			helper_11b04(1.75, vm.f32(4.8), var0, var1, 50.0, 50.0, 50)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_19a74()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	monster.set_motion("歩き", -1, 0)
	do
		local out1, out2, out3 = monster.get_target_position()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	helper_890ee63a(vm.f32(9.6))
	monster.reset_motion()
	monster.set_motion("攻撃１in", -1, 6)
	helper_56d63eae()
	monster.set_motion("攻撃１", -1, 0)
	var10 = helper_57bfae69(var3, var4, var5, var10)
	helper_f308(var3, vm.f32(var4 + 10.0), var5, 5.25, 5.0, 10.0, 60)
	var9 = monster.get_target_angle() or var9
	do
		local out1, out2, out3 = monster.get_target_position()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.set_rotation(0.0, var9, 0.0)
	vm.wait()
	var9 = vm.f32(var9 + vm.f32(3.1415927))
	if var9 > vm.f32(3.1415927) then
		var9 = vm.f32(var9 - vm.f32(6.2831855))
	end
	if var9 <= vm.f32(-3.1415927) then
		var9 = vm.f32(var9 + vm.f32(6.2831855))
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var9) * 150.0))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var9) * 150.0))
	monster.set_motion("攻撃１out", -1, 6)
	helper_f308(pos_x, pos_y, pos_z, vm.f32(2.1000001), vm.f32(16.666666), 50.0, 30)
end

--- Helper function.
local function helper_13098(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	monster.get_target_position()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		var11 = out2 or var11
	end
	var13 = vm.f32(var11 + vm.f32(3.1415927))
	if var13 > vm.f32(3.1415927) then
		var13 = vm.f32(var13 - vm.f32(6.2831855))
	end
	if var13 <= vm.f32(-3.1415927) then
		var13 = vm.f32(var13 + vm.f32(6.2831855))
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var13) * var14))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var13) * var14))
	helper_f308(pos_x, pos_y, pos_z, arg0, arg1, arg2, arg3)
end

--- Helper function.
local function helper_1a7c0()
	local var0: f32 = 0
	local argc: s32 = 0
	local var3: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 70 then
		monster.set_motion("歩き", -1, 0)
		helper_fea4(1.75, vm.f32(4.8), 50.0, 50.0, 15)
		helper_19a74()
		monster.set_motion("立ち", -1, 0)
	else
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_motion("歩き", -1, 0)
			var0 = monster.get_target_distance() or var0
			var3 = monster.get_random_whole_number(360.0) or var3
			var0 = vm.f32(var0 + 30.0)
			helper_11b04(1.75, vm.f32(4.8), var3, var0, 25.0, 40.0, 50)
		else
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(vm.f32(4.8))
			helper_13098(1.75, 50.0, 46.0, 60)
			helper_890ee63a(vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_1b78c()
	local var3: f32 = 0
	local gekirin: s32 = 0
	local priority: s32 = 0
	helper_18160()
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin <= 0 then
		return
	end
	priority = monster.get_priority() or priority
	if priority > 6 then
		helper_18598()
		return
	end
	var3 = helper_e2fdabb9(var3)
	if var3 < 350.0 and var3 >= 180.0 then
		helper_1b2a8()
	elseif var3 < 180.0 and var3 >= 100.0 then
		helper_1ada0()
	else
		helper_1a7c0()
	end
end

--- Helper function.
local function helper_11eb4(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	helper_595cbf61(arg2, arg0)
	helper_442b9962()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(vm.f32(arg2 * vm.f32(0.017453292))) * arg3))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(vm.f32(arg2 * vm.f32(0.017453292))) * arg3))
	local _ = helper_f308(pos_x, pos_y, pos_z, arg1, arg4, arg5, arg6)
end

--- Helper function.
local function helper_126a4(
	target: f32,
	target_2: f32,
	target_3: f32,
	arg3: f32,
	arg4: f32,
	arg5: f32,
	arg6: f32,
	arg7: f32,
	arg8: f32,
	arg9: s32
)
	local target_4: f32 = 0
	local target_2_2: f32 = 0
	local target_3_2: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	var17 = vm.f32(arg6 * vm.f32(0.017453292))
	var18 = monster.get_angle_to_position(target, target_2, target_3) or var18
	var18 = vm.f32(var18 - vm.f32(3.1415927))
	var18 = vm.f32(var18 + var17)
	if var18 > vm.f32(3.1415927) then
		var18 = vm.f32(var18 - vm.f32(6.2831855))
	end
	if var18 <= vm.f32(-3.1415927) then
		var18 = vm.f32(var18 + vm.f32(6.2831855))
	end
	target_4 = vm.f32(target + vm.f32(arg5 * vm.sin(var18)))
	target_2_2 = 0.0
	target_3_2 = vm.f32(target_3 + vm.f32(arg5 * vm.cos(var18)))
	arg6 = monster.get_angle_to_position(target_4, target_2_2, target_3_2) or arg6
	helper_595cbf61(helper_28452e16(arg6), arg4)
	helper_442b9962()
	local _ = helper_f308(target_4, target_2_2, target_3_2, arg3, arg7, arg8, arg9)
end

--- Helper function.
local function helper_12240(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	arg1 = helper_787df986(arg1)
	if arg1 > vm.f32(3.1415927) then
		arg1 = vm.f32(arg1 - vm.f32(6.2831855))
	end
	if arg1 <= vm.f32(-3.1415927) then
		arg1 = vm.f32(arg1 + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(arg1) * arg2))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(arg1) * arg2))
	local _ = helper_f308(pos_x, pos_y, pos_z, arg0, arg3, arg4, arg5)
end

--- Helper function.
local function helper_11670(arg0: f32, arg1: f32, arg2: f32, range: f32, range_2: f32, arg5: f32, arg6: f32, arg7: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var12: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	var15 = monster.get_random_whole_number(range_2) or var15
	var16 = monster.get_random_whole_number(range) or var16
	var15 = vm.f32(var15 + arg2)
	helper_595cbf61(var16, arg1)
	helper_442b9962()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = monster.get_rotation()
		var12 = out2 or var12
	end
	pos_x = vm.f32(pos_x + vm.f32(vm.sin(var12) * var15))
	pos_z = vm.f32(pos_z + vm.f32(vm.cos(var12) * var15))
	local _ = helper_f308(pos_x, pos_y, pos_z, arg0, arg5, arg6, arg7)
end

--- Helper function.
local function helper_155c4()
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local place_pos_x: f32 = 0
	local place_pos_y: f32 = 0
	local place_pos_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var15: f32 = 0
	local var18: f32 = 0
	local var20: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	helper_0ba23e4e()
	argc = monster.get_random(100) or argc
	if argc < 10 then
	else
	end
	monster.set_secondary_variable(0, 0)
	monster.get_target_distance()
	do
		local out1, out2, out3 = monster.get_place_position_3()
		place_pos_x = out1 or place_pos_x
		place_pos_y = out2 or place_pos_y
		place_pos_z = out3 or place_pos_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var5 = monster.get_distance_between(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or var5
	do
		local _, out2, _ = monster.get_rotation()
		var15 = out2 or var15
	end
	var18 = monster.get_clear_distance(100.0, 0.0) or var18
	if var18 < 50.0 then
		print("1------------------------------------------------\n")
		var7 = monster.get_random_whole_number(360.0) or var7
		monster.set_motion("歩き", -1, 0)
		helper_595cbf61(var7, vm.f32(4.8))
		var18 = monster.get_clear_distance(100.0, 0.0) or var18
		var18 = vm.f32(var18 - 50.0)
		if var18 > 0.0 then
			helper_11eb4(vm.f32(4.8), 1.75, var7, var18, 50.0, 50.0, 30)
		end
		monster.set_motion("立ち", -1, 0)
	end
	if var5 > 300.0 then
		argc = monster.get_random(100) or argc
		if argc < 90 then
			if var5 > 800.0 then
				do
					local out1, out2, out3 = monster.get_position_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				do
					local _, out2, _ = monster.get_target_position()
					var20 = out2 or var20
				end
				monster.set_place_position(pos_x, var20 + 50.0, pos_z)
			end
			argc = monster.get_random(100) or argc
			if argc < 30 then
				print("2------------------------------------------------\n")
				monster.set_secondary_variable(0, 4)
				argc = monster.get_random(100) or argc
				var22 = monster.get_random_whole_number(360.0) or var22
				var5 = monster.get_random_whole_number(150.0) or var5
				if argc < 50 then
					var22 = vm.f32(-var22 - 30.0)
				else
					var22 = vm.f32(var22 + 30.0)
				end
				monster.set_motion("歩き", -1, 0)
				helper_126a4(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.8), var5, var22, 50.0, 50.0, 60)
				var23 = monster.get_random_whole_number(180.0) or var23
				argc = monster.get_random(100) or argc
				if argc < 50 then
					var23 = vm.f32(var23 * -1.0)
				end
				helper_595cbf61(var23, vm.f32(4.8))
				monster.set_motion("立ち", -1, 0)
			else
				print("3------------------------------------------------\n")
				monster.set_secondary_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_7e925497(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
			monster.get_random(100, argc)
			return
		end
	end
	argc = monster.get_random(100) or argc
	if argc < 30 then
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_secondary_variable(0, 8)
			monster.set_motion("立ち", -1, 0)
			helper_7e925497(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			print("4------------------------------------------------\n")
			monster.set_secondary_variable(0, 16)
			var7 = monster.get_random_whole_number(180.0) or var7
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var7 = vm.f32(var7 * -1.0)
			end
			monster.set_motion("歩き", -1, 0)
			helper_595cbf61(var7, vm.f32(4.8))
			monster.set_motion("立ち", -1, 0)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			argc = monster.get_random(100) or argc
			if argc < 50 then
				argc = monster.get_random(100) or argc
				if argc < 50 then
					print("5------------------------------------------------\n")
					monster.set_secondary_variable(0, 4)
					argc = monster.get_random(100) or argc
					var24 = monster.get_random_whole_number(180.0) or var24
					var25 = monster.get_random_whole_number(30.0) or var25
					var26 = monster.get_target_distance() or var26
					var25 = vm.f32(var25 + var26)
					if argc < 50 then
						var24 = vm.f32(var24 * -1.0)
					end
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var24 = vm.f32(-var24 - 30.0)
					else
						var24 = vm.f32(var24 + 30.0)
					end
					monster.set_motion("歩き", -1, 0)
					var1 = helper_11b04(1.75, vm.f32(4.8), var24, var25, 50.0, 50.0, 60)
					var27 = monster.get_random_whole_number(360.0) or var27
					argc = monster.get_random(100) or argc
					if argc < 50 then
						var27 = vm.f32(var27 * -1.0)
					end
					helper_595cbf61(var27, vm.f32(4.8))
					monster.set_motion("立ち", -1, 0)
				else
					print("6------------------------------------------------\n")
					monster.set_secondary_variable(0, 32)
					monster.set_motion("歩き", -1, 0)
					do
						local _, out2, _ = monster.get_rotation()
						var15 = out2 or var15
					end
					var7 = helper_28452e16(var15)
					if var7 > vm.f32(3.1415927) then
						var7 = vm.f32(var7 - vm.f32(6.2831855))
					end
					if var7 <= vm.f32(-3.1415927) then
						var7 = vm.f32(var7 + vm.f32(6.2831855))
					end
					helper_12240(1.75, var7, 1000.0, 50.0, 50.0, 60)
					monster.set_motion("立ち", -1, 0)
				end
			else
				monster.set_secondary_variable(0, 8)
				monster.set_motion("立ち", -1, 0)
				var1 = helper_7e925497(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
		elseif var2 == 8 then
			print("7------------------------------------------------\n")
			monster.set_variable(0, 1)
			argc = monster.get_random(120) or argc
			var5 = monster.get_target_distance() or var5
			argc = vm.i32(argc + 15)
			monster.set_motion("歩き", -1, 0)
			helper_11670(1.75, vm.f32(4.8), var5, 360.0, 40.0, 50.0, 50.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

--- Helper function.
local function helper_1a3f0()
	local gekirin: s32 = 0
	local var1: f32 = 0
	gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
	if gekirin > 0 then
		return
	end
	var1 = helper_e2fdabb9(var1)
	if var1 < 100.0 then
		monster.set_motion("歩き", -1, 0)
		helper_fea4(1.75, vm.f32(4.8), 50.0, 50.0, 30)
		helper_19a74()
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("歩き", -1, 0)
		helper_9bdbdfd5(1.75, vm.f32(4.8), 50.0, 50.0, 0, 45)
		monster.set_motion("立ち", -1, 0)
	end
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local grade: s32 = 0
	monster.set_clip_distance(500.0)
	grade = monster.get_monster_grade_2(-1) or grade
	if grade == 0 then
		monster.register_damage_hit("通常攻撃", 4.0, "攻撃１", 0.0, 1.0, 0)
	end
	if grade == 1 then
		monster.register_damage_hit("通常毒", 4.0, "攻撃１", 0.0, 1.0, 0)
	end
	if grade == 2 then
		monster.register_damage_hit("通常毒", 4.0, "攻撃１", 0.0, 1.0, 0)
	end
	if grade == 3 then
		monster.register_damage_hit("通常毒", 4.0, "攻撃１", 0.0, 1.0, 0)
	end
	monster.set_variable(0, 0)
	helper_1ba0()
	monster.stop_moving()
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(256, 1)
	helper_704fd595()
	do
		local out1, out2, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.set_position(pos_x, pos_y + 10.0, pos_z)
	helper_ac26cdde(55.0)
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: f32 = 0
	local gekirin: s32 = 0
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		vm.wait()
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin > 0 then
			var0 = helper_e2fdabb9(var0)
			helper_18160()
			if var0 < 350.0 then
				helper_1b78c()
			else
				helper_155c4()
			end
		else
			helper_1a3f0()
		end
	end
end

--- Reacts to a hit while greyed out, or to a hit that greys it out.
function script.on_status_hit()
	local var0: s32 = 0
	helper_5d37e9f4()
	print("damage stop action-------------\n")
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	var0 = 1
	while var0 ~= 0 do
		var0 = monster.get_status_ailments(40) or var0
		vm.wait()
	end
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_28faa04b()
	monster.set_motion("ダメージ", -1, 6)
	helper_56d63eae()
	helper_c3e8ae39(12)
	monster.set_motion("立ち")
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_a2d828a7()
	helper_905c94a1()
end

--- Guards against a hit.
function script.on_guard()
	helper_ab4b367a()
	helper_a551797e()
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
function script.on_death()
	helper_83dc8947()
	monster.set_motion("死に", -1, 6)
	helper_56d63eae()
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
	helper_2f2adeb4()
	monster.stop_moving()
	monster.end_throw()
	helper_c3e8ae39(10)
	monster.reset_motion()
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	helper_2e729f21()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_59867820()
	monster.set_motion("吹っ飛び", -1, 6)
	helper_56d63eae()
	monster.set_motion("起き上がり", -1, 6)
	helper_56d63eae()
	helper_aada6ba2()
end

return script
