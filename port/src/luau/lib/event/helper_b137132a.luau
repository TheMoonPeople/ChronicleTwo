--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4484af04 = require("@lib/event/helper_4484af04")
local helper_4d6fefb8 = require("@lib/event/helper_4d6fefb8")
local helper_c85a55f2 = require("@lib/event/helper_c85a55f2")
local helper_e5871cb4 = require("@lib/event/helper_e5871cb4")

--- Helper function.
local function helper_b137132a()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c85a55f2(15)
		end
		if at <= 2 then
			active_chr_no = 0
			helper_4d6fefb8()
		end
		if at <= 3 then
			helper_c85a55f2(30)
		end
		if at <= 4 then
			helper_4d6fefb8()
		end
		if at <= 5 then
			helper_c85a55f2(30)
		end
		if at <= 6 then
			helper_e5871cb4(5260010, 120)
		end
		if at <= 7 then
			helper_c85a55f2(90)
		end
		if at <= 8 then
			helper_c85a55f2(30)
		end
		helper_4484af04(0.0, -30.0, 1500.0, vm.f32(3.14))
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(526, 1)
	event.SetFadeOut(15)
	helper_c85a55f2(15)
	if vm.skipping() then
		return skip(2)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 0 then
		event.DngSetupMainUnit(0)
		active_chr_no = 0
	end
	event.AssignStack(5)
	event.ClearStack(5)
	var1 = event.SndLoadSound(5814) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e526/")
	event.LoadMes(0, 5, "e526_1.txt")
	event.LoadMotion(5, "e526_mints.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "phorn.gltf", "info", 8)
	event.CharaActive(8)
	event.SetReference(0, "item", 8)
	event.ChangeDir("")
	event.EohSyncChara(1, 1)
	event.EohSyncChara(2, 2)
	event.EohSetShow(1, 0)
	event.EohSetShow(2, 0)
	event.EohSetPos(0, 0.0, -30.0, 1500.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "ホーン吹く", 4)
	event.EohNormalDrive(0)
	event.EohResetDaPosition(0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "ふき顔")
	event.EohSetTexAnim(0, 1, "下向き目パチ")
	event.FuncPointShow("d05", "takil", 1)
	event.FuncPointShow("d05", "takir", 1)
	event.CmrsInit()
	event.CmrsSetPos(16.1, -10.46, 1474.52)
	event.CmrsSetRef(0.26, -9.87, 1496.35)
	event.CmrsMove2(30.06, -19.27, 1455.3, 2.31, -16.91, 1493.52, 60, 0, 1.0)
	event.SndSePlay(var1, 0)
	event.SetFadeIn(30)
	helper_4d6fefb8()
	if vm.skipping() then
		return skip(3)
	end
	helper_c85a55f2(30)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(0.0, 30.39, 1561.77)
	event.CmrsSetRef(0.0, -19.94, 1493.75)
	event.CmrsMove2(0.0, 30.39, 1561.77, 0.0, 11.85, 1493.75, 80, 0, 1.0)
	event.SndSePlay(var1, 1)
	event.ObjsSetMotion(0, "ホーン持ち立ち", 4)
	helper_4d6fefb8()
	if vm.skipping() then
		return skip(5)
	end
	helper_c85a55f2(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(14.64, -10.25, 1472.02)
	event.CmrsSetRef(0.03, -10.34, 1496.41)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おどろき顔")
	event.EohSetTexAnim(0, 1, "おどろき目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_e5871cb4(5260010, 120)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(0.0, 0.69, 877.16)
	event.CmrsSetRef(0.0, -9.03, 949.98)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	helper_c85a55f2(90)
	if vm.skipping() then
		return skip(8)
	end
	event.SndSeStop(var1, 1)
	event.SetFadeOut(30)
	helper_c85a55f2(30)
	if vm.skipping() then
		return skip(9)
	end
	event.SetStatus(1, 0, 256, 0)
	event.EohSetFootSoundId(0, 0)
	event.DelExtMotion(0)
	event.DeleteChara(8)
	event.LoadMes(0, -1)
	event.SetStatusbarShow(1, 1.0)
	event.EohSetShow(1, 1)
	event.EohSetShow(2, 1)
	helper_4484af04(0.0, -30.0, 1500.0, vm.f32(3.14))
	event.SetCameraRef(0.0, 0.0, 1500.0)
	event.SetCameraPos(0.0, 10.0, 1600.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	event.Finish()
end

return helper_b137132a
