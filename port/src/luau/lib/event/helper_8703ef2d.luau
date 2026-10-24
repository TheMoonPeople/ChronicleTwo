--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c357943 = require("@lib/event/helper_1c357943")
local helper_4eedff96 = require("@lib/event/helper_4eedff96")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_8ab48644 = require("@lib/event/helper_8ab48644")
local helper_e7ba8bf4 = require("@lib/event/helper_e7ba8bf4")

--- Helper function.
local function helper_8703ef2d(arg0: s32, arg1: s32)
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
			helper_8ab48644(var2, 1)
		end
		if at <= 6 then
			helper_e7ba8bf4(1)
		end
		if at <= 7 then
			helper_635ee3fd(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_1c357943()
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
	event.MesMake_2(0, "Ah, Max ! J'ai enfin fini un\nv[UNI00ea]tement !")
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Je ne voulais pas que tes mat[UNI00e9]riaux\nsoient jet[UNI00e9]s, et c'est [UNI00e7]a qui\nm'a oblig[UNI00e9]e [UNI00e0] le terminer."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Je ne suis pas tr[UNI00e8]s satisfaite\nde cette tenue, mais... voudrais-tu\nla porter ?")
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
	helper_8ab48644(var2, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_e7ba8bf4(1)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Ah, c'est vraiment super d'avoir\nenfin pu terminer quelque chose.<page>Je me sens beaucoup plus s[UNI00fb]re\nde moi, maintenant.<page>Je ferai de mon mieux, je\nt'en prie, emm[UNI00e8]ne-moi avec toi."
	)
	helper_635ee3fd(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	helper_1c357943()
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 7, 1)
end

return helper_8703ef2d
