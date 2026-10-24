--!strict
-- Shared event helper used by 108 scripts, translated by tools/luau/stb2luau.

local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")

--- Helper function.
local function helper_5e868d47(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	event.SetMesPreset(1, 4)
	helper_125385ee(1, 4)
	event.MesSetBuff(1, 1, 1)
	var2 = event.GetPartyCharaMesNo_3(arg0, 0) or var2
	event.SetMesItemDirect(1, 1, var2)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if true then
		var1 = 50
	else
		var4 = event.GetPartyCharaMesNo_3(now_party_chara_id, 0) or var4
		event.SetMesItemDirect(1, 2, var4)
		var1 = 51
	end
	helper_a3cc6850(1, var1, 8, 0, 0)
	event.MesSetBuff(1, 1, 0)
end

return helper_5e868d47
