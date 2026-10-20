--!strict
-- map/d/d02/b03/d02b03_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2b2441c3 = require("@lib/event/helper_2b2441c3")
local helper_7d5c69de = require("@lib/event/helper_7d5c69de")
local helper_9fc4f98d = require("@lib/event/helper_9fc4f98d")
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
			helper_7d5c69de()
		end
		if at <= 4 then
			helper_2b2441c3()
		end
		if at <= 6 then
			helper_9fc4f98d()
		end
		if at <= 7 then
			helper_2b2441c3()
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
					"Aqu[UNI00ed] hay un brote enorme.\nTodav[UNI00ed]a falta algo.<page>[UNI00bf]Ser[UNI00e1] un objeto para que las plantas crezcan m[UNI00e1]s r[UNI00e1]pido...?\n(Pulsa (#) para abrir el men[UNI00fa].)"
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
					"Aqu[UNI00ed] hay un pantanito. Es un poco\nextra[UNI00f1]o...\n(Pulsa (#) para abrir el men[UNI00fa].)"
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
					helper_7d5c69de()
					if vm.skipping() then
						return skip(4)
					end
					event.SetFlag(24, 1)
				else
					helper_2b2441c3()
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
					helper_9fc4f98d()
					if vm.skipping() then
						return skip(7)
					end
					event.SetFlag(23, 1)
				else
					helper_2b2441c3()
					if vm.skipping() then
						return skip(8)
					end
				end
			end
		end
	end
end

return script
