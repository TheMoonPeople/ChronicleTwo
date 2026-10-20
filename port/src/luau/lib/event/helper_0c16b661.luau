--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_678050ac = require("@lib/event/helper_678050ac")
local helper_e5219064 = require("@lib/event/helper_e5219064")
local helper_eb560126 = require("@lib/event/helper_eb560126")

--- Helper function.
local function helper_0c16b661(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_678050ac()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 < 3 then
		event.MesMake_2(
			0,
			"Lo siento, todav[UNI00ed]a\nno estoy lista.<page>[UNI00bf]Puedes darme un poco m[UNI00e1]s de tiempo?"
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Por cierto: [UNI00bf]has ido ya\na ver a Morton de mi parte?")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Qu[UNI00e9]? [UNI00bf]C[UNI00f3]mo puede ser tan\ndesconsiderado?<page>En fin,\npuedes qued[UNI00e1]rtelas."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "No importa.\nEn marcha.<page>[UNI00bf]A d[UNI00f3]nde\nvamos?")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SubItem(300, 20)
	event.AddItem(299, 20)
	helper_678050ac()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 8, 1)
end

return helper_0c16b661
