--!strict
-- map/s/s32/s32_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_35d0b0c0 = require("@lib/event/helper_35d0b0c0")
local helper_6fb26b13 = require("@lib/event/helper_6fb26b13")
local helper_6fdf54f5 = require("@lib/event/helper_6fdf54f5")
local helper_acaaef23 = require("@lib/event/helper_acaaef23")
local helper_cac13d04 = require("@lib/event/helper_cac13d04")
local helper_da42986f = require("@lib/event/helper_da42986f")
local helper_f0f50717 = require("@lib/event/helper_f0f50717")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
-- Defined empty, so the engine runs this instead of its default.
script[99] = function() end

--- Program 100.
-- Defined empty, so the engine runs this instead of its default.
script[100] = function() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_f0f50717(64)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.CmrsSetPos(0.0, 1000.0, -100.0)
	event.CmrsSetRef(0.0, 1000.0, 0.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.EsmInitialize(5)
	event.EsmLoadBase("Ｅ７３２光雨")
	event.EsmInitFix(5)
	event.EsmCreate("Ｅ７３２光雨")
	event.EsmSetVect1(0.0, 1000.0, 0.0)
	event.EsmSetVect2(100.0, 100.0, 100.0)
	event.EsmSetValue(0, 240)
	if vm.wait() then
		return skip(2)
	end
	helper_f0f50717(64)
	if vm.skipping() then
		return skip(3)
	end
	event.EsmClear()
	event.Finish()
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_acaaef23()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s70", 530)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_cac13d04()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s30", 620)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 610.
script[610] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_35d0b0c0()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s66", 610)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 620.
script[620] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_6fb26b13()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s66", 620)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 630.
script[630] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_da42986f()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s66", 630)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 640.
script[640] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_6fdf54f5()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s66", 650)
	if vm.wait() then
		return skip(2)
	end
end

return script
