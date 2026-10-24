--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_884a0371 = require("@lib/event/helper_884a0371")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")
local helper_e769163a = require("@lib/event/helper_e769163a")

--- Helper function.
local function helper_f341f3e9(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local argc: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b8f871c8(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_b8f871c8(arg0, -1, 3, 256, 208)
			end
			return helper_884a0371(arg0)
		end
		if at <= 5 then
			helper_e769163a(arg0, 1)
			helper_635ee3fd(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_b8f871c8(arg0, -1, 3, 256, 208)
		end
		return helper_884a0371(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_e769163a(arg0, 1)
		event.MesMake_2(arg0, "Andresti a prendermi\nun Blocchetto Scoop?")
		if now_map_no == 22 then
			helper_635ee3fd(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_b8f871c8(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		return 0
	end
	do
		local out1, out2 = event.GetMenuEtc_3(5)
		var5 = out1 or var5
		var6 = out2 or var6
	end
	if var5 == var6 then
		helper_e769163a(arg0, 1)
		event.MesMake_2(arg0, "Sembra non ci siano\naltri scoop.")
		if now_map_no == 22 then
			helper_635ee3fd(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_b8f871c8(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(4)
			end
		end
		return helper_884a0371(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_e769163a(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Ho trovato ancora [Numero1] scoop.")
		event.SetMesDrawspeed(arg0, 0)
		helper_b8f871c8(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_e769163a(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(arg0, "Allora, amico! Non startene\nimpalato! Dove sono i tuoi scoop?")
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Wow! Hai ottenuto [Number1] scoop!\nSapevo che ce l'avevi nel sangue!")
	end
	if now_map_no == 22 then
		helper_635ee3fd(arg0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		helper_b8f871c8(arg0, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(7)
		end
	end
	return helper_884a0371(arg0)
end

return helper_f341f3e9
