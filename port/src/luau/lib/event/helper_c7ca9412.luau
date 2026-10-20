--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bdbefa67 = require("@lib/event/helper_bdbefa67")
local helper_c14e497f = require("@lib/event/helper_c14e497f")

--- Helper function.
local function helper_c7ca9412()
	local flag: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_c14e497f(3720190)
			end
			if at <= 2 then
				helper_c14e497f(3720200)
			end
			if at <= 3 then
				helper_c14e497f(3720210)
			end
			if at <= 4 then
				helper_c14e497f(3720220)
			end
			if at <= 5 then
				helper_bdbefa67(30)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DeleteChara(32)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e300/e372/e372_waku2.gltf", "info", 32)
	event.EohSyncChara(0, 32)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadMes(0, 5, "event/e300/e372/e372_1.txt")
	flag = event.GetFlag(43) or flag
	if flag ~= 0 then
		event.StopBgm(0)
		helper_bdbefa67(4)
		if vm.skipping() then
			return skip(1)
		end
		event.LoadBgm(59)
		event.PlayBgm(0)
		event.SetFlag(43, 0)
	end
	event.InitDramaScene()
	event.CharaActive(0, 0)
	event.CharaActive(1, 32)
	event.SetCrossfade(0, 0, 90)
	event.CmrsSetPos(-178.53, 128.12, 2185.49)
	event.CmrsSetRef(-546.76, 268.24, 1697.27)
	event.ObjsSetPos(0, -546.76, 268.24, 1697.27)
	event.CmrsCharaAttach(32, 608.78, 99999999)
	event.CmrsMove2(1177.44, 128.12, 1162.78, 809.21, 268.24, 674.57, 600, 2, 0.4)
	helper_c14e497f(3720190)
	if vm.skipping() then
		return skip(2)
	end
	helper_c14e497f(3720200)
	if vm.skipping() then
		return skip(3)
	end
	helper_c14e497f(3720210)
	if vm.skipping() then
		return skip(4)
	end
	helper_c14e497f(3720220)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsInit()
	event.SetFadeOut(30)
	helper_bdbefa67(30)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

return helper_c7ca9412
