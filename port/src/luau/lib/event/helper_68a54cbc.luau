--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_17134f47 = require("@lib/event/helper_17134f47")
local helper_1cbf7cf7 = require("@lib/event/helper_1cbf7cf7")
local helper_29a74df7 = require("@lib/event/helper_29a74df7")
local helper_2cb73019 = require("@lib/event/helper_2cb73019")
local helper_34641e15 = require("@lib/event/helper_34641e15")
local helper_472082a1 = require("@lib/event/helper_472082a1")
local helper_5b8dd6e7 = require("@lib/event/helper_5b8dd6e7")
local helper_68671b54 = require("@lib/event/helper_68671b54")
local helper_7f75e08e = require("@lib/event/helper_7f75e08e")
local helper_964f013f = require("@lib/event/helper_964f013f")
local helper_9e2fef46 = require("@lib/event/helper_9e2fef46")
local helper_ae5ee586 = require("@lib/event/helper_ae5ee586")
local helper_f33ee88c = require("@lib/event/helper_f33ee88c")
local helper_f7f5ddcf = require("@lib/event/helper_f7f5ddcf")

--- Helper function.
local function helper_68a54cbc()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 12 then
			if at <= 1 then
				helper_f7f5ddcf(var0)
			end
			if at <= 2 then
				helper_472082a1(var0)
			end
			if at <= 3 then
				helper_9e2fef46()
			end
			if at <= 4 then
				helper_964f013f(var0)
			end
			if at <= 5 then
				helper_ae5ee586(var0)
			end
			if at <= 6 then
				helper_1cbf7cf7(var0)
			end
			if at <= 7 then
				helper_f33ee88c(var0)
			end
			if at <= 8 then
				helper_68671b54(var0)
			end
			if at <= 9 then
				helper_29a74df7(var0)
			end
			if at <= 10 then
				helper_17134f47(var0)
			end
			if at <= 11 then
				helper_5b8dd6e7(var0)
			end
			if vm.skip_end() then
				return skip(13)
			end
			return part2()
		end
		helper_34641e15()
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		event.SetStatus(1, 0, 256, 0)
		helper_34641e15()
		event.CharaActive(1, 9)
		event.CharaActive(1, 10)
		event.CharaActive(1, 11)
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 8)
		event.CmrsSetPos(29.29, 88.68, -13.52)
		event.CmrsSetRef(-6.48, 65.74, 32.61)
		event.ResetCamera(0)
	end
	event.SetFlag(203, 1)
	event.Initialize()
	var0 = event.SndLoadSound(2200) or var0
	helper_2cb73019()
	event.EohSetSoundId(3, var0)
	event.StopBgm(0)
	helper_7f75e08e(6)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(105)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目パチ")
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.SetStatus(1, 0, 256, 1)
	event.InitDramaScene()
	event.CharaActive(1, 0)
	event.CharaActive(1, 33)
	event.CharaActive(1, 34)
	event.CmrsSetPos(41.03, 65.52, -72.49)
	event.CmrsSetRef(1.22, 121.98, 25.12)
	event.ObjsSetPos(0, 2.3, 36.08, 14.12)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, 5.62, 36.1, 39.9)
	event.ObjsSetRot(1, 0.0, 3.04, 0.0)
	event.ObjsSetPos(2, -38.37, 36.08, 32.88)
	event.ObjsSetRot(2, 0.0, 1.48, 0.0)
	event.ObjsSetPos(3, -1.81, 36.1, 72.51)
	event.ObjsSetRot(3, 0.0, -0.48, 0.0)
	event.ObjsResetDaPosition(0)
	event.SndSePlay(var0, 2)
	helper_f7f5ddcf(var0)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(54.99, 53.17, 1.95)
	event.CmrsSetRef(-1.12, 50.66, 35.36)
	event.CmrsMoveAhd2(2.64, 2.9, 55.5, 140, 0, 1.0)
	event.ObjsSetPos(0, 2.3, 36.08, 14.12)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsResetDaPosition(0)
	helper_472082a1(var0)
	if vm.skipping() then
		return skip(3)
	end
	helper_9e2fef46()
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(11.36, 60.35, 36.83)
	event.CmrsSetRef(-1.48, 59.0, 7.39)
	helper_964f013f(var0)
	if vm.skipping() then
		return skip(5)
	end
	helper_ae5ee586(var0)
	if vm.skipping() then
		return skip(6)
	end
	helper_1cbf7cf7(var0)
	if vm.skipping() then
		return skip(7)
	end
	helper_f33ee88c(var0)
	if vm.skipping() then
		return skip(8)
	end
	helper_68671b54(var0)
	if vm.skipping() then
		return skip(9)
	end
	event.CharaActive(1, 0)
	event.CmrsInit()
	event.CmrsSetPos(12.55, 58.61, 36.64)
	event.CmrsSetRef(3.28, 58.99, 20.96)
	helper_29a74df7(var0)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsInit()
	event.CmrsSetPos(3.0, 69.45, -14.12)
	event.CmrsSetRef(-5.47, 39.58, 58.5)
	helper_17134f47(var0)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(29.29, 88.68, -13.52)
	event.CmrsSetRef(-6.48, 65.74, 32.61)
	event.ObjsSetPos(0, 6.15, 36.08, -1.68)
	event.ObjsSetRot(0, 0.0, -3.12, 0.0)
	event.ObjsSetPos(2, -18.35, 36.08, 35.6)
	event.ObjsSetRot(2, 0.0, 1.48, 0.0)
	event.ObjsResetDaPosition(0)
	helper_5b8dd6e7(var0)
	if vm.skipping() then
		return skip(12)
	end
	return part2()
end

return helper_68a54cbc
