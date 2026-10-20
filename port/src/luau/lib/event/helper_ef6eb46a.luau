--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_001d3481 = require("@lib/event/helper_001d3481")
local helper_3e3329d3 = require("@lib/event/helper_3e3329d3")
local helper_e5219064 = require("@lib/event/helper_e5219064")
local helper_eb560126 = require("@lib/event/helper_eb560126")

--- Helper function.
local function helper_ef6eb46a(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
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
		if at <= 8 then
			helper_001d3481(22)
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Te he estado esperando.<page>R[UNI00e1]pido, dame la Pintura para\ndar vida a mi cuadro.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoUseItem(376)
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
	if var2 ~= 376 then
		event.MesMake_2(
			0,
			"[UNI00a1]Est[UNI00e1]s de broma!<page>Lo que necesito es Pintura dorada.\n[UNI00a1]No te equivoques!"
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(376)
	event.MesMake_2(0, "O sea que esta es la Pintura dorada...\nLa probar[UNI00e9] ahora mismo.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Es... Es real...<page>[UNI00a1]Incre[UNI00ed]ble, es perfecta!")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Gracias, Max.\nNo he olvidado mi promesa. Usa mi\nnuevo poder cuando quieras.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_3e3329d3()
	if vm.skipping() then
		return skip(8)
	end
	event.SetNpcStatus(22, 130)
	helper_001d3481(22)
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 1, 1)
end

return helper_ef6eb46a
