--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_8d53dd04()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.FuncPointShow("", "item1", 0)
	event.FuncPointShow("", "item2", 0)
	event.FuncPointShow("", "item3", 0)
	event.FuncPointShow("", "item4", 0)
	event.FuncPointShow("", "item5", 0)
	event.FuncPointShow("", "item6", 0)
	event.FuncPointShow("", "item7", 0)
	event.FuncPointShow("", "item8", 0)
	event.FuncPointShow("", "item9", 0)
	event.FuncPointShow("", "item10", 0)
	event.FuncPointShow("", "item11", 0)
	event.FuncPointShow("", "item12", 0)
	event.FuncPointShow("", "item13", 0)
	event.FuncPointShow("", "item14", 0)
	event.FuncPointShow("", "item15", 0)
	event.FuncPointShow("", "item16", 0)
	event.FuncPointShow("", "item17", 0)
	event.FuncPointShow("", "item18", 0)
	event.FuncPointShow("", "item19", 0)
	event.FuncPointShow("", "item20", 0)
	event.FuncPointShow("", "item21", 0)
	event.FuncPointShow("", "item22", 0)
end

return helper_8d53dd04
