--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_49dd0fe3(arg0: f32)
	local skip: (number) -> ...any
	function skip(at: number)
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
		return arg0
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg0 < vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < arg0 then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	return arg0
end

return helper_49dd0fe3
