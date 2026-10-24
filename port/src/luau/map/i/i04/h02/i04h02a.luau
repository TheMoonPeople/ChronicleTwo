--!strict
-- map/i/i04/h02/i04h02a.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_ec68643c = require("@lib/event/helper_ec68643c")

--- Helper function.
local function helper_cbc(arg0: s32)
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
local function helper_ec0(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_cbc(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_cbc(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = helper_1ef0d4b2

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ec0(32)
		end
	end
	event.Initialize()
	event.SetAi(0, 8)
	event.CharaActive(0, 8)
	event.SetCameraPos(19.51, 30.7, -34.38)
	event.SetCameraRef(49.07, 14.1, 12.65)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetCharaPos(0, 30.65, 0.0, -2.05)
	event.SetCharaRot(0, 0.0, 1.3, 0.0)
	event.SetMotion(0, "立ち")
	event.LoadChara(5, "chara/tp01_16a.gltf", "info", 8)
	event.CharaActive(1, 8)
	event.SetCharaPos(8, 48.62, 0.0, 3.43)
	event.SetCharaRot(8, 0.0, -1.78, 0.0)
	event.SetMotion(8, "待機")
	if vm.wait() then
		return skip(1)
	end
	helper_ec0(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ec68643c()
	if vm.skipping() then
		return skip(1)
	end
end

return script
