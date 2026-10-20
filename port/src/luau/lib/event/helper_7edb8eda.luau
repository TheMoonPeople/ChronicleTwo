--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_ca98e93f = require("@lib/event/helper_ca98e93f")

--- Helper function.
local function helper_7edb8eda(arg0: any, arg1: any, arg2: any)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return rot_y
	end
	if arg2 ~= 0 then
		event.EohSyncChara(0, arg0)
		do
			local _, out2, _ = event.EohGetRot(0)
			rot_y = out2 or rot_y
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_ca98e93f(player_chara, arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
	return rot_y
end

return helper_7edb8eda
