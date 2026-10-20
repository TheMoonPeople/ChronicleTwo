--!strict
-- map/s/s54/s54_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0d091e4c = require("@lib/event/helper_0d091e4c")
local helper_1fe11ec4 = require("@lib/event/helper_1fe11ec4")
local helper_36526538 = require("@lib/event/helper_36526538")
local helper_38c16c5d = require("@lib/event/helper_38c16c5d")
local helper_4b68ef15 = require("@lib/event/helper_4b68ef15")
local helper_8d177e5c = require("@lib/event/helper_8d177e5c")
local helper_9f2fc9ef = require("@lib/event/helper_9f2fc9ef")
local helper_a36ec6d8 = require("@lib/event/helper_a36ec6d8")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_d0885087 = require("@lib/event/helper_d0885087")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	event.StopBgm(0)
	event.LoadSound(8684)
	flag = event.GetFlag(808) or flag
	if flag == 1 then
		helper_a36ec6d8()
	end
end

--- Program 28010.
local function program_28010()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(6)
		end
		helper_8d177e5c(0.0, 0.0, 300.0, 0.0)
	end
	event.Initialize()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_aafd6a80(6)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(107)
	event.PlayBgm(0)
	event.LoadMonsterFile(628, 1)
	event.LoadMonsterFile(1006, 0)
	event.AutoSetMonster(628, 0.0, 0.0, 800.0, 0.0, 3.14, 0.0)
	helper_8d177e5c(0.0, 0.0, 300.0, 0.0)
	event.SetCameraRef(0.0, 30.0, 300.0)
	event.SetCameraPos(0.0, 40.0, 180.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	event.Finish()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_8d177e5c(0.0, 0.0, 300.0, 0.0)
	end
	program_99()
	helper_8d177e5c(0.0, 0.0, 0.0, 0.0)
	event.SetCameraRef(0.0, 30.0, 0.0)
	event.SetCameraPos(0.0, 40.0, -120.0)
	event.ResetCamera(0)
	flag = event.GetFlag(808) or flag
	if flag == 0 then
		helper_9f2fc9ef()
		if vm.skipping() then
			return skip(1)
		end
		event.SetBitCtrl(1, 1)
		if vm.wait() then
			return skip(2)
		end
		helper_8d177e5c(0.0, 0.0, 300.0, 0.0)
		event.SetCameraRef(0.0, 30.0, 300.0)
		event.SetCameraPos(0.0, 40.0, 180.0)
		event.ResetCamera(0)
		event.LoadMonsterFile(628, 1)
		event.LoadMonsterFile(1006, 0)
		event.AutoSetMonster(628, 0.0, 0.0, 800.0, 0.0, 3.14, 0.0)
	end
	event.SetFadeIn(30)
	event.Finish()
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

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_28010()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 300.
script[300] = function()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local stage_id: s32 = 0
	local var3: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_36526538(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_aafd6a80(30)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_36526538(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_36526538(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var1 = helper_d0885087(0, 10, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(4)
		end
		stage_id = event.DngGetStageId() or stage_id
		var3 = event.DngGetFloorId() or var3
		argc = event.GetNextFloor(var3, 0) or argc
		event.DngSetFloorId(argc)
		event.SetFloorInfo(stage_id, var3, 5, 2)
		event.SetFloorInfo(stage_id, argc, 5, 1)
		event.LoadScript("d07/d07.stb", 1000)
	else
		event.Finish()
	end
end

--- Program 500.
script[500] = function()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d091e4c()
			if not vm.skipping() then
				return part2()
			end
		end
		helper_a36ec6d8()
		helper_8d177e5c(0.0, 0.0, 700.0, 0.0)
	end
	function part2()
		event.SetBitCtrl(1, 0)
		helper_a36ec6d8()
		helper_8d177e5c(0.0, 0.0, 700.0, 0.0)
		event.SetCameraRef(0.0, 30.0, 700.0)
		event.SetCameraPos(0.0, 40.0, 580.0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.FadeOutBgm(20)
	event.SetFadeOut(20)
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(1)
	end
	event.StopBgm(0)
	event.DelMonster(-1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
	end
	helper_0d091e4c()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 1200.
script[1200] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local value: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1fe11ec4(0, 8590070)
			end
			return
		end
	end
	flag = event.GetFlag(808) or flag
	flag_2 = event.GetFlag(812) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = 0
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_1fe11ec4(0, 8590060)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_1fe11ec4(0, 8590070)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	helper_38c16c5d(0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 18080.
script[18080] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_99()
	helper_9f2fc9ef()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 18120.
script[18120] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_99()
	helper_0d091e4c()
	if vm.skipping() then
		return skip(1)
	end
end

script[28010] = program_28010

return script
