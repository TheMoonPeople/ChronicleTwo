--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9f45b0a5 = require("@lib/event/helper_9f45b0a5")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_c764436a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_9f45b0a5(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_9f45b0a5(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "You've been going out of town recently,\nright Max?<page>Don't deny it.\nI know you have.")
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_c764436a
