--!strict
-- dungeon/eff_script/spore.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local var0: s32 = 0
	local angle: f32 = 0
	local var2: f32 = 0
	local value: f32 = 0
	local var4: f32 = 0
	local value_2: f32 = 0
	local var6: f32 = 0
	local value_3: f32 = 0
	local color_w: f32 = 0
	effect.SptAssignSprite_1(50)
	effect.SptSetTexname("b02maphousi01")
	effect.SptInitSprite(0, 50)
	effect.SptSetAlphab(0, 2, 50)
	effect.SptSetDrawFlag(0, 1, 50)
	effect.SptSetUvSize(0, 64.0, 0.0, 64.0, 64.0, 50)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0, 50)
	var0 = 0
	angle = 0.0
	while var0 < 50 do
		effect.SptSetPutSize(var0, 60.0, 60.0)
		var2 = vm.f32(vm.sin(angle) * 120.0)
		value = effect.GetRand(50.0) or value
		value = vm.f32(value + 790.0)
		var4 = vm.f32(vm.cos(angle) * 120.0)
		angle = vm.f32(angle + vm.f32(0.25120002))
		angle = effect.AngleLimit(angle) or angle
		effect.SptSetPos(var0, var2 + 268.0, value, var4 - 322.0)
		value_2 = effect.GetRand(360.0) or value_2
		value_2 = vm.f32(vm.f32(vm.f32(value_2 / 180.0) * vm.f32(3.1415927)) - vm.f32(3.1415927))
		effect.SptSetRotz(var0, value_2)
		var0 = var0 + 1
	end
	var6 = 1.0
	var0 = 0
	while var0 < 160 do
		value_3 = effect.GetRand(0.04) or value_3
		effect.SptAddRotz(0, value_3, 25)
		value_3 = effect.GetRand(0.04) or value_3
		effect.SptAddRotz(25, -value_3, 25)
		effect.SptAddColor(0, 0.0, 0.0, 0.0, var6, 50)
		do
			local _, _, _, out4 = effect.SptGetColor(0)
			color_w = out4 or color_w
		end
		if color_w > 80.0 then
			var6 = -var6
		end
		if vm.imod(var0, 12) == 0 then
			effect.EsCreate_1("ラフレシア花粉サブ")
			effect.EsSetVect1(268.802, 758.472, -322.002)
		end
		var0 = var0 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
