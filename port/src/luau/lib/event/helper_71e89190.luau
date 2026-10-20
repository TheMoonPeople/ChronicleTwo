--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8afc4c0b = require("@lib/event/helper_8afc4c0b")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_b8950300 = require("@lib/event/helper_b8950300")

--- Helper function.
local function helper_71e89190(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_8afc4c0b()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "[UNI00bf]Has conseguido alguna Casta[UNI00f1]a?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoUseItem(301)
	do
		local skipped = vm.wait()
		var2 = event.DeferredOutput() or var2
		if skipped then
			return skip(3)
		end
	end
	if var2 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 ~= 301 then
		event.MesMake_2(0, "No puedes...<page>En fin, tendr[UNI00e9] que dejar\nel Castagnaccio.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Muy bien. Muchas gracias.<page>Intentar[UNI00e9] preparar algo de Castagnaccio.<page>Te lo dar[UNI00e9] a probar en cuanto termine."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Puedo devolverte el favor de alguna manera?<page>[UNI00bf]C[UNI00f3]mo? [UNI00bf]Quieres que te acompa[UNI00f1]e en tu aventura?<page>[UNI00a1]Ja, ja! Eso est[UNI00e1] hecho.<page>[UNI00bf]Por qu[UNI00e9] no me has preguntado antes?"
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_8afc4c0b()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 3, 1)
end

return helper_71e89190
