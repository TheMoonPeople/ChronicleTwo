--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")

--- Helper function.
local function helper_1ab16d9d()
	local var0: s32 = 0
	local now_party_chara_id: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	event.SetMesPreset(1, 4)
	helper_125385ee(1, 4)
	event.MesSetBuff(1, 1, 1)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id < 0 then
		var0 = 55
	else
		var2 = event.GetPartyCharaMesNo_3(now_party_chara_id, 0) or var2
		event.SetMesItemDirect(1, 2, var2)
		var3 = event.GetNpcStatus(now_party_chara_id) or var3
		if bit32.band(var3, 4) ~= 0 then
			var0 = 57
		else
			var0 = 56
		end
	end
	helper_a3cc6850(1, var0, 8, 0, 0)
	event.MesSetBuff(1, 1, 0)
end

return helper_1ab16d9d
