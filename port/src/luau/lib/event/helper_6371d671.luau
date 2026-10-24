--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2bcf81b0 = require("@lib/event/helper_2bcf81b0")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")

--- Helper function.
local function helper_6371d671(arg0: s32)
	local flag: s32 = 0
	flag = event.GetFlag(612) or flag
	if flag == 0 then
		return
	end
	event.SetMesWindowMode(0, 12)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 255, 255, 255, 255)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(20, 0)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.SpriteSetDraw(0, 1)
	event.SetFadeIn(0)
	vm.wait(1)
	if arg0 ~= 0 then
		event.MesMake_2(
			0,
			"On a [UNI00e9]t[UNI00e9] propuls[UNI00e9]s dans le futur\npar la machine temporelle d'Ixion."
		)
	else
		event.MesMake_2(
			0,
			"On a r[UNI00e9]int[UNI00e9]gr[UNI00e9] le pr[UNI00e9]sent gr[UNI00e2]ce [UNI00e0]\nla machine temporelle d'Ixion."
		)
	end
	vm.wait(2)
	helper_a3cc6850(0, -1, 5, 0, 0)
	vm.wait(4)
	event.SetFadeOut(0, 255.0, 255.0, 255.0)
	vm.wait(5)
	helper_2bcf81b0()
end

return helper_6371d671
