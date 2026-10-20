--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")
local helper_e769163a = require("@lib/event/helper_e769163a")

--- Helper function.
local function helper_fa6233e6(arg0: s32)
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
			helper_b8f871c8(arg0, -1, 3, 256, 208)
		end
		if at <= 3 then
			helper_e769163a(arg0, 1)
			helper_635ee3fd(arg0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_b8f871c8(arg0, -1, 3, 256, 208)
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
		helper_e769163a(arg0, 1)
		event.MesMake_2(arg0, "Si no me traes m[UNI00e1]s logros\nno puedo darte nada.")
		if now_map_no == 22 then
			helper_635ee3fd(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_b8f871c8(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
	end
	if var5 == 2 then
		helper_e769163a(arg0, 1)
		event.MesMake_2(
			arg0,
			"El nivel de tu Fotograf[UNI00ed]a est[UNI00e1] determinado\npor el n[UNI00fa]mero de ideas y logros\nque tengas.<page>Conforme vayas aumentando de nivel, conseguir[UNI00e1]s\nm[UNI00e1]s objetos como recompensa."
		)
		if now_map_no == 22 then
			helper_635ee3fd(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_b8f871c8(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return 0
end

return helper_fa6233e6
