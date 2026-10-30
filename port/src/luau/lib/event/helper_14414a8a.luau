--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6944feb4 = require("@lib/event/helper_6944feb4")

--- Helper function.
local function helper_14414a8a(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var4: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var4 = event.set_party_member(1) or var4
		if var4 == 1 then
			at = 1
			helper_6944feb4(arg0, arg1, arg2, arg3, 1, 1)
		else
			at = 2
			helper_6944feb4(arg0, arg1, arg2, arg3, 1, 0)
		end
		event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_6944feb4(arg0, arg1, arg2, arg3, 1, 0)
				return vm.continue_with(function()
					event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

return helper_14414a8a
