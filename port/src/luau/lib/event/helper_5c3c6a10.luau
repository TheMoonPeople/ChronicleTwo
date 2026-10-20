--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47171f2d = require("@lib/event/helper_47171f2d")
local helper_78064d45 = require("@lib/event/helper_78064d45")

--- Helper function.
local function helper_5c3c6a10(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_78064d45(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_78064d45(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Du warst au[UNI00df]erhalb der Stadt,\nstimmt's, Max?<page>Streite es nicht ab.\nIch wei[UNI00df], dass es stimmt."
	)
	helper_47171f2d(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_5c3c6a10
