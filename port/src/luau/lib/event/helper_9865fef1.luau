--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_87b252ac = require("@lib/event/helper_87b252ac")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")

--- Helper function.
local function helper_9865fef1(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_87b252ac(arg0, arg1)
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"ユリス、最近町の外に\n出かけてるんでしょう？<page>隠したってだめよ、\n知ってるんだから。"
	)
	helper_907fd9a8(arg0, -1, 0, 0)
end

return helper_9865fef1
