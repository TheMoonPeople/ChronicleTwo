--!strict
-- Shared event helper used by 24 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_5be5f988()
	local var0: s32 = 0
	var0 = event.get_save_counter(1) or var0
	if var0 == 2 then
		event.jump_to_map_2(-1, "s02")
		vm.wait(1)
		return
	end
	if var0 == 3 then
		event.jump_to_map_2(-1, "s04")
		vm.wait(2)
		return
	end
	if var0 == 4 then
		event.jump_to_map_2(-1, "s09")
		vm.wait(3)
		return
	end
	if var0 == 5 then
		event.jump_to_map_2(-1, "s10")
		vm.wait(4)
		return
	end
	if var0 == 6 then
		event.jump_to_map_2(-1, "s11")
		vm.wait(5)
		return
	end
	if var0 == 7 then
		event.jump_to_map_2(-1, "s12")
		vm.wait(6)
		return
	end
	if var0 == 8 then
		event.jump_to_map_2(-1, "s31")
		vm.wait(7)
		return
	end
	if var0 == 9 then
		event.jump_to_map_2(-1, "s34")
		vm.wait(8)
		return
	end
	event.jump_to_map_2(-1, "i02h01")
	vm.wait(9)
end

return helper_5be5f988
