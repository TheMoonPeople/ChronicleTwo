--!strict
-- map/i/i04/h02/i04h02a_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_19ec2b45 = require("@lib/event/helper_19ec2b45")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_3af20891 = require("@lib/event/helper_3af20891")

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
			helper_19ec2b45(64)
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
	helper_19ec2b45(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3af20891()
	if vm.skipping() then
		return skip(1)
	end
end

return script
