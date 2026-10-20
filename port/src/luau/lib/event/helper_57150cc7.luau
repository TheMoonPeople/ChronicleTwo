--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_72b1d1ea = require("@lib/event/helper_72b1d1ea")

--- Helper function.
local function helper_57150cc7(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_72b1d1ea(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"もう店じまいだ。これからは\n親父の店で買ってくれ。<page>カボチャが目印だ。知ってるだろ。\nそこのはしごから出りゃすぐだから。"
	)
	helper_72b1d1ea(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_57150cc7
