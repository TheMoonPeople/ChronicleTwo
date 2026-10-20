--!strict
-- map/i/i01/h07/i01h07_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0c95681b = require("@lib/event/helper_0c95681b")
local helper_0d70bce8 = require("@lib/event/helper_0d70bce8")
local helper_187f0d3d = require("@lib/event/helper_187f0d3d")
local helper_2056b079 = require("@lib/event/helper_2056b079")
local helper_2ddedb3b = require("@lib/event/helper_2ddedb3b")
local helper_85ab2618 = require("@lib/event/helper_85ab2618")
local helper_8834eba9 = require("@lib/event/helper_8834eba9")
local helper_975658d3 = require("@lib/event/helper_975658d3")
local helper_b1ca721b = require("@lib/event/helper_b1ca721b")
local helper_bbc8e499 = require("@lib/event/helper_bbc8e499")
local helper_be50380c = require("@lib/event/helper_be50380c")
local helper_c87b6812 = require("@lib/event/helper_c87b6812")
local helper_d22b9744 = require("@lib/event/helper_d22b9744")
local helper_eb131214 = require("@lib/event/helper_eb131214")
local helper_ecb662ce = require("@lib/event/helper_ecb662ce")

--- Helper function.
local function helper_39560(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg0 < 0 or 1 < arg0 or arg1 < 0 or 6 < arg1 then
		return
	end
	var2 = arg0 * 7 + arg1
	if var2 == 0 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m7")
	end
	if var2 == 7 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m21")
	end
	if var2 == 1 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m8")
	end
	if var2 == 8 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m20")
	end
	if var2 == 2 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m9")
	end
	if var2 == 9 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m19")
	end
	if var2 == 3 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m10")
	end
	if var2 == 10 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m18")
	end
	if var2 == 4 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m11")
	end
	if var2 == 11 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m17")
	end
	if var2 == 5 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m12")
	end
	if var2 == 12 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m16")
	end
	if var2 == 6 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m14")
	end
	if var2 == 13 then
		event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m15")
	end
	var3 = event.EohGetShow(0) or var3
	event.EohSetShow(0, if var3 == 0 then 1 else 0)
end

--- Helper function.
local function helper_39f80(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_39560(arg0, arg1)
			helper_39560(vm.i32(arg0 + 1), arg1)
			helper_39560(vm.i32(arg0 - 1), arg1)
			helper_39560(arg0, vm.i32(arg1 + 1))
			helper_39560(arg0, vm.i32(arg1 - 1))
			helper_0c95681b(45)
		end
	end
	event.SetMotion(0, "立ち")
	event.CmrsInit()
	event.CmrsSetPos(-5.74, 133.71, 0.0)
	event.CmrsSetRef(-143.54, 66.02, 0.0)
	helper_0c95681b(45)
	if vm.skipping() then
		return skip(1)
	end
	helper_39560(arg0, arg1)
	helper_39560(vm.i32(arg0 + 1), arg1)
	helper_39560(vm.i32(arg0 - 1), arg1)
	helper_39560(arg0, vm.i32(arg1 + 1))
	helper_39560(arg0, vm.i32(arg1 - 1))
	helper_0c95681b(45)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_12284(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMotion(arg1, "立ち")
		event.MesMake_2(0, "Umm. Este [UNI00e1]rbol... Le pasa\nalgo. Tengo que hacer algo.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(1)
		end
	else
		event.MesMake_2(
			0,
			"[UNI00a1]Max! Qu[UNI00e9] susto.\nEstaba quit[UNI00e1]ndole los bichos\na este [UNI00e1]rbol.<page>No todos los [UNI00e1]rboles crecen bien\nsolos. A algunos, como\neste, hay que vigilarlos."
		)
		helper_eb131214(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_11f30(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMotion(arg1, "立ち")
	event.MesMake_2(0, "Umm. Este [UNI00e1]rbol... Le pasa\nalgo. Tengo que hacer algo.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Tendr[UNI00e1]s que hablar con\nGordon para atraer su atenci[UNI00f3]n.")
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
end

--- Helper function.
local function helper_125cc(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 11 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_11f30(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"[UNI00a1]Max! Has estado limpiando mucho\n[UNI00fa]ltimamente. [UNI00bf]Seguro que cuidas\nde ti?<page>[UNI00bf]Puedo hacer algo por ti?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "[UNI00bf]C[UNI00f3]mo? [UNI00bf]Quieres que te acompa[UNI00f1]e\nen tu aventura?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Umm... Me gustar[UNI00ed]a ir contigo,\npero este [UNI00e1]rbol necesita\natenci[UNI00f3]n.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Ver[UNI00e1]s, mi prioridad consiste en cuidar las\nplantas y los [UNI00e1]rboles de este\nterreno.<page>Si me voy a dar vueltas por ah[UNI00ed], podr[UNI00ed]a\nperder el trabajo."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Seguro que este [UNI00e1]rbol se repondr[UNI00ed]a con un poco del Agua bendita que el Padre Bruno\nvende en la iglesia.<page>Pero ya sabes que tu padre\ny el cura no se llevan bien...<page>Tu padre no me dar[UNI00ed]a ni loco dinero\npara comparle Agua bendita al cura.<page>[UNI00a1]Vaya berenjenal!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Para que Gordon vaya a Sindain, primero debes\nconseguir que se apunte a\ntu viaje.")
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "[(!)]Si ayudas a Gordon,\nse apuntar[UNI00e1] al viaje y\nsubir[UNI00e1] al tren.")
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "[(!)]Puedes consultar tus misiones\nleyendo la Libreta\nque hay en el men[UNI00fa] Objetos.")
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"[(!)][UNI00a1]Pero si no tienes Libreta!\nHay una sobre la mesa\ndel Taller de Mantenimiento."
		)
		helper_8834eba9(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"[(!)]Hay otra en el escondrijo\nde Donny. Cualquiera valdr[UNI00e1].\n [UNI00a1]Pero coge una r[UNI00e1]pido!"
		)
		helper_8834eba9(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(12)
		end
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 0, 1)
end

--- Helper function.
local function helper_1333c(arg0: s32, arg1: s32)
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
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_11f30(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Max, mi prioridad ahora es\ncurar este [UNI00e1]rbol.<page>Lo que necesito\nes...")
	helper_85ab2618(0, -1, arg0, arg1, 0)
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
		helper_85ab2618(0, -1, arg0, arg1, 0)
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
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Ya est[UNI00e1] todo resuelto\n por el momento.<page>[UNI00a1]Ya te puedo acompa[UNI00f1]ar\nen tu aventura!<page>[UNI00a1]Ah! Ni se te ocurra hablarle a\ntu padre del Agua bendita, [UNI00bf]entendido?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "Gordon se ha unido al grupo.")
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Puedes emplear sus habilidades\n desde la opci[UNI00f3]n Estado del\napartado Personajes del men[UNI00fa] Principal.<page>[(!)]Si reclutas a m[UNI00e1]s personas\npara la aventura, se\nsubir[UNI00e1]n al tren."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]Habla con ese pasajero\ndel tren para que se\nconvierta en el tercer miembro del grupo.<page>[(!)]Para que\nuno de tus amigos del tren entre en una casa, elige Mover persona\nen el men[UNI00fa] Puerta de la casa en cuesti[UNI00f3]n."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"[(!)]Puede que haya muchos m[UNI00e1]s\nque quieran unirse a tu grupo.\n[UNI00a1]B[UNI00fa]scalos!"
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	var4 = event.GetEventData_2(14) or var4
	event.SetNpcStatus(var4, 130)
	event.Finish()
	event.SetQuestEtc(1, 0, 1)
end

--- Helper function.
local function helper_1405c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.MesMake_2(0, "Oh. Hola, joven.\n[UNI00bf]Puedo hacer algo por ti?")
		else
			event.MesMake_2(0, "Max, no le hables a tu padre del\nAgua bendita, [UNI00bf]entendido?")
		end
	else
		event.MesMake_2(0, "Tiene que haber much[UNI00ed]simas plantas\npor ah[UNI00ed] que ni siquiera conozcamos.")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1438c(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
	end
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_12284(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_125cc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_1333c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_1405c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_16e94(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_0d70bce8(arg0, 0, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_0d70bce8(arg0, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Hola.\n[UNI00bf]M[UNI00f3]nica, no?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Soy Parn.\nSoy un artista m[UNI00e1]gico.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Oye, Max.<page>[UNI00bf]C[UNI00f3]mo es que siempre tienes buen aspecto?")
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_17290(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_85ab2618(0, -1, arg1, arg0, 0)
			end
			if at <= 5 then
				helper_8834eba9(0, -1, 8, 0, 0)
			end
			return
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_85ab2618(0, -1, arg1, arg0, 0)
		end
		if at <= 10 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 13 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_0d70bce8(arg0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.MesMake_2(0, "Hola.\n[UNI00bf]M[UNI00f3]nica, no?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Soy Parn.\nSoy un artista m[UNI00e1]gico.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "No os he presentado todav[UNI00ed]a, [UNI00bf]no?<page>Esta es Julia, mi futura mujer.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(0, "...")
		helper_85ab2618(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)]A M[UNI00f3]nica no se le dan muy bien\nestas situaciones. Podr[UNI00ed]a lograr algo,\npero es probable que no lo haga. Prueba m[UNI00e1]s tarde con Max."
		)
		helper_8834eba9(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMesPreset(0, 0)
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "Hola, Max.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "No os he presentado todav[UNI00ed]a, [UNI00bf]no?<page>Esta es Julia, mi futura mujer.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "...")
	helper_85ab2618(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"Puedes re[UNI00ed]rte lo que quieras.\nYa s[UNI00e9] que es raro.<page>[UNI00bf]Qui[UNI00e9]n se enamorar[UNI00ed]a de\nun retrato?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(
		0,
		"Pero soy un artista m[UNI00e1]gico.\nTengo el poder de convertir en realidad las cosas que pinto.<page>Todo lo que pinto existe en el cuadro verdaderamente.\nA menos que se trate de un ser vivo..."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.MesMake_2(0, "Ni siquiera un artista m[UNI00e1]gico puede pintar vida.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(
		0,
		"Aunque he o[UNI00ed]do que existe una forma.\nHay un Huevo dorado en un [UNI00e1]rbol grande y viejo."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Se cuenta que con el color dorado\nse puede dar vida a cualquier cosa que pintes.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.MesMake_2(
		0,
		"Max, tengo entendido que\nte marchas de la ciudad, [UNI00bf]no?<page>[UNI00bf]Podr[UNI00ed]as traerme algo de Pintura dorada?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"Por supuesto que no espero que lo hagas a cambio de nada.<page>Si me ayudas, usar[UNI00e9]\nmi nuevo poder para devolverte el favor."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Un [UNI00e1]rbol grande y viejo...\n [UNI00a1]Con un Huevo dorado! [UNI00bf]Y d[UNI00f3]nde se supone\nque hay algo as[UNI00ed]?"
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 1, 1)
end

--- Helper function.
local function helper_11e50()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bbc8e499(var0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	event.SetNpcStatus(var0, 128)
	helper_bbc8e499(var0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_18498(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_11e50()
		end
		if at <= 8 then
			helper_bbc8e499(22)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Te he estado esperando.<page>R[UNI00e1]pido, dame la Pintura para\ndar vida a mi cuadro.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
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
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(376)
	event.MesMake_2(0, "O sea que esta es la Pintura dorada...\nLa probar[UNI00e9] ahora mismo.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Es... Es real...<page>[UNI00a1]Incre[UNI00ed]ble, es perfecta!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Gracias, Max.\nNo he olvidado mi promesa. Usa mi\nnuevo poder cuando quieras.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(8)
	end
	event.SetNpcStatus(22, 130)
	helper_bbc8e499(22)
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 1, 1)
end

--- Helper function.
local function helper_18c70(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Usa mi nuevo poder\ncuando quieras.")
	else
		event.MesMake_2(
			0,
			"El mundo de la pintura es muy profundo.\nPuede que me lleve toda una vida dominarlo,\npero el trayecto bien vale la pena."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_18ec8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_16e94(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_16e94(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_17290(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_18498(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_18c70(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_10cdc(arg0: s32)
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
			helper_8834eba9(arg0, -1, 3, 256, 208)
		end
		if at <= 3 then
			helper_ecb662ce(arg0, 1)
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_8834eba9(arg0, -1, 3, 256, 208)
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
		helper_ecb662ce(arg0, 1)
		event.MesMake_2(arg0, "Si no me traes m[UNI00e1]s logros\nno puedo darte nada.")
		if now_map_no == 22 then
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_8834eba9(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
	end
	if var5 == 2 then
		helper_ecb662ce(arg0, 1)
		event.MesMake_2(
			arg0,
			"El nivel de tu Fotograf[UNI00ed]a est[UNI00e1] determinado\npor el n[UNI00fa]mero de ideas y logros\nque tengas.<page>Conforme vayas aumentando de nivel, conseguir[UNI00e1]s\nm[UNI00e1]s objetos como recompensa."
		)
		if now_map_no == 22 then
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_8834eba9(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_11364(arg0: s32)
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
				helper_8834eba9(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_8834eba9(arg0, -1, 3, 256, 208)
			end
			return helper_10cdc(arg0)
		end
		if at <= 5 then
			helper_ecb662ce(arg0, 1)
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_8834eba9(arg0, -1, 3, 256, 208)
		end
		return helper_10cdc(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_ecb662ce(arg0, 1)
		event.MesMake_2(arg0, "Tr[UNI00e1]eme una\nNota de Logros, anda.")
		if now_map_no == 22 then
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_8834eba9(arg0, -1, 3, 256, 208)
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
		helper_ecb662ce(arg0, 1)
		event.MesMake_2(arg0, "Parece que no quedan\nlogros.")
		if now_map_no == 22 then
			helper_85ab2618(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_8834eba9(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(4)
			end
		end
		return helper_10cdc(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_ecb662ce(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Yo calculo [Number1] logros m[UNI00e1]s.")
		event.SetMesDrawspeed(arg0, 0)
		helper_8834eba9(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_ecb662ce(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(
			arg0,
			"[UNI00a1]Oye, t[UNI00ed]o! [UNI00a1]No te relajes!\n[UNI00bf]D[UNI00f3]nde est[UNI00e1]n todas tus nuevos logros Interiores?"
		)
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(
			arg0,
			"[UNI00a1]Guau! [UNI00a1]Ya tienes [Number 1] nuevos logros!\n[UNI00a1]Sab[UNI00ed]a que lo llevabas dentro de ti!"
		)
	end
	if now_map_no == 22 then
		helper_85ab2618(arg0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		helper_8834eba9(arg0, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(7)
		end
	end
	return helper_10cdc(arg0)
end

--- Helper function.
local function helper_e528()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("IN go_shop_up()\n")
			print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
			helper_eb131214(var1, -1, 0, 0)
		end
		if at <= 2 then
			helper_c87b6812(15)
		end
		if at <= 3 then
			helper_c87b6812(1)
		end
		if at <= 4 then
			helper_c87b6812(6)
		end
		if at <= 5 then
			helper_c87b6812(0)
		end
		if at <= 6 then
			helper_c87b6812(4)
		end
		if at <= 7 then
			helper_c87b6812(31)
		end
		if at <= 8 then
			helper_c87b6812(35)
		end
		if at <= 9 then
			helper_c87b6812(36)
		end
		if at <= 10 then
			helper_c87b6812(37)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	print("IN go_shop_up()\n")
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Bienvenido.")
	if var0 == 18 then
		event.MesMake_2(
			0,
			"[UNI00bf]Quieres que te asista el\npoder de los dioses? Pues ten la amabilidad\nde hacer un donativo a la iglesia."
		)
	end
	if var0 == 4 then
		event.MesMake_2(
			0,
			"Trabajando duro, [UNI00bf]no?\n[UNI00bf]Necesit[UNI00e1]is algo?<page>Pero por la cara, nada.\nNi siquiera para ti, Max."
		)
	end
	if var0 == 34 then
		event.MesMake_2(
			0,
			"[UNI00bf]Necesitas m[UNI00e1]s elementos\nde Georama?<page>Si no tienes tiempo\npara conseguirlos t[UNI00fa] mismo, a lo mejor\npuedes solucionar tus problemas con un poco de dinero."
		)
	end
	if var0 == 1012 then
		flag = event.GetFlag(45) or flag
		if flag == 0 then
			event.MesMake_2(
				0,
				"Hola. Soy un aprendiz de panadero.\nMe encargo de la panader[UNI00ed]a mientras\nPolly est[UNI00e1] fuera.<page>Estoy un poco nervioso, pero es\nparte de mi formaci[UNI00f3]n, supongo.\n[UNI00a1]Har[UNI00e9] lo que pueda!"
			)
			event.SetFlag(45, 1)
		end
	end
	if var0 == 1015 then
		flag_2 = event.GetFlag(46) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"No nos parecemos mucho...\nPero soy la hermana peque[UNI00f1]a de Milane.<page>Me pidi[UNI00f3] que cuidara de la tienda mientras ella no est[UNI00e1].\n[UNI00a1]Yo no s[UNI00e9] nada de armas!"
			)
			event.SetFlag(46, 1)
		end
	end
	if var0 == 1018 then
		flag_3 = event.GetFlag(47) or flag_3
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"[UNI00bf]Te he sorprendido, a que s[UNI00ed]? Cualquiera se sorprender[UNI00ed]a\nal ver a alguien\nvestido de esta manera aqu[UNI00ed].<page>Soy un buen amigo del Padre Bruno. Estoy\npara informar a la gente mientras [UNI00e9]l est[UNI00e1] de viaje.\nBueno, [UNI00bf]te puedo ayudar en algo?"
			)
			event.SetFlag(47, 1)
		else
			event.MesMake_2(
				0,
				"[UNI00bf]Quieres que te asista el\npoder de los dioses? Pues ten la amabilidad\nde hacer un donativo a la iglesia."
			)
		end
	end
	if var1 ~= -1 then
		helper_eb131214(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 18 then
		helper_c87b6812(15)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 12 then
		helper_c87b6812(1)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 4 then
		helper_c87b6812(6)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 15 then
		helper_c87b6812(0)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 33 then
		helper_c87b6812(4)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 34 then
		helper_c87b6812(31)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1012 then
		helper_c87b6812(35)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1015 then
		helper_c87b6812(36)
		if vm.skipping() then
			return skip(10)
		end
	end
	if var0 == 1018 then
		helper_c87b6812(37)
		if vm.skipping() then
			return skip(11)
		end
	end
end

--- Helper function.
local function helper_1934c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"La tienda est[UNI00e1] cerrada. Tendr[UNI00e1]s que\nir a la tienda de mi padre.<page>Busca las calabazas. Est[UNI00e1]n a la vista,\nencima de la escalera."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_191ac(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Desde que has venido,\napenas he visto a Max.\nNo s[UNI00e9] qu[UNI00e9] pretendes,<page>pero espero que no lo est[UNI00e9]s utilizando."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_194fc(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_191ac(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Deber[UNI00ed]as imaginarte la respuesta:\n[UNI00a1]ni hablar!<page>[UNI00bf]Por qu[UNI00e9] iba yo a trabajar por\nel bien de otros?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Yo no saco nada y\nadem[UNI00e1]s me da mucho miedo.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Trat[UNI00e1]ndose de ti, supongo\nque me lo puedo pensar mejor.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Pero soy hijo de comerciante:\nno hacemos nada gratis.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Ya sabr[UNI00e1]s que colecciono monedas.<page>Son el s[UNI00ed]mbolo de los negocios. Quiero\nacabar mi colecci[UNI00f3]n."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Pero soy incapaz de conseguir\nla Moneda negra\ny la Moneda indestructible.<page>Si me ayudas,<page>quiz[UNI00e1] te ayude yo a ti."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(0, 2, 1)
end

--- Helper function.
local function helper_19c50(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var5: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				var5 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 5 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			helper_11e50()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_191ac(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	argc = event.GetItemNum(201) or argc
	argc_2 = event.GetItemNum(202) or argc_2
	if argc <= 0 or argc_2 <= 0 then
		event.MesMake_2(
			0,
			"[UNI00bf]Qu[UNI00e9]? Ah, un coleccionista de monedas.<page>Estoy buscando la Moneda negra\ny la Moneda indestructible.<page>No se ven en ninguna parte. Las he buscado\npor todos lados pero no hay quien las encuentre."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Eh? [UNI00bf]Las tienes? [UNI00a1]Incre[UNI00ed]ble!<page>[UNI00a1]No te quedes ah[UNI00ed]! [UNI00a1]Dame, dame, dame!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Vale.\n[UNI00bf]Qu[UNI00e9] tengo que hacer?")
	var5 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "[UNI00a1]Agh! Si vas a cabrearme,\npaso de ayudarte.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(201)
	event.SubItem(202)
	event.MesMake_2(
		0,
		"[UNI00a1]Guau! [UNI00a1]Ya las tengo todas!\nCre[UNI00ed]a que era imposible...<page>Bueno, ahora creo que no tengo alternativa.\nSer[UNI00e1] mejor que vaya contigo."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 2, 1)
end

--- Helper function.
local function helper_1a750(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_191ac(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.SetMesPreset(0, 0)
		event.MesMake_2(
			0,
			"No me lo puedo creer. Nunca pens[UNI00e9] que\nfueras a conseguirlas.<page>[UNI00a1]Vaya pedazo de haza[UNI00f1]a, Max!"
		)
	else
		event.MesMake_2(
			0,
			"[UNI00a1]Eh! [UNI00bf]C[UNI00f3]mo va la b[UNI00fa]squeda de Zelmite?\nSi puedo ayudar,\ndame una voz."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1aa90(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_1934c(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_194fc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_19c50(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_1a750(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_1ad74(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d70bce8(arg0, 0, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Hola. [UNI00bf]Qu[UNI00e9] clase de comida\nquieres, M[UNI00f3]nica?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Me gusta la comida normal, pero\nno le hago ascos a lo extra[UNI00f1]o.")
	else
		event.MesMake_2(
			0,
			"Alg[UNI00fa]n d[UNI00ed]a ser[UNI00e9] el mejor chef\ndel mundo y entonces\npodr[UNI00e1]s comer gratis cuando quieras."
		)
	end
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1b15c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"[UNI00bf]Has hecho alg[UNI00fa]n gran descubrimiento?<page>Mientras t[UNI00fa] descubres\nm[UNI00e1]quinas y chismes,\nyo invento platos.<page>Todos los d[UNI00ed]as investigo para\npreparar comida que nadie haya\nprobado a[UNI00fa]n."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1b35c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "[UNI00a1]Ah, por cierto!\nQuer[UNI00ed]a charlar contigo sobre un asunto.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Ya sabr[UNI00e1]s que estoy\nhaciendo caramelos extra[UNI00f1]os de todo\nel mundo como parte de mi investigaci[UNI00f3]n."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Me han hablado de un caramelo llamado Castagnaccio.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "que se fabrica con una cosa llamada Castarna.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "He descubierto que la Castarna crece\nen el mismo tipo de [UNI00e1]rbol que las Nueces.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Por eso pens[UNI00e9] que dar[UNI00ed]a lo mismo usar Nueces en su lugar,\npero ha pasado algo raro...\nNo quedan Nueces en toda la ciudad."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "Parece ser que el alcalde las ha vendido todas.\nNo s[UNI00e9] si podr[UNI00ed]as ayudarme.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetQuestEtc(0, 3, 1)
end

--- Helper function.
local function helper_1bb08(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_11e50()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "[UNI00bf]Has conseguido alguna Casta[UNI00f1]a?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
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
		helper_85ab2618(0, -1, arg0, arg1, 0)
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
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Puedo devolverte el favor de alguna manera?<page>[UNI00bf]C[UNI00f3]mo? [UNI00bf]Quieres que te acompa[UNI00f1]e en tu aventura?<page>[UNI00a1]Ja, ja! Eso est[UNI00e1] hecho.<page>[UNI00bf]Por qu[UNI00e9] no me has preguntado antes?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 3, 1)
end

--- Helper function.
local function helper_1c220(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Claro, nunca te dir[UNI00ed]a\nque no.")
	else
		event.MesMake_2(
			0,
			"Alg[UNI00fa]n d[UNI00ed]a ser[UNI00e9] el mejor chef\ndel mundo y entonces\npodr[UNI00e1]s comer gratis cuando quieras."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1c478(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1ad74(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1ad74(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1b15c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_1b35c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1bb08(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_1c220(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_1c804(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d70bce8(arg0, 0, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "[UNI00a1]Hola! [UNI00bf]Eres la novia\nde Max?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Qu[UNI00e9] color tan original tiene tu pelo.\nComo el de Erik, pero diferente...<page>El tuyo es muy bonito,\ncomo una joya."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1cae4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1c804(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1c804(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Has estado fuera [UNI00fa]ltimamente,\n[UNI00bf]no, Max?<page>No lo niegues.\nLo s[UNI00e9] de buena tinta."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_1cd0c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1c804(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Me gustar[UNI00ed]a ayudarte pero pelear\nme da miedo y, adem[UNI00e1]s, es muy sucio.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Adem[UNI00e1]s, no me gusta incordiar a nadie.\nLo siento pero no.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Pero tiene que haber muchas\ncosas interesantes fuera de la ciudad.<page>[UNI00c1]rboles que no hemos visto\ny flores de todas las clases."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Si ves una flor interesante, [UNI00bf]podr[UNI00ed]as\nsacarle una foto y tra[UNI00e9]rmela, Max?\nMe encantar[UNI00ed]a verla."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Ha dicho que no, pero si\nle ense[UNI00f1]as una foto de algo que\nle interese puede que acepte."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 4, 1)
end

--- Helper function.
local function helper_1d470(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local photo: s32 = 0
	local photo_2: s32 = 0
	local photo_3: s32 = 0
	local photo_4: s32 = 0
	local photo_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_11e50()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1c804(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	photo = event.CheckInventPhoto(2009) or photo
	photo_2 = event.CheckInventPhoto(52, 3) or photo_2
	photo_3 = event.CheckInventPhoto(53, 3) or photo_3
	photo_4 = event.CheckInventPhoto(54, 3) or photo_4
	photo_5 = event.CheckInventPhoto(55, 3) or photo_5
	if vm.i32(vm.i32(vm.i32(vm.i32(photo + photo_2) + photo_3) + photo_4) + photo_5) <= 0 then
		event.MesMake_2(
			0,
			"[UNI00bf]Tienes fotos de flores raras?<page>S[UNI00e9] mucho de flores, as[UNI00ed] que si\nno es algo especial, no me va a interesar."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "[UNI00bf]Tienes fotos de flores raras?\n[UNI00a1]A ver, a ver!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "[UNI00a1]Guau! [UNI00a1]Alucinante!\nAs[UNI00ed] que estas son las flores que se ven fuera.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Umm... [UNI00bf]Qu[UNI00e9] hago?<page>Bueno, venga. Me voy con vosotros.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 4, 1)
end

--- Helper function.
local function helper_1dcd0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_1c804(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.MesMake_2(0, "Pero no me lleves\na ning[UNI00fa]n sitio demasiado peligroso.")
	else
		event.MesMake_2(
			0,
			"Por fin, el Ferrocarril\nBlackstone conquista el mundo.\n[UNI00a1]Qu[UNI00e9] emoci[UNI00f3]n!"
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1dfd0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1cae4(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_1cae4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_1cd0c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1d470(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_1dcd0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_1e2b4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Quiz[UNI00e1] s[UNI00f3]lo me pase a m[UNI00ed], pero hay\nalgo en ti que me recuerda a Elena.<page>No s[UNI00e9] qu[UNI00e9] es, pero tienes cierta cualidad\ndistinta al resto de los habitantes de la ciudad."
		)
	else
		event.MesMake_2(
			0,
			"La Mina de Zelmite es un lugar terror[UNI00ed]fico.\nNo se puede bajar\nla guardia ni un momento."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1e59c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Si tienes alg[UNI00fa]n problema,\nhabla primero conmigo.")
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1e6ec(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Si necesitas algo,\nhar[UNI00e9] lo que pueda para ayudarte.<page>T[UNI00fa] d[UNI00e9]jame a m[UNI00ed]."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "...")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "No s[UNI00e9] si podr[UNI00e1]s solucionar algo,<page>pero escucha.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Me he tirado 30 a[UNI00f1]os trabajando\ncomo un mulo en esta casa.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Es todo lo que hago, pero\nmi afici[UNI00f3]n es la lectura.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "En estos momentos est[UNI00e1]n subastando\nun libro muy valioso.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "La gente se pega por [UNI00e9]l.\nCreo que con una oferta\nde 1000 Gildas bastar[UNI00ed]a.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"Yo no dispongo de ese dinero y, si se\nlo pidiera a mi maestro, se escandalizar[UNI00ed]a y\nseguramente me echar[UNI00ed]a."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"Eres mi [UNI00fa]nica esperanza.<page>Pero no quiere decir\nque si no me ayudas yo no vaya a echarte una mano."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]A pesar de lo que diga, Stewart seguramente\n no te ayudar[UNI00e1] si no le consigues 1000 Gildas.\n En fin, ser[UNI00e1] mejor que empieces a ahorrar."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 6, 1)
end

--- Helper function.
local function helper_1f1c8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local money: s32 = 0
	local var4: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			return
		end
		if at <= 10 then
			if at <= 8 then
				var4 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 9 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_0c95681b(30)
			end
			return
		end
		if at <= 13 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_11e50()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(9) or var2
	money = event.GetMoney() or money
	if var2 == 0 then
		if money < 1000 then
			event.MesMake_2(
				0,
				"Ese dinero no\nme vale para la subasta.<page>Necesito 1000 Gildas.\nNo s[UNI00e9] si est[UNI00e1] claro."
			)
			helper_85ab2618(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			event.MesMake_2(0, "[UNI00a1]No te lo vas a creer!<page>El precio ha subido a\n1200 Gildas.")
			helper_85ab2618(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.MesMake_2(0, "Lo siento mucho, pero [UNI00bf]podr[UNI00ed]as\nconseguir 1500 Gildas?")
			helper_85ab2618(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(4)
			end
			event.SetCnt(9, 1)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 1 then
		if money < 1500 then
			event.MesMake_2(
				0,
				"No podemos perder el tiempo,\nsi no, se lo vender[UNI00e1]n a otro.<page>[UNI00a1]Cons[UNI00ed]gueme 1500 Gildas cuanto antes!"
			)
			helper_85ab2618(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(5)
			end
		else
			event.MesMake_2(
				0,
				"[UNI00a1]Es terrible!\nAlguien ofrece 1800 Gildas.<page>Si no doy m[UNI00e1]s de 2000,\nno me lo llevar[UNI00e9] ni en broma."
			)
			helper_85ab2618(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetCnt(9, 2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 2 then
		if money < 2000 then
			event.MesMake_2(
				0,
				"No podemos perder el tiempo,\nsi no se lo vender[UNI00e1]n a otro.<page>[UNI00a1]Cons[UNI00ed]gueme 2000 Gildas cuanto antes!"
			)
			helper_85ab2618(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Sonny, [UNI00bf]has conseguido reunir\nlas 2000 Gildas?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "[UNI00bf]Qu[UNI00e9] hago? Es tuyo.\nHa sido un despilfarro.")
		var4 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(9)
		end
		event.SetMesShippo(0, 1)
		event.SetMesEtc(0, 0, 0)
		if var4 ~= 0 then
			event.MesMake_2(
				0,
				"Ya... Bueno, 2000 Gildas es mucho dinero.\nDebe de ser duro gast[UNI00e1]rselo.\nIncluso para un joven bien acomodado como t[UNI00fa]... <page>Bueno, no importa.\nPero la subasta a[UNI00fa]n no ha terminado.\nEsperar[UNI00e9] lo que haga falta..."
			)
			helper_85ab2618(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(10)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Gracias por todo.<page>[UNI00a1]Me largo corriendo a la subasta!")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.AddMoney(-2000)
		event.SetCnt(9, 3)
		event.SetFadeOut(30)
		helper_0c95681b(30)
		if vm.skipping() then
			return skip(12)
		end
		event.SetAi(1, arg0)
		event.CharaActive(0, arg0)
		event.DeleteVillager(arg0)
		event.SetFadeIn(30)
		event.Finish()
		return
	end
	event.MesMake_2(0, "Muchas gracias.\nHe conseguido ganar la subasta.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(
		0,
		"Puj[UNI00e9] mucho y los dem[UNI00e1]s desistieron\nr[UNI00e1]pidamente. [UNI00a1]Me lo he llevado por 1400 Gildas!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Tengo que devolverte 600.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.AddMoney(600)
	event.MesMake_2(0, "Y trabajar[UNI00e9] para devolverte\nel resto del dinero que te debo.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"S[UNI00e9] que te he causado muchas molestias.\nTe devolver[UNI00e9] el favor en cualquier momento."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(18)
	end
	event.Finish()
	event.SetQuestEtc(1, 6, 1)
end

--- Helper function.
local function helper_20880(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"[UNI00bf]El libro que compr[UNI00e9]?\nEn realidad todav[UNI00ed]a no lo he le[UNI00ed]do.<page>Me bastaba\nel hecho de tenerlo."
		)
	else
		event.MesMake_2(
			0,
			"La Mina de Zelmite es un lugar terror[UNI00ed]fico.\nNo se puede bajar\nla guardia ni un momento."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_20b18(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1e2b4(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1e2b4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1e59c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_1e6ec(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1f1c8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_20880(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_20ea4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d70bce8(arg0, 0, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Por favor, deja de meter\na Max en situaciones peligrosas.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Como le hagan un ara[UNI00f1]azo,\nno te perdonar[UNI00e9] nunca.")
	else
		event.MesMake_2(0, "Rezar[UNI00e9] por ti...")
	end
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_2121c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"En estos momento trabajo de doncella\npero desde peque[UNI00f1]a he so[UNI00f1]ado\ncon ser sastre."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Los sue[UNI00f1]os no se hacen realidad,\npor eso digo que es un sue[UNI00f1]o.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_2150c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Ya veo... Me gustar[UNI00ed]a\npoder ayudaros, de verdad.\nM[UNI00e1]s que nada.<page>Pero no tengo ninguna\nconfianza en m[UNI00ed] misma."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Siempre me rindo antes de tiempo\ny nunca he hecho nada hasta el final.<page>Cuando era peque[UNI00f1]a, so[UNI00f1]aba con convertirme en sastre\ne intent[UNI00e9] hacer algo muchas veces,\npero nunca termin[UNI00e9] ninguna prenda."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Si os acompa[UNI00f1]ara, estoy segura\nde que molestar[UNI00ed]a.<page>Perdonad, pero no.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Vaya por Dios, Adel ha perdido\ntoda su confianza. Eso no es nada bueno. Hay\n que lograr que haga ropa otra vez."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 7, 1)
end

--- Helper function.
local function helper_21b78(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"S[UNI00ed], si lo intento otra vez\ny logro terminar algo,\nquiz[UNI00e1] vuelva a creer en m[UNI00ed] misma."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Pero no tengo los materiales que necesito.<page>[UNI00bf]Podr[UNI00ed]as consegu[UNI00ed]rmelos?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "S[UNI00f3]lo necesito tela resistente,\nun trozo de cuero gordo y un cacho de cobre.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetCnt(8, 1)
end

--- Helper function.
local function helper_21f98(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local var5: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_0d70bce8(arg0, 0, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			if at <= 4 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			helper_0c95681b(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	argc = event.GetItemNum(214) or argc
	argc_2 = event.GetItemNum(245) or argc_2
	argc_3 = event.GetItemNum(227) or argc_3
	if argc <= 0 or argc_2 <= 0 or argc_3 <= 0 then
		event.MesMake_2(
			0,
			"Sin los materiales\nno puedo hacer nada.<page>Necesito tela resistente,\nun trozo de cuero gordo y un cacho de cobre.<page>Siento dar\ntantos problemas."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "[UNI00a1]Toma, toma esto!\nMenudo derroche.")
	var5 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "Sin los materiales\nno puedo hacer nada.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(214)
	event.SubItem(245)
	event.SubItem(227)
	event.SetCnt(8, 2)
	event.MesMake_2(
		0,
		"Muchas gracias.\n[UNI00a1]Intentar[UNI00e9] confeccionar algo de ropa!<page>No dejar[UNI00e9] que tiren esto."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.Finish()
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_229ac(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d70bce8(arg0, 0, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			var2 = 259
			var2 = 258
			var2 = 260
			helper_be50380c(var2, 1)
		end
		if at <= 6 then
			helper_b1ca721b(1)
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_11e50()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "[UNI00a1]Ah, Max! Ya he acabado una prenda.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"No quer[UNI00ed]a dejar\nque desecharan los materiales que me trajiste\ny gracias a eso llegu[UNI00e9] hasta el final."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "No me he quedado completamente satisfecha,\n[UNI00bf]pero te lo pondr[UNI00ed]as igualmente?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	var2 = 259
	argc = event.GetItemNum(258) or argc
	if argc <= 0 then
		var2 = 258
	else
		argc = event.GetItemNum(260) or argc
		if argc <= 0 then
			var2 = 260
		end
	end
	event.AddItem(var2)
	helper_be50380c(var2, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_b1ca721b(1)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Ah, qu[UNI00e9] bien sienta\nterminar algo.<page>Ahora siento mucha\nm[UNI00e1]s confianza.<page>Har[UNI00e9] todo lo que pueda.\nLlevadme con vosotros."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 7, 1)
end

--- Helper function.
local function helper_230e8(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "[UNI00bf]Qu[UNI00e9] tal te queda?<page>[UNI00a1]No me mientas!")
	else
		event.MesMake_2(0, "Rezar[UNI00e9] por ti...")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_23300(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_20ea4(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 7 then
			if at <= 5 then
				helper_21f98(arg0, arg1)
			end
			if at <= 6 then
				helper_229ac(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_20ea4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_2121c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_2150c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_21b78(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_21f98(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_229ac(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_230e8(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

--- Helper function.
local function helper_24658(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d70bce8(arg0, 0, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"T[UNI00fa] eres la chica que\nha estado con Max [UNI00fa]ltimamente.<page>Reconozco a un buen hombre\ncuando lo veo."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Si fuera un poco m[UNI00e1]s joven,\nno lo dejar[UNI00ed]a escapar.")
	else
		event.MesMake_2(0, "Cuando te apetezca\npan, ya sabes d[UNI00f3]nde encontrarme.")
	end
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_24a30(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Lo m[UNI00e1]s importante en los negocios\nes contar con la confianza de los clientes.<page>Es algo que nunca\nse puede descuidar."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_24bd0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_be50380c(300, 20)
		end
		if at <= 5 then
			helper_b1ca721b(1)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Quieres que\nte acompa[UNI00f1]e?<page>S[UNI00f3]lo soy una mujer que hace Pan,\npero si crees que puedo ser [UNI00fa]til,\nir[UNI00e9] encantada."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Ah, pero antes tengo\nque hacer un env[UNI00ed]o a Morton.<page>[UNI00bf]Te importar[UNI00ed]a llevarle 20 barras\nde Pan a Morton a su tienda?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Mientras vas y vienes,\nhar[UNI00e9] las maletas.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(300, 20)
	helper_be50380c(300, 20)
	if vm.skipping() then
		return skip(5)
	end
	helper_b1ca721b(1)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "[UNI00bf]Qu[UNI00e9] querr[UNI00e1] hacer\ncon 20 barras?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(0, 8, 1)
	event.SetCnt(12, 0)
end

--- Helper function.
local function helper_251b0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_11e50()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 < 3 then
		event.MesMake_2(
			0,
			"Lo siento, todav[UNI00ed]a\nno estoy lista.<page>[UNI00bf]Puedes darme un poco m[UNI00e1]s de tiempo?"
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Por cierto: [UNI00bf]has ido ya\na ver a Morton de mi parte?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
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
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "No importa.\nEn marcha.<page>[UNI00bf]A d[UNI00f3]nde\nvamos?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SubItem(300, 20)
	event.AddItem(299, 20)
	helper_11e50()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 8, 1)
end

--- Helper function.
local function helper_257e0(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Vamos, Max,\nen marcha.<page>[UNI00bf]A d[UNI00f3]nde vamos?")
	else
		event.MesMake_2(0, "Cuando te apetezca\npan, ya sabes d[UNI00f3]nde encontrarme.")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_25a18(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_24658(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_24658(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_24a30(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_24bd0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_251b0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_257e0(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_14658(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"No quiero ver a ninguna mujer\nempu[UNI00f1]ando una espada por ah[UNI00ed].<page>Las mejores mujeres son las\nfinas. F[UNI00ed]jate en Adel, por ejemplo."
		)
	else
		event.MesMake_2(0, "Si hay algo en lo que pueda ayudarte\n, no tienes m[UNI00e1]s que ped[UNI00ed]rmelo.")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_14900(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Esta ciudad es demasiado pac[UNI00ed]fica y\nno hay trabajo para m[UNI00ed].<page>Ya s[UNI00e9] que eso es bueno,\npero..."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_14a90(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Max.\nLo siento, pero estoy\nalgo ocupado ahora mismo.<page>Estoy a punto\nde conseguir materiales importantes\npara la seguridad de la ciudad."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Si no es nada urgente,\n[UNI00bf]podr[UNI00ed]a esperar hasta ma[UNI00f1]ana?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_14da0(arg0: s32, arg1: s32)
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Claro, d[UNI00e9]jame probar.\nNo me apetece.")
	var2 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var2 ~= 0 then
		event.MesMake_2(
			0,
			"Vale...<page>Bueno, si quieres volver a probar m[UNI00e1]s tarde,\nd[UNI00ed]melo. Te esperar[UNI00e9]."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(7, 0)
		return
	end
	event.MesMake_2(0, "[UNI00a1]Preparado, listo,\nya!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.Finish()
	event.Stopwatch(3, 32, 364, 0)
	event.Stopwatch_1(0)
	event.SetCnt(7, 1)
end

--- Helper function.
local function helper_15354(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_14da0(arg0, arg1)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Eh, Max, [UNI00bf]has venido a buscarme?<page>Te he estado esperando.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Gracias a las murallas,\nla ciudad es segura.<page>Es hora de salir.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Me parece bien que te pases\nel d[UNI00ed]a manipulando m[UNI00e1]quinas,\npero me gustar[UNI00ed]a saber qu[UNI00e9] fuerza tienes."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"La lucha\nes cuesti[UNI00f3]n de velocidad y juego de pies.<page>Si eres m[UNI00e1]s lento que yo,\nest[UNI00e1]s listo."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Por qu[UNI00e9] no te ponemos a prueba?\nCorre hasta la barca del lago y vuelve.<page>Mi r[UNI00e9]cord es de 2 minutos y 1 segundo.\nSi eres m[UNI00e1]s lento,\nno hay nada que hacer."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetQuestEtc(0, 9, 1)
	event.MesMake_2(0, "[UNI00bf]Qu[UNI00e9] dices, quieres probar?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	helper_14da0(arg0, arg1)
	if vm.skipping() then
		return skip(8)
	end
end

--- Helper function.
local function helper_15a58(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_14da0(arg0, arg1)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_14da0(arg0, arg1)
			end
			return
		end
		if at <= 9 then
			if at <= 7 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 8 then
				helper_14da0(arg0, arg1)
			end
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 11 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_14da0(arg0, arg1)
			end
			return
		end
		if at <= 14 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_11e50()
		end
	end
	do
		local out1, out2, out3, out4 = event.Stopwatch_5(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var6 = event.GetCnt(7) or var6
	if var6 == 0 then
		event.MesMake_2(0, "Hola, Max.\n[UNI00bf]Quieres probar otra vez?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		helper_14da0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var6 == 1 then
		event.MesMake_2(
			0,
			"Eh. No has ido hasta la barca,\n[UNI00bf]no? Quer[UNI00ed]as enga[UNI00f1]arme.\n[UNI00a1]No seas tramposo!"
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(0, "[UNI00bf]Quieres probar otra vez?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		helper_14da0(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var2 < 0 then
		event.MesMake_2(0, "[UNI00a1]Eh, no hagas trampas!")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "[UNI00bf]Quieres probar otra vez?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		helper_14da0(arg0, arg1)
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	event.MesMake_2(0, "Has llegado.\nBien,<page>vamos a ver\ntu tiempo.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesValue(0, 1, var2)
	event.SetMesValue(0, 2, var3)
	event.SetMesValue(0, 3, var4)
	if var5 == 0 then
		event.MesMake_2(0, "[UNI00a1]Vaya por Dios!\n[数値２] minutos.[数値３] segundos.\nDemasiado lento.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(0, "[UNI00bf]Quieres probar otra vez?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		helper_14da0(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
		return
	end
	event.MesMake_2(0, "[UNI00a1]Oh!\n[数値１] minutos [数値２] segundos[数値３].\nNo est[UNI00e1] mal.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(
		0,
		"Eres m[UNI00e1]s r[UNI00e1]pido de lo que parece. Vale,\nvamos a pelear contra los malos juntos."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(16)
	end
	event.Finish()
	event.SetQuestEtc(1, 9, 1)
end

--- Helper function.
local function helper_166e8(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Eres mucho m[UNI00e1]s r[UNI00e1]pido\nde lo que parece.\n[UNI00a1]Me has sorprendido!")
	else
		event.MesMake_2(0, "Si hay algo en lo que pueda ayudarte\n, no tienes m[UNI00e1]s que ped[UNI00ed]rmelo.")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_16950(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_14658(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_14658(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_14900(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 < 1182.0 or 1183.0 < var4 or var6 < 210.0 or 211.0 < var6 then
		print("kokokokokokokokokoko\n")
		helper_14a90(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_15354(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 1 then
		helper_15a58(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var3 == 2 then
		helper_166e8(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
		return
	end
end

--- Helper function.
local function helper_25da4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"[UNI00bf]As[UNI00ed] que me has visto en el circo?\n[UNI00bf]Est[UNI00e1] bien, eh?<page>Para m[UNI00ed] es m[UNI00e1]s una afici[UNI00f3]n\nque un trabajo."
		)
	else
		event.MesMake_2(
			0,
			"[UNI00bf]Qu[UNI00e9] hay de los logros? [UNI00bf]Te has encontrado\ncon alg[UNI00fa]n bicho raro en la mina?"
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2606c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Mi tienda est[UNI00e1]\nespecializada en espadas.<page>Tengo pistolas,\npero las armas de fuego\nno son lo m[UNI00ed]o."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_261fc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_be50380c(44, 1)
		end
		if at <= 6 then
			helper_b1ca721b(1)
		end
		if at <= 7 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "T[UNI00fa] eres M[UNI00f3]nica,\n[UNI00bf]no?<page>Me han dicho que no\nmanejas mal la espada.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Pero las espadas no\nson ning[UNI00fa]n juguete.<page>Tienes que darte cuenta de lo que tienes enfrente."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Si puedes mejorar dos niveles una espada,\nadmitir[UNI00e9] que tienes aptitudes.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Empieza con este\nGladius.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(44)
	helper_be50380c(44, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_b1ca721b(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Si quieres que Milane te acepte, deber[UNI00e1]s\nmejorar el Gladius\ndos niveles.")
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Tambi[UNI00e9]n se pueden comprar o recoger armas.\n Consigue un arma fuerte y\n Milane te ayudar[UNI00e1]."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 10, 1)
end

--- Helper function.
local function helper_269b0(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_11e50()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(67) or argc
	argc_2 = event.GetItemNum(69) or argc_2
	if argc <= 0 and argc_2 <= 0 then
		event.MesMake_2(
			0,
			"[UNI00bf]Qu[UNI00e9] clase de espada es esa?\n[UNI00bf]Hablabas por hablar?<page>[UNI00a1]Fuera de aqu[UNI00ed]!\nMe est[UNI00e1]s estorbando."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Guau, vaya espada\nm[UNI00e1]s bonita.<page>Siento haber\ntenido que ponerte a prueba.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Es que si lucho contra\nun aficionado me pongo yo tambi[UNI00e9]n en peligro.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Aunque me parece que\ncontigo no hay de qu[UNI00e9] preocuparse.<page>Venga, vamos\na luchar.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 10, 1)
end

--- Helper function.
local function helper_2705c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Los destellos de las espadas\nbien forjadas brillan mucho.<page>Te quitan el aliento.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "No s[UNI00e9] c[UNI00f3]mo le puede gustar\na nadie pulir piedras.")
	else
		event.MesMake_2(
			0,
			"[UNI00bf]Qu[UNI00e9] hay de los logros? [UNI00bf]Te has encontrado\ncon alg[UNI00fa]n bicho raro en la mina?"
		)
	end
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_27444(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_25da4(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		helper_25da4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_2606c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_261fc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_269b0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_2705c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_277d0(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "[UNI00bf]Eres amiga de Max?<page>Bueno, ten cuidado.")
	else
		event.MesMake_2(
			0,
			"A partir de ahora voy a ayudar\na Need y Cedric a reconstruir el mundo.\nTenemos que trabajar juntos."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_27a28(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Se te dan bien las m[UNI00e1]quinas,\n[UNI00bf]pero no crees que va siendo hora\nde que aprendas algo de miner[UNI00ed]a?"
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_27bb8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_be50380c(24, 1)
		end
		if at <= 6 then
			helper_b1ca721b(1)
		end
		if at <= 7 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Seg[UNI00fa]n Cedric,\nhas estado fuera\npor ciertos asuntos.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Eres bueno en muchas cosas,\npero luego\nnunca terminas nada.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Por eso cuando me pides\nayuda me resulta dif[UNI00ed]cil tomarte\nen serio a la primera.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Ya. [UNI00bf]Por qu[UNI00e9] no mejoras esta Pistola Trompeta y la conviertes en Pistola Campana?<page>[UNI00bf]Ser[UNI00e1]s capaz?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(24)
	helper_be50380c(24, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_b1ca721b(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Para conseguir que Gerald te acepte,\n tendr[UNI00e1]s que\nconseguirle una Pistola Trompeta.<page>[(!)]Puedes mejorar el arma\n que te han dado, comprar una\n o conseguir una en las Mazmorras."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 11, 1)
end

--- Helper function.
local function helper_282fc(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_11e50()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(25) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"[UNI00bf]Qu[UNI00e9] pasa?\n[UNI00bf]Te rindes otra vez?<page>Me decepcionas.\n[UNI00bf]Es eso todo lo que sabes\nhacer despu[UNI00e9]s de pasarte toda la vida entre m[UNI00e1]quinas?"
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"[UNI00a1]Vaya! Parece que te\nhas acostumbrado a manejar armas.<page>No me hace falta ni verte disparar.\nBasta con ver c[UNI00f3]mo la coges."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Vale, te ayudar[UNI00e9].\nPero no lo hago por ti.<page>No me puedo\nquedar aqu[UNI00ed] parado si\nla ciudad est[UNI00e1] en peligro."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 11, 1)
end

--- Helper function.
local function helper_288ac(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Las armas las carga el diablo.<page>Ten cuidado con\nellas o podr[UNI00ed]as hacerte da[UNI00f1]o."
		)
	else
		event.MesMake_2(
			0,
			"A partir de ahora voy a ayudar\na Need y Cedric a reconstruir el mundo.\nTenemos que trabajar juntos."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_28b34(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_277d0(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_277d0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_27a28(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_27bb8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_282fc(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_288ac(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_28ec0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2056b079(arg0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Grrr, grrr..")
	helper_2056b079(arg0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "...1212,<page>No, no. Seguro que era 1122.<page>[UNI00bf]O era 1010?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Grrr, grrr..")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		'[(!)]Si ni siquiera se ha enterado\n de que le has dicho "hola".Debe de\ntener problemas graves.<page>[(!)][UNI00bf]Por qu[UNI00e9] no pruebas despu[UNI00e9]s?\n A lo mejor le puedes echar una mano\n o escucharle o algo.'
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
end

--- Helper function.
local function helper_29320(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_187f0d3d(arg0, arg1)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_187f0d3d(arg1, arg0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Grrr, grrr..")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Qu[UNI00e9] quieres decir con\neso de que qu[UNI00e9] estoy murmullando?<page>Estoy intentando\nrecordar la combinaci[UNI00f3]n de la caja fuerte."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Qu[UNI00e9] quieres decir?\n[UNI00bf]Qu[UNI00e9] caja?<page>La caja fuerte escondida\ndetr[UNI00e1]s del cuadro de mi despacho, claro..."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_187f0d3d(arg0, arg1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"[UNI00a1]Ah, qu[UNI00e9] susto!<page>[UNI00a1]Porras!<page>Me he ido y he desvelado\nmi mayor secreto.<page>Bueno, ya lo sabes.<page>A lo mejor me puedes\nechar una mano."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Tengo muchos problemas\nporque he olvidado\nla combinaci[UNI00f3]n de la caja fuerte.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Es un n[UNI00fa]mero de\n4 d[UNI00ed]gitos. Us[UNI00e9]\nla fecha de nacimiento de Claire\npara no olvidarme nunca."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "[UNI00bf]C[UNI00f3]mo lo habr[UNI00e9] olvidado?<page>Vaya padre soy...")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]El alcalde parece muy preocupado.\n Escucha lo que te dice sobre\nel cumplea[UNI00f1]os de Claire y trata de descifrar la combinaci[UNI00f3]n."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 12, 1)
end

--- Helper function.
local function helper_29d60(arg0: s32, arg1: s32)
	local var2: any = 0
	local var3: s32 = 0
	local var7: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 6 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				var2 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 9 then
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_0c95681b(30)
			end
			if at <= 11 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_0c95681b(15)
			end
			return
		end
		if at <= 14 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_2ddedb3b(0)
		end
		if at <= 16 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_0c95681b(15)
		end
		if at <= 18 then
			helper_0c95681b(15)
		end
		if at <= 19 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 20 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 21 then
			helper_11e50()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	while true do
		event.MesMake_2(0, "Hace mucho le di un broche\ncon su signo del zodiaco.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Holly se encarg[UNI00f3] de todo,\nas[UNI00ed] que no me acuerdo exactamente,\npero estoy seguro de que era un animal de 4 patas..."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"[UNI00bf]Que qu[UNI00e9] clase de\nregalos de cumplea[UNI00f1]os le he hecho?<page>Umm... Muchos abrigos\ny pa[UNI00f1]uelos, supongo.<page>Nunca s[UNI00e9] qu[UNI00e9] comprarle.\nTodos los a[UNI00f1]os es la misma historia."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"[UNI00a1]Y tanto! El cumplea[UNI00f1]os de Claire siempre es un sufrimiento.\nCae siempre en el d[UNI00ed]a que recogen la basura\nque se puede quemar y la que no.<page>A m[UNI00ed] me toca sacar\nla basura de casa."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"La basura que no se puede quemar\nse recoge los d[UNI00ed]as divisibles por 7<page>y la que s[UNI00ed] se puede quemar\nlos divisibles por tres."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.MesMake_2(0, "[UNI00bf]A que t[UNI00fa] tampoco te olvidar[UNI00ed]as\nde eso, eh?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(
			0,
			"[UNI00a1]Ya est[UNI00e1]! [UNI00a1]Misterio resuelto!\nLa combinaci[UNI00f3]n es... <page>No s[UNI00e9]... Vamos a escuchar un poco m[UNI00e1]s."
		)
		var2 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(8)
		end
		if var2 == 0 then
			break
		else
			if var2 == -1 then
				event.Finish()
				return
			end
			event.SetMotion(arg0, "会話")
		end
	end
	event.SetMenuEtc(0, "Introduce el c[UNI00f3]digo secreto.", "1221", 0)
	event.GotoMenu(5)
	if vm.wait() then
		return skip(9)
	end
	event.SetFadeIn(15)
	do
		local out1, _, _, _ = event.GetMenuParam_4()
		var3 = out1 or var3
	end
	if var3 == -1 then
		event.Finish()
		return
	end
	event.SetFadeOut(15)
	helper_0c95681b(15)
	if vm.skipping() then
		return skip(10)
	end
	var7 = event.GetSndId(2) or var7
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = event.GetCharaRot(arg0)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	event.SetCharaPos(arg0, -100.0, 0.0, -110.0)
	event.SetCharaRot(arg0, 0.0, 3.1415927, 0.0)
	event.SetMotion(arg0, "立ち")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.GetCharaRot(0)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	var20 = event.Atan2f(-100.0 - var14, -110.0 - var16) or var20
	event.SetCharaRot(0, 0.0, var20, 0.0)
	event.SetMotion(0, "立ち")
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetCameraRef()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.SetCameraPos(64.64, 46.9, 92.64)
	event.SetCameraRef(-100.0, 20.0, -110.0)
	event.SetFadeIn(15)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(11)
	end
	if var3 == 0 then
		event.SetMotion(arg0, "会話")
		event.MesMake_2(0, "Vaya, no se abre. Cachis la mar... <page>Dentro tengo documentos\nmuy importantes...")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		event.SetMotion(arg0, "立ち")
		event.SetFadeOut(15)
		helper_0c95681b(15)
		if vm.skipping() then
			return skip(13)
		end
		event.SetCharaRot(0, var17, var18, var19)
		event.SetCharaPos(arg0, var8, var9, var10)
		event.SetCharaRot(arg0, var11, var12, var13)
		event.SetCameraPos(pos_x, pos_y, pos_z)
		event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
		event.SetFadeIn(15)
		event.Finish()
		return
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(0, "Esto... Um...\n1,<page>2,<page>2,<page>1...")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMotion(arg0, "立ち")
	event.SndSePlay(var7, 66)
	event.MesMake_2(0, "[UNI00a1]Yujuuuu!<page>Bien,\n[UNI00a1]ha funcionado!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSyncChara(0, arg0)
	event.ObjsInit(0, arg0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsReference(0, var14, var15, var16, 30)
	helper_2ddedb3b(0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"[UNI00a1]Genial! Ahora podr[UNI00e9]\nsacar los documentos que necesito.<page>[UNI00a1]Muchas gracias!"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	event.SetFadeOut(15)
	helper_0c95681b(15)
	if vm.skipping() then
		return skip(18)
	end
	event.SetCharaRot(0, var17, var18, var19)
	event.SetCharaPos(arg0, var8, var9, var10)
	event.SetCharaRot(arg0, var11, var12, var13)
	event.SetCameraPos(pos_x, pos_y, pos_z)
	event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
	event.SetFadeIn(15)
	helper_0c95681b(15)
	if vm.skipping() then
		return skip(19)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"[UNI00bf]Qu[UNI00e9] documentos?<page>Unos que ayudar[UNI00e1]n al Teniente Alcalde Morton\na sustituirme mientras estoy fuera.<page>Me preocupa un poco,\npero no creo que pase nada."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.MesMake_2(0, "Ahora ya estoy listo para marcharme.<page>Cedric me lo ha contado todo.<page>Venga, vamos.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(21)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(22)
	end
	event.Finish()
	event.SetQuestEtc(1, 12, 1)
end

--- Helper function.
local function helper_2bdd0(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"No te olvides de reciclar y\nsaca la basura los d[UNI00ed]as apropiados. [UNI00bf]Te acordar[UNI00e1]s?"
		)
	else
		event.MesMake_2(
			0,
			"F[UNI00ed]jate bien en lo que te digo:\ns[UNI00e9] que la Mina de Zelmite es un lugar\npeligroso. No hagas tonter[UNI00ed]as."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2c078(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_28ec0(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_28ec0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_29320(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_29d60(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2bdd0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2cd34(arg0: s32, arg1: any, arg2: s32)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var3 = event.GetChapter() or var3
	if arg2 ~= 0 and var3 == 8 then
		event.MesMake_2(0, "Rezo por que haya paz\nen el mundo a partir de hoy y para siempre.")
	else
		event.MesMake_2(0, "Si luchas por una buena causa\nes que eres un sabio.")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2cf90(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]S[UNI00ed]? [UNI00bf]Necesitas mi ayuda?\nEntonces d[UNI00e9]jame que te plantee un problema."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Las velas de la iglesia\nest[UNI00e1]n controladas por un peque[UNI00f1]o mecanismo.<page>Cuando est[UNI00e1]n encendidas\nlas apaga y,\ncuando se apagan, las enciende.<page>Si una cambia,\nlas adyacentes a ella tambi[UNI00e9]n lo hacen."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Si apagas todas las velas,\nme demostrar[UNI00e1]s tu sabidur[UNI00ed]a y te acompa[UNI00f1]ar[UNI00e9].<page>Si resuelves el problema, estupendo.\nSi no, tendr[UNI00e1]s que entender que no puedo ayudarte."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Este es otro puzzle. Int[UNI00e9]ntalo\nun par de veces y f[UNI00ed]jate bien\nen lo que pasa."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]Si vuelves a entrar en la iglesia,\n las velas volver[UNI00e1]n a su estado original.\n O sea que no hay de qu[UNI00e9] preocuparse.\n La soluci[UNI00f3]n podr[UNI00ed]a ser muy simple."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 13, 1)
end

--- Helper function.
local function helper_2c35c()
	local var0: { s32 } = table.create(14, 0)
	local var14: s32 = 0
	local var15: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var14 = 0
		var15 = 0
		var14 = var14 + 1
		var15 = var15 + 1
		return var14
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m7")
	event.EohSyncObj(1, "p08_i01h07", "i01h07_13-m21")
	event.EohSyncObj(2, "p08_i01h07", "i01h07_13-m8")
	event.EohSyncObj(3, "p08_i01h07", "i01h07_13-m20")
	event.EohSyncObj(4, "p08_i01h07", "i01h07_13-m9")
	event.EohSyncObj(5, "p08_i01h07", "i01h07_13-m19")
	event.EohSyncObj(6, "p08_i01h07", "i01h07_13-m10")
	event.EohSyncObj(7, "p08_i01h07", "i01h07_13-m18")
	event.EohSyncObj(8, "p08_i01h07", "i01h07_13-m11")
	event.EohSyncObj(9, "p08_i01h07", "i01h07_13-m17")
	event.EohSyncObj(10, "p08_i01h07", "i01h07_13-m12")
	event.EohSyncObj(11, "p08_i01h07", "i01h07_13-m16")
	event.EohSyncObj(12, "p08_i01h07", "i01h07_13-m14")
	event.EohSyncObj(13, "p08_i01h07", "i01h07_13-m15")
	var0[1] = event.EohGetShow(0) or var0[1]
	var0[2] = event.EohGetShow(1) or var0[2]
	var0[3] = event.EohGetShow(2) or var0[3]
	var0[4] = event.EohGetShow(3) or var0[4]
	var0[5] = event.EohGetShow(4) or var0[5]
	var0[6] = event.EohGetShow(5) or var0[6]
	var0[7] = event.EohGetShow(6) or var0[7]
	var0[8] = event.EohGetShow(7) or var0[8]
	var0[9] = event.EohGetShow(8) or var0[9]
	var0[10] = event.EohGetShow(9) or var0[10]
	var0[11] = event.EohGetShow(10) or var0[11]
	var0[12] = event.EohGetShow(11) or var0[12]
	var0[13] = event.EohGetShow(12) or var0[13]
	var0[14] = event.EohGetShow(13) or var0[14]
	var14 = 0
	var15 = 0
	while var15 < 14 do
		if var0[var15 + 1] ~= 0 then
			var14 = vm.i32(var14 + 1)
		end
		var15 = var15 + 1
	end
	return var14
end

--- Helper function.
local function helper_2d77c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_2c35c()
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_11e50()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = helper_2c35c()
	if 0 < var2 then
		event.MesMake_2(0, "Al parecer, todav[UNI00ed]a\nte queda mucho por aprender.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Tengo depositada una gran confianza en ti,\npero me temo que por el momento\nno podr[UNI00e9] ayudarte."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Muy bien hecho.\nEspl[UNI00e9]ndido.<page>Estoy convencido de que cumplir[UNI00e1]s con creces mis expectativas.<page>[UNI00bf]Lo he prometido, no?\nTe acompa[UNI00f1]ar[UNI00e9]."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 13, 1)
end

--- Helper function.
local function helper_2dcbc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2cd34(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2dd54(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2cd34(arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2cd34(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_2cf90(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2d77c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2dcbc(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2e044(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"[UNI00bf]Por qu[UNI00e9] echo tanto de menos la luna?<page>A lo mejor yo he venido\nde all[UNI00ed]..."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2e1c4(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Bah, no me importa acompa[UNI00f1]arte,\npero... [UNI00bf]Hay luna en el lugar al que vamos?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "[UNI00bf]De verdad? A lo mejor te lo inventas.\nS[UNI00e9] que los humanos mienten.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"En realidad he cambiado de opini[UNI00f3]n.\nEsperar[UNI00e9] aqu[UNI00ed] a que salga la luna."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Quiz[UNI00e1] se deba a alg[UNI00fa]n suceso pasado,\npero Rufio no se f[UNI00ed]a\n nada de los humanos."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]Tienes que conseguir que Rufio\nte crea. Si le dieras una\nfoto de la luna quiz[UNI00e1] lo lograr[UNI00ed]as."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 14, 1)
end

--- Helper function.
local function helper_2e870(arg0: s32, arg1: s32)
	local photo: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_11e50()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	photo = event.CheckInventPhoto(193) or photo
	if photo <= 0 then
		event.MesMake_2(
			0,
			"Pens[UNI00e9] que t[UNI00fa] eras diferente,\npero no, los humanos son humanos.<page>Da igual, estoy acostumbrado\na o[UNI00ed]r mentiras vuestras."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"[UNI00a1]Guau! Es alucinante. Hay una luna en la foto.<page>Ahora podr[UNI00e9] verla cuando sea y donde sea."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "[UNI00bf]Ir contigo?<page>Pues claro que s[UNI00ed].\nNo tengo otro sitio adonde ir.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 14, 1)
end

--- Helper function.
local function helper_2edb0(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Me has dado esta foto de la luna.\nEres un humano bueno.")
	else
		event.MesMake_2(
			0,
			"Si el Ferrocarril Blackstone recorre\ntodo el mundo, podremos visitar\nun mont[UNI00f3]n de sitios nuevos."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2f018(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2e044(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2e044(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_2e1c4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2e870(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2edb0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2f2fc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Mi afici[UNI00f3]n es la pesca.<page>Mi sue[UNI00f1]o es capturar un Mardan Garayan.<page>S[UNI00f3]lo respeto a la gente que pesca peces grandes."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2f4ac(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "[UNI00bf]Quieres que te haga un favor?<page>Pues esc[UNI00fa]chame primero.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"S[UNI00f3]lo presto atenci[UNI00f3]n a la gente que respeto.<page>Y s[UNI00f3]lo respeto a la gente\nque ha pescado peces m[UNI00e1]s grandes que yo."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"El mayor pez que he cogido\nfue un Nonky de 60 cm.<page>[UNI00bf]Qu[UNI00e9], impresionado?\nSi te apetece competir conmigo,\nestar[UNI00e9] encantado."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Al parecer, la [UNI00fa]nica forma de\nconseguir que se una a ti es capturando un Nonky\n de m[UNI00e1]s de 60 cm. [UNI00a1]T[UNI00fa] puedes!"
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "[(!)]Prueba de todas formas en\nel lago de Palm Brinks.")
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 15, 1)
end

--- Helper function.
local function helper_2fba8(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_11e50()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.ExtTyped(564, "iiF", 2, 322) or var2
	if var2 <= 0 then
		event.MesMake_2(
			0,
			"Apostar[UNI00ed]a a que nunca has\npescado un Nonky, [UNI00bf]eh?<page>Ja, ja. [UNI00a1]Tienes que ser p[UNI00e9]simo pescando!"
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
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
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"[UNI00a1]No me llegas ni a la altura del bet[UNI00fa]n!<page>Te recomiendo que empieces de nuevo."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "... Vaya, te he subestimado.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"En fin, soy un hombre de palabra.\nNo tienes que record[UNI00e1]rmelo.<page>Escuchar[UNI00e9] lo que tengas que decirme."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "[UNI00a1]Habla cuanto quieras!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 15, 1)
end

--- Helper function.
local function helper_30470(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Umm. No me hace falta saberlo ahora mismo,\npero quiz[UNI00e1] alg[UNI00fa]n d[UNI00ed]a\npuedas ense[UNI00f1]arme alguno de tus trucos."
		)
	else
		event.MesMake_2(
			0,
			"Tengo unas ganas de\nver todos los lugares para pescar\ndel mundo... S[UNI00ed] que va a ser divertido."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_30718(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2f2fc(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2f2fc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_2f4ac(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2fba8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_30470(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_309fc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Los Firbit s[UNI00f3]lo\nconceder[UNI00e1]n favores a\nlos que sean mejores que ellos.")
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_30b6c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Los Firbit s[UNI00f3]lo\nconceder[UNI00e1]n favores a\nlos que sean mejores que ellos.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Cuando se trata de pescar,\nvoy muy seguro.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Me han dicho que los humanos\ncelebran un concurso en el que\nse enfrentan peces entre s[UNI00ed].<page>Si tienes un pez, [UNI00bf]por qu[UNI00e9]\nno intentas ganar?<page>Si lo consigues,\nme demostrar[UNI00e1]s que eres merecedor de mi ayuda."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Parece que se refiere a la Carrera\n de Peces. [UNI00bf]Por qu[UNI00e9] no pruebas en la categor[UNI00ed]a de Principiantes\n? A lo mejor as[UNI00ed] te ayuda."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 16, 1)
end

--- Helper function.
local function helper_311a8(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_11e50()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(41) or flag
	if flag == 0 then
		event.MesMake_2(0, "Se dice que los peces se parecen a sus amos.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "No le voy a dirigir la palabra al\ndue[UNI00f1]o de una birria de pez.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"La he visto.\nHa sido una carrera muy emocionante.<page>No creo que yo hubiera\npodido criar un pez tan bueno.<page>Ll[UNI00e9]vame contigo, por favor.\nEns[UNI00e9][UNI00f1]ame c[UNI00f3]mo lo haces."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 16, 1)
end

--- Helper function.
local function helper_316cc(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Un d[UNI00ed]a espero poder\nsubirme al podio yo tambi[UNI00e9]n.")
	else
		event.MesMake_2(0, "Me gustar[UNI00ed]a que Fabio se interesase\npor algo m[UNI00e1]s aparte\nde la pesca.")
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_31924(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_309fc(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_309fc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_30b6c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_311a8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_316cc(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_31c68(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d70bce8(arg0, 0, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "[UNI00da]ltimamente no me encuentro muy bien.")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"El Dr. Dell me ha examinado,\npero seg[UNI00fa]n [UNI00e9]l no me pasa nada.<page>[UNI00bf]C[UNI00f3]mo es posible?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_31f48(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_85ab2618(0, -1, arg1, arg0, 0)
			end
			return
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg1, arg0, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg1, arg0, 0)
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg1, arg0, 0)
		end
		if at <= 8 then
			helper_85ab2618(0, -1, arg1, arg0, 0)
		end
		if at <= 9 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"[UNI00da]ltimamente no me encuentro muy bien.<page>El Dr. Dell me ha examinado,\npero seg[UNI00fa]n [UNI00e9]l no me pasa nada."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Con s[UNI00f3]lo ponerme de pie\nme da la impresi[UNI00f3]n de que me voy a caer.<page>No  es f[UNI00e1]cil de explicar. Es como si\nel mundo estuviera alterado."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
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
		helper_85ab2618(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return
	end
	event.MesMake_2(0, "Recuerdo los s[UNI00ed]ntomas.")
	helper_85ab2618(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Cuando nac[UNI00ed],\nel mundo estaba en un estado lamentable:\nhab[UNI00ed]a m[UNI00e1]s distorsiones temporales de las\nque te puedas imaginar."
	)
	helper_85ab2618(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Adem[UNI00e1]s afectaban a personas\nfr[UNI00e1]giles f[UNI00ed]sicamente.<page>Los delgados se mareaban o se desmayaban\ny los m[UNI00e1]s rellenos no se pod[UNI00ed]an ni levantar."
	)
	helper_85ab2618(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"A lo mejor t[UNI00fa] eres especialmente\nsusceptible a estas cosas.<page>Incluso las pocas distorsiones temporales\nque hay aqu[UNI00ed] bastan para afectarte."
	)
	helper_85ab2618(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"Si pudi[UNI00e9]ramos librarnos de las distorsiones\nm[UNI00e1]s pr[UNI00f3]ximas, seguro que te sentir[UNI00ed]as mejor."
	)
	helper_85ab2618(0, -1, arg1, arg0, 0)
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
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	var3 = event.GetMenuEtc_2(0) or var3
	event.SetCnt(19, var3)
	event.SetQuestEtc(0, 17, 1)
end

--- Helper function.
local function helper_32c04(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				print("start=", var3, ",now=", var2, ",clear=", var2 - var3, "\n")
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_11e50()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetMenuEtc_2(0) or var2
	var3 = event.GetCnt(19) or var3
	print("start=", var3, ",now=", var2, ",clear=", vm.i32(var2 - var3), "\n")
	if vm.i32(var2 - var3) < 10 then
		event.MesMake_2(0, "Todav[UNI00ed]a no me siento demasiado bien.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"A lo mejor es\nque me pasa algo de verdad.<page>Quiz[UNI00e1] ni siquiera\nel Dr. Dell pueda ayudarme..."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "[UNI00a1]Hola!<page>[UNI00bf]Que c[UNI00f3]mo me siento? [UNI00a1]Como nunca!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"No me creo lo bien que me encuentro estos d[UNI00ed]as.<page>El mundo vuelve a estar como antes."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Ah, s[UNI00ed], me hab[UNI00ed]as pedido un favor.<page>Te ayudar[UNI00e9] en lo que pueda.<page>T[UNI00fa] me has ayudado,\nas[UNI00ed] que te debo una."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 17, 1)
end

--- Helper function.
local function helper_333c4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"T[UNI00fa] me has ayudado, as[UNI00ed] que te debo una,\npero no me lleves a ning[UNI00fa]n sitio donde haya insectos."
		)
	else
		event.MesMake_2(
			0,
			"Si el Ferrocarril Blackstone se extiende\npor todo el mundo, quiz[UNI00e1]\nyo deba recorrer todo el mundo tambi[UNI00e9]n."
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_3366c(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_31c68(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_31c68(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_31f48(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_32c04(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_333c4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_33938(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d70bce8(arg0, 0, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "[UNI00a1]Max! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	else
		event.MesMake_2(0, "[UNI00a1]M[UNI00f3]nica! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	end
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "[UNI00a1]Qu[UNI00e9] bien! [UNI00bf]Por qu[UNI00e9] no\nme llevas contigo?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_33d00(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				var3 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 6 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 9 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_0c95681b(30)
		end
		if at <= 13 then
			helper_0c95681b(30)
		end
		if at <= 14 then
			helper_0c95681b(60)
		end
		if at <= 15 then
			helper_8834eba9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "[UNI00a1]Max! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	else
		event.MesMake_2(0, "[UNI00a1]M[UNI00f3]nica! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	end
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "[UNI00a1]Qu[UNI00e9] bien! [UNI00bf]Por qu[UNI00e9] no\nme llevas contigo?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Seguro que piensas que\nno valdr[UNI00e9] para nada porque soy una chica.<page>Pues la verdad es que\ntraigo suerte a la gente."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Nunca llueve cuando salgo\ny nunca he visto ning[UNI00fa]n\nbillete de loter[UNI00ed]a perdedor.<page>[UNI00bf]Qu[UNI00e9] me dices?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Est[UNI00e1] bien.\nNo, lo siento.")
	var3 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "会話")
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var3 ~= 0 then
		event.MesMake_2(0, "[UNI00a1][UNI00bf]Por qu[UNI00e9]?! No seas as[UNI00ed].\nEres muy mala.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "[UNI00a1]Eres una in[UNI00fa]til!<page>[UNI00a1]Est[UNI00fa]pida!<page>[UNI00a1]Idiota!")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "[UNI00bf]Me vas a llevar contigo?<page>[UNI00a1]Cre[UNI00ed]a que no lo har[UNI00ed]as!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Por qu[UNI00e9] soy yo la [UNI00fa]nica\nque tiene que ped[UNI00ed]rtelo, cuando t[UNI00fa] has ido\npor ah[UNI00ed] preguntando a los dem[UNI00e1]s?<page>Si me lo hubieras pedido, te\nhabr[UNI00ed]a ayudado."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "Ya lo s[UNI00e9]: si me encuentras,\nte ayudar[UNI00e9]. [UNI00bf]Qu[UNI00e9] te parece?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "En otras palabras: [UNI00a1]vamos a jugar al escondite!<page>[UNI00a1]Venga, vamos!")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMotion(arg0, "立ち")
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(13)
	end
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(14)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.SetFadeIn(30)
	helper_0c95681b(60)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Vaya... Ser[UNI00e1] mejor que te pongas\na buscar a Corinne. Seguramente estar[UNI00e1] escondida\nen alg[UNI00fa]n lugar de Palm Brinks."
	)
	helper_8834eba9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 18, 1)
	event.SetCnt(11, 0)
end

--- Helper function.
local function helper_34f40(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_0c95681b(30)
			end
			return
		end
		if at <= 4 then
			helper_11e50()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(11) or var2
	if var2 < 1 then
		event.MesMake_2(
			0,
			"[UNI00a1]Eh! [UNI00a1]Me has encontrado!<page>[UNI00bf]Podr[UNI00e1]s tambi[UNI00e9]n la pr[UNI00f3]xima vez?"
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(11, var2 + 1)
		event.SetFadeOut(30)
		helper_0c95681b(30)
		if vm.skipping() then
			return skip(3)
		end
		event.SetAi(1, arg0)
		event.CharaActive(0, arg0)
		event.DeleteVillager(arg0)
		event.SetFadeIn(30)
		return
	end
	event.MesMake_2(
		0,
		"[UNI00a1]Vaya! [UNI00a1]Me has encontrado!<page>Me estoy hartando.<page>Esconderse es\nmuy aburrido.<page>[UNI00a1]Bueno! V[UNI00e1]monos\nde aventura."
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 18, 1)
end

--- Helper function.
local function helper_354d8(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "El escondite es\npara ni[UNI00f1]os.")
	else
		event.MesMake_2(
			0,
			"A m[UNI00ed] no me enga[UNI00f1]as. T[UNI00fa] has\nestado por ah[UNI00ed] pas[UNI00e1]ndotelo\nbomba. [UNI00a1]Tienes que contarme tus andanzas alg[UNI00fa]n d[UNI00ed]a!"
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_35760(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_33938(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_33938(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_33d00(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_34f40(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_354d8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_35a44(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"...<page>[UNI00a1]Ah! [UNI00a1]Hola!\n[UNI00da]ltimamente no oigo muy bien.<page>No te entiendo si no\nme hablas m[UNI00e1]s despacio."
	)
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_35be4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_85ab2618(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_11e50()
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "[UNI00bf]C[UNI00f3]mo?<page>[UNI00bf]No puedes hablar m[UNI00e1]s despacio?")
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetQuestEtc(0, 19, 1)
	event.SetMenuEtc(0, 'Escribe: "Vamos juntos."', "Vamos juntos.", 0)
	event.GotoMenu(5)
	if vm.wait() then
		return skip(3)
	end
	event.SetFadeIn(15)
	do
		local out1, _, _, _ = event.GetMenuParam_4()
		var2 = out1 or var2
	end
	if var2 == -1 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 0 then
		event.MesMake_2(0, "[UNI00bf]De qu[UNI00e9] me est[UNI00e1]s hablando?\nNo tengo ni idea...")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Una aventura?\nEso estar[UNI00ed]a bien.<page>Pero, [UNI00bf]de qu[UNI00e9] te servir[UNI00ed]a una\nvieja como yo?"
	)
	helper_85ab2618(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e50()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 19, 1)
end

--- Helper function.
local function helper_362e8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_35be4(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_36374(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Pero, [UNI00bf]de qu[UNI00e9] te iba a servir una\nabuelita como yo?")
	else
		event.MesMake_2(
			0,
			'Cuando est[UNI00e9] terminado el Ferrocarril Blackstone\nme gustar[UNI00ed]a\nir al "Fin del mundo".'
		)
	end
	helper_eb131214(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_365dc(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_35a44(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_35a44(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_35be4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_362e8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_36374(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_23b48(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_85ab2618(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_0d70bce8(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 == 0 then
		event.MesMake_2(0, "Ah, [UNI00bf]est[UNI00e1]s ayudando\na Polly?<page>Muy bien.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"[UNI00bf]Para qu[UNI00e9] se\nnecesitan 20 barras?<page>Pues para hacer\nuna fondue de queso hoy mismo."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			'Hablando en t[UNI00e9]rminos de tus famosas "invenciones",\nes una combinaci[UNI00f3]n culinaria de queso,<page>pan y vino.'
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"Est[UNI00e1] de muerte. Todo el mundo repite,\npor eso me hace falta tanto pan.<page>Pero no quer[UNI00ed]a que me\nlo trajeran aqu[UNI00ed], en realidad."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"[UNI00bf]No podr[UNI00ed]as llev[UNI00e1]rmelo\na casa, no Max?<page>Ya sabes donde est[UNI00e1], [UNI00bf]no?\nCerca del campo de calabazas."
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetCnt(12, 1)
	end
	if var2 == 1 then
		event.MesMake_2(0, "Ya sabes donde est[UNI00e1], [UNI00bf]no?\nCerca del campo de calabazas.")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 2 then
		event.MesMake_2(0, "[UNI00bf]Cancelado?\n[UNI00a1]Qu[UNI00e9] pena!")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.MesMake_2(
			0,
			"En tal caso, no necesito el pan.\n[UNI00bf]Puedes devolv[UNI00e9]rselo a Polly por m[UNI00ed]?"
		)
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.SetCnt(12, 3)
	end
	if var2 == 3 then
		event.MesMake_2(0, "Lo siento. [UNI00bf]Podr[UNI00ed]as devolverle el pan\na Polly por m[UNI00ed]?")
		helper_85ab2618(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(10)
		end
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_368c0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local now_sub_map_no: s32 = 0
	local flag: s32 = 0
	local var7: any = 0
	local var8: any = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local var11: any = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local var14: any = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local var17: any = 0
	local var18: s32 = 0
	local active_chr_no: s32 = 0
	local var20: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_18ec8(arg0, arg1)
			end
			if at <= 2 then
				var7 = helper_975658d3(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_0c95681b(30)
			end
			return
		end
		if at <= 8 then
			if at <= 7 then
				var8 = helper_975658d3(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 11 then
			if at <= 9 then
				helper_0c95681b(30)
			end
			return
		end
		if at <= 17 then
			if at <= 12 then
				helper_1c478(arg0, arg1)
			end
			if at <= 13 then
				helper_1dfd0(arg0, arg1)
			end
			if at <= 14 then
				helper_20b18(arg0, arg1)
			end
			if at <= 15 then
				helper_23300(arg0, arg1)
			end
			if at <= 16 then
				var11 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 18 then
			return
		end
		if at <= 22 then
			if at <= 19 then
				helper_25a18(arg0, arg1)
			end
			if at <= 20 then
				helper_16950(arg0, arg1)
			end
			if at <= 21 then
				var14 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 23 then
			return
		end
		if at <= 28 then
			if at <= 24 then
				helper_27444(arg0, arg1)
			end
			if at <= 25 then
				helper_28b34(arg0, arg1)
			end
			if at <= 26 then
				helper_2c078(arg0, arg1)
			end
			if at <= 27 then
				var17 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 29 then
			return
		end
		if at <= 38 then
			if at <= 30 then
				helper_2dd54(arg0, arg1)
			end
			if at <= 31 then
				helper_2f018(arg0, arg1)
			end
			if at <= 32 then
				helper_30718(arg0, arg1)
			end
			if at <= 33 then
				helper_31924(arg0, arg1)
			end
			if at <= 34 then
				helper_3366c(arg0, arg1)
			end
			if at <= 35 then
				helper_35760(arg0, arg1)
			end
			if at <= 36 then
				helper_365dc(arg0, arg1)
			end
			if at <= 37 then
				var20 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 39 then
			return
		end
		if at <= 40 then
			helper_eb131214(arg0, -1, 0, 0)
		end
		if at <= 41 then
			helper_eb131214(arg0, -1, 0, 0)
		end
		if at <= 42 then
			helper_eb131214(arg0, -1, 0, 0)
		end
		if at <= 43 then
			helper_eb131214(arg0, -1, 0, 0)
		end
		if at <= 44 then
			helper_eb131214(arg0, -1, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMesShippo(0, 1)
	var2 = event.GetChapter() or var2
	var3 = event.GetEventData_2(14) or var3
	event.GetNowMapNo()
	now_sub_map_no = event.GetNowSubmapNo() or now_sub_map_no
	event.CtrlcStay()
	event.SetAi(0, arg0)
	if var3 == 3 then
		helper_1438c(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var3 == 5 then
		helper_18ec8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "D[UNI00e9]jame comprar\nCavar buscando logros")
			var7 = helper_975658d3(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(3)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_11364(0)
				if vm.skipping() then
					return skip(4)
				end
				if t0 ~= 0 then
					event.SetFadeOut(25)
					helper_0c95681b(30)
					if vm.skipping() then
						return skip(5)
					end
					event.GotoMenu(6, 33)
					if vm.wait() then
						return skip(6)
					end
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_e528()
				if vm.skipping() then
					return skip(7)
				end
			end
		else
			event.MesMake_2(0, "Hazte amigo m[UNI00ed]o\nCavar buscando logros")
			var8 = helper_975658d3(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_11364(0)
				if vm.skipping() then
					return skip(9)
				end
				if t1 ~= 0 then
					event.SetFadeOut(25)
					helper_0c95681b(30)
					if vm.skipping() then
						return skip(10)
					end
					event.GotoMenu(6, 33)
					if vm.wait() then
						return skip(11)
					end
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_1aa90(arg0, arg1)
				if vm.skipping() then
					return skip(12)
				end
			end
		end
	end
	if var3 == 7 then
		helper_1c478(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
	end
	if var3 == 8 then
		helper_1dfd0(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 10 then
		helper_20b18(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 11 then
		helper_23300(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var11 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(17)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_25a18(arg0, arg1)
				if vm.skipping() then
					return skip(18)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_e528()
			if vm.skipping() then
				return skip(19)
			end
		else
			helper_25a18(arg0, arg1)
			if vm.skipping() then
				return skip(20)
			end
		end
	end
	if var3 == 14 then
		helper_16950(arg0, arg1)
		if vm.skipping() then
			return skip(21)
		end
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var14 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(22)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_27444(arg0, arg1)
				if vm.skipping() then
					return skip(23)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_e528()
			if vm.skipping() then
				return skip(24)
			end
		else
			helper_27444(arg0, arg1)
			if vm.skipping() then
				return skip(25)
			end
		end
	end
	if var3 == 16 then
		helper_28b34(arg0, arg1)
		if vm.skipping() then
			return skip(26)
		end
	end
	if var3 == 17 then
		helper_2c078(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var17 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(28)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_2dd54(arg0, arg1)
				if vm.skipping() then
					return skip(29)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_e528()
			if vm.skipping() then
				return skip(30)
			end
		else
			helper_2dd54(arg0, arg1)
			if vm.skipping() then
				return skip(31)
			end
		end
	end
	if var3 == 19 then
		helper_2f018(arg0, arg1)
		if vm.skipping() then
			return skip(32)
		end
	end
	if var3 == 20 then
		helper_30718(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 21 then
		helper_31924(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 23 then
		helper_3366c(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 24 then
		helper_35760(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 25 then
		helper_365dc(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "D[UNI00e9]jame comprar\nHola")
			var20 = helper_d22b9744(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(38)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_23b48(arg0, arg1)
				if vm.skipping() then
					return skip(39)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_e528()
		if vm.skipping() then
			return skip(40)
		end
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"[UNI00da]ltimamente lo he pasado\nmal viendo todas las peque[UNI00f1]as piezas.<page>Supongo que\nme estoy haciendo viejo..."
			)
		else
			event.MesMake_2(
				0,
				"Ver en funcionamiento el\nFerrocarril Blackstone por todo el continente es un\nsue[UNI00f1]o com[UNI00fa]n de Need y m[UNI00ed]o.<page>Podemos contar con tu ayuda, [UNI00bf]no?"
			)
		end
		helper_eb131214(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(41)
		end
	end
	if var3 == 2 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Si no estoy ocupado\nen algo,\nme pongo de mal humor.")
		else
			event.MesMake_2(
				0,
				"Si descubren Zelmite me\nllegar[UNI00e1] el agua al cuello. S[UNI00ed].\n[UNI00a1][UNI00a1]Tendr[UNI00e9] que excavar y excavar sin parar!!"
			)
		end
		helper_eb131214(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(42)
		end
	end
	if var3 == 6 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"No s[UNI00e9] por qu[UNI00e9], tengo tantos\nbichos en las plumas [UNI00fa]ltimamente\nque me pica todo."
			)
		else
			event.MesMake_2(
				0,
				"Est[UNI00e1] bien que pases el tiempo\nintentando encontrar Zelmite, pero\ntampoco exageres."
			)
		end
		helper_eb131214(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(43)
		end
	end
	if var3 == 13 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"[UNI00a1]Me encanta el olor de la p[UNI00f3]lvora!\nEste trabajo est[UNI00e1] hecho para m[UNI00ed].<page>Aunque mi jefe\nes un cabez[UNI00f3]n anticuado.\nEn fin..."
			)
		else
			event.MesMake_2(0, "Te encanta toda esta\naventura, [UNI00bf]verdad?")
		end
		helper_eb131214(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(44)
		end
	end
	if var3 == 22 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Aparte del hecho de que\nmi vida empez[UNI00f3] como cuadro, no soy diferente\na cualquier otra persona."
			)
		else
			event.MesMake_2(0, "La Mina de Zelmite me da mala espina.\nTen cuidado, [UNI00bf]vale?")
		end
		helper_eb131214(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(45)
		end
	end
	event.SetAi(1, arg0)
end

--- Helper function.
local function helper_f460()
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local active_chr_no: s32 = 0
	local var7: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local active_chr_no_2: s32 = 0
	local active_chr_no_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
				var5 = 2
				var5 = 1
				helper_e528()
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
		if at <= 7 then
			return
		end
		if at <= 8 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.GetControlChrid()
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	do
		local out1, out2 = event.GetMesEtc(0, 3, var2)
		var3 = out1 or var3
		var4 = out2 or var4
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		var5 = 2
	else
		var5 = 1
	end
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	if var2 == 1012 or var2 == 1015 or var2 == 1018 then
		helper_e528()
		if vm.skipping() then
			return skip(2)
		end
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "[UNI00a1]Eh! Prohibido\nel paso.")
		helper_eb131214(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetAi(1, var1)
		return
	end
	var7 = event.GetChapter() or var7
	if var7 == 1 then
		flag = event.GetFlag(9) or flag
		if var2 == 2 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Mira. Cualquiera se cree\nque este trasto iba por ah[UNI00ed]\nzumbando, [UNI00bf]eh?<page>Pues as[UNI00ed] era... Hace mucho tiempo.<page>Mi sue[UNI00f1]o es volver a viajar\nen [UNI00e9]l. Por eso\nme preocupo de mantenerlo a punto.<page>As[UNI00ed], si alg[UNI00fa]n d[UNI00ed]a llega la ocasi[UNI00f3]n,\n lo pondr[UNI00e9] a funcionar\nen un periquete."
				)
			else
				event.MesMake_2(
					0,
					"[UNI00bf]No ves que si\nno haces ejercicio todos los d[UNI00ed]as te quedas\nanquilosado? Pues igual les pasa a las m[UNI00e1]quinas."
				)
			end
			helper_eb131214(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(4)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 63 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"[UNI00a1]Max, hola!\nHace ya mucho\nque no circula el tren,<page>pero yo sigo vigilando\nla estaci[UNI00f3]n todos los d[UNI00ed]as."
				)
			else
				event.MesMake_2(
					0,
					"El alcalde levant[UNI00f3] por fin el trasero\nde la silla y puso en marcha los trenes otra vez. Pero\ntodav[UNI00ed]a no est[UNI00e1]n listos.<page>Ni te imaginas las ganas que tengo\nde que se monten los de la ciudad..."
				)
			end
			helper_eb131214(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(5)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 65 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Hola, Max. [UNI00bf]Sab[UNI00ed]as que el jefe de la estaci[UNI00f3]n\nes mi padre? Vigilamos\njuntos la estaci[UNI00f3]n.<page>Hasta que el tren vuelva\na funcionar como antes..."
				)
			else
				event.MesMake_2(
					0,
					"[UNI00a1]El tren ya funciona!\nPero todav[UNI00ed]a queda tiempo para\nque la estaci[UNI00f3]n vuelva a la normalidad..."
				)
			end
			helper_eb131214(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetAi(1, var1)
			return
		end
	end
	if var7 == 8 then
		flag_2 = event.GetFlag(804) or flag_2
		if var2 == 61 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"He sido admirador secreto de\nM[UNI00f3]nica durante a[UNI00f1]os, pero\nno la hab[UNI00ed]a visto [UNI00fa]ltimamente.<page>Por eso no me\npuedo concentrar en el trabajo."
				)
			else
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.MesMake_2(
						0,
						"[UNI00a1]Oye, Max!\nParece ser que M[UNI00f3]nica ha vuelto.\n[UNI00a1]Se va alegrar todo el mundo!"
					)
				else
					event.MesMake_2(
						0,
						"[UNI00a1]M[UNI00f3]nica! [UNI00bf]C[UNI00f3]mo te ha ido?\nTe he echado de menos."
					)
				end
			end
			helper_eb131214(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 80 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"Estaba hablando\ncon ella  como siempre,\ny va y desaparece.<page>Max, dime:\n[UNI00bf]d[UNI00f3]nde est[UNI00e1]?"
				)
			else
				active_chr_no_3 = event.GetActiveChrNo() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.MesMake_2(0, "Ha vuelto M[UNI00f3]nica.\n[UNI00bf]C[UNI00f3]mo puede ser?")
				else
					event.MesMake_2(0, "M[UNI00f3]nica, has vuelto.\n[UNI00bf]C[UNI00f3]mo es posible?")
				end
			end
			helper_eb131214(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetAi(1, var1)
			return
		end
	end
	event.MesMake_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_eb131214(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_10ba8()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f460()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_f460()
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_39388()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_10ba8()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_368c0(var1, player_chara)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_10ba8()
		if vm.skipping() then
			return skip(2)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	event.ResetCamera(1, 0.0, 10.0)
end

--- Program 150.
script[150] = function()
	local now_map_no: s32 = 0
	local now_sub_map_no: s32 = 0
	now_map_no = event.GetNowMapNo() or now_map_no
	now_sub_map_no = event.GetNowSubmapNo() or now_sub_map_no
	print(
		"##########################map_no=",
		now_map_no,
		",submap_no=",
		now_sub_map_no,
		"###########################\n"
	)
end

--- Program 401.
script[401] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39f80(0, 5)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 402.
script[402] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39f80(0, 4)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 403.
script[403] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39f80(0, 3)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 404.
script[404] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39f80(0, 2)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 405.
script[405] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39f80(0, 1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 406.
script[406] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39f80(0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 407.
script[407] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39f80(1, 6)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 408.
script[408] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39f80(1, 5)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 409.
script[409] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39f80(1, 4)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 410.
script[410] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39f80(1, 3)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 411.
script[411] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39f80(1, 2)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 412.
script[412] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39f80(1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 413.
script[413] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39f80(1, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 414.
script[414] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39f80(0, 6)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39388()
	if vm.skipping() then
		return skip(1)
	end
end

return script
