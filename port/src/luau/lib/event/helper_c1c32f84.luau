--!strict
-- Shared event helper used by 50 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_c1c32f84(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			arg0 = arg0
			arg0 = vm.wrap(arg0 - 1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg0 > 0 then
		arg0 = arg0
	end
	while arg0 >= 0 do
		arg0 = arg0 - 1
		if vm.wait() then
			return skip(2)
		end
	end
end

return helper_c1c32f84
