--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3e3329d3 = require("@lib/event/helper_3e3329d3")
local helper_e5219064 = require("@lib/event/helper_e5219064")
local helper_eb560126 = require("@lib/event/helper_eb560126")

--- Helper function.
local function helper_289bd6b1(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_3e3329d3()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.ExtTyped(564, "iiF", 2, 322) or var2
	if var2 <= 0 then
		event.MesMake_2(
			0,
			"Apostar[UNI00ed]a a que nunca has\npescado un Nonky, [UNI00bf]eh?<page>Ja, ja. [UNI00a1]Tienes que ser p[UNI00e9]simo pescando!"
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 < vm.f32(0.6) then
		var3 = vm.ftoi(vm.f32(var2 * 100.0))
		event.SetMesValue(0, 1, var3)
		event.MesMake_2(0, "[UNI00a1]Ja, ja! S[UNI00f3]lo has cogido\nun pezque[UNI00f1][UNI00ed]n de [数値１] cm.")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"[UNI00a1]No me llegas ni a la altura del bet[UNI00fa]n!<page>Te recomiendo que empieces de nuevo."
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "... Vaya, te he subestimado.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"En fin, soy un hombre de palabra.\nNo tienes que record[UNI00e1]rmelo.<page>Escuchar[UNI00e9] lo que tengas que decirme."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "[UNI00a1]Habla cuanto quieras!")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_3e3329d3()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 15, 1)
end

return helper_289bd6b1
