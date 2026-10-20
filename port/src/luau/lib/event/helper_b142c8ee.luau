--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_a79d0b65 = require("@lib/event/helper_a79d0b65")
local helper_a935ef6e = require("@lib/event/helper_a935ef6e")
local helper_e7ba8bf4 = require("@lib/event/helper_e7ba8bf4")

--- Helper function.
local function helper_b142c8ee(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4eedff96(arg0, 0, 0)
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
			var2 = 259
			var2 = 258
			var2 = 260
			helper_a935ef6e(var2, 1)
		end
		if at <= 6 then
			helper_e7ba8bf4(1)
		end
		if at <= 7 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_a79d0b65()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_4eedff96(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Ah, Max! Ho finito un indumento!")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Non volevo sprecare i materiali\nche mi avete dato e che mi hanno\npermesso di arrivare fino in fondo."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Non sono del tutto convinta,\nma lo proveresti intanto?")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
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
	helper_a935ef6e(var2, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_e7ba8bf4(1)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Ah, che bello aver\nportato qualcosa a termine!<page>Ora mi sento molto\npi[UNI00f9] sicura di me.<page>Far[UNI00f2] del mio meglio...\nPer favore, portatemi con voi!"
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	helper_a79d0b65()
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 7, 1)
end

return helper_b142c8ee
