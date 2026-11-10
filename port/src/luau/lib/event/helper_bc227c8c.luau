--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_d7885d22 = require("@lib/event/helper_d7885d22")

--- Helper function.
local function helper_bc227c8c(param: s32)
	event.fade_out_screen(25)
	helper_888ab2a3(30)
	event.open_event_menu(6, param)
	vm.wait(2)
	helper_d7885d22()
	event.fade_in_screen(30)
end

return helper_bc227c8c
