--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_fce6c9ae = require("@lib/event/helper_fce6c9ae")

--- Helper function.
local function helper_a15e119e(arg0: any, arg1: any, arg2: any)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fce6c9ae(player_chara, arg0, arg1)
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
	helper_fce6c9ae(player_chara, arg0, arg1)
	if vm.skipping() then
		return skip(2)
	end
	return rot_y
end

return helper_a15e119e
