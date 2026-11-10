--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_86e93423 = require("@lib/event/helper_86e93423")

--- Helper function.
local function helper_0999bd0f()
	local flag: s32 = 0
	helper_86e93423()
	flag = event.get_save_flag(18) or flag
	if flag == 1 then
		flag = event.get_save_flag(17) or flag
		if flag == 0 then
			event.set_save_flag(17, 1)
		end
	end
	event.fade_out_screen(1)
	vm.wait(1)
	event.fade_in_screen(30)
	event.go_to_outside_map(-1, "m01")
end

return helper_0999bd0f
