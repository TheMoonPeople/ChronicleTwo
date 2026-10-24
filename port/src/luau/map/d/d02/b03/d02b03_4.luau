--!strict
-- map/d/d02/b03/d02b03_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5cb21b5c = require("@lib/event/helper_5cb21b5c")
local helper_7085f747 = require("@lib/event/helper_7085f747")
local helper_914a4b77 = require("@lib/event/helper_914a4b77")
local helper_cc7603b9 = require("@lib/event/helper_cc7603b9")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.MesMake_2(0, "どどーん")
	helper_cc7603b9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	event.SetCharaPos(0, -124.13, 782.88, -644.77)
	event.SetFadeIn(30)
	event.ResetCamera(0)
end

--- Program 400.
script[400] = function()
	local var0: s32 = 0
	local flag: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_cc7603b9(0, -1, 5, 0, 0)
		end
		if at <= 3 then
			helper_914a4b77()
		end
		if at <= 4 then
			helper_5cb21b5c()
		end
		if at <= 6 then
			helper_7085f747()
		end
		if at <= 7 then
			helper_5cb21b5c()
		end
	end
	print("event400\n")
	var0 = event.GetEventData_2(6) or var0
	if var0 == 1 then
		flag = event.GetFlag(24) or flag
		if flag ~= 0 then
		else
			flag = event.GetFlag(23) or flag
			if flag ~= 0 then
				event.SetMesShippo(0, 0)
				event.MesMake_2(
					0,
					"Qui c'[UNI00e8] un germoglio enorme.\nSembra manchi ancora qualcosa.<page>Si potr[UNI00e0] accelerare la crescita?\n(Usa (#) per accedere al Menu.)"
				)
				helper_cc7603b9(0, -1, 5, 0, 0)
				if vm.skipping() then
					return skip(1)
				end
				event.SetMesShippo(0, 1)
			else
				event.SetMesShippo(0, 0)
				event.MesMake_2(
					0,
					"Qui c'[UNI00e8] una piccola palude.\nHa qualcosa di misterioso...\n(Usa (#) per accedere al Menu.)"
				)
				helper_cc7603b9(0, -1, 5, 0, 0)
				if vm.skipping() then
					return skip(2)
				end
				event.SetMesShippo(0, 1)
			end
		end
	end
	if var0 == 2 then
		flag = event.GetFlag(24) or flag
		if flag ~= 0 then
		else
			flag = event.GetFlag(23) or flag
			if flag ~= 0 then
				event.GotoUseItem(356)
				do
					local skipped = vm.wait()
					var2 = event.DeferredOutput() or var2
					if skipped then
						return skip(3)
					end
				end
				if var2 == 356 then
					helper_914a4b77()
					if vm.skipping() then
						return skip(4)
					end
					event.SetFlag(24, 1)
				else
					helper_5cb21b5c()
					if vm.skipping() then
						return skip(5)
					end
				end
			else
				event.GotoUseItem(361)
				do
					local skipped = vm.wait()
					var2 = event.DeferredOutput() or var2
					if skipped then
						return skip(6)
					end
				end
				if var2 == 361 then
					helper_7085f747()
					if vm.skipping() then
						return skip(7)
					end
					event.SetFlag(23, 1)
				else
					helper_5cb21b5c()
					if vm.skipping() then
						return skip(8)
					end
				end
			end
		end
	end
end

return script
