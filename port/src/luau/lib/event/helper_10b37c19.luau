--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_72b1d1ea = require("@lib/event/helper_72b1d1ea")

--- Helper function.
local function helper_10b37c19(arg0: s32, arg1: any)
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
		"なんでこんなに月が恋しいんだろう。<page>もしかしたら、僕はあそこから\n来たのかも知れない・・・"
	)
	helper_72b1d1ea(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_10b37c19
