--!strict
-- Shared event helper used by 42 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_c44453a9()
	event.open_event_menu(26)
	vm.wait(1)
	event.load_event_script("d01/d01_sfida.stb", 6000)
end

return helper_c44453a9
