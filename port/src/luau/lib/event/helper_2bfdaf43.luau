--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_a38f455e = require("@lib/event/helper_a38f455e")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")

--- Helper function.
local function helper_2bfdaf43(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 4 then
			if at <= 2 then
				helper_635ee3fd(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_a38f455e(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Max, mi prioridad ahora es\ncurar este [UNI00e1]rbol.<page>Lo que necesito\nes...")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.GotoUseItem(276)
	do
		local skipped = vm.wait()
		var3 = event.DeferredOutput() or var3
		if skipped then
			return skip(4)
		end
	end
	if var3 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var3 ~= 276 then
		event.MesMake_2(0, "Max, as[UNI00ed] no hacemos nada.<page>Lo que necesito es\nAgua bendita del Padre Bruno.")
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"[UNI00a1]S[UNI00ed]! [UNI00a1]Lo has conseguido, Max!\n[UNI00a1]Ya me ocupo yo del [UNI00e1]rbol!<page>Gracias, Max."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Ya est[UNI00e1] todo resuelto\n por el momento.<page>[UNI00a1]Ya te puedo acompa[UNI00f1]ar\nen tu aventura!<page>[UNI00a1]Ah! Ni se te ocurra hablarle a\ntu padre del Agua bendita, [UNI00bf]entendido?"
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "Gordon se ha unido al grupo.")
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Puedes emplear sus habilidades\n desde la opci[UNI00f3]n Estado del\napartado Personajes del men[UNI00fa] Principal.<page>[(!)]Si reclutas a m[UNI00e1]s personas\npara la aventura, se\nsubir[UNI00e1]n al tren."
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]Habla con ese pasajero\ndel tren para que se\nconvierta en el tercer miembro del grupo.<page>[(!)]Para que\nuno de tus amigos del tren entre en una casa, elige Mover persona\nen el men[UNI00fa] Puerta de la casa en cuesti[UNI00f3]n."
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"[(!)]Puede que haya muchos m[UNI00e1]s\nque quieran unirse a tu grupo.\n[UNI00a1]B[UNI00fa]scalos!"
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	var4 = event.GetEventData_2(14) or var4
	event.SetNpcStatus(var4, 130)
	event.Finish()
	event.SetQuestEtc(1, 0, 1)
end

return helper_2bfdaf43
