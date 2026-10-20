--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_a935ef6e = require("@lib/event/helper_a935ef6e")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")
local helper_e7ba8bf4 = require("@lib/event/helper_e7ba8bf4")

--- Helper function.
local function helper_5ce89550(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_a935ef6e(24, 1)
		end
		if at <= 6 then
			helper_e7ba8bf4(1)
		end
		if at <= 7 then
			helper_b8f871c8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Cedric sagt, du w[UNI00e4]rst in\nletzter Zeit viel\nunterwegs gewesen.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Du kannst vieles gut,<page>aber andererseits bringst du\nnie etwas zu Ende.")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Deshalb f[UNI00e4]llt es mir schwer,\ndich einfach ernst zu nehmen,\nwenn du mich um Hilfe bittest."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Ich hab's - stufe dieses\nTrompeten-Gewehr zu einem\nKlingel-Abzug hoch!<page>Schaffst du das?")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(24)
	helper_a935ef6e(24, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_e7ba8bf4(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Damit Gerald dich akzeptiert,\n   musst du ihm einen\n   Klingel-Abzug bringen.<page>[(!)]Du kannst seine Waffe\n   hochstufen, eine andere kaufen\n   oder eine aus dem Verlies holen."
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 11, 1)
end

return helper_5ce89550
