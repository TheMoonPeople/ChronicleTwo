--!strict
-- map/m/m06/m06b_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b077e72 = require("@lib/event/helper_0b077e72")
local helper_18063f80 = require("@lib/event/helper_18063f80")
local helper_2c14343e = require("@lib/event/helper_2c14343e")
local helper_70456028 = require("@lib/event/helper_70456028")
local helper_7334e9f5 = require("@lib/event/helper_7334e9f5")
local helper_7bb034a7 = require("@lib/event/helper_7bb034a7")
local helper_7eebaa1d = require("@lib/event/helper_7eebaa1d")
local helper_b5445365 = require("@lib/event/helper_b5445365")
local helper_bdbefa67 = require("@lib/event/helper_bdbefa67")
local helper_db98deda = require("@lib/event/helper_db98deda")

--- Helper function.
local function helper_11bbc()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				helper_db98deda()
			end
			if at <= 2 then
				helper_7eebaa1d(1)
			end
			if at <= 3 then
				helper_bdbefa67(10)
			end
			if at <= 4 then
				helper_bdbefa67(20)
			end
			if at <= 5 then
				helper_7bb034a7(10300, -1, 10)
			end
			if at <= 6 then
				helper_7eebaa1d(1)
			end
			if at <= 7 then
				helper_bdbefa67(15)
			end
			if at <= 9 then
				helper_7bb034a7(10310, -1, 0)
			end
			if at <= 10 then
				helper_7eebaa1d(1)
			end
			if at <= 11 then
				helper_7bb034a7(10320, -1, 4)
			end
			if at <= 12 then
				helper_bdbefa67(20)
			end
			if at <= 13 then
				helper_7eebaa1d(1)
			end
			if at <= 14 then
				helper_7eebaa1d(1)
			end
			if at <= 15 then
				helper_7eebaa1d(1)
			end
			if at <= 16 then
				helper_bdbefa67(30)
			end
			if at <= 18 then
				helper_7bb034a7(10330, -1, 10)
			end
			if at <= 19 then
				helper_7eebaa1d(1)
			end
			if at <= 20 then
				helper_7bb034a7(10340, -1, 10)
			end
			if at <= 21 then
				helper_7eebaa1d(1)
			end
			if at <= 22 then
				helper_db98deda()
			end
			if vm.skip_end() then
				return skip(24)
			end
			return part2()
		end
		if at <= 24 then
			helper_db98deda()
		end
		if at <= 25 then
			helper_18063f80(0, -1, 8, 0, 0)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StreamClose(1)
		event.EohSetFootSoundId(1, -1)
		event.DelExtMotion(0)
		event.DeleteChara(20)
		event.DeleteChara(21)
		event.SetCharaPos(0, 1699.68, 0.0, 2409.28)
		event.SetCharaRot(0, 0.0, -0.67, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.SetMotion(8, "立ち", 4)
		event.ObjsInit(0)
		event.ObjsInit(1)
		event.ObjsInit(2)
		event.ObjsInit(3)
		event.SetActiveCmrid(1)
		event.SetBeforeCmrid(0)
		event.SetCameraPos(1780.41, 40.0, 2307.38)
		event.SetCameraRef(1699.68, 30.0, 2409.28)
		event.ResetCamera(0)
		event.Finish()
		event.LoadSound(1210)
		event.CmrsFadeInit()
		event.CmrsFadeIn(10)
		helper_db98deda()
		if vm.skipping() then
			return skip(25)
		end
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		event.MesMake_2(0, "[(!)]Find the boy who ran away with the\n   ticket. Check with people in town first.")
		helper_18063f80(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(26)
		end
		event.SetMesWindowMode(0, 7)
		event.SetMesDrawspeed(0, 0)
		event.LoadMes(0, -1)
	end
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	event.SetMotion(0, "立ち")
	helper_db98deda()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadSound(1209)
	var0 = event.SndLoadSound(1209) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p1/op1_5_1.txt")
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 2260.0, 0.0, 2233.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "立ち")
	event.LoadMotion(5, "event/opening/p1/p1_5_mints.gltf", "info", 0)
	event.EohSyncChara(1, 0)
	event.EohSetFootSoundId(1, 2)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 2260.0, 0.0, 2160.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "旧・立ち")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "目パチ")
	event.ObjsTexAnime(1, 1, "うれし口")
	event.LoadChara(5, "event/opening/p1/p1_5_ticket.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.EohSyncChara(2, 20)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 2260.0, 0.0, 2204.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "チケットを渡す", 5)
	event.LoadChara(5, "event/opening/p1/p1_5_boy.gltf", "info", 21)
	event.CharaActive(0, 21)
	event.EohSyncChara(3, 21)
	event.EohSetSoundId(3, var0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 2342.84, 0.0, 2225.88)
	event.ObjsSetRot(3, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(3, "ひったくり走り", 4)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMove(1, 2260.0, 0.0, 2204.0, 40)
	event.CmrsInit()
	event.CmrsSetPos(2316.32, 55.34, 2082.86)
	event.CmrsSetRef(2255.09, 19.29, 2223.48)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	helper_db98deda()
	if vm.skipping() then
		return skip(2)
	end
	helper_7eebaa1d(1)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(2335.02, 32.15, 2225.77)
	event.CmrsSetRef(2254.69, 19.29, 2220.02)
	event.ObjsSetMotion(1, "旧・立ち")
	helper_bdbefa67(10)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "チケットを渡す", 6)
	event.ObjsNextMotion(1, "チケットを渡すL", 4)
	event.CharaActive(20)
	event.ObjsSetMotion(2, "チケットを渡す", 6)
	event.ObjsNextMotion(2, "チケットを渡すL", 4)
	event.ObjsSePlay(0, var0, 4)
	helper_bdbefa67(20)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(1, "通常口パク", "うれし口")
	helper_7bb034a7(10300, -1, 10)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	helper_7eebaa1d(1)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "もぎり", 6)
	event.ObjsNextMotion(0, "もぎりL", 4)
	event.CharaActive(21)
	event.ObjsInitPas(3)
	event.ObjsSetPasFrm(3, 160)
	event.ObjsAddPas(3, 2342.84, 0.0, 2225.88)
	event.ObjsAddPas(3, 2265.2, 0.0, 2220.33)
	event.ObjsAddPas(3, 2145.86, 0.0, 2211.81)
	event.ObjsAddPas(3, 2114.11, 0.0, 2211.45)
	event.ObjsAddPas(3, 2009.12, 0.0, 2222.65)
	event.ObjsAddPas(3, 1912.97, 0.0, 2256.82)
	event.ObjsAddPas(3, 1821.43, 0.0, 2302.92)
	event.ObjsAddPas(3, 1716.38, 0.0, 2374.01)
	event.ObjsAddPas(3, 1661.85, 0.0, 2462.44)
	event.ObjsStartPas(3)
	helper_bdbefa67(15)
	if vm.skipping() then
		return skip(8)
	end
	event.CharaActive(0, 20)
	event.ObjsSetMotion(1, "チケットを取られる", 6)
	event.ObjsNextMotion(1, "チケットを取られるL", 4)
	event.ObjsSePlay(0, var0, 5)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "目パチ")
	event.ObjsSetMotion(0, "少年を見る", 6)
	event.ObjsNextMotion(0, "少年を見るL", 4)
	if vm.wait() then
		return skip(9)
	end
	event.SetPakuAnim(1, "通常口パク", "口パク大")
	helper_7bb034a7(10310, -1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	helper_7eebaa1d(1)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(1, "通常口パク", "口パク大")
	helper_7bb034a7(10320, -1, 4)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(2237.85, 16.17, 2229.34)
	event.CmrsSetRef(2261.06, 22.16, 2203.21)
	event.CharaActive(0, 21)
	event.ObjsSetRot(1, 0.0, -1.2, 0.0)
	event.ObjsSetMotion(1, "立ち2", 6, -1.0, 1)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "真剣目")
	event.ObjsTexAnime(1, 1, "口パク小")
	helper_bdbefa67(20)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(1, "走り")
	event.ObjsMove(1, 2230.82, 0.0, 2208.96, 10)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "真剣目")
	event.ObjsTexAnime(1, 1, "怒り口")
	helper_7eebaa1d(1)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(1699.32, 73.27, 2202.85)
	event.CmrsSetRef(1973.4, 44.98, 2268.33)
	event.CmrsMove(1699.32, 73.27, 2202.85, 1862.18, 11.38, 2316.42, 100)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 100)
	event.ObjsAddPas(1, 2146.75, 0.0, 2208.56)
	event.ObjsAddPas(1, 2052.61, 0.0, 2224.84)
	event.ObjsAddPas(1, 1947.63, 0.0, 2244.64)
	event.ObjsAddPas(1, 1840.32, 0.0, 2274.25)
	event.ObjsAddPas(1, 1724.36, 0.0, 2317.09)
	event.ObjsStartPas(1)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "真剣目")
	event.ObjsTexAnime(1, 1, "怒り口")
	helper_7eebaa1d(1)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(1834.95, 35.66, 2229.37)
	event.CmrsSetRef(1697.59, 7.87, 2411.67)
	event.ObjsSetPos(1, 1798.09, 0.0, 2277.17)
	event.ObjsSetRot(1, 0.0, -0.67, 0.0)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMove(1, 1699.68, 0.0, 2409.28, 40)
	event.ObjsMotionDelay(1, 38)
	event.ObjsSetMotion(1, "旧・立ち", 0)
	helper_7eebaa1d(1)
	if vm.skipping() then
		return skip(16)
	end
	helper_bdbefa67(30)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(1671.69, 14.08, 2425.85)
	event.CmrsSetRef(1699.11, 20.51, 2408.48)
	event.ObjsSetMotion(1, "キョロキョロ立ち", 2)
	event.ObjsNextMotion(1, "立ち2", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "困った目")
	if vm.wait() then
		return skip(18)
	end
	event.SetPakuAnim(1, "通常口パク", "怒り口")
	helper_7bb034a7(10330, -1, 10)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	helper_7eebaa1d(1)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(1, "ため息", 2)
	event.ObjsNextMotion(1, "立ち2", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "閉じる目（半目）")
	event.ObjsTexAnime(1, 1, "ため息")
	helper_7bb034a7(10340, -1, 10)
	if vm.skipping() then
		return skip(21)
	end
	helper_7eebaa1d(1)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_db98deda()
	if vm.skipping() then
		return skip(23)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2c14343e()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2c14343e()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s42", 502)
end

--- Program 152.
script[152] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_7334e9f5()
	helper_0b077e72()
	if vm.skipping() then
		return skip(1)
	end
	event.SetActiveCmrid(0)
	event.SetBeforeCmrid(0)
	event.LoadScript("m06/m06.stb", -1)
end

--- Program 153.
script[153] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_11bbc()
	if vm.skipping() then
		return skip(1)
	end
	event.SetActiveCmrid(0)
	event.SetBeforeCmrid(0)
	event.LoadScript("m06/m06.stb", -1)
end

--- Program 154.
script[154] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.AddItem(353)
	helper_b5445365()
	if vm.skipping() then
		return skip(1)
	end
	event.SetActiveCmrid(0)
	event.SetBeforeCmrid(0)
	event.LoadScript("m06/m06.stb", -1)
end

--- Program 155.
script[155] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_70456028()
	if vm.skipping() then
		return skip(1)
	end
	event.SetActiveCmrid(0)
	event.SetBeforeCmrid(0)
	event.MapJump(-1, "m08", 152)
end

return script
