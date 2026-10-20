--!strict
-- map/i/i04/h02/i04h02b.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_315544cc = require("@lib/event/helper_315544cc")
local helper_39c23b75 = require("@lib/event/helper_39c23b75")
local helper_b2ebd4c4 = require("@lib/event/helper_b2ebd4c4")

--- Helper function.
local function helper_84a8(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_b2ebd4c4(arg0)
	end
	local _ = helper_315544cc(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_39c23b75(arg0, 0, var6)
	if vm.skipping() then
		return skip(1)
	end
	helper_b2ebd4c4(arg0)
end

--- Helper function.
local function helper_c5fc(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(1, 4)
	helper_125385ee(1, 4)
	helper_84a8(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(1)
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
	function skip(at: number) end
	helper_c5fc(0)
	if vm.skipping() then
		return skip(1)
	end
end

return script
