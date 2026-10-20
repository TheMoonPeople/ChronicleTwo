--!strict
-- map/i/i01/h02/i01h02.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_516932d0 = require("@lib/event/helper_516932d0")
local helper_c026e6fb = require("@lib/event/helper_c026e6fb")
local helper_ffe53b10 = require("@lib/event/helper_ffe53b10")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	helper_1ef0d4b2()
	event.Initialize()
	event.SetCharaPos(0, -5.0, 0.0, 82.0)
	event.SetCharaRot(0, 0, 3.14, 0)
	event.SetMotion(0, "立ち")
	event.ResetCamera(1)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ffe53b10()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 400.
script[400] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	event.SetEventData(14, 12)
	var0 = 24
	event.SetEventData(13, var0)
	var1 = event.GetSavedataEtc(0) or var1
	if var1 == 100 then
		helper_516932d0()
		if vm.skipping() then
			return skip(1)
		end
		event.SetAi(1, var0)
		return
	end
	helper_c026e6fb()
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	var0 = event.GetEventData_2(13) or var0
	var1 = event.GetSavedataEtc(0) or var1
	if var1 == 100 then
		helper_516932d0()
		if vm.skipping() then
			return skip(1)
		end
		event.SetAi(1, var0)
		return
	end
	helper_c026e6fb()
	if vm.skipping() then
		return skip(2)
	end
end

return script
