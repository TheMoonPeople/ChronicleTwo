--!strict
-- Shared event helper used by 964 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- The value step steps of the given count along from from to to.
local function interpolate(from: f32, to: f32, step: f32, steps: f32)
	return vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(to - from) * step), steps)) + from)
end

return interpolate
