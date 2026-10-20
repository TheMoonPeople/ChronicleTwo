--!strict
-- dungeon/eff_script/e118a_arrow_doku.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local user_id: s32 = 0
	local var20: s32 = 0
	local value: s32 = 0
	local var22: s32 = 0
	local var23: s32 = 0
	local var24: s32 = 0
	local dir_x: f32 = 0
	local dir_y: f32 = 0
	local dir_z: f32 = 0
	var20 = 1
	value = effect.GetValue(0) or value
	user_id = effect.GetUserId() or user_id
	do
		local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "dcol0")
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.ScnGetChrRot_4(user_id)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	do
		local out1, out2, out3 = effect.GetDirVector(rot_x, rot_y, rot_z)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.NormalVector(var9, var10, var11)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, 12.0)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	effect.ChrSetPos(var0, var1, var2)
	effect.ChrSetRot(rot_x, rot_y, rot_z)
	effect.ChrSetShow(1, 1)
	effect.ColprimCreate("通常毒")
	effect.ColprimSetDamage(value)
	effect.ChrSetMotion("ループ", -1, 0)
	var18 = var1
	var22 = 0
	while var22 < 60 do
		do
			local out1, out2, out3 = effect.GetDirVector(rot_x, rot_y, rot_z)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.NormalVector(var9, var10, var11)
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, 12.0 - vm.f32(vm.f32(0.02) * var22))
			var9 = out1 or var9
			var10 = out2 or var10
			var11 = out3 or var11
		end
		if var22 > 30 then
			var10 = vm.f32(var10 - vm.f32(vm.f32(0.06) * var22))
		end
		do
			local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var9, var10, var11)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var23 = effect.IntersectionPoint_8(4, var6, var7, var8, var0, var1, var2) or var23
		if var23 >= 0 then
			var24 = 0
			do
				local out1, out2, out3, out4, out5, out6, out7 =
					effect.IntersectionPoint_14(4, var6, var7, var8, var0, var1, var2)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
				var15 = out4 or var15
				var16 = out5 or var16
				var17 = out6 or var17
				var23 = out7 or var23
			end
			do
				local out1, out2, out3 = effect.GetDirVector(rot_x + vm.f32(1.5707964), 0.0, 0.0)
				dir_x = out1 or dir_x
				dir_y = out2 or dir_y
				dir_z = out3 or dir_z
			end
			do
				local out1, out2, out3 = effect.GetDirVector(0.0, rot_y + vm.f32(3.1415927), 0.0)
				var12 = out1 or var12
				var13 = out2 or var13
				var14 = out3 or var14
			end
			do
				local out1, out2, out3 = effect.AddVector(var12, var13, var14, dir_x, dir_y, dir_z)
				var12 = out1 or var12
				var13 = out2 or var13
				var14 = out3 or var14
			end
			do
				local out1, out2, out3 = effect.NormalVector(var12, var13, var14)
				var12 = out1 or var12
				var13 = out2 or var13
				var14 = out3 or var14
			end
			do
				local out1, out2, out3 = effect.AddVector(var12, var13, var14, var15, var16, var17)
				var12 = out1 or var12
				var13 = out2 or var13
				var14 = out3 or var14
			end
			do
				local out1, out2, out3 = effect.NormalVector(var12, var13, var14)
				var12 = out1 or var12
				var13 = out2 or var13
				var14 = out3 or var14
			end
			do
				local out1, out2, out3 = effect.CopyVector(var12, var13, var14)
				var9 = out1 or var9
				var10 = out2 or var10
				var11 = out3 or var11
			end
			do
				local out1, out2, out3 = effect.ScaleVector(var9, var10, var11, 4.5)
				var9 = out1 or var9
				var10 = out2 or var10
				var11 = out3 or var11
			end
			if var10 > 0.0 or var1 < vm.f32(var18 - 10.0) then
				break
			else
				var22 = 0
				while var22 < 20 do
					do
						local out1, out2, out3 = effect.CopyVector(var0, var1, var2)
						var6 = out1 or var6
						var7 = out2 or var7
						var8 = out3 or var8
					end
					do
						local out1, out2, out3 = effect.AddVector(var0, var1, var2, var9, var10, var11)
						var0 = out1 or var0
						var1 = out2 or var1
						var2 = out3 or var2
					end
					effect.ColprimDelete(-1)
					var23 = effect.IntersectionPoint_8(4, var6, var7, var8, var0, var1, var2) or var23
					if var23 < 0 then
						effect.ChrSetPos(var0, var1, var2)
					else
						var24 = var24 + 1
						if var24 > 1 then
							break
						end
					end
					vm.wait()
					var22 = var22 + 1
				end
				break
			end
		else
			effect.ChrSetPos(var0, var1, var2)
			effect.ColprimSetCoord(var0, var1, var2, 10.0)
			var23 = effect.ColprimGetHitcnt() or var23
			if var23 > 0 then
				var20 = 0
				break
			else
				vm.wait()
				var22 = var22 + 1
			end
		end
	end
	effect.ColprimDelete(-1)
	if var20 == 1 then
		effect.ChrSetMotion("ループ", -1, 1)
		effect.ChrSetShow(0, 1, -7.0)
		var22 = 0
		while var22 < 30 do
			vm.wait()
			var22 = var22 + 1
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
