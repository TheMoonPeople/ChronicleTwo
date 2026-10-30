--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ab2f339 = require("@lib/event/helper_1ab2f339")
local helper_6104b8a4 = require("@lib/event/helper_6104b8a4")
local helper_f87a5101 = require("@lib/event/helper_f87a5101")

--- Helper function.
local function helper_de7d1d4b(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var4: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var4 = event.set_party_member(1) or var4
		if var4 == 1 then
			at = 1
			helper_f87a5101(arg0, arg1, arg2, arg3, 0, 1)
		else
			flag = event.get_save_flag(520) or flag
			flag_2 = event.get_save_flag(532) or flag_2
			if flag ~= 0 and flag_2 == 0 then
				flag_3 = event.get_save_flag(522) or flag_3
				if flag_3 == 0 then
					at = 2
					helper_6104b8a4(arg0, arg1, arg2, arg3)
				end
			end
			at = 3
			helper_1ab2f339(arg0, arg1, arg2, arg3, 0, 0)
		end
		event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_6104b8a4(arg0, arg1, arg2, arg3)
				return vm.continue_with(function()
					at = 3
					helper_1ab2f339(arg0, arg1, arg2, arg3, 0, 0)
					event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
					return
				end)
			end
			if at <= 2 then
				at = 3
				helper_1ab2f339(arg0, arg1, arg2, arg3, 0, 0)
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

return helper_de7d1d4b
