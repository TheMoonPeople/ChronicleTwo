--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_08dc8e34 = require("@lib/event/helper_08dc8e34")
local helper_23bda4ba = require("@lib/event/helper_23bda4ba")
local helper_261c70db = require("@lib/event/helper_261c70db")
local helper_661ab502 = require("@lib/event/helper_661ab502")
local helper_adea7ba0 = require("@lib/event/helper_adea7ba0")

--- Helper function.
local function helper_ec82b1f6()
	local projection: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_661ab502()
				helper_adea7ba0(60)
			end
			if at <= 2 then
				helper_23bda4ba(2)
			end
			if at <= 3 then
				helper_23bda4ba(2)
			end
			if at <= 4 then
				helper_adea7ba0(30)
			end
			if at <= 5 then
				helper_261c70db()
			end
			if at <= 6 then
				helper_adea7ba0(60)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
		helper_08dc8e34()
	end
	function part2()
		event.CancelDramaScene()
		event.SetProjection(projection)
		event.BgmLoadCancel()
		event.SoundLoadCancel()
		if vm.wait() then
			return skip(9)
		end
		helper_08dc8e34()
	end
	event.CharaActive(0, 0)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	if vm.wait() then
		return skip(1)
	end
	event.LoadSound(7840)
	helper_661ab502()
	projection = event.GetProjection() or projection
	event.InitDramaScene()
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "泣き目")
	event.CharaActive(1, 35)
	event.CharaActive(1, 33)
	event.ObjsSetMotion(2, "走り", 4)
	event.ObjsSetMotion(3, "立ち", 4)
	event.CmrsCharaAttach(34, 760.0, -1)
	event.CmrsSetPos(-152.72, 63.59, 450.23)
	event.CmrsSetRef(0.0, 8.4, 400.0)
	event.ObjsSetPos(2, 0.0, 0.0, 400.0)
	event.ObjsSetRot(2, 0.0, 3.12, 0.0)
	event.ObjsSetPos(3, 0.0, 0.0, 220.0)
	event.ObjsSetRot(3, 0.0, 3.12, 0.0)
	event.CmrsFadeIn(60, 255.0, 255.0, 255.0)
	event.CmrsMoveRef(0.0, 8.4, 200.0, 150)
	event.ObjsMove(2, 0.0, 0.0, 220.0, 120, 1)
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(3, "しゃがむ", 2)
	event.ObjsNextMotion(3, "しゃがむL", 4)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "泣き目とじ")
	event.ObjsSetMotion(2, "抱きつく", 2)
	event.ObjsNextMotion(2, "抱きつくL", 4)
	event.ObjsSetMotion(3, "抱きつく", 2)
	event.ObjsNextMotion(3, "抱きつくL", 4)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(4)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsInit()
	event.CmrsCharaAttach(34, 760.0, 480.0)
	event.CmrsMoveRef(0.0, 389.25, 200.0, 480)
	helper_261c70db()
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsFadeOut(60, 255.0, 255.0, 255.0)
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

return helper_ec82b1f6
