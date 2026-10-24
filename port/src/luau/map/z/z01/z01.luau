--!strict
-- map/z/z01/z01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_7a8(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			arg0 = vm.wrap(arg0 - 1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while arg0 >= 0 do
		arg0 = arg0 - 1
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_8ac(arg0: s32)
	local get_pad_down: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.i32(bit32.band(get_pad_down, arg0))
	end
	if vm.skipping() then
		return skip(1)
	end
	get_pad_down = event.GetPaddown() or get_pad_down
	return vm.i32(bit32.band(get_pad_down, arg0))
end

--- Helper function.
local function helper_ab0(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_8ac(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_8ac(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_aac8()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_ab0(32)
		end
	end
	event.Initialize()
	event.SetTime(24.0)
	event.SetTimeStepEnable(0)
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.LoadChara(5, "event/lm/p00_01ev.gltf", "info", 8)
	event.CharaActive(1, 8)
	event.SetCharaPos(8, 0.0, 0.0, 0.0)
	event.SetCharaRot(8, 0.0, 0.0, 0.0)
	event.SetMotion(8, "羽開き", 5)
	event.LoadChara(5, "event/lm/ef00.gltf", "info", 9)
	event.CharaActive(1, 9)
	event.SetCharaPos(9, 0.0, 0.0, 0.0)
	event.SetCharaRot(9, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/lm/2moon.gltf", "info", 10)
	event.CharaActive(1, 10)
	event.SetCharaPos(10, 0.0, 394.94, -1119.58)
	event.SetCharaRot(10, 0.0, 0.6, 0.0)
	event.SetScale(10, 40.0, 40.0, 40.0)
	event.LoadChara(5, "event/lm/hotaru_gg.gltf", "info", 11)
	event.CharaActive(11)
	event.LoadChara(5, "event/lm/hotaru_gg.gltf", "info", 12)
	event.CharaActive(12)
	event.LoadChara(5, "event/lm/hotaru_gg.gltf", "info", 13)
	event.CharaActive(13)
	event.LoadChara(5, "event/lm/hotaru_gg.gltf", "info", 14)
	event.CharaActive(14)
	event.SetCharaPos(11, 0.0, 0.0, 0.0)
	event.SetCharaRot(11, 0.0, 0.0, 0.0)
	event.SetCharaPos(12, 0.0, 0.0, 0.0)
	event.SetCharaRot(12, 0.0, 1.57, 0.0)
	event.SetCharaPos(13, 0.0, 0.0, 0.0)
	event.SetCharaRot(13, 0.0, -3.14, 0.0)
	event.SetCharaPos(14, 0.0, 0.0, 0.0)
	event.SetCharaRot(14, 0.0, 3.14, 0.0)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsRotation(2, 0.0, -0.002, 0.0, -1)
	event.SetCameraPos(0.0, -10.44, 138.29)
	event.SetCameraRef(0.0, 42.51, 0.0)
	helper_7a8(30)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsInit()
	event.CmrsMove2(0.0, 11.62, 87.3, 0.0, 42.51, 0.0, 120, 2, 1.0)
	event.ObjsMove(2, -256.22, -5.2, -666.44, 300)
	event.SetMotion(8, "羽開き", 2)
	if vm.wait() then
		return skip(2)
	end
	helper_ab0(32)
	if vm.skipping() then
		return skip(3)
	end
	event.CharaActive(1, 0)
	event.DeleteChara(8)
	event.DeleteChara(9)
	event.DeleteChara(10)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_aac8()
	if vm.skipping() then
		return skip(1)
	end
end

return script
