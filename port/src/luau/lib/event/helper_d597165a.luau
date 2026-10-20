--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_403f0e66 = require("@lib/event/helper_403f0e66")
local helper_ab5bcd36 = require("@lib/event/helper_ab5bcd36")
local helper_c049c42a = require("@lib/event/helper_c049c42a")

--- Helper function.
local function helper_d597165a(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_ab5bcd36(arg0, arg1)
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_ab5bcd36(arg1, arg0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Grummel, grummel ...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Was soll das hei[UNI00df]en, was\nmurmele ich da?<page>Ich versuche, mich an die\nSafe-Kombination zu erinnern."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Was soll das hei[UNI00df]en,\nwelcher Safe?<page>Der Safe hinter dem Bild\nin meinem B[UNI00fc]ro nat[UNI00fc]rlich ..."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_ab5bcd36(arg0, arg1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"Ah, du hast mich erschreckt!<page>Oh, Mist!<page>Jetzt hab ich mein gr[UNI00f6][UNI00df]tes\nGeheimnis ausgeplaudert!<page>Na ja, jetzt wei[UNI00df]t du's.<page>Vielleicht hilfst du mir\nja, ihn zu [UNI00f6]ffnen."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Ich hab ein gro[UNI00df]es Problem -\nich habe die Kombination f[UNI00fc]r\nden Safe vergessen."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Es sind vier Ziffern. Deshalb\nhabe ich Claires Geburtstag genommen -\nich dachte, den vergess ich nie."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "Wie konnte ich ihn vergessen ...<page>Ich bin ein schrecklicher Vater!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Need scheint sehr besorgt.\n   H[UNI00f6]r zu, was er [UNI00fc]ber Claires Ge-\n   burtstag sagt und knack den Code!"
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 12, 1)
end

return helper_d597165a
