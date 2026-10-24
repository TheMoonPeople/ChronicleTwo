--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_ef5ff17b()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.FuncPointShow("", "fc_e220", 0)
	event.FuncPointShow("", "fc_e230", 0)
	event.FuncPointShow("", "fc_e235", 0)
	event.FuncPointShow("", "fc_e247", 0)
	event.FuncPointShow("", "fc_e253", 0)
	event.FuncPointShow("", "next_floor", 0)
	event.FuncPointShow("", "item_e245", 0)
	event.FuncPointShow("", "itemget_paplle", 0)
	event.FuncPointShow("", "itemget_mimi", 0)
end

return helper_ef5ff17b
