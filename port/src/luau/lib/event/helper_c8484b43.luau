--!strict
-- Shared event helper used by 100 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_20426bd1 = require("@lib/event/helper_20426bd1")

--- Helper function.
local function helper_c8484b43(arg0: s32, arg1: s32, arg2: s32)
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
		helper_20426bd1(player_chara, arg0, arg1)
		return rot_y
	end, function(received: { any })
		if at <= 1 then
			return rot_y
		end
		return nil
	end)
end

return helper_c8484b43
