--!strict
-- map/s/s16/s16_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3aa592d7 = require("@lib/event/helper_3aa592d7")
local helper_4e334a8e = require("@lib/event/helper_4e334a8e")
local helper_5486f7a5 = require("@lib/event/helper_5486f7a5")
local helper_ab9c465c = require("@lib/event/helper_ab9c465c")
local helper_adea7ba0 = require("@lib/event/helper_adea7ba0")
local helper_b055e396 = require("@lib/event/helper_b055e396")
local helper_b1f7144b = require("@lib/event/helper_b1f7144b")
local helper_dc17ca57 = require("@lib/event/helper_dc17ca57")
local helper_fd5ce08a = require("@lib/event/helper_fd5ce08a")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	event.StopBgm(0)
	event.LoadSound(5694)
	flag = event.GetFlag(636) or flag
	if flag == 1 then
		helper_b1f7144b()
	end
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
		helper_ab9c465c(0.0, vm.f32(33.9), vm.f32(1530.4), vm.f32(3.14))
	end
	event.Initialize()
	program_99()
	flag = event.GetFlag(636) or flag
	if flag == 0 then
		helper_dc17ca57()
		if vm.skipping() then
			return skip(1)
		end
		event.FuncPointShow("", "rapis", 0)
		event.LoadMonsterFile(613, 1)
		event.AutoSetMonster(613, 0.0, 0.0, -200.0, 0.0, 0.0, 0.0)
	end
	event.SetBitCtrl(1, if flag == 0 then 1 else 0)
	helper_ab9c465c(0.0, vm.f32(33.9), vm.f32(1530.4), vm.f32(3.14))
	event.SetCameraRef(0.0, 63.9, 1530.4)
	event.SetCameraPos(0.0, 83.9, 1650.4)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_dc17ca57()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b055e396(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			helper_adea7ba0(15)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_b055e396(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_b055e396(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	flag = event.GetFlag(636) or flag
	if flag == 0 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		event.MesMake_2(0, "Tu n'as pas encore la pierre !")
		helper_b055e396(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(3)
		end
		event.Finish()
		return
	end
	var2 = helper_5486f7a5(2, -1)
	if vm.skipping() then
		return skip(4)
	end
	if var2 == 0 then
		event.SetFadeOut(15)
		helper_adea7ba0(15)
		if vm.skipping() then
			return skip(5)
		end
		event.DelMonster(-1)
		event.LoadScript("d05/d05.stb", 1000)
	end
	event.Finish()
end

--- Program 500.
script[500] = function()
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b055e396(0, 23, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_3aa592d7()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetBitCtrl(1, 0)
		event.SetFadeIn(10)
		event.Finish()
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_b055e396(0, 22, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_b055e396(0, 23, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	event.AddItem(368, 1)
	event.SetFadeOut(10)
	helper_adea7ba0(10)
	if vm.skipping() then
		return skip(3)
	end
	stage_id = event.DngGetStageId() or stage_id
	var2 = event.DngGetFloorId() or var2
	event.SetFloorInfo(stage_id, var2, 5, 2)
	helper_3aa592d7()
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_fd5ce08a(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1500.
script[1500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.DelMonster(-1)
	event.FuncPointShow("", "rapis", 1)
	event.SetLoadbgFile("snd2/bgm/bg_193.sound.json")
	helper_4e334a8e()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgmPack(193)
	event.PlayBgm(0)
	event.Finish()
end

--- Program 26040.
script[26040] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_adea7ba0(4)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadMonsterFile(613, 1)
	event.AutoSetMonster(613, 0.0, 0.0, -200.0, 0.0, 0.0, 0.0)
	event.DngPause(16384, 1)
	event.StopBgm(0)
	helper_adea7ba0(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(190)
	event.PlayBgm(0)
	event.SetFadeIn(30)
	event.Finish()
end

return script
