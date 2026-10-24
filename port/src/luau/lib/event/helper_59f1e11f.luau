--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_59f1e11f(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.FuncPointShow("", "jimen1", arg0)
	event.FuncPointShow("", "jimen2", arg0)
	event.FuncPointShow("", "jimen3", arg0)
	event.FuncPointShow("", "jimen4", arg0)
	event.FuncPointShow("", "jimen5", arg0)
	event.FuncPointShow("", "jimen6", arg0)
	event.FuncPointShow("", "jimen7", arg0)
	event.FuncPointShow("", "jimen9", arg0)
	event.FuncPointShow("", "jimen10", arg0)
end

return helper_59f1e11f
