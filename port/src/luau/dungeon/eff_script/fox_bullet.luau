--!strict
-- dungeon/eff_script/fox_bullet.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local user_id: s32 = 0
	local value: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var12: s32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: s32 = 0
	value = effect.GetValue(0) or value
	user_id = effect.GetUserId() or user_id
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	do
		local out1, out2, out3 = effect.ScnGetChrRot_4(user_id)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = effect.GetDirVector(var5, var6, var7)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var8, var9, var10, 20.0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	effect.SptSetTexname("effect00")
	effect.SptAssignSprite_1(16)
	effect.SptInitSprite(0, 16)
	effect.SptSetAlphab(0, 2, 16)
	effect.SptSetDrawFlag(0, 1, 16)
	effect.SptSetPutSize(0, 3.0, 3.0, 16)
	effect.SptSetUvSize(0, 32.0, 80.0, 16.0, 16.0, 16)
	effect.ColprimCreate("通常攻撃")
	effect.ColprimSetDamage(value)
	effect.EsSetVect1(var2, var3, var4)
	var12 = 0
	while var12 < 300 do
		do
			local out1, out2, out3 = effect.CopyVector(var2, var3, var4)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		do
			local out1, out2, out3 = effect.AddVector(var2, var3, var4, var8, var9, var10)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		do
			local out1, out2, out3 = effect.CopyVector(var8, var9, var10)
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		do
			local out1, out2, out3 = effect.NormalVector(var13, var14, var15)
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		effect.ColprimSetCoord(var2, var3, var4, 5.0)
		do
			local out1, out2, out3 = effect.CopyVector(-var8, -var9, -var10)
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		do
			local out1, out2, out3 = effect.NormalVector(var13, var14, var15)
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var13, var14, var15, 0.5)
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		effect.SptVanSetPos(0, var2, var3, var4, var13, var14, var15, 0.0, 0.0, 0.0, 16)
		effect.SptVanSetCol(0, 128.0, 128.0, 128.0, 128.0, 2.0, 2.0, 2.0, -10.0, 0.0, 0.0, 0.0, 0.0, 16)
		var16 = effect.ColprimGetHitcnt() or var16
		if var16 > 0 then
			break
		else
			var16 = effect.IntersectionPoint_8(4, var5, var6, var7, var2, var3, var4) or var16
			if var16 >= 0 then
				break
			else
				var12 = var12 + 1
				vm.wait()
			end
		end
	end
	effect.ColprimDelete(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
