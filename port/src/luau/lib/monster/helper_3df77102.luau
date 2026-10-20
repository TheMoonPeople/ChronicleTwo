--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07f813d9 = require("@lib/monster/helper_07f813d9")
local helper_21f9f6c4 = require("@lib/monster/helper_21f9f6c4")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_362382c7 = require("@lib/monster/helper_362382c7")
local helper_461f64ff = require("@lib/monster/helper_461f64ff")
local helper_9d1ba522 = require("@lib/monster/helper_9d1ba522")
local helper_a1e1ffb2 = require("@lib/monster/helper_a1e1ffb2")
local helper_d17f2e95 = require("@lib/monster/helper_d17f2e95")
local helper_e3808540 = require("@lib/monster/helper_e3808540")

--- Helper function.
local function helper_3df77102()
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
	helper_461f64ff()
	argc = monster.GetRnd(100) or argc
	if argc < 10 then
	else
	end
	monster.VPush2(0, 0)
	monster.GetTargetDist()
	do
		local out1, out2, out3 = monster.GetPlacePos_3()
		place_pos_x = out1 or place_pos_x
		place_pos_y = out2 or place_pos_y
		place_pos_z = out3 or place_pos_z
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var5 = monster.GetDistVector2(pos_x, pos_y, pos_z, place_pos_x, place_pos_y, place_pos_z) or var5
	do
		local _, out2, _ = monster.GetRot()
		var15 = out2 or var15
	end
	var18 = monster.SearchArea(100.0, 0.0) or var18
	if var18 < 30.0 then
		print("1------------------------------------------------\n")
		var7 = monster.GetRndf(360.0) or var7
		monster.SetMos("歩き", -1, 0)
		helper_362382c7(var7, vm.f32(4.8))
		var18 = monster.SearchArea(100.0, 0.0) or var18
		var18 = vm.f32(var18 - 30.0)
		if var18 > 0.0 then
			helper_a1e1ffb2(vm.f32(4.8), 1.75, var7, var18, 30.0, 30.0, 30)
		end
		monster.SetMos("立ち", -1, 0)
	end
	if var5 > 300.0 then
		argc = monster.GetRnd(100) or argc
		if argc < 90 then
			if var5 > 800.0 then
				do
					local out1, out2, out3 = monster.GetPos_3()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				do
					local _, out2, _ = monster.GetTargetPos()
					var20 = out2 or var20
				end
				monster.SetPlacePos(pos_x, var20 + 30.0, pos_z)
			end
			argc = monster.GetRnd(100) or argc
			if argc < 30 then
				print("2------------------------------------------------\n")
				monster.VPush2(0, 4)
				argc = monster.GetRnd(100) or argc
				var22 = monster.GetRndf(360.0) or var22
				var5 = monster.GetRndf(150.0) or var5
				if argc < 50 then
					var22 = vm.f32(-var22 - 30.0)
				else
					var22 = vm.f32(var22 + 30.0)
				end
				monster.SetMos("歩き", -1, 0)
				helper_e3808540(place_pos_x, place_pos_y, place_pos_z, 1.75, vm.f32(4.8), var5, var22, 30.0, 30.0, 60)
				var23 = monster.GetRndf(180.0) or var23
				argc = monster.GetRnd(100) or argc
				if argc < 50 then
					var23 = vm.f32(var23 * -1.0)
				end
				helper_362382c7(var23, vm.f32(4.8))
				monster.SetMos("立ち", -1, 0)
			else
				print("3------------------------------------------------\n")
				monster.VPush2(0, 8)
				monster.SetMos("立ち", -1, 0)
				var1 = helper_07f813d9(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
			monster.GetRnd(100) -- retail: argument 2 is a value where the handler writes an output; the output is discarded
			return
		end
	end
	argc = monster.GetRnd(100) or argc
	if argc < 40 then
		argc = monster.GetRnd(100) or argc
		if argc < 80 then
			monster.VPush2(0, 8)
			monster.SetMos("立ち", -1, 0)
			helper_07f813d9(100.0, 50.0, 35.0, vm.f32(1.2), 30)
		else
			print("4------------------------------------------------\n")
			monster.VPush2(0, 16)
			var7 = monster.GetRndf(180.0) or var7
			argc = monster.GetRnd(100) or argc
			if argc < 50 then
				var7 = vm.f32(var7 * -1.0)
			end
			monster.SetMos("歩き", -1, 0)
			helper_362382c7(var7, vm.f32(4.8))
			monster.SetMos("立ち", -1, 0)
		end
	else
		argc = monster.GetRnd(100) or argc
		if argc < 50 then
			argc = monster.GetRnd(100) or argc
			if argc < 50 then
				argc = monster.GetRnd(100) or argc
				if argc < 50 then
					print("5------------------------------------------------\n")
					monster.VPush2(0, 4)
					argc = monster.GetRnd(100) or argc
					var24 = monster.GetRndf(180.0) or var24
					var25 = monster.GetRndf(30.0) or var25
					var26 = monster.GetTargetDist() or var26
					var25 = vm.f32(var25 + var26)
					if argc < 50 then
						var24 = vm.f32(var24 * -1.0)
					end
					argc = monster.GetRnd(100) or argc
					if argc < 50 then
						var24 = vm.f32(-var24 - 30.0)
					else
						var24 = vm.f32(var24 + 30.0)
					end
					monster.SetMos("歩き", -1, 0)
					var1 = helper_9d1ba522(1.75, vm.f32(4.8), var24, var25, 30.0, 30.0, 60)
					var27 = monster.GetRndf(360.0) or var27
					argc = monster.GetRnd(100) or argc
					if argc < 50 then
						var27 = vm.f32(var27 * -1.0)
					end
					helper_362382c7(var27, vm.f32(4.8))
					monster.SetMos("立ち", -1, 0)
				else
					print("6------------------------------------------------\n")
					monster.VPush2(0, 32)
					monster.SetMos("歩き", -1, 0)
					do
						local _, out2, _ = monster.GetRot()
						var15 = out2 or var15
					end
					var7 = helper_28452e16(var15)
					if var7 > vm.f32(3.1415927) then
						var7 = vm.f32(var7 - vm.f32(6.2831855))
					end
					if var7 <= vm.f32(-3.1415927) then
						var7 = vm.f32(var7 + vm.f32(6.2831855))
					end
					helper_d17f2e95(1.75, var7, 1000.0, 30.0, 30.0, 60)
					monster.SetMos("立ち", -1, 0)
				end
			else
				monster.VPush2(0, 8)
				monster.SetMos("立ち", -1, 0)
				var1 = helper_07f813d9(100.0, 50.0, 35.0, vm.f32(1.2), 30)
				if var1 == 1 then
					return
				end
			end
		elseif var2 == 8 then
			print("7------------------------------------------------\n")
			monster.VPush(0, 1)
			argc = monster.GetRnd(120) or argc
			var5 = monster.GetTargetDist() or var5
			argc = vm.i32(argc + 15)
			monster.SetMos("歩き", -1, 0)
			helper_21f9f6c4(1.75, vm.f32(4.8), var5, 360.0, 40.0, 30.0, 30.0, argc)
			monster.SetMos("立ち", -1, 0)
		end
	end
end

return helper_3df77102
