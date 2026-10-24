--!strict
-- map/m/m03/m03_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_20e47713 = require("@lib/event/helper_20e47713")
local helper_9ef8527b = require("@lib/event/helper_9ef8527b")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")

--- Program 99.
local function program_99() end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	program_99()
	print("e109a kita----------\n")
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9ef8527b(64)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_9ef8527b(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_9ef8527b(64)
			end
			if vm.skip_end() then
				return skip(3)
			end
			return part2()
		end
		if at <= 3 then
			helper_ed0a80b8(30)
		end
	end
	function part2()
		event.SetFadeOut(30)
		helper_ed0a80b8(30)
		if vm.skipping() then
			return skip(4)
		end
		event.DeleteChara(32)
		event.CharaActive(1, 0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e100/e109/e109_starble.chr", "info", 32)
	event.EohSyncChara(0, 32)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	print("m03-e109a---------------------------------\n")
	event.InitDramaScene()
	event.CharaActive(0, 0)
	event.CharaActive(1, 32)
	event.CmrsSetPos(1984.9, 50.0, 3002.6)
	event.CmrsSetRef(1984.9, 30.0, 2882.6)
	event.ObjsSetPos(0, 1984.9, 0.0, 2882.6)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(1)
	end
	helper_9ef8527b(64)
	if vm.skipping() then
		return skip(2)
	end
	event.CancelDramaScene()
	return part2()
end

--- Program 11091.
script[11091] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_20e47713()
	if vm.skipping() then
		return skip(1)
	end
	event.CancelLoadVillager()
	if vm.wait() then
		return skip(2)
	end
	event.GotoInterior(-1, "i03h01a", 500)
	if vm.wait() then
		return skip(3)
	end
end

return script
