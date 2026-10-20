--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_403f0e66 = require("@lib/event/helper_403f0e66")
local helper_c049c42a = require("@lib/event/helper_c049c42a")
local helper_dae2ac4c = require("@lib/event/helper_dae2ac4c")

--- Helper function.
local function helper_b614cfea(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_403f0e66(0, -1, arg1, arg0, 0)
			end
			return
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg1, arg0, 0)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg1, arg0, 0)
		end
		if at <= 7 then
			helper_403f0e66(0, -1, arg1, arg0, 0)
		end
		if at <= 8 then
			helper_403f0e66(0, -1, arg1, arg0, 0)
		end
		if at <= 9 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"[UNI00da]ltimamente no me encuentro muy bien.<page>El Dr. Dell me ha examinado,\npero seg[UNI00fa]n [UNI00e9]l no me pasa nada."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Con s[UNI00f3]lo ponerme de pie\nme da la impresi[UNI00f3]n de que me voy a caer.<page>No  es f[UNI00e1]cil de explicar. Es como si\nel mundo estuviera alterado."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(
			0,
			"Um...\nSi el Dr. Dell no sabe cu[UNI00e1]l es el problema,\nyo no voy a poder ayudar mucho..."
		)
		helper_403f0e66(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return
	end
	event.MesMake_2(0, "Recuerdo los s[UNI00ed]ntomas.")
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Cuando nac[UNI00ed],\nel mundo estaba en un estado lamentable:\nhab[UNI00ed]a m[UNI00e1]s distorsiones temporales de las\nque te puedas imaginar."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Adem[UNI00e1]s afectaban a personas\nfr[UNI00e1]giles f[UNI00ed]sicamente.<page>Los delgados se mareaban o se desmayaban\ny los m[UNI00e1]s rellenos no se pod[UNI00ed]an ni levantar."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"A lo mejor t[UNI00fa] eres especialmente\nsusceptible a estas cosas.<page>Incluso las pocas distorsiones temporales\nque hay aqu[UNI00ed] bastan para afectarte."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"Si pudi[UNI00e9]ramos librarnos de las distorsiones\nm[UNI00e1]s pr[UNI00f3]ximas, seguro que te sentir[UNI00ed]as mejor."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg1, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)][UNI00bf]C[UNI00f3]mo se arregla una distorsi[UNI00f3]n temporal? [UNI00a1]Esfeda!\n Si pasas m[UNI00e1]s de 10 niveles,\n quiz[UNI00e1] Mena mejore un poco."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	var3 = event.GetMenuEtc_2(0) or var3
	event.SetCnt(19, var3)
	event.SetQuestEtc(0, 17, 1)
end

return helper_b614cfea
