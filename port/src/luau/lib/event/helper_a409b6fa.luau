--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_55ba6ec9 = require("@lib/event/helper_55ba6ec9")

--- Helper function.
local function helper_a409b6fa()
	local var4: f32 = 0
	helper_55ba6ec9()
	var4 = vm.f32(var4 - vm.f32(3.1415927))
end

return helper_a409b6fa
