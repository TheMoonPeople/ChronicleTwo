--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_c190f878 = require("@lib/event/helper_c190f878")
local helper_f8bbcc57 = require("@lib/event/helper_f8bbcc57")

--- Helper function.
local function helper_2a6d5753(arg0: s32)
	local at: number = 0
	return vm.guard(function()
		event.SetMesPreset(1, 4)
		helper_125385ee(1, 4)
		if arg0 == 0 then
			at = 1
			return helper_c190f878(1, 1000 + arg0, 7, 0, 0, 2, 0)
		end
		if arg0 == 1 then
			at = 2
			return helper_c190f878(1, 1000 + arg0, 7, 0, 0, 3, 0)
		end
		return 0
	end, function(received: { any })
		if at <= 1 then
			return helper_f8bbcc57(1, vm.i32(1000 + arg0), 7, 0, 0, 2, 0)
		end
		if at <= 2 then
			return helper_f8bbcc57(1, vm.i32(1000 + arg0), 7, 0, 0, 3, 0)
		end
		return nil
	end)
end

return helper_2a6d5753
