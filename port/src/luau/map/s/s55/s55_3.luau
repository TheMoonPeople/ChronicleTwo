--!strict
-- map/s/s55/s55_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0bb12b83 = require("@lib/event/helper_0bb12b83")
local helper_526e72e3 = require("@lib/event/helper_526e72e3")
local helper_5762c64f = require("@lib/event/helper_5762c64f")
local helper_8153b798 = require("@lib/event/helper_8153b798")
local helper_817d9526 = require("@lib/event/helper_817d9526")
local helper_9e9a52bf = require("@lib/event/helper_9e9a52bf")
local helper_d050e5af = require("@lib/event/helper_d050e5af")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")

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
			helper_0bb12b83()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_817d9526()
			if not vm.skipping() then
				return part3()
			end
		end
		if at <= 3 then
			helper_9e9a52bf()
			if not vm.skipping() then
				return part4()
			end
		end
	end
	function part2()
		helper_817d9526()
		if vm.skipping() then
			return skip(3)
		end
		return part3()
	end
	function part3()
		helper_9e9a52bf()
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
	helper_0bb12b83()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_d050e5af()
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
	helper_526e72e3()
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
	helper_8153b798()
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
	helper_5762c64f()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "f30", 604)
end

return script
