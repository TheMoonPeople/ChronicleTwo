--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")

--- Helper function.
local function helper_7595bb3d()
	local var0: f32 = 0
	event.CmrsSetPos(396.92, 146.86, -175.05)
	event.CmrsSetRef(744.44, 257.9, -23.8)
	event.SetTime(6.5)
	var0 = 6.5
	while true do
		var0 = vm.f32(var0 + vm.f32(0.004))
		event.SetTime(var0)
		vm.wait(1)
		if var0 > vm.f32(6.8) then
			break
		end
	end
	event.CmrsFadeInit()
	event.CmrsFadeDelay(190)
	event.CmrsFadeOut(60, 0.0, 0.0, 0.0)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(250)
	event.CmrsAddPas(396.92, 146.86, -175.05, 744.44, 257.9, -23.8)
	event.CmrsAddPas(104.88, 122.77, 6.77, 326.18, 70.53, 147.12)
	event.CmrsStartPas()
	helper_c624bc16()
end

return helper_7595bb3d
