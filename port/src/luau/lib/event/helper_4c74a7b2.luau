--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9d142a11 = require("@lib/event/helper_9d142a11")

--- Helper function.
local function helper_4c74a7b2(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9d142a11(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"ファブリースの民は、\n自分より秀でた人でないと、\nたのみを聞く事はありません。"
	)
	helper_9d142a11(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_4c74a7b2
