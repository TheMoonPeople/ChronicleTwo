--!strict
-- dungeon/monster/e236a.stb: monster script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/monster/helper_1ef0d4b2")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")
local helper_b44b0a55 = require("@lib/monster/helper_b44b0a55")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

local global0: f32 = 0
local global1: f32 = 0
local global2: f32 = 0

--- Helper function.
local function helper_16a0()
	monster.call_command(50, global0, global1, global2) -- retail: the handler rejects 3 arguments
	global1 = 0.0
end

--- Helper function.
local function helper_116c(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32)
	local var5: f32 = 0
	local var6: f32 = 0
	var5 = vm.f32(arg0 * vm.f32(0.017453292))
	monster.call_command(60, var6) -- retail: the handler rejects 1 arguments
	var6 = vm.f32(var6 - vm.f32(3.1415927))
	var6 = vm.f32(var6 + var5)
	if var6 > vm.f32(3.1415927) then
		var6 = vm.f32(var6 - vm.f32(6.2831855))
	end
	if var6 <= vm.f32(-3.1415927) then
		var6 = vm.f32(var6 + vm.f32(6.2831855))
	end
	monster.call_command(61, var6, arg1, arg2, arg3, arg4) -- retail: the handler rejects 5 arguments
	return arg2, arg3, arg4
end

--- Helper function.
local function helper_18b0(arg0: f32)
	if arg0 < 0.0 then
		arg0 = vm.f32(arg0 * -1.0)
	end
	return arg0
end

--- Helper function.
local function helper_1c04(arg0: f32, arg1: f32)
	local var2: f32 = 0
	local result: f32 = 0
	local var5: f32 = 0
	do
		local out1, _ = monster.get_pause_flags(var2) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		result = vm.bits_float(out1) or result
	end
	result = helper_18b0(vm.f32(helper_28452e16(arg0) - helper_28452e16(result)))
	if helper_28452e16(arg1) == 0.0 then
		var5 = 0.0
	else
		var5 = vm.f32(vm.fdiv(result, helper_28452e16(arg1)))
	end
	if var5 < 1.0 then
		var5 = 0.0
	end
	return var5
end

--- Helper function.
local function helper_83c()
	local var0: f32 = 0
	local result: f32 = 0
	do
		local out1, _ = monster.get_pause_flags(var0) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		result = vm.bits_float(out1) or result
	end
	monster.set_save_flag(result, 0)
end

--- Helper function.
local function helper_1e70(arg0: f32, arg1: f32, arg2: f32)
	local var3: f32 = 0
	local result: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	arg0 = helper_787df986(arg0)
	if arg0 > vm.f32(3.1415927) then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	if arg0 <= vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	arg1 = helper_787df986(arg1)
	var8 = helper_1c04(arg0, arg1)
	var7 = 0.0
	while var7 < var8 do
		do
			local out1, _ = monster.get_pause_flags(var3) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
			result = vm.bits_float(out1) or result
		end
		if helper_8971d3b6(arg0, result, arg1) == 0 then
			helper_83c()
			break
		elseif var7 >= arg2 then
			break
		else
			vm.wait()
			var7 = vm.f32(var7 + 1.0)
		end
	end
	monster.apply_reserved_image()
	return var7
end

--- Helper function.
local function helper_297c(arg0: f32, arg1: f32)
	monster.set_save_flag(helper_787df986(arg0), helper_787df986(arg1))
	local _ = helper_1e70(arg0, arg1, 360.0)
end

--- Helper function.
local function helper_2310(arg0: f32, arg1: any)
	local var2: s32 = 0
	local argument_count: s32 = 0
	local var4: f32 = 0
	var2 = 0
	while var2 < arg1 do
		argument_count = monster.get_player_status_attribute() or argument_count
		monster.call_command(59, var4) -- retail: the handler rejects 1 arguments
		if var4 < arg0 then
			monster.apply_reserved_image()
			return 1
		end
		if argument_count == 0 then
			vm.wait()
		else
			monster.apply_reserved_image()
			return 2
		end
		var2 = vm.i32(var2 + 1)
	end
	monster.apply_reserved_image()
	return 0
end

--- Helper function.
local function helper_53c8(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: s32)
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var15: s32 = 0
	var6, var7, var8 = helper_116c(arg2, arg3, var6, var7, var8)
	monster.call_command(50, var9, var10, var11) -- retail: the handler rejects 3 arguments
	arg2 = monster.keep_monster_loop_sound_4(var6, var7, var8) or arg2
	helper_297c(helper_28452e16(arg2), arg1)
	monster.get_last_attack_type(var6, var10, var8, arg0, arg0)
	var15 = helper_2310(arg4, arg5)
	return var15
end

--- Helper function.
local function helper_53c(enabled: f32)
	local bit: f32 = 0
	monster.call_command(60, bit) -- retail: the handler rejects 1 arguments
	monster.set_save_flag(bit, enabled)
end

--- Helper function.
local function helper_3180(arg0: f32)
	local var2: f32 = 0
	helper_53c(helper_787df986(arg0))
	monster.call_command(60, var2) -- retail: the handler rejects 1 arguments
	local _ = helper_1e70(helper_28452e16(var2), arg0, 360.0)
end

--- Helper function.
local function helper_2770(arg0: f32, arg1: any, arg2: s32)
	local var3: f32 = 0
	local var4: f32 = 0
	local var7: f32 = 0
	for var8 = 0, arg2 - 1 do
		monster.get_pause_flags(var4) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		monster.call_command(59, var3) -- retail: the handler rejects 1 arguments
		monster.call_command(60, var7) -- retail: the handler rejects 1 arguments
		if var3 < arg0 then
			return
		end
		vm.wait()
	end
end

--- Helper function.
local function helper_7bf8()
	monster.call_command(100, "あそび", -1, 6) -- retail: the handler rejects 3 arguments
	helper_2770(40.0, 45.0, 35)
end

--- Helper function.
local function helper_7ecc()
	local var0: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	var0 = monster.test_no_op(100) or var0
	if var0 < 50 then
		var0 = monster.test_no_op(100) or var0
		if var0 < 50 then
			var0 = monster.test_no_op(100) or var0
			var3 = monster.get_vector_length(30.0) or var3
			var4 = monster.get_vector_length(30.0) or var4
			var4 = vm.f32(var4 + 90.0)
			if var0 < 50 then
				var3 = vm.f32(-var3 - 30.0)
			else
				var3 = vm.f32(var3 + 30.0)
			end
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			local _ = helper_53c8(2.0, 3.0, var3, var4, 40.0, 30)
			helper_3180(3.0)
			monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
		else
			monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
			helper_2770(40.0, 45.0, 30)
		end
	else
		helper_7bf8()
	end
end

--- Helper function.
local function helper_a7fc()
	local var3: f32 = 0
	while true do
		vm.wait()
		monster.call_command(59, var3) -- retail: the handler rejects 1 arguments
		if var3 < 175.0 then
			vm.wait()
			return
		end
		helper_7ecc()
	end
end

--- Helper function.
local function helper_3d48(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var9: f32 = 0
	do
		local out1, _, out3 = monster.get_status_ailments()
		var7 = out1 or var7
		var9 = out3 or var9
	end
	helper_3180(arg1)
	monster.call_command(50, var4, var5, var6) -- retail: the handler rejects 3 arguments
	monster.get_last_attack_type(var7, var5, var9, arg0, arg2 + arg0)
	local _ = helper_2310(arg2, arg3)
	monster.apply_reserved_image()
end

--- Helper function.
local function helper_78c4()
	monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
	helper_3180(3.0)
	monster.call_command(100, "攻撃２", -1, 2) -- retail: the handler rejects 3 arguments
	helper_c3e8ae39(8)
	helper_3d48(4.5, 6.0, 1.0, 17)
	helper_c3e8ae39(9)
	monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
	helper_c3e8ae39(9)
end

--- Helper function.
local function helper_9a3c()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	monster.call_command(59, var1) -- retail: the handler rejects 1 arguments
	var0 = monster.test_no_op(100) or var0
	if var0 < 80 then
		var0 = monster.test_no_op(100) or var0
		if var0 < 30 then
			var0 = monster.test_no_op(100) or var0
			if var0 < 80 then
				monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
				helper_3d48(2.0, 3.0, 40.0, 60)
				monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
			else
				monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
				helper_2770(40.0, 45.0, 75)
			end
		else
			var0 = monster.test_no_op(100) or var0
			if var0 < 50 then
				var2 = -30.0
			else
				var2 = 30.0
			end
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			helper_3180(3.0)
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			helper_53c8(2.0, 3.0, var2, var1, 90.0, 45)
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			helper_3180(3.0)
			monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
			helper_2770(40.0, 45.0, 30)
		end
	else
		monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
		helper_3180(3.0)
		helper_78c4()
		monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
	end
end

--- Helper function.
local function helper_51c4(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	monster.call_command(59, var10) -- retail: the handler rejects 1 arguments
	var7, var8, var9 = helper_116c(arg1, var10, var7, var8, var9)
	monster.call_command(50, var4, var5, var6) -- retail: the handler rejects 3 arguments
	monster.get_last_attack_type(var7, var5, var9, arg0, arg0)
	local _ = helper_2310(arg2, arg3)
end

--- Helper function.
local function helper_9350()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	monster.call_command(59, var1) -- retail: the handler rejects 1 arguments
	var0 = monster.test_no_op(100) or var0
	if var0 < 60 then
		helper_78c4()
	else
		var0 = monster.test_no_op(100) or var0
		if var0 < 55 then
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			helper_3d48(2.0, 3.0, 40.0, 90)
			monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
		else
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			helper_3180(3.0)
			var0 = monster.test_no_op(100) or var0
			if var0 < 50 then
				var2 = -30.0
				monster.call_command(100, "歩き左", -1, 0) -- retail: the handler rejects 3 arguments
			else
				var2 = 30.0
				monster.call_command(100, "歩き右", -1, 0) -- retail: the handler rejects 3 arguments
			end
			helper_51c4(2.0, var2, 3.0, 60)
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			helper_3180(3.0)
			monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
			helper_2770(40.0, 45.0, 30)
		end
	end
end

--- Helper function.
local function helper_73a0()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local result: f32 = 0
	monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
	helper_3180(6.0)
	monster.call_command(100, "攻撃１", -1, 2) -- retail: the handler rejects 3 arguments
	helper_c3e8ae39(12)
	monster.call_command(50, var0, var1, var2) -- retail: the handler rejects 3 arguments
	do
		local out1, _ = monster.get_pause_flags(var3) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		result = vm.bits_float(out1) or result
	end
	var0 = vm.f32(var0 + vm.f32(100.0 * vm.sin(result)))
	var2 = vm.f32(var2 + vm.f32(100.0 * vm.cos(result)))
	monster.get_last_attack_type(var0, var1, var2, 2.8, 2.8)
	helper_c3e8ae39(28)
	monster.apply_reserved_image()
	monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
	helper_c3e8ae39(9)
end

--- Helper function.
local function helper_1498()
	local var0: s32 = 0
	while true do
		vm.wait()
		monster.call_command(101, var0) -- retail: the handler rejects 1 arguments
		if var0 ~= 0 then
			return
		end
	end
end

--- Helper function.
local function helper_6e84(arg0: f32)
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	monster.call_command(59, var5) -- retail: the handler rejects 1 arguments
	monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
	helper_3180(6.0)
	var1 = monster.test_no_op(100) or var1
	if var1 < 50 then
		monster.set_camera_mode()
		monster.call_command(100, "歩き右", -1, 6) -- retail: the handler rejects 3 arguments
		var6 = 30.0
	else
		monster.set_camera_mode()
		monster.call_command(100, "歩き左", -1, 6) -- retail: the handler rejects 3 arguments
		var6 = -30.0
	end
	var2, var3, var4 = helper_116c(var6, var5, var2, var3, var4)
	helper_2770(40.0, 45.0, 7)
	monster.get_last_attack_type(var2, global1, var4, arg0, arg0)
	monster.call_command(67, 32, 1) -- retail: command 67 is not registered
	helper_2770(40.0, 45.0, 9)
	monster.call_command(67, 32, 0) -- retail: command 67 is not registered
	monster.apply_reserved_image()
	helper_1498()
end

--- Helper function.
local function helper_6994(arg0: f32)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
	helper_3180(6.0)
	monster.call_command(67, 32, 1) -- retail: command 67 is not registered
	monster.call_command(59, var5) -- retail: the handler rejects 1 arguments
	do
		local _, out2 = monster.get_event_info_3(var2) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		var4 = out2 or var4
	end
	var7 = monster.get_vector_length(10.0) or var7
	var5 = vm.f32(var5 + vm.f32(40.0 + var7))
	var2, var3, var4 = helper_116c(0.0, var5, var2, var3, var4)
	monster.call_command(100, "歩き後", -1, 6) -- retail: the handler rejects 3 arguments
	helper_c3e8ae39(8)
	monster.call_command(50, var8, var9, var10) -- retail: the handler rejects 3 arguments
	monster.get_last_attack_type(var2, var9, var4, arg0, arg0 + 1.0)
	helper_c3e8ae39(8)
	monster.call_command(67, 32, 0) -- retail: command 67 is not registered
	monster.apply_reserved_image()
	helper_1498()
	monster.apply_reserved_image()
	-- retail: monster.get_monster_yaw("立ち", -1) does nothing, since its handler ignores a string as argument 1
end

--- Helper function.
local function helper_8cdc()
	local var0: s32 = 0
	local var4: f32 = 0
	monster.get_object_position()
	var0 = monster.test_no_op(100) or var0
	if var0 < 50 then
		helper_73a0()
	else
		var0 = monster.test_no_op(100) or var0
		if var0 < 40 then
			var0 = monster.test_no_op(100) or var0
			if var0 < 50 then
				helper_6e84(3.0)
			else
				helper_6994(3.0)
			end
		else
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			helper_3180(3.0)
			var0 = monster.test_no_op(100) or var0
			if var0 < 50 then
				var4 = -30.0
				monster.call_command(100, "歩き左", -1, 0) -- retail: the handler rejects 3 arguments
			else
				var4 = 30.0
				monster.call_command(100, "歩き右", -1, 0) -- retail: the handler rejects 3 arguments
			end
			helper_51c4(2.0, var4, 3.0, 45)
			monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
			helper_3180(3.0)
			monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
		end
	end
end

--- Helper function.
local function helper_a2e4()
	local var0: f32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	while true do
		vm.wait()
		monster.call_command(59, var0) -- retail: the handler rejects 1 arguments
		if var0 > 175.0 then
			vm.wait()
			return
		end
		monster.call_command(157, var2) -- retail: command 157 is not registered
		if var2 == 0 then
			vm.wait()
			return
		end
		monster.call_command(159, var1) -- retail: command 159 is not registered
		if var1 > 1 then
			helper_7ecc()
			continue
		end
		if var0 < 175.0 and var0 >= 140.0 then
			helper_9a3c()
		elseif var0 < 140.0 and var0 >= 90.0 then
			helper_9350()
		else
			helper_8cdc()
		end
	end
end

--- Helper function.
local function helper_5dd4()
	monster.apply_reserved_image()
	helper_83c()
end

--- Helper function.
local function helper_5ec()
	local var0: f32 = 0
	monster.call_command(60, var0) -- retail: the handler rejects 1 arguments
	monster.is_save_flag_set(0.0, var0, 0.0)
end

--- Helper function.
local function helper_5efc()
	monster.apply_reserved_image()
	helper_83c()
	helper_5ec()
	vm.wait()
end

--- Helper function.
local function helper_5cac()
	monster.apply_reserved_image()
	helper_83c()
end

--- Helper function.
local function helper_6048()
	monster.apply_reserved_image()
	helper_83c()
	monster.end_throw()
end

--- Helper function.
local function helper_610c()
	monster.call_command(154) -- retail: command 154 is not registered
	while true do
		vm.wait()
	end
end

--- Helper function.
local function helper_676c()
	monster.apply_reserved_image()
	monster.call_command(155) -- retail: command 155 is not registered
	helper_c3e8ae39(10)
	monster.set_camera_mode()
end

--- Helper function.
local function helper_63d8()
	monster.call_command(152, 1, 1) -- retail: the handler rejects 2 arguments
	monster.call_command(152, 2, 1) -- retail: the handler rejects 2 arguments
	monster.set_camera_mode()
end

--- Helper function.
local function helper_420()
	local var0: s32 = 0
	monster.call_command(79) -- retail: the handler rejects 0 arguments
	var0 = monster.move_toward_position() or var0
	while var0 > 0 do
		var0 = monster.move_toward_position() or var0
		vm.wait()
	end
end

--- Helper function.
local function helper_64cc()
	-- retail: monster.get_monster_yaw("気絶", -1) does nothing, since its handler ignores a string as argument 1
	helper_420()
	monster.call_command(152, 1, 0) -- retail: the handler rejects 2 arguments
	monster.call_command(152, 2, 0) -- retail: the handler rejects 2 arguments
end

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Sets the monster up when it is placed.
function script.init()
	monster.get_no_damage_hit_count("通常攻撃", 5.0, "攻撃１", 0.382, 0.697, 0)
	monster.get_no_damage_hit_count("吹っ飛び攻撃", 6.0, "攻撃２", 0.522, 0.652, 1)
	helper_16a0()
end

--- Runs the monster's normal behaviour.
function script.loop()
	local var0: s32 = 0
	monster.call_command(152, 1, 0) -- retail: the handler rejects 2 arguments
	monster.call_command(152, 2, 0) -- retail: the handler rejects 2 arguments
	monster.call_command(151, 0) -- retail: the handler rejects 1 arguments
	monster.call_command(157, var0) -- retail: command 157 is not registered
	while true do
		helper_a7fc()
		helper_a2e4()
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
function script.on_damage()
	helper_5dd4()
	monster.call_command(100, "ダメージ", -1, 6) -- retail: the handler rejects 3 arguments
	monster.start_knockback(4.0, 0.0, 3)
	helper_1498()
	helper_c3e8ae39(12)
	monster.call_command(100, "立ち") -- retail: the handler rejects 1 arguments
	helper_1ef0d4b2()
end

--- Reacts to a hit that knocks it over.
function script.on_knockdown()
	helper_5efc()
	monster.call_command(100, "吹っ飛び", -1, 6) -- retail: the handler rejects 3 arguments
	monster.start_knockback(3.0, 0.05, 20)
	helper_1498()
	monster.call_command(151, 1) -- retail: the handler rejects 1 arguments
	helper_c3e8ae39(30)
	monster.call_command(151, 0) -- retail: the handler rejects 1 arguments
	monster.call_command(100, "起き上がり", -1, 6) -- retail: the handler rejects 3 arguments
	helper_1498()
	monster.call_command(100, "立ち") -- retail: the handler rejects 1 arguments
	helper_1ef0d4b2()
end

--- Guards against a hit.
function script.on_guard()
	local var0: s32 = 0
	helper_5cac()
	var0 = monster.test_no_op(100) or var0
	if var0 < 65 then
		monster.set_camera_mode()
		monster.call_command(100, "ガード入り", -1, 6) -- retail: the handler rejects 3 arguments
		helper_1498()
		monster.call_command(100, "ガード", -1, 0) -- retail: the handler rejects 3 arguments
		monster.start_knockback(3.0, 0.0, 2)
		helper_c3e8ae39(8)
		monster.call_command(100, "ガード戻り", -1, 6) -- retail: the handler rejects 3 arguments
		helper_1498()
		monster.call_command(100, "立ち") -- retail: the handler rejects 1 arguments
	else
		monster.call_command(100, "歩き", -1, 0) -- retail: the handler rejects 3 arguments
		helper_3180(15.0)
		monster.set_camera_mode()
		monster.call_command(100, "ガード入り", -1, 6) -- retail: the handler rejects 3 arguments
		helper_1498()
		monster.call_command(100, "ガード", -1, 0) -- retail: the handler rejects 3 arguments
		monster.start_knockback(3.0, 0.0, 2)
		helper_c3e8ae39(60)
		monster.call_command(100, "ガード戻り", -1, 6) -- retail: the handler rejects 3 arguments
		helper_1498()
		monster.call_command(100, "立ち") -- retail: the handler rejects 1 arguments
	end
	helper_1ef0d4b2()
end

--- Dodges the target's first kind of attack.
function script.on_dodge_1()
	helper_1ef0d4b2()
	helper_6994(3.0)
	monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
	helper_1ef0d4b2()
end

--- Dodges the target's second kind of attack.
function script.on_dodge_2()
	helper_1ef0d4b2()
	helper_6e84(3.0)
	monster.call_command(100, "立ち", -1, 0) -- retail: the handler rejects 3 arguments
	helper_1ef0d4b2()
end

--- Runs the monster's death.
function script.on_death()
	helper_6048()
	monster.call_command(100, "死に", -1, 2) -- retail: the handler rejects 3 arguments
	helper_1498()
	monster.call_command(154) -- retail: command 154 is not registered
	while true do
		vm.wait()
	end
	helper_610c()
end

--- Reacts to being caught by a frame that lifts it.
function script.on_caught()
	monster.call_command(100, "じたばた", -1, 4) -- retail: the handler rejects 3 arguments
	while true do
		vm.wait()
	end
end

--- Lands the monster after it has been thrown.
function script.on_land()
	helper_676c()
	monster.apply_reserved_image()
	monster.call_command(155) -- retail: command 155 is not registered
	helper_c3e8ae39(10)
	monster.set_camera_mode()
	monster.call_command(100, "起き上がり", -1, 6) -- retail: the handler rejects 3 arguments
	helper_1498()
	helper_b44b0a55()
	return 1
end

--- Stuns the monster.
function script.on_stun()
	helper_63d8()
	monster.call_command(100, "吹っ飛び", -1, 6) -- retail: the handler rejects 3 arguments
	helper_1498()
	monster.call_command(100, "起き上がり", -1, 6) -- retail: the handler rejects 3 arguments
	helper_1498()
	helper_64cc()
end

return script
