--!strict
-- map/s/s33/s33_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_83ae408e = require("@lib/event/helper_83ae408e")
local helper_8941f822 = require("@lib/event/helper_8941f822")
local helper_97f655f8 = require("@lib/event/helper_97f655f8")
local helper_a56b0e49 = require("@lib/event/helper_a56b0e49")
local helper_c7ca9412 = require("@lib/event/helper_c7ca9412")
local helper_dabc0c0a = require("@lib/event/helper_dabc0c0a")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_dabc0c0a(0.0, 0.0, 2300.0, vm.f32(3.14))
	end
	flag = event.GetFlag(600) or flag
	flag_2 = event.GetFlag(604) or flag_2
	if flag == 1 and flag_2 == 0 then
		helper_8941f822()
		if vm.skipping() then
			return skip(1)
		end
	else
		if flag_2 == 1 then
			event.EohSyncObj(0, "p01_s3302-0", "s330208-m0")
			event.EohSyncObj(1, "p01_s3302-0", "s330208-m1")
			event.EohSetRot(0, 0.0, 0.61, 0.0)
			event.EohSetRot(1, 0.0, -0.61, 0.0)
		end
		helper_dabc0c0a(0.0, 0.0, 2300.0, vm.f32(3.14))
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_83ae408e()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_97f655f8()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.BgmLoadCancel()
		event.GotoDng(5, -1, 500)
	end
end

--- Program 210.
script[210] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_a56b0e49()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.MapJump(-1, "s31")
	end
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_c7ca9412()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "f02", 510)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 16040.
script[16040] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_8941f822()
	if vm.skipping() then
		return skip(1)
	end
end

return script
