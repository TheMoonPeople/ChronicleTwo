--!strict
-- Shared event helper used by 50 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_50a71e7d = require("@lib/event/helper_50a71e7d")

--- Helper function.
local function helper_eb560126(arg0: s32, arg1: s32, arg2: s32)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_50a71e7d(player_chara, arg0, arg1)
		end
		return rot_y
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg2 ~= 0 then
		event.EohSyncChara(0, arg0)
		do
			local _, out2, _ = event.EohGetRot(0)
			rot_y = out2 or rot_y
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_50a71e7d(player_chara, arg0, arg1)
	if vm.skipping() then
		return skip(2)
	end
	return rot_y
end

return helper_eb560126
