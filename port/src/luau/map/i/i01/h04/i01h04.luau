--!strict
-- map/i/i01/h04/i01h04.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9d142a11 = require("@lib/event/helper_9d142a11")
local helper_c026e6fb = require("@lib/event/helper_c026e6fb")

--- Helper function.
local function helper_35ab4()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.CtrlcStay()
	var0 = 24
	event.SetAi(0, var0)
	event.MesMake_2(0, "Claire? I don't know.<page>She might be at the \nsquare drinking tea.")
	helper_9d142a11(var0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetAi(1, var0)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
-- Defined empty, so the engine runs this instead of its default.
script[100] = function() end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 550.
script[550] = function()
	local var0: s32 = 0
	local chara_id: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		helper_35ab4()
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetEventData(14, 15)
	chara_id = event.GetCharaId(15) or chara_id
	event.SetEventData(13, chara_id)
	helper_c026e6fb()
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		helper_35ab4()
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	helper_c026e6fb()
	if vm.skipping() then
		return skip(2)
	end
end

return script
