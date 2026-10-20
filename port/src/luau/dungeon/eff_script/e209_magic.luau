--!strict
-- dungeon/eff_script/e209_magic.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	effect.ChrSetPos(var0, var1, var2)
	do
		local out1, out2, out3 = effect.SubVector(var3, var4, var5, var0, var1, var2)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = effect.NormalVector(var3, var4, var5)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var3, var4, var5, 0.2)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	effect.ChrSetMotion("ｴﾌｪｸﾄ_コンダ魔法1")
	effect.ChrSetShow(1, 1, 0.1)
	var6 = 0
	while var6 < 15 do
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var3, var4, var5)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		effect.ChrSetPos(var0, var1, var2)
		vm.wait()
		var6 = var6 + 1
	end
	effect.ChrSetShow(0, 1, -0.1)
	var6 = 0
	while var6 < 15 do
		do
			local out1, out2, out3 = effect.AddVector(var0, var1, var2, var3, var4, var5)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		effect.ChrSetPos(var0, var1, var2)
		vm.wait()
		var6 = var6 + 1
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
