--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4a83636a = require("@lib/event/helper_4a83636a")

--- Helper function.
local function helper_79d4180d(arg0: any, arg1: any, arg2: any, sp: number)
	local junk = 0
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4a83636a(player_chara, arg0, arg1, sp + junk + 8)
			junk += 1
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
	helper_4a83636a(player_chara, arg0, arg1, sp + junk + 7)
	if vm.skipping() then
		return skip(2)
	end
	return rot_y
end

return helper_79d4180d
