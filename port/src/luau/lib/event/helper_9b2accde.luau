--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7178e1be = require("@lib/event/helper_7178e1be")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")
local helper_c6124e13 = require("@lib/event/helper_c6124e13")

--- Helper function.
local function helper_9b2accde()
	local var0: s32 = 0
	local projection: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_a8b5d854(50)
			end
			if at <= 2 then
				helper_a8b5d854(25)
			end
			if at <= 3 then
				helper_a8b5d854(50)
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
		if at <= 5 then
			helper_a8b5d854(30)
		end
		if at <= 6 then
			helper_7178e1be()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_a8b5d854(30)
		if vm.skipping() then
			return skip(6)
		end
		event.BgmLoadCancel()
		event.SndSeAllStop(4)
		event.EsmClear()
		helper_7178e1be()
		if vm.skipping() then
			return skip(7)
		end
		event.SetProjection(projection)
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	var0 = event.SndLoadSound(7200) or var0
	helper_c6124e13()
	projection = event.GetProjection() or projection
	event.SetProjection(500)
	event.InitDramaScene()
	event.EohSetScale(5, 0.125, 0.125, 0.125)
	event.EohSetScale(6, 2.0, 2.0, 2.0)
	event.ObjsSetPos(5, 275.8, 1361.59, 69.04)
	event.ObjsSetPos(6, 1553.99, 0.0, 55.85)
	event.ObjsSetPos(7, 275.8, 1361.59, 69.04)
	event.ObjsSetRot(7, 0.0, 1.32, 0.0)
	event.ObjsSetPos(4, 0.0, 1000.0, 0.0)
	event.CharaActive(0, 0)
	event.CmrsSetPos(832.39, 758.85, 3094.99)
	event.CmrsSetRef(811.41, 786.18, 1062.32)
	event.SetCrossfade(30)
	helper_a8b5d854(60)
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 40)
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(5, "入り", 6)
	event.ObjsNextMotion(5, "発射", 6)
	helper_a8b5d854(50)
	if vm.skipping() then
		return skip(2)
	end
	event.EsmCreate("Ｅ６１６月花ビームＡ")
	event.EsmSetVect1(275.8, 1361.59, 69.04)
	event.EsmSetVect2(0.0, 1.32, 0.0)
	event.SndSePlay(var0, 4)
	event.CharaActive(1, 42)
	event.SetMotion(42, "弾道", 6, -1, 1)
	helper_a8b5d854(25)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 5)
	event.CharaActive(1, 41)
	event.SetMotion(41, "ヒット", 6, -1, 1)
	event.ObjsSetPos(5, 375.8, 1461.59, 69.04)
	event.ObjsSetPos(7, 375.8, 1461.59, 69.04)
	event.CharaActive(1, 40)
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(5, "入り", 6)
	event.ObjsNextMotion(5, "発射", 6)
	helper_a8b5d854(50)
	if vm.skipping() then
		return skip(4)
	end
	event.EsmCreate("Ｅ６１６月花ビームＡ")
	event.EsmSetVect1(375.8, 1461.59, 69.04)
	event.EsmSetVect2(0.0, 1.32, 0.0)
	event.SndSePlay(var0, 4)
	event.CharaActive(1, 42)
	event.SetMotion(42, "弾道", 6, -1, 1)
	return part2()
end

return helper_9b2accde
