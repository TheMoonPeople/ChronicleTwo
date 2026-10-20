--!strict
-- map/s/s37/s37_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_029160fe = require("@lib/event/helper_029160fe")
local helper_10bdb8ed = require("@lib/event/helper_10bdb8ed")
local helper_5d972db7 = require("@lib/event/helper_5d972db7")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_d683692f = require("@lib/event/helper_d683692f")
local helper_d7cc1cc1 = require("@lib/event/helper_d7cc1cc1")
local helper_d7e2d7c2 = require("@lib/event/helper_d7e2d7c2")
local helper_f3bffb9f = require("@lib/event/helper_f3bffb9f")
local helper_ff5d4b79 = require("@lib/event/helper_ff5d4b79")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_5d972db7()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = helper_10bdb8ed(1)
			helper_aafd6a80(30)
		end
		if at <= 2 then
			helper_d683692f()
		end
		if at <= 3 then
			helper_f3bffb9f()
		end
	end
	print("--------------------------event200-------------------------\n")
	helper_d7cc1cc1(vm.f32(-1.5707964))
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetSndId(2) or var0
	var1 = helper_10bdb8ed(1)
	if var1 ~= 0 then
		event.SetMotion(0, "立ち")
		event.SndSePlay(var0, 94)
		event.SetFadeOut(30)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetCnt(15, 1)
		event.StopBgm(0)
		helper_d683692f()
		if vm.skipping() then
			return skip(3)
		end
	else
		event.SndSePlay(var0, 108)
		helper_f3bffb9f()
		if vm.skipping() then
			return skip(4)
		end
	end
end

--- Program 201.
script[201] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = helper_10bdb8ed(0)
			helper_aafd6a80(30)
		end
		if at <= 2 then
			helper_d683692f()
		end
		if at <= 3 then
			helper_f3bffb9f()
		end
	end
	print("--------------------------event201-------------------------\n")
	helper_d7cc1cc1(vm.f32(1.5707964))
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetSndId(2) or var0
	var1 = helper_10bdb8ed(0)
	if var1 ~= 0 then
		event.SetMotion(0, "立ち")
		event.SndSePlay(var0, 94)
		event.SetFadeOut(30)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetCnt(15, 0)
		event.StopBgm(0)
		helper_d683692f()
		if vm.skipping() then
			return skip(3)
		end
	else
		event.SndSePlay(var0, 108)
		helper_f3bffb9f()
		if vm.skipping() then
			return skip(4)
		end
	end
end

--- Program 202.
script[202] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(30)
		end
	end
	print("--------------------------event202-------------------------\n")
	helper_d7cc1cc1(vm.f32(3.1415927))
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 94)
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(2)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetCnt(0, 1)
	event.SetCharaPos(0, 0.0, -14.0, 235.0)
	event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
	event.StopBgm(0)
	event.MapJump(-1, "s38")
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_029160fe()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s59", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ff5d4b79()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s58", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 520.
script[520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_d7e2d7c2()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s11", 520)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 530.
script[530] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_5d972db7()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s11", 599)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 16480.
script[16480] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_d7e2d7c2()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s11", 520)
	if vm.wait() then
		return skip(2)
	end
end

return script
