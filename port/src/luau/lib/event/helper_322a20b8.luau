--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_73adc3f3 = require("@lib/event/helper_73adc3f3")

--- Helper function.
local function helper_322a20b8()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_73adc3f3()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_73adc3f3()
end

return helper_322a20b8
