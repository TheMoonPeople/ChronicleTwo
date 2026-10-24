--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_a19c5ee3 = require("@lib/event/helper_a19c5ee3")

--- Helper function.
local function helper_50186fa0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_a0e17f3c(60)
			end
			if at <= 2 then
				helper_a0e17f3c(20)
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(1, 0)
		event.EohSetFootSoundId(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.LoadMes(0, -1)
		event.Finish()
	end
	event.Initialize()
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	var0 = event.SndLoadSound(3820) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.LoadMotion(5, "event/e300/e308/e308_mints.gltf", "info", 0)
	else
		event.LoadMotion(5, "event/e300/e308/e308_monica.gltf", "info", 0)
	end
	event.CharaActive(0, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "event/d03/p00_26a.gltf", "info", 8)
	event.CharaActive(1, 8)
	event.EohSyncChara(1, 8)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSetShadow(1, 0)
	event.EohSetPos(0, -1306.0, 200.39, -546.0)
	event.EohSetRot(0, 0.0, 1.88, 0.0)
	event.EohSetPos(1, -169.01, 1296.7, 919.52)
	event.EohSetRot(1, 0.0, 2.52, 0.0)
	event.EohSetMotion(1, "肉つかみ飛び", 4)
	event.CmrsInit()
	event.CmrsSetPos(2137.92, 789.89, -634.43)
	event.CmrsSetRef(1501.16, 847.03, -450.95)
	event.ObjsMove(1, -127.0, 1099.81, 692.26, 90)
	event.SndSePlay(var0, 0)
	event.SndSePlay(var0, 1)
	event.SetFadeIn(30)
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-1182.17, 240.83, -585.56)
	event.CmrsSetRef(-1306.0, 230.83, -546.0)
	event.CharaActive(1, 0)
	event.SndSePlay(var0, 2)
	event.SndSePlay(var0, 3)
	event.ObjsSetPos(1, -1272.85, 225.03, -556.23)
	event.ObjsSetRot(1, 0.0, 1.92, 0.0)
	event.ObjsMove(1, -1272.85, 267.03, -556.23, 60)
	event.ObjsSetMotion(0, "着地", 6, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(20)
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

return helper_50186fa0
