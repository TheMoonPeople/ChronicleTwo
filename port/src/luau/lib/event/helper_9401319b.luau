--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_126faf7c = require("@lib/event/helper_126faf7c")
local helper_3f0dde4d = require("@lib/event/helper_3f0dde4d")
local helper_5fe8f3bb = require("@lib/event/helper_5fe8f3bb")
local helper_63bebd50 = require("@lib/event/helper_63bebd50")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_e20fd550 = require("@lib/event/helper_e20fd550")

--- Helper function.
local function helper_9401319b()
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_63bebd50()
				helper_e20fd550(2800410, 210)
			end
			if at <= 2 then
				helper_126faf7c(2)
			end
			if at <= 3 then
				helper_e20fd550(2800420, -1)
			end
			if at <= 4 then
				helper_5fe8f3bb()
			end
			if at <= 5 then
				helper_b0211f82(60)
			end
			if at <= 6 then
				helper_b0211f82(30)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
		helper_3f0dde4d()
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		helper_3f0dde4d()
		event.SetTime(time)
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(280, 1)
	event.Initialize()
	helper_63bebd50()
	event.InitDramaScene()
	time = event.GetTime() or time
	if time > 23.0 or time < 3.0 then
		event.SetTime(23.5)
	end
	event.CharaActive(0, 0)
	event.CmrsSetPos(-345.15, 101.35, 500.91)
	event.CmrsSetRef(-187.77, 66.45, 754.48)
	event.ObjsSetPos(5, 1.3, 8.0, 700.0)
	event.ObjsSetPos(2, -211.51, 0.0, 580.92)
	event.ObjsSetRot(2, 0.0, 0.12, 0.0)
	event.ObjsSetPos(3, -179.62, 0.0, 849.1)
	event.ObjsSetRot(3, 0.0, -3.04, 0.0)
	event.ObjsSetPos(4, -127.36, 0.0, 848.26)
	event.ObjsSetRot(4, 0.0, -2.88, 0.0)
	event.ObjsSetMotion(2, "歩き", 0)
	event.ObjsSetMotion(3, "会話2", 0)
	event.ObjsSetMotion(4, "喜び", 0)
	event.SetCrossfade(30)
	event.ObjsMove(2, -178.31, 0.0, 745.86, 240, 1)
	helper_e20fd550(2800410, 210)
	if vm.skipping() then
		return skip(2)
	end
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(2, "立ち")
	event.SetCameraSpeed(0)
	event.CmrsMove2(-345.15, 101.35, 500.91, -393.5, 319.63, 632.81, 240, 0, 0.4)
	helper_e20fd550(2800420, -1)
	if vm.skipping() then
		return skip(4)
	end
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(5)
	end
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(6)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

return helper_9401319b
