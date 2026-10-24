--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_336b519d(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		event.MesMake_2(
			arg0,
			"Need und ich tr[UNI00e4]umen davon, dass\ndie Blackstone-Bahn den ganzen\nKontinent bef[UNI00e4]hrt.<page>Du hilft uns doch, oder?"
		)
	end
	if arg1 == 2 then
		event.MesMake_2(
			arg0,
			"Wenn sie Zelmit finden, bin ich\nauch besch[UNI00e4]ftigt. Dann w[UNI00fc]rde\nich buddeln, buddeln, buddeln!"
		)
	end
	if arg1 == 3 then
		event.MesMake_2(arg0, "Es muss so viele Pflanzen geben,\ndie wir noch nie gesehen haben.")
	end
	if arg1 == 4 then
		event.MesMake_2(arg0, "He! Wie l[UNI00e4]uft die Zelmit-Suche?\nWenn ich helfen kann,\nsag einfach Bescheid.")
	end
	if arg1 == 5 then
		event.MesMake_2(
			arg0,
			"Die Welt der Bilder ist gro[UNI00df].\nMalen zu lernen mag ein Leben\ndauern, doch es ist die Zeit wert."
		)
	end
	if arg1 == 6 then
		event.MesMake_2(
			arg0,
			"Wenn du Zelmit suchen willst,\nmach das ruhig. Aber\n[UNI00fc]beranstrenge dich nicht, Kleiner."
		)
	end
	if arg1 == 7 then
		event.MesMake_2(
			arg0,
			"Ich werde der beste Koch\nder Welt, und wenn's soweit ist,\nisst du immer gratis bei mir."
		)
	end
	if arg1 == 8 then
		event.MesMake_2(arg0, "Endlich f[UNI00e4]hrt die Blackstone-\nBahn auf der ganzen Welt.\nDas ist so aufregend!")
	end
	if arg1 == 9 then
		event.MesMake_2(arg0, "Hey, wie l[UNI00e4]uft's?\nBei mir l[UNI00e4]uft's super!")
	end
	if arg1 == 10 then
		event.MesMake_2(arg0, "Die Zelmit-Mine ist unheimlich.\nDort musst du immer\nwachsam bleiben.")
	end
	if arg1 == 11 then
		event.MesMake_2(arg0, "Ich bete f[UNI00fc]r deine Sicherheit ...")
	end
	if arg1 == 12 then
		event.MesMake_2(arg0, "Wenn du Lust auf Brot hast,\nwei[UNI00df]t du ja, wo ich bin.")
	end
	if arg1 == 13 then
		event.MesMake_2(arg0, "Diese Abenteuer machen dir\neinen Riesenspa[UNI00df], was?")
	end
	if arg1 == 14 then
		event.MesMake_2(arg0, "Falls ich dir irgendwie helfen\nkann, frag mich ruhig.")
	end
	if arg1 == 15 then
		event.MesMake_2(arg0, "Na, wie steht's? Bist du in der\nMine schon Fieslingen begegnet?")
	end
	if arg1 == 16 then
		event.MesMake_2(
			arg0,
			"Ab jetzt helfe ich Need und Cedric,\ndie Welt wieder aufzubauen.\nDabei m[UNI00fc]ssen wir zusammenarbeiten."
		)
	end
	if arg1 == 17 then
		event.MesMake_2(
			arg0,
			"Nur so zwischen dir und mir - die\nZelmit-Mine ist nicht ungef[UNI00e4]hrlich.\nMach keine Dummheiten."
		)
	end
	if arg1 == 18 then
		event.MesMake_2(arg0, "Ich bete, dass die Welt ab\nheute ewigen Frieden genie[UNI00df]t.")
	end
	if arg1 == 19 then
		event.MesMake_2(
			arg0,
			"Wenn die Blackstone-Bahn die\nganze Welt bef[UNI00e4]hrt, k[UNI00f6]nnen wir\nlauter coole neue Orte besuchen."
		)
	end
	if arg1 == 20 then
		event.MesMake_2(
			arg0,
			"Ich bin schon ganz gespannt auf\ndie neuen Angelpl[UNI00e4]tze in der\nganzen Welt. Das wird so toll!"
		)
	end
	if arg1 == 21 then
		event.MesMake_2(
			arg0,
			"Ich w[UNI00fc]nschte nur, Fabio w[UNI00fc]rde\nsich auch f[UNI00fc]r andere Dinge\nals Angeln interessieren."
		)
	end
	if arg1 == 22 then
		event.MesMake_2(arg0, "Ich hab ein dummes Gef[UNI00fc]hl bei der\nZelmit-Mine. Sei vorsichtig, ja?")
	end
	if arg1 == 23 then
		event.MesMake_2(
			arg0,
			"Wenn die Blackstone-Bahn die\nganze Welt bef[UNI00e4]hrt, muss\nich vielleicht auch mal hier raus."
		)
	end
	if arg1 == 24 then
		event.MesMake_2(
			arg0,
			"Mir machst du nichts vor. Ich\nwei[UNI00df], dass du alle m[UNI00f6]glichen tollen\nSachen gemacht hast. Erz[UNI00e4]hl mal!"
		)
	end
	if arg1 == 25 then
		event.MesMake_2(
			arg0,
			'Wenn die Blackstone-Bahn fertig\nist, w[UNI00fc]rde ich gern mal\nzu den "Enden der Erde" fahren.'
		)
	end
end

return helper_336b519d
