--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")
local helper_e769163a = require("@lib/event/helper_e769163a")

--- Helper function.
local function helper_8a24aea5()
	local var0: s32 = 0
	local now_party_chara_id: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e769163a(1, 4)
			var0 = 55
			var0 = 57
			var0 = 56
			helper_b8f871c8(1, var0, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_e769163a(1, 4)
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
	helper_b8f871c8(1, var0, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesSetBuff(1, 1, 0)
end

return helper_8a24aea5
