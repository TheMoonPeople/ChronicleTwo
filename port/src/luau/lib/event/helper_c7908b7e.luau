--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1036c524 = require("@lib/event/helper_1036c524")
local helper_30c30f62 = require("@lib/event/helper_30c30f62")

--- Helper function.
local function helper_c7908b7e(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_1036c524(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.MesMake_2(0, "Don't go anywhere too\ndangerous.")
	else
		event.MesMake_2(0, "At long last the Blackstone\nRailroad takes on the world.\nIt's so exciting!")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_c7908b7e
