--!strict
-- Shared event helper used by 141 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_927b384d = require("@lib/event/helper_927b384d")

--- Helper function.
local function helper_d25c550f(arg0: any, arg1: any, arg2: any)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local at: number = 0
	return vm.guard(function()
		if arg2 ~= 0 then
			event.EohSyncChara(0, arg0)
			do
				local _, out2, _ = event.EohGetRot(0)
				rot_y = out2 or rot_y
			end
		end
		player_chara = event.GetControlChrid() or player_chara
		at = 1
		helper_927b384d(player_chara, arg0, arg1)
		return rot_y
	end, function(received: { any })
		if at <= 1 then
			return rot_y
		end
		return nil
	end)
end

return helper_d25c550f
