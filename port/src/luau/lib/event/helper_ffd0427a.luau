--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_ffd0427a(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: s32 = 0
	if arg1 == 0 then
		arg1 = 1
	end
	var3 = 0
	if arg0 == 0 then
		var2 = 1.0
		while var3 < arg1 do
			var2 = vm.f32(var2 - vm.f32(vm.fdiv(1.0, arg1)))
			if var2 < 0.0 then
				var2 = 0.0
			end
			event.show_dungeon_status_bar(var2)
			var3 = var3 + 1
			vm.wait(1)
		end
	else
		var2 = 0.0
		while var3 < arg1 do
			var2 = vm.f32(var2 + vm.f32(vm.fdiv(1.0, arg1)))
			if var2 > 1.0 then
				var2 = 1.0
			end
			event.show_dungeon_status_bar(var2)
			var3 = var3 + 1
			vm.wait(2)
		end
	end
end

return helper_ffd0427a
