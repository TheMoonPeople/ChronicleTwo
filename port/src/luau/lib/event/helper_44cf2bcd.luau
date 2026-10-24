--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9d142a11 = require("@lib/event/helper_9d142a11")

--- Helper function.
local function helper_44cf2bcd(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "ゴミはきちんと分別\nして、決められた日に\n出すようにな。")
	else
		event.MesMake_2(
			0,
			"頼みごとをしていて言うのも変だが、\n鉱山は危険な場所だ。\nあまり無理をしないようにな。"
		)
	end
	helper_9d142a11(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_44cf2bcd
