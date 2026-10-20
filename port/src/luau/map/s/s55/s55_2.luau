--!strict
-- map/s/s55/s55_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06266606 = require("@lib/event/helper_06266606")
local helper_5098f0de = require("@lib/event/helper_5098f0de")
local helper_5f8ee1e3 = require("@lib/event/helper_5f8ee1e3")
local helper_7269e9ef = require("@lib/event/helper_7269e9ef")
local helper_940344b8 = require("@lib/event/helper_940344b8")
local helper_ebb00530 = require("@lib/event/helper_ebb00530")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")
local helper_f5607cd0 = require("@lib/event/helper_f5607cd0")

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
	local part2: () -> ...any
	local part3: () -> ...any
	local part4: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7269e9ef()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_940344b8()
			if not vm.skipping() then
				return part3()
			end
		end
		if at <= 3 then
			helper_f5607cd0()
			if not vm.skipping() then
				return part4()
			end
		end
	end
	function part2()
		helper_940344b8()
		if vm.skipping() then
			return skip(3)
		end
		return part3()
	end
	function part3()
		helper_f5607cd0()
		if vm.skipping() then
			return skip(4)
		end
		return part4()
	end
	function part4() end
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_7269e9ef()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_5098f0de()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "f30", 601)
end

--- Program 601.
script[601] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_06266606()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "f30", 602)
end

--- Program 602.
script[602] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ebb00530()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "f30", 603)
end

--- Program 603.
script[603] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_5f8ee1e3()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "f30", 604)
end

return script
