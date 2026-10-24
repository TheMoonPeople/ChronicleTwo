--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_7e5e1a93()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var3 = 0
			var1 = vm.f32(var1 + 30.0)
			var3 = var3 + 1
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.SetCharaPos(0, -691.6, 339.04, 2249.38)
	event.SetCharaRot(0, 0.0, 1.91, 0.0)
	event.SetMotion(0, "走り", 4)
	event.SetCameraPos(-454.66, 376.79, 2105.55)
	event.SetFadeIn(30)
	event.ObjsMove(0, -584.92, 320.0, 2221.56, 30, 1)
	var3 = 0
	while var3 < 30 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.SetCameraRef(var0, var1, var2)
		var3 = var3 + 1
		if vm.wait() then
			return skip(2)
		end
	end
end

return helper_7e5e1a93
