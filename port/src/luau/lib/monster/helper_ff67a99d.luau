--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09cefb45 = require("@lib/monster/helper_09cefb45")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_595cbf61 = require("@lib/monster/helper_595cbf61")
local helper_65df8bdc = require("@lib/monster/helper_65df8bdc")
local helper_6e272166 = require("@lib/monster/helper_6e272166")
local helper_7e925497 = require("@lib/monster/helper_7e925497")
local helper_a973d0cd = require("@lib/monster/helper_a973d0cd")
local helper_beda02f3 = require("@lib/monster/helper_beda02f3")

--- Helper function.
local function helper_ff67a99d()
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
	if var18 < 35.0 then
		print("1------------------------------------------------\n")
		var7 = monster.get_random_whole_number(360.0) or var7
		monster.set_motion("歩き", -1, 0)
		helper_595cbf61(var7, vm.f32(4.8))
		var18 = monster.get_clear_distance(100.0, 0.0) or var18
		var18 = vm.f32(var18 - 35.0)
		if var18 > 0.0 then
			helper_6e272166(vm.f32(4.8), 2.0, var7, var18, 35.0, 25.0, 30)
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
				monster.set_place_position(pos_x, var20 + 25.0, pos_z)
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
				helper_a973d0cd(place_pos_x, place_pos_y, place_pos_z, 2.0, vm.f32(4.8), var5, var22, 35.0, 25.0, 60)
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
	if argc < 35 then
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
					var1 = helper_65df8bdc(2.0, vm.f32(4.8), var24, var25, 35.0, 25.0, 60)
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
					helper_beda02f3(2.0, var7, 1000.0, 35.0, 25.0, 60)
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
			helper_09cefb45(2.0, vm.f32(4.8), var5, 360.0, 40.0, 35.0, 25.0, argc)
			monster.set_motion("立ち", -1, 0)
		end
	end
end

return helper_ff67a99d
