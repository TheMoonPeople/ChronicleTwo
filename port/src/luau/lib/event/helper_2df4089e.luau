--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_04dd67c6 = require("@lib/event/helper_04dd67c6")
local helper_407b4453 = require("@lib/event/helper_407b4453")
local helper_8e53ce0a = require("@lib/event/helper_8e53ce0a")
local helper_bc77b237 = require("@lib/event/helper_bc77b237")

--- Helper function.
local function helper_2df4089e()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_407b4453()
			end
			if at <= 2 then
				helper_04dd67c6(10680, -1, 10)
			end
			if at <= 3 then
				helper_8e53ce0a(4)
			end
			if at <= 4 then
				helper_04dd67c6(10690, -1, 10)
			end
			if at <= 5 then
				helper_8e53ce0a(0)
			end
			if at <= 6 then
				helper_04dd67c6(10700, -1, 10)
			end
			if at <= 7 then
				helper_8e53ce0a(0)
			end
			if at <= 8 then
				helper_bc77b237(30)
			end
			if at <= 9 then
				helper_bc77b237(30)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
		if at <= 11 then
			helper_bc77b237(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StreamClose(1)
		event.DelExtMotion(0)
		event.LoadMes(0, -1)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.DeleteChara(18)
		event.DeleteChara(20)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.StopBgm(0)
		event.StopEnvBgm()
		helper_bc77b237(4)
		if vm.skipping() then
			return skip(12)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	event.SetMotion(0, "立ち")
	helper_407b4453()
	if vm.skipping() then
		return skip(1)
	end
	event.InitDramaScene()
	event.CharaActive(0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p1/op1_5_1.txt")
	event.EohSyncChara(0, 8)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 2265.38, 0.0, 2231.01)
	event.ObjsSetRot(0, 0.0, -2.3, 0.0)
	event.LoadMotion(5, "event/opening/p1/p1_5_mints.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(4, 0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 2244.38, 0.0, 2216.71)
	event.ObjsSetRot(4, 0.0, 1.08, 0.0)
	event.ObjsResetDaPosition(4)
	event.ObjsSetMotion(4, "旧・立ち", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "目パチ")
	event.ObjsTexAnime(4, 1, "うれし口")
	event.LoadChara(5, "event/opening/p1/p1_5_ticket.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.EohSyncChara(5, 20)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 2244.38, 0.0, 2216.71)
	event.ObjsSetRot(5, 0.0, 1.08, 0.0)
	event.CmrsSetPos(2261.3, 11.72, 2146.03)
	event.CmrsSetRef(2254.85, 18.38, 2223.77)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	helper_407b4453()
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(4, "チケットを渡す", 6)
	event.ObjsNextMotion(4, "チケットを渡すL", 4)
	event.CharaActive(20)
	event.ObjsSetMotion(5, "チケットを渡す", 6)
	event.ObjsNextMotion(5, "チケットを渡すL", 4)
	event.SetPakuAnim(4, "通常口パク", "うれし口")
	helper_04dd67c6(10680, -1, 10)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	helper_8e53ce0a(4)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "もぎり", 6)
	event.ObjsNextMotion(0, "もぎりL", 4)
	helper_04dd67c6(10690, -1, 10)
	if vm.skipping() then
		return skip(5)
	end
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(6)
	end
	event.CharaActive(0, 20)
	event.ObjsSetMotion(4, "チケットを渡す戻り", 6)
	event.ObjsNextMotion(4, "旧・立ち", 4)
	event.ObjsSetMotion(0, "もぎり戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(4, "通常口パク", "うれし口")
	helper_04dd67c6(10700, -1, 10)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_8e53ce0a(0)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(4, "歩き")
	event.ObjsMove(4, 2246.15, 0.0, 2250.53, 45)
	event.ObjsMove(4, 2245.15, 8.0, 2295.52, 45)
	event.ObjsRotation(4, 0.0, 0.0, 0.0, 10)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(9)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_bc77b237(30)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

return helper_2df4089e
