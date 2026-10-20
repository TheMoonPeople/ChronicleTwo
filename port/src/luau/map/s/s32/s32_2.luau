--!strict
-- map/s/s32/s32_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_064d6496 = require("@lib/event/helper_064d6496")
local helper_06729ac6 = require("@lib/event/helper_06729ac6")
local helper_64d0cf63 = require("@lib/event/helper_64d0cf63")
local helper_9b2accde = require("@lib/event/helper_9b2accde")
local helper_c9300dcf = require("@lib/event/helper_c9300dcf")
local helper_e1d23ade = require("@lib/event/helper_e1d23ade")
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
	helper_9b2accde()
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
	helper_06729ac6()
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
	helper_e1d23ade()
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
	helper_c9300dcf()
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
	helper_64d0cf63()
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
	helper_064d6496()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s66", 650)
	if vm.wait() then
		return skip(2)
	end
end

return script
