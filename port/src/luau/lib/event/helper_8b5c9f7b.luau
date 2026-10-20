--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1036c524 = require("@lib/event/helper_1036c524")
local helper_30c30f62 = require("@lib/event/helper_30c30f62")

--- Helper function.
local function helper_8b5c9f7b(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1036c524(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1036c524(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "You've been going out of town recently,\nright Max?<page>Don't deny it.\nI know you have.")
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_8b5c9f7b
