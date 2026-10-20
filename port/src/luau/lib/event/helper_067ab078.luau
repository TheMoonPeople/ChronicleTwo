--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_72b1d1ea = require("@lib/event/helper_72b1d1ea")

--- Helper function.
local function helper_067ab078(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"洋服の着心地は\nどうですか？<page>正直な意見を\n聞かせてください。"
		)
	else
		event.MesMake_2(0, "ご無事をお祈りします・・・")
	end
	helper_72b1d1ea(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_067ab078
