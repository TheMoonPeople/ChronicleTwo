--!strict
-- map/s/s13/s13_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_057b781f = require("@lib/event/helper_057b781f")
local helper_2386f745 = require("@lib/event/helper_2386f745")
local helper_2ad1600a = require("@lib/event/helper_2ad1600a")
local helper_2cd0005b = require("@lib/event/helper_2cd0005b")
local helper_6f70f976 = require("@lib/event/helper_6f70f976")
local helper_93df337e = require("@lib/event/helper_93df337e")
local helper_a26e53e3 = require("@lib/event/helper_a26e53e3")
local helper_ad417018 = require("@lib/event/helper_ad417018")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_daa12212 = require("@lib/event/helper_daa12212")
local helper_deb7b054 = require("@lib/event/helper_deb7b054")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	event.StopBgm(0)
	event.LoadSound(2694)
	flag = event.GetFlag(624) or flag
	if flag == 1 then
		helper_93df337e()
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
		helper_2cd0005b(0.0, 0.0, 1000.0, vm.f32(3.14))
	end
	event.Initialize()
	program_99()
	flag = event.GetFlag(624) or flag
	if flag == 0 then
		helper_057b781f()
		if vm.skipping() then
			return skip(1)
		end
		event.FuncPointShow("", "rapis", 0)
		event.LoadMonsterFile(609, 1)
		event.LoadMonsterFile(610, 0)
		event.AutoSetMonster(609, 0.0, 0.0, -800.0, 0.0, 0.0, 0.0)
	end
	event.SetBitCtrl(1, if flag == 0 then 1 else 0)
	helper_2cd0005b(0.0, 0.0, 1000.0, vm.f32(3.14))
	event.SetCameraRef(0.0, 30.0, 1000.0)
	event.SetCameraPos(0.0, 40.0, 1120.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_057b781f()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 160.
script[160] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6f70f976(64)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_6f70f976(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 161.
script[161] = function()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c1c32f84(6)
		end
		if at <= 2 then
			helper_2386f745(0)
		end
		if at <= 3 then
			print("pos[0]=", string.format("%f", pos_x), "---------------\n")
			print("pos[1]=", string.format("%f", pos_y), "---------------\n")
			print("pos[2]=", string.format("%f", pos_z), "---------------\n")
		end
		if at <= 4 then
			helper_6f70f976(64)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetStatus(1, 0, 256, 1)
	event.LoadMotion(5, "event/time_gate/blue/c02a_warp.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetCharaPos(0, 91.79, 22.67, -311.8)
	event.SetCharaRot(0, 0.0, 2.52, 0.0)
	event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 8)
	event.CharaActive(1, 8)
	event.SetCharaPos(0, 91.79, -0.0, -311.8)
	event.SetCharaRot(0, 0.0, 2.52, 0.0)
	event.SetCharaPos(8, 93.06, 22.75, -313.0)
	event.SetCharaRot(8, 0.0, 2.44, 0.0)
	event.SetMotion(8, "発動", 4)
	helper_c1c32f84(6)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMotion(8, "発動", 1)
	event.ObjsSetMotion(0, "タイムワープ", 6)
	event.ObjsNextMotion(0, "タイムワープL", 5)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(3)
	end
	do
		local out1, out2, out3 = event.EohGetFramePos(0, "atoramiria")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	print("pos[0]=", string.format("%f", pos_x), "---------------\n")
	print("pos[1]=", string.format("%f", pos_y), "---------------\n")
	print("pos[2]=", string.format("%f", pos_z), "---------------\n")
	event.SetCharaPos(0, 91.79, -0.0, -311.8)
	event.SetCharaRot(0, 0.0, 2.52, 0.0)
	if vm.wait() then
		return skip(4)
	end
	helper_6f70f976(64)
	if vm.skipping() then
		return skip(5)
	end
	event.DelExtMotion(0)
	event.DeleteChara(8)
	event.SetStatus(1, 0, 256, 0)
	event.Finish()
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
				helper_daa12212(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			helper_c1c32f84(15)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_daa12212(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_daa12212(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	flag = event.GetFlag(624) or flag
	if flag == 0 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		event.MesMake_2(0, "Tu n'as pas encore la pierre !")
		helper_daa12212(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(3)
		end
		event.Finish()
		return
	end
	var2 = helper_a26e53e3(2, -1)
	if vm.skipping() then
		return skip(4)
	end
	if var2 == 0 then
		event.SetFadeOut(15)
		helper_c1c32f84(15)
		if vm.skipping() then
			return skip(5)
		end
		event.DelMonster(-1)
		event.LoadScript("d02/d02.stb", 1000)
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
				helper_daa12212(0, 23, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_ad417018()
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
			helper_daa12212(0, 22, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_daa12212(0, 23, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	event.AddItem(365, 1)
	event.SetFadeOut(10)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(3)
	end
	stage_id = event.DngGetStageId() or stage_id
	var2 = event.DngGetFloorId() or var2
	event.SetFloorInfo(stage_id, var2, 5, 2)
	helper_ad417018()
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Program 550.
-- Defined empty, so the engine runs this instead of its default.
script[550] = function() end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.DelMonster(-1)
	event.ActchrSetDefMotion(0)
	event.FuncPointShow("", "rapis", 1)
	event.SetLoadbgFile("snd2/bgm/bg_193.sound.json")
	helper_deb7b054()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgmPack(193)
	event.PlayBgm(0)
	event.Finish()
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2ad1600a(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 26010.
script[26010] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c1c32f84(4)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadMonsterFile(609, 1)
	event.LoadMonsterFile(610, 0)
	event.AutoSetMonster(609, 0.0, 0.0, -800.0, 0.0, 0.0, 0.0)
	event.DngPause(16384, 1)
	event.StopBgm(0)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(190)
	event.PlayBgm(0)
	event.SetFadeIn(30)
	event.Finish()
end

return script
