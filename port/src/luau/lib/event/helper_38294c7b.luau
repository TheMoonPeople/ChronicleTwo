--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_38294c7b(arg0: any, sp: number)
	local junk = 0
	vm.stack(sp + 1)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			vm.stack(sp + junk + 3)
			arg0 = arg0
			vm.stack(sp + junk + 5)
			arg0 = vm.wrap(arg0 - 1)
			junk += 2
		end
		vm.stack(sp + junk + 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	vm.stack(sp + junk + 2)
	if arg0 > 0 then
		vm.stack(sp + junk + 2)
		arg0 = arg0
	end
	while true do
		vm.stack(sp + junk + 2)
		if not (arg0 >= 0) then
			break
		end
		vm.stack(sp + junk + 3)
		arg0 = arg0 - 1
		if vm.wait() then
			return skip(2)
		end
	end
	vm.stack(sp + junk + 1)
end

return helper_38294c7b
