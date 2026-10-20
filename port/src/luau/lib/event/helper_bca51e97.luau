--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9d142a11 = require("@lib/event/helper_9d142a11")

--- Helper function.
local function helper_bca51e97(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"お姉さんが来てから、ユリスの\n付き合いが悪くなっちまった。<page>何してんのか知らないけど、\nあいつをこき使わないでくれよ。"
	)
	helper_9d142a11(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_bca51e97
