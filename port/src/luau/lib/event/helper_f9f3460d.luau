--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c3ce9c48 = require("@lib/event/helper_c3ce9c48")
local helper_e2d04ed9 = require("@lib/event/helper_e2d04ed9")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")

--- Helper function.
local function helper_f9f3460d()
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_c3ce9c48(3070030)
			end
			if at <= 2 then
				helper_c3ce9c48(3070040)
			end
			if at <= 3 then
				helper_c3ce9c48(3070050)
			end
			if at <= 4 then
				helper_c3ce9c48(3070060)
			end
			if at <= 5 then
				helper_c3ce9c48(3070070)
			end
			if at <= 6 then
				helper_c3ce9c48(3070075)
			end
			if at <= 7 then
				helper_c3ce9c48(3070080)
			end
			if at <= 8 then
				helper_c3ce9c48(3070090)
			end
			if at <= 9 then
				helper_ed0a80b8(30)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.StopBgm(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		if vm.wait() then
			return skip(12)
		end
	end
	event.SetFlag(307, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.SoundAllStop()
	event.LoadBgm(58)
	event.PlayBgm(0)
	event.LoadSound(3801)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.ChangeDir("event/e300/e307/")
	event.LoadMes(0, 5, "e307_1.txt")
	event.LoadChara(5, "e307_minchu.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e307_eina.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "e307_bed.gltf", "info", 10)
	event.CharaActive(10)
	event.LoadChara(5, "e307_senmen.gltf", "info", 11)
	event.CharaActive(11)
	event.ChangeDir("")
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "寝てる", 4)
	event.SetReference(10, "minchu", 8)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "苦しい顔")
	event.EohSetTexAnim(0, 1, "苦しい目パチ")
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "座り", 4)
	event.SetReference(10, "eina", 9)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "わらい顔")
	event.EohSetTexAnim(1, 1, "目パチ")
	event.SetCharaPos(10, 58.0, 13.0, 108.0)
	event.SetCharaRot(10, 0.0, 0.0, 0.0)
	event.SetMotion(10, "寝てる", 4)
	event.SetCharaPos(11, 56.65, 13.0, 71.33)
	event.SetCharaRot(10, 0.0, 0.0, 0.0)
	time = event.GetTime() or time
	event.SetTime(12.0)
	event.SetTimeStepEnable(0)
	event.CmrsInit()
	event.CmrsSetPos(-25.28, 87.45, 28.6)
	event.CmrsSetRef(68.06, 28.91, 95.45)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.ObjsSetMotion(1, "頭を冷やす", 6)
	event.ObjsNextMotion(1, "座り", 4)
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(51.94, 47.84, 90.03)
	event.CmrsSetRef(64.5, 32.42, 98.98)
	event.SetPakuAnim(0, "苦しい口パク")
	helper_c3ce9c48(3070030)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(3070040)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsTexaDelay(0, 180)
	event.ObjsTexAnime(0, 1, "目あき～とじ")
	event.ObjsTexaDelay(0, 90)
	event.ObjsTexAnime(0, 1, "目とじ～目あき")
	event.ObjsTexaDelay(0, 30)
	event.ObjsTexAnime(0, 0, "目あき～とじ")
	event.ObjsTexAnime(0, 0, "目とじ～目あき")
	event.SetPakuAnim(0, "苦しい口パク")
	helper_c3ce9c48(3070050)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "頭をなでる", 2)
	event.ObjsNextMotion(1, "頭をなでるL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(3070060)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(3070070)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(35.28, 48.46, 114.2)
	event.CmrsSetRef(66.59, 39.0, 88.86)
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(3070075)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(0, "苦しい口パク")
	helper_c3ce9c48(3070080)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(50.56, 35.76, 96.14)
	event.CmrsSetRef(69.63, 43.83, 87.3)
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(3070090)
	if vm.skipping() then
		return skip(9)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

return helper_f9f3460d
