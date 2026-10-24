--!strict
-- Shared event helper used by 42 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_a61953d0(arg0: f32, arg1: f32, arg2: s32)
	local language_code: s32 = 0
	local mini_level: s32 = 0
	local var5: f32 = 0
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
	local var18: f32 = 0
	local var19: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	language_code = 0
	while language_code < 48 do
		event.SpriteInit(language_code)
		event.SpriteSetType(language_code, 1)
		event.SpriteSetTexture(language_code, "sphida_bar", arg2)
		event.SpriteSetUvsize(language_code, 64, 0, 32, 32)
		event.SpriteSetPutsize(language_code, 2, 2)
		event.SpriteSetColor(language_code, 128, 128, 128, 128)
		event.SpriteSetDraw(language_code, 0)
		language_code = language_code + 1
	end
	mini_level = event.SphidaGetMiniLevel() or mini_level
	if mini_level == 0 then
		language_code = event.GetLanguage() or language_code
		event.SpriteSetType(31, 0)
		event.SpriteSetDraw(31, 1)
		if language_code == 0 then
			event.SpriteSetUvsize(31, 308, 146, 204, 30)
			event.SpriteSetPutsize(31, 204, 30)
			event.SpriteSetPos(31, 120, 30)
		else
			event.SpriteSetUvsize(31, 286, 146, 226, 30)
			event.SpriteSetPutsize(31, 226, 30)
			event.SpriteSetPos(31, 140, 30)
		end
	end
	mini_level = 0
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	var6 = vm.f32(var6 + 3.0)
	var15 = vm.f32(var15 + 3.0)
	var18 = 100.0
	var11 = vm.f32(vm.sin(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
	var12 = vm.f32(20.0 * vm.sin(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)))
	var13 = vm.f32(vm.cos(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
	do
		local out1, out2, out3 = event.CopyVector(var11, var12, var13)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = event.ScaleVector(var8, var9, var10, 5.0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	var19 = 0
	language_code = 0
	while var19 < 6 do
		var18 = 100.0
		do
			local out1, out2, out3 = event.CopyVector(var11, var12, var13)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		do
			local out1, out2, out3 = event.ScaleVector(var8, var9, var10, 5.0)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		while true do
			do
				local out1, out2, out3 = event.AddVector(var5, var6, var7, var8, var9, var10)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			do
				local out1, out2, out3, out4, out5, out6, out7 =
					event.ChkIntersectionPoint_15(12, var14, var15, var16, var5, var6, var7, 1)
				var20 = out1 or var20
				var21 = out2 or var21
				var22 = out3 or var22
				var23 = out4 or var23
				var24 = out5 or var24
				var25 = out6 or var25
				var30 = out7 or var30
			end
			if var30 >= 0 then
				do
					local out1, out2, out3 = event.CopyVector(-var11, -var12, -var13)
					var26 = out1 or var26
					var27 = out2 or var27
					var28 = out3 or var28
				end
				do
					local out1, out2, out3 = event.NormalVector(var26, var27, var28)
					var26 = out1 or var26
					var27 = out2 or var27
					var28 = out3 or var28
				end
				do
					local out1, out2, out3 = event.ScaleVector(var26, var27, var28, 3.0)
					var26 = out1 or var26
					var27 = out2 or var27
					var28 = out3 or var28
				end
				do
					local out1, out2, out3 = event.AddVector(var20, var21, var22, var26, var27, var28)
					var20 = out1 or var20
					var21 = out2 or var21
					var22 = out3 or var22
				end
				var29 = event.DistVector2(var14, var15, var16, var20, var21, var22) or var29
				var18 = vm.f32(var18 - var29)
				if var18 <= 0.0 then
					break
				end
				while true do
					var29 = event.DistVector2(var14, var15, var16, var20, var21, var22) or var29
					if var29 <= 20.0 then
						var31 = vm.f32(20.0 - var29)
						var18 = vm.f32(var18 - var31)
						do
							local out1, out2, out3 = event.CopyVector(var20, var21, var22)
							var14 = out1 or var14
							var15 = out2 or var15
							var16 = out3 or var16
						end
						break
					end
					do
						local out1, out2, out3 = event.AddVector(var14, var15, var16, var11, var12, var13)
						var14 = out1 or var14
						var15 = out2 or var15
						var16 = out3 or var16
					end
					event.SpriteSetPos(language_code, var14, var15, var16)
					event.SpriteSetDraw(language_code, 1)
					language_code = vm.i32(language_code + 1)
					if vm.imod(language_code, 6) == 0 then
						event.SphidaSetMmLinePos(mini_level, var14, var15, var16)
						mini_level = vm.i32(mini_level + 1)
					end
					if vm.imod(language_code, 5) == 0 then
						break
					end
					if language_code >= 31 then
						break
					end
				end
				if language_code >= 31 then
					break
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, var24, var25)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.ScaleVector(var11, var12, var13, var31)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.AddVector(var14, var15, var16, var11, var12, var13)
					var14 = out1 or var14
					var15 = out2 or var15
					var16 = out3 or var16
				end
				event.SpriteSetPos(language_code, var14, var15, var16)
				event.SpriteSetDraw(language_code, 1)
				language_code = language_code + 1
				if vm.imod(language_code, 6) == 0 then
					event.SphidaSetMmLinePos(mini_level, var14, var15, var16)
					mini_level = vm.i32(mini_level + 1)
				end
				if language_code >= 31 then
					break
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, var24, var25)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.ScaleVector(var11, var12, var13, 20.0)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, var24, var25)
					var8 = out1 or var8
					var9 = out2 or var9
					var10 = out3 or var10
				end
				do
					local out1, out2, out3 = event.ScaleVector(var8, var9, var10, var18)
					var8 = out1 or var8
					var9 = out2 or var9
					var10 = out3 or var10
				end
				do
					local out1, out2, out3 = event.CopyVector(var14, var15, var16)
					var5 = out1 or var5
					var6 = out2 or var6
					var7 = out3 or var7
				end
				if vm.imod(language_code, 5) == 0 then
					break
				end
			else
				while language_code < 31 do
					do
						local out1, out2, out3 = event.AddVector(var14, var15, var16, var11, var12, var13)
						var14 = out1 or var14
						var15 = out2 or var15
						var16 = out3 or var16
					end
					event.SpriteSetPos(language_code, var14, var15, var16)
					event.SpriteSetDraw(language_code, 1)
					language_code = language_code + 1
					if vm.imod(language_code, 6) == 0 then
						event.SphidaSetMmLinePos(mini_level, var14, var15, var16)
						mini_level = vm.i32(mini_level + 1)
					end
					if vm.imod(language_code, 5) == 0 then
						break
					end
				end
				do
					local out1, out2, out3 = event.CopyVector(var14, var15, var16)
					var5 = out1 or var5
					var6 = out2 or var6
					var7 = out3 or var7
				end
				break
			end
		end
		var19 = var19 + 1
	end
end

return helper_a61953d0
