--!strict
-- map/g/g05/g05_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_136a94b8 = require("@lib/event/helper_136a94b8")
local helper_1be09d2c = require("@lib/event/helper_1be09d2c")
local helper_1e222528 = require("@lib/event/helper_1e222528")
local helper_264dad4b = require("@lib/event/helper_264dad4b")
local helper_4b68ef15 = require("@lib/event/helper_4b68ef15")
local helper_8668c8fd = require("@lib/event/helper_8668c8fd")
local helper_a5fa890e = require("@lib/event/helper_a5fa890e")
local helper_a99ab21d = require("@lib/event/helper_a99ab21d")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_ec3996ac = require("@lib/event/helper_ec3996ac")

--- Program 99.
local function program_99() end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	program_99()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_1be09d2c(40.0, 0.0, 1400.0, vm.f32(3.14))
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 and old_map_no ~= 4 then
			if old_map_no == 109 then
				helper_1be09d2c(0.0, vm.f32(140.7), -1750.0, 0.0)
				event.ResetCamera(1, 3.14, 10.0)
				event.SetFadeIn(30)
			else
				helper_1be09d2c(0.0, 0.0, 1400.0, vm.f32(3.14))
				event.ResetCamera(1, 3.14, 10.0)
				event.SetFadeIn(30)
			end
		end
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4b68ef15(64)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_4b68ef15(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_ec3996ac(155)
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.MapJump(-1, "s34")
	end
end

--- Program 210.
script[210] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_ec3996ac(109)
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		flag = event.GetFlag(702) or flag
		if flag == 0 then
			event.BgmLoadCancel()
		end
		event.MapJump(-1, "d06e01")
	end
end

--- Program 310.
script[310] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			local _ = helper_a99ab21d()
			helper_aafd6a80(30)
		end
		if at <= 4 then
			local _ = helper_1e222528()
			helper_aafd6a80(30)
		end
	end
	if (if helper_a99ab21d() ~= 0 then helper_1e222528() else 0) ~= 0 then
		event.SetMotion(0, "立ち")
		event.SetFadeOut(30)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(1)
		end
		event.SetFlag(744, 1)
		event.SetFlag(748, 1)
		event.MapJump(-1, "s44", 570)
		if vm.wait() then
			return skip(2)
		end
	end
	if helper_a99ab21d() ~= 0 then
		event.SetMotion(0, "立ち")
		event.SetFadeOut(30)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(3)
		end
		event.SetFlag(744, 1)
		event.MapJump(-1, "s44", 550)
		if vm.wait() then
			return skip(4)
		end
	end
	if helper_1e222528() ~= 0 then
		event.SetMotion(0, "立ち")
		event.SetFadeOut(30)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFlag(748, 1)
		event.MapJump(-1, "s44", 560)
		if vm.wait() then
			return skip(6)
		end
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_a5fa890e()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_1be09d2c(0.0, 0.0, -1000.0, vm.f32(3.14))
	end
	helper_264dad4b()
	if vm.skipping() then
		return skip(1)
	end
	event.SetSavedataEtc(0, 9)
	event.LoadSound(7000)
	helper_1be09d2c(0.0, 0.0, -1000.0, vm.f32(3.14))
	event.SetCameraRef(0.0, 30.0, -1000.0)
	event.SetCameraPos(0.0, 50.0, -880.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Program 550.
script[550] = function()
	helper_1be09d2c(0.0, 0.0, -1100.0, 0.0)
	event.SetCameraRef(0.0, 30.0, -1100.0)
	event.SetCameraPos(0.0, 50.0, -1220.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Program 560.
script[560] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8668c8fd(198, 1)
		end
		if at <= 2 then
			helper_8668c8fd(199, 1)
		end
		if at <= 3 then
			helper_136a94b8(1)
		end
	end
	helper_1be09d2c(0.0, 0.0, -1100.0, 0.0)
	event.SetCameraRef(0.0, 30.0, -1100.0)
	event.SetCameraPos(0.0, 50.0, -1220.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(1)
	end
	event.AddItem(198, 1)
	event.AddItem(199, 1)
	helper_8668c8fd(198, 1)
	if vm.skipping() then
		return skip(2)
	end
	helper_8668c8fd(199, 1)
	if vm.skipping() then
		return skip(3)
	end
	helper_136a94b8(1)
	if vm.skipping() then
		return skip(4)
	end
end

return script
