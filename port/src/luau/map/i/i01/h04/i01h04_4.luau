--!strict
-- map/i/i01/h04/i01h04_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1e8f7ae6 = require("@lib/event/helper_1e8f7ae6")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")

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
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		helper_1ef0d4b2()
		return
	end
	event.SetEventData(14, 15)
	chara_id = event.GetCharaId(15) or chara_id
	event.SetEventData(13, chara_id)
	helper_1e8f7ae6()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		helper_1ef0d4b2()
		return
	end
	helper_1e8f7ae6()
	if vm.skipping() then
		return skip(1)
	end
end

return script
