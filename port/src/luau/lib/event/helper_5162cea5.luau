--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b03eb2e1 = require("@lib/event/helper_b03eb2e1")
local helper_cc7603b9 = require("@lib/event/helper_cc7603b9")
local helper_e5219064 = require("@lib/event/helper_e5219064")

--- Helper function.
local function helper_5162cea5(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			helper_cc7603b9(arg0, -1, 3, 256, 208)
		end
		if at <= 3 then
			helper_b03eb2e1(arg0, 1)
			helper_e5219064(arg0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_cc7603b9(arg0, -1, 3, 256, 208)
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	do
		local out1, out2 = event.GetMenuEtc_3(6)
		var4 = out1 or var4
		var5 = out2 or var5
	end
	if 0 < var4 then
		return 1
	end
	if var5 == 1 then
		helper_b03eb2e1(arg0, 1)
		event.MesMake_2(arg0, "Se non mi porti altri scoop,\nnon posso darti nulla!")
		if now_map_no == 22 then
			helper_e5219064(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_cc7603b9(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
	end
	if var5 == 2 then
		helper_b03eb2e1(arg0, 1)
		event.MesMake_2(
			arg0,
			"Il numero di idee e di scoop\ndetermineranno il tuo Livello\nfotografico.<page>Salendo di livello, riceverai\nin premio altri oggetti magnifici."
		)
		if now_map_no == 22 then
			helper_e5219064(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_cc7603b9(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return 0
end

return helper_5162cea5
