--!strict
-- dungeon/monster/b07a_atora_yellow.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_3bd6d918 = require("@lib/monster/helper_3bd6d918")
local helper_522cc63a = require("@lib/monster/helper_522cc63a")
local helper_56845ba9 = require("@lib/monster/helper_56845ba9")
local helper_6033d0e7 = require("@lib/monster/helper_6033d0e7")
local helper_63eb9d5b = require("@lib/monster/helper_63eb9d5b")
local helper_7471d537 = require("@lib/monster/helper_7471d537")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_79d6eaca = require("@lib/monster/helper_79d6eaca")
local helper_adcbef14 = require("@lib/monster/helper_adcbef14")
local helper_af3c7344 = require("@lib/monster/helper_af3c7344")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_bbb2220b = require("@lib/monster/helper_bbb2220b")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_c99f4fa5 = require("@lib/monster/helper_c99f4fa5")
local helper_c9f11562 = require("@lib/monster/helper_c9f11562")
local helper_d7694a9b = require("@lib/monster/helper_d7694a9b")
local helper_fd06d627 = require("@lib/monster/helper_fd06d627")

local global0: f32 = 0
local global1: f32 = 0
local global2: f32 = 0

--- Helper function.
local function helper_ae40()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	monster.keep_monster_loop_sound_3(var0, var1, var2) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	monster.call_command(70, var0, var1, var2, 0.0, 0.0) -- retail: the handler rejects 5 arguments
	monster.call_command(72) -- retail: the handler rejects 0 arguments
end

--- Helper function.
local function helper_18c8()
	monster.keep_monster_loop_sound_3(global0, global1, global2) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	global1 = 0.0
end

--- Helper function.
local function helper_12738(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: f32, arg7: s32)
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local scale: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: s32 = 0
	monster.keep_monster_loop_sound_3(x, y, z) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	do
		local out1, out2, out3 = monster.copy_vector(arg0, arg1, arg2)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(var11, var12, var13, x, y, z)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	do
		local out1, out2, out3 = monster.normalize_vector(var11, var12, var13)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	var21 = monster.get_distance_between(arg0, arg1, arg2, x, y, z) or var21
	var22 = helper_adcbef14(var21, scale, vm.f32(vm.fdiv(vm.f32(vm.f32(var21 + arg5) * arg6), arg3)), var22)
	scale = arg3
	var23 = 0
	while var23 < arg7 do
		monster.keep_monster_loop_sound_3(x, y, z) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		scale = vm.f32(scale + var22)
		do
			local out1, out2, out3 = monster.copy_vector(var11, var12, var13)
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
			local out1, out2, out3 = monster.add_vectors(x, y, z, var14, var15, var16)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		monster.set_positional_sound(x, y, z)
		if scale < 0.0 then
			return
		end
		var21 = monster.get_distance_between(arg0, arg1, arg2, x, y, z) or var21
		if var21 < arg4 then
			return
		end
		monster.copy_vector(x, y, z)
		vm.wait()
		var23 = var23 + 1
	end
end

--- Helper function.
local function helper_13184(arg0: f32, arg1: any, arg2: f32, arg3: f32, arg4: s32)
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local arrived: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	helper_fd06d627(vm.f32(4.2))
	monster.keep_monster_loop_sound_3(var9, var10, var11) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	monster.set_place_position(var5, var6, var7) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
	arrived = vm.bits_float(monster.is_move_finished()) or arrived
	arrived = vm.f32(var10 - arrived)
	helper_12738(var5, vm.f32(arrived + arg2), var7, arg0, arg0, arg3, vm.f32(1.9), arg4)
end

--- Helper function.
local function helper_43a0(arg0: f32, arg1: f32)
	local no_damage_cnt: f32 = 0
	local var3: s32 = 0
	if arg1 == -1.0 then
		arg1 = vm.f32(0.03)
	end
	var3 = 0
	while true do
		vm.wait()
		no_damage_cnt = vm.bits_float(monster.get_no_damage_hit_count()) or no_damage_cnt
		if no_damage_cnt < vm.f32(arg0 + arg1) and no_damage_cnt > vm.f32(arg0 - arg1) then
			break
		else
			var3 = vm.i32(var3 + 1)
		end
	end
end

--- Helper function.
local function helper_9a34(arg0: f32, arg1: s32)
	local var2: f32 = 0
	local _ = helper_787df986(arg0)
	for var4 = 0, arg1 - 1 do
		monster.call_command(75, var2) -- retail: the handler rejects 1 arguments
		monster.call_command(69, var2, arg0) -- retail: command 69 is not registered
		vm.wait()
	end
	helper_79d6eaca()
end

--- Helper function.
local function helper_9c40(arg0: f32)
	local var1: f32 = 0
	local life: s32 = 0
	arg0 = helper_787df986(arg0)
	while true do
		monster.call_command(75, var1) -- retail: the handler rejects 1 arguments
		monster.call_command(69, var1, arg0) -- retail: command 69 is not registered
		vm.wait()
		life = monster.get_life_int() or life
		if life ~= 0 then
			helper_79d6eaca()
			break
		end
	end
end

--- Helper function.
local function helper_1342c()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	monster.set_life("攻撃１in", -1, 2)
	monster.set_life("攻撃１", -1, 6)
	helper_43a0(vm.f32(0.262), -1.0)
	for var16 = 0, 3 do
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.set_place_position(x, y, z) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		do
			local out1, out2, out3 = monster.subtract_vectors(x, y, z, pos_x, pos_y, pos_z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(x, y, z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		monster.call_command(171, "グリ羽根Ｌ１") -- retail: the handler rejects 1 arguments
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, x, y, z)
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, x, y, z)
		helper_9a34(vm.f32(4.2), 1)
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.set_place_position(x, y, z) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		do
			local out1, out2, out3 = monster.subtract_vectors(x, y, z, pos_x, pos_y, pos_z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(x, y, z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		monster.call_command(171, "グリ羽根Ｌ１") -- retail: the handler rejects 1 arguments
		monster.call_command(
			174,
			-1,
			pos_x + vm.f32(vm.sin(vm.f32(1.5707964)) * 20.0),
			pos_y,
			pos_z + vm.f32(vm.cos(vm.f32(1.5707964)) * 20.0)
		) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, x, y, z)
		helper_9a34(vm.f32(4.2), 1)
		do
			local out1, out2, out3 = monster.get_frame_position("dcol00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		monster.set_place_position(x, y, z) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 2 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed; argument 3 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		do
			local out1, out2, out3 = monster.subtract_vectors(x, y, z, pos_x, pos_y, pos_z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local out1, out2, out3 = monster.normalize_vector(x, y, z)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		monster.call_command(171, "グリ羽根Ｌ１") -- retail: the handler rejects 1 arguments
		monster.call_command(
			174,
			-1,
			pos_x + vm.f32(vm.sin(vm.f32(-1.5707964)) * 20.0),
			pos_y,
			pos_z + vm.f32(vm.cos(vm.f32(-1.5707964)) * 20.0)
		) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, x, y, z)
		helper_9a34(vm.f32(4.2), 1)
	end
	helper_9c40(vm.f32(4.2))
	monster.set_life("攻撃１out", -1, 2)
	helper_7471d537()
end

--- Helper function.
local function helper_1452c()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local argc: s32 = 0
	monster.set_life("攻撃１in", -1, 2)
	helper_7471d537()
	monster.set_life("攻撃１", -1, 2)
	helper_43a0(vm.f32(0.262), -1.0)
	for var16 = 0, 5 do
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_l00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var12 = monster.get_random_whole_number(10.0) or var12
		var13 = monster.get_random_whole_number(0.2) or var13
		var14 = monster.get_random_whole_number(180.0) or var14
		argc = monster.get_random(2) or argc
		var12 = 12.0
		var12 = vm.f32(var12 + 6.0)
		var13 = vm.f32(var13 + vm.f32(0.15))
		var14 = vm.f32(var14 * -1.0)
		var14 = vm.f32(var14 - 90.0)
		monster.call_command(171, "グリ羽根Ｌ２") -- retail: the handler rejects 1 arguments
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, var9, var10, var11)
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, var12, var13, var14)
		monster.set_motion("", 1, argc) -- retail: argument 1 is -1, an address that names nothing the handler finds
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_l01")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var12 = monster.get_random_whole_number(10.0) or var12
		var13 = monster.get_random_whole_number(0.2) or var13
		var14 = monster.get_random_whole_number(180.0) or var14
		argc = monster.get_random(2) or argc
		var12 = 12.0
		var12 = vm.f32(var12 + 6.0)
		var13 = vm.f32(var13 + vm.f32(0.15))
		var14 = vm.f32(var14 * -1.0)
		var14 = vm.f32(var14 - 90.0)
		monster.call_command(171, "グリ羽根Ｌ２") -- retail: the handler rejects 1 arguments
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, var9, var10, var11)
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, var12, var13, var14)
		monster.set_motion("", 1, argc) -- retail: argument 1 is -1, an address that names nothing the handler finds
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_r00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var12 = monster.get_random_whole_number(10.0) or var12
		var13 = monster.get_random_whole_number(0.2) or var13
		var14 = monster.get_random_whole_number(180.0) or var14
		argc = monster.get_random(2) or argc
		var12 = 12.0
		var12 = vm.f32(var12 + 6.0)
		var13 = vm.f32(var13 + vm.f32(0.15))
		var14 = vm.f32(var14 - 90.0)
		monster.call_command(171, "グリ羽根Ｌ２") -- retail: the handler rejects 1 arguments
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, var9, var10, var11)
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, var12, var13, var14)
		monster.set_motion("", 1, argc) -- retail: argument 1 is -1, an address that names nothing the handler finds
		do
			local out1, out2, out3 = monster.get_frame_position("dcol_r01")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var12 = monster.get_random_whole_number(10.0) or var12
		var13 = monster.get_random_whole_number(0.2) or var13
		var14 = monster.get_random_whole_number(180.0) or var14
		argc = monster.get_random(2) or argc
		var12 = 12.0
		var12 = vm.f32(var12 + 6.0)
		var13 = vm.f32(var13 + vm.f32(0.15))
		var14 = vm.f32(var14 - 90.0)
		monster.call_command(171, "グリ羽根Ｌ２") -- retail: the handler rejects 1 arguments
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, var9, var10, var11)
		monster.call_command(174, -1, pos_x, pos_y, pos_z) -- retail: the handler rejects 4 arguments
		monster.set_entry_object_size(-1, var12, var13, var14)
		monster.set_motion("", 1, argc) -- retail: argument 1 is -1, an address that names nothing the handler finds
		helper_9a34(vm.f32(4.2), 3)
	end
	helper_9c40(vm.f32(4.2))
	monster.set_life("攻撃１out", -1, 2)
	helper_7471d537()
end

--- Helper function.
local function helper_15e8c()
	monster.set_life("エネルギー吸収in", -1, 2)
	helper_7471d537()
	monster.set_life("エネルギー吸収", -1, 2)
	helper_7471d537()
	monster.set_life("エネルギー吸収out", 2)
	helper_7471d537()
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.call_command(119, 1, 1) -- retail: the handler rejects 2 arguments
	monster.call_command(119, 2, 1) -- retail: the handler rejects 2 arguments
	helper_ae40()
	monster.set_photo_opportunity(4, 1)
	monster.set_photo_opportunity(8, 1)
	monster.stop_palette_pulse(9999.9)
	monster.set_camera_mode(0)
	monster.call_command(106, "グリ羽根Ｌ１") -- retail: the handler rejects 1 arguments
	monster.call_command(106, "グリ羽根Ｌ２") -- retail: the handler rejects 1 arguments
	monster.call_command(106, "グリ羽根Ｈ") -- retail: the handler rejects 1 arguments
	helper_18c8()
end

--- Runs the monster's normal behaviour.
function script.loop()
	monster.set_model_lighting(0)
	monster.set_life("飛び", -1, 0)
	helper_13184(4.0, vm.f32(4.2), 60.0, 35.0, 90)
	while true do
		vm.wait()
		helper_fd06d627(vm.f32(4.2))
		helper_1342c()
		monster.set_life("飛び", -1, 0)
		helper_c3e8ae39(60)
		helper_fd06d627(vm.f32(4.2))
		helper_1452c()
		monster.set_life("飛び", -1, 0)
		helper_c3e8ae39(60)
		helper_15e8c()
		monster.set_life("飛び", -1, 0)
		helper_c3e8ae39(20)
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_d7694a9b()
	monster.set_life("ダメージ", -1, 6)
	monster.call_command(140, 4.0, 0.0, 3) -- retail: the handler rejects 3 arguments
	helper_7471d537()
	helper_c3e8ae39(12)
	-- retail: monster.set_life("立ち") does nothing, since its handler ignores a string as argument 1
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_bbb2220b()
	monster.set_life("吹っ飛び", -1, 6)
	monster.call_command(140, 3.0, 0.05, 20) -- retail: the handler rejects 3 arguments
	helper_7471d537()
	monster.set_model_lighting(1)
	helper_c3e8ae39(30)
	monster.set_model_lighting(0)
	monster.set_life("起き上がり", -1, 6)
	helper_7471d537()
	-- retail: monster.set_life("立ち") does nothing, since its handler ignores a string as argument 1
	helper_522cc63a()
end

--- Guards against a hit.
function script.on_guard()
	helper_56845ba9()
	monster.set_life("歩き", -1, 0)
	helper_fd06d627(21.0)
	monster.get_attack_power_0()
	monster.set_life("ガードin", -1, 6)
	helper_7471d537()
	monster.set_life("ガード", -1, 0)
	monster.call_command(140, 3.0, 0.0, 2) -- retail: the handler rejects 3 arguments
	helper_c3e8ae39(30)
	monster.set_life("ガードout", -1, 6)
	helper_7471d537()
	monster.set_life("立ち", 0)
	helper_1ef0d4b2()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	local var0: f32 = 0
	helper_af3c7344()
	monster.call_command(75, var0) -- retail: the handler rejects 1 arguments
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.call_command(68, 0.0, var0, 0.0) -- retail: command 68 is not registered
	vm.wait()
	monster.set_life("立ち", -1, 0)
	helper_522cc63a()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	local var0: f32 = 0
	helper_af3c7344()
	monster.call_command(75, var0) -- retail: the handler rejects 1 arguments
	if var0 > vm.f32(3.1415927) then
		var0 = vm.f32(var0 - vm.f32(6.2831855))
	end
	if var0 <= vm.f32(-3.1415927) then
		var0 = vm.f32(var0 + vm.f32(6.2831855))
	end
	monster.call_command(68, 0.0, var0, 0.0) -- retail: command 68 is not registered
	vm.wait()
	monster.set_life("立ち", -1, 0)
	helper_522cc63a()
end

--- Runs the monster's death.
function script.on_death()
	helper_c9f11562()
	monster.set_life("死に", -1, 2)
	helper_7471d537()
	monster.call_command(142) -- retail: command 142 is not registered
	while true do
		vm.wait()
	end
	helper_6033d0e7()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	monster.set_life("じたばた", -1, 4)
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_3bd6d918()
	monster.call_command(72) -- retail: the handler rejects 0 arguments
	monster.call_command(143) -- retail: command 143 is not registered
	helper_c3e8ae39(10)
	monster.get_attack_power_0()
	monster.set_life("起き上がり", -1, 6)
	helper_7471d537()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_63eb9d5b()
	monster.set_life("吹っ飛び", -1, 6)
	helper_7471d537()
	monster.set_life("起き上がり", -1, 6)
	helper_7471d537()
	helper_c99f4fa5()
end

return script
