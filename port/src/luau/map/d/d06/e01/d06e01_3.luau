--!strict
-- map/d/d06/e01/d06e01_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_079d3d9b = require("@lib/event/helper_079d3d9b")
local helper_100ac525 = require("@lib/event/helper_100ac525")
local helper_19f46db4 = require("@lib/event/helper_19f46db4")
local helper_2b7a517c = require("@lib/event/helper_2b7a517c")
local helper_2dd024be = require("@lib/event/helper_2dd024be")
local helper_6492ac5f = require("@lib/event/helper_6492ac5f")
local helper_73ea637d = require("@lib/event/helper_73ea637d")
local helper_8bb82531 = require("@lib/event/helper_8bb82531")
local helper_8d53dd04 = require("@lib/event/helper_8d53dd04")
local helper_a1362407 = require("@lib/event/helper_a1362407")
local helper_a77b24cf = require("@lib/event/helper_a77b24cf")
local helper_ac1d9bd8 = require("@lib/event/helper_ac1d9bd8")
local helper_ac63c923 = require("@lib/event/helper_ac63c923")
local helper_be98a013 = require("@lib/event/helper_be98a013")
local helper_df37a2d4 = require("@lib/event/helper_df37a2d4")
local helper_e489003d = require("@lib/event/helper_e489003d")
local helper_eb344bc3 = require("@lib/event/helper_eb344bc3")
local helper_fc8fdf1e = require("@lib/event/helper_fc8fdf1e")

--- Program 99.
local function program_99() end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local flag: s32 = 0
	local old_map_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_6492ac5f(vm.f32(649.7), 0.0, vm.f32(-122.2), vm.f32(1.71))
	end
	program_99()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_6492ac5f(20.0, 280.0, -600.0, vm.f32(3.14))
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
	else
		flag = event.GetFlag(702) or flag
		if flag == 0 then
			helper_8bb82531()
			if vm.skipping() then
				return skip(1)
			end
			helper_6492ac5f(vm.f32(649.7), 0.0, vm.f32(-122.2), vm.f32(1.71))
			event.ResetCamera(1, 3.14, 0.0)
			event.SetFadeIn(30)
			return
		end
		old_map_no = event.GetOldMapNo() or old_map_no
		var3 = event.GetMapType(old_map_no) or var3
		if var3 ~= -1 then
			if old_map_no == 128 or var3 == 7 or var3 == 8 then
				helper_6492ac5f(0.0, 280.0, -650.0, 0.0)
				event.ResetCamera(1, 3.14, 10.0)
				event.SetFadeIn(30)
			else
				helper_6492ac5f(0.0, 0.0, 600.0, vm.f32(3.14))
				event.ResetCamera(1, 3.14, 10.0)
				event.SetFadeIn(30)
			end
		end
	end
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_100ac525(4)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_100ac525(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(36)
	event.PlayBgm(0)
	event.EohSyncObj(0, "p05_d06e01-0")
	event.EohSetShow(0, 1)
	event.SetFadeIn(30)
	event.LoadMonsterFile(515, 1)
	event.AutoSetMonster(515, 0.4, 62.5, -115.7, 0.0, 0.0, 0.0)
	event.Finish()
end

--- Program 152.
script[152] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a77b24cf(0, -1, 8, 0, 0)
		end
		if at <= 2 then
			helper_100ac525(30)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.DngPause(15, 1)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 0, 0, 0, 128)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetColor(0, 128.0, 128.0, 128.0, 0.0, 30)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(0, 0.0, 0.0, 0.0, 128.0)
	event.SetMesWindowMode(0, 7)
	event.SetFadeIn(15)
	event.MesMake_2(0, "e610『グリフォンの言い分』")
	helper_a77b24cf(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetColor(0, 0.0, 0.0, 0.0, 0.0, 30)
	helper_100ac525(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SpriteSetDraw(0, 0)
	event.DngPause(15, 0)
	event.Finish()
end

--- Program 153.
script[153] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a77b24cf(0, -1, 8, 0, 0)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.SetFadeIn(15)
	event.MesMake_2(0, "勝利")
	helper_a77b24cf(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.Finish()
end

--- Program 154.
script[154] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.AddItem(19, 1)
	event.AddItem(8, 1)
	event.AddItem(30, 1)
	event.AddItem(33, 1)
	event.AddItem(38, 1)
	event.AddItem(77, 1)
	event.AddItem(80, 1)
	event.AddItem(59, 1)
	event.AddItem(87, 1)
	event.AddItem(55, 1)
	event.AddItem(72, 1)
	event.AddItem(84, 1)
	event.AddItem(63, 1)
	event.AddItem(107, 1)
	event.AddItem(96, 1)
	event.AddItem(99, 1)
	event.AddItem(105, 1)
	event.Finish()
end

--- Program 155.
script[155] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fc8fdf1e(64)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_fc8fdf1e(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 160.
script[160] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fc8fdf1e(64)
		end
	end
	event.SetCameraPos(0.0, 0.0, 0.0)
	event.SetCameraRef(0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(1)
	end
	helper_fc8fdf1e(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 200.
script[200] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			local _ = helper_eb344bc3()
		end
	end
	argc = event.GetNowLoopNo() or argc
	if argc == 1 then
		local t0 = helper_19f46db4()
		if vm.skipping() then
			return skip(1)
		end
		if t0 ~= 0 then
			event.MapJump(-1, "g05")
			if vm.wait() then
				return skip(2)
			end
		end
	else
		local t1 = helper_eb344bc3()
		if vm.skipping() then
			return skip(3)
		end
		if t1 ~= 0 then
			event.SetBitCtrl(1, 0)
			event.GotoEdit(177, 100)
		end
	end
end

--- Program 210.
script[210] = function()
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_2b7a517c()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.DngSetStageId(5)
		event.GotoMenu(3, 5)
		if vm.wait() then
			return skip(2)
		end
		do
			local _, _, out3, _ = event.GetMenuParam_4()
			var2 = out3 or var2
		end
		if var2 == 0 then
			event.SetFadeIn(30)
			return
		else
			if var2 == 26 then
				event.BgmLoadCancel()
			end
			event.GotoDng(5, var2, 1010)
		end
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_df37a2d4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 401.
script[401] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ac1d9bd8(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 402.
script[402] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ac1d9bd8(1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 403.
script[403] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ac1d9bd8(2)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 404.
script[404] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ac1d9bd8(3)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 405.
script[405] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ac1d9bd8(4)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 406.
script[406] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ac1d9bd8(5)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 407.
script[407] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ac1d9bd8(6)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 408.
script[408] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ac1d9bd8(7)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8d53dd04()
		end
		helper_6492ac5f(0.0, 0.0, 600.0, vm.f32(3.14))
	end
	helper_ac63c923()
	if vm.skipping() then
		return skip(1)
	end
	event.FuncPointShow("", "exit", 0)
	event.FuncPointShow("", "in_dng", 0)
	helper_8d53dd04()
	event.SetBitCtrl(1, 1)
	if vm.wait() then
		return skip(2)
	end
	event.EohSyncObj(0, "p05_d06e01-0")
	event.EohSetShow(0, 1)
	event.LoadMonsterFile(515, 1)
	event.AutoSetMonster(515, 0.4, 62.5, -115.7, 0.0, 0.0, 0.0)
	helper_6492ac5f(0.0, 0.0, 600.0, vm.f32(3.14))
	event.SetCameraRef(0.0, 30.0, 600.0)
	event.SetCameraPos(0.0, 40.0, 720.0)
	event.ResetCamera(0)
	event.SetFadeIn(20)
	event.Finish()
end

--- Program 502.
script[502] = function()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_079d3d9b()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetCharaPos(0, var0, var1, var2)
		event.SetCharaRot(0, var3, var4, var5)
		event.SetCameraPos(pos_x, pos_y, pos_z)
		event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
		event.ResetCamera(0)
		event.DngPause(1041, 0)
		event.SetFadeIn(10)
		event.Finish()
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(10)
	helper_100ac525(10)
	if vm.skipping() then
		return skip(1)
	end
	event.SndSeAllStop(5)
	event.DngPause(1041, 1)
	event.DngEffectAllClear()
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = event.GetCharaRot(0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetCameraRef()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	helper_079d3d9b()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 504.
script[504] = function()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a1362407()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetBitCtrl(8, 1)
		event.LoadDungeonMapFile("s31")
		event.LoadScript("s31/s31.stb", 510)
		if vm.wait() then
			return skip(3)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(10)
	helper_100ac525(10)
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
	end
	event.DelMonster(-1)
	helper_a1362407()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 506.
script[506] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_73ea637d()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("s35")
	event.LoadScript("s35/s35.stb", 502)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 508.
script[508] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2dd024be()
	if vm.skipping() then
		return skip(1)
	end
	event.SetBitCtrl(1, 0)
	event.GotoEdit(187, 100)
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
				helper_e489003d(0, 8550090)
			end
			return
		end
	end
	flag = event.GetFlag(608) or flag
	flag_2 = event.GetFlag(612) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_e489003d(0, 8550080)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_e489003d(0, 8550090)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	helper_be98a013(0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 16080.
script[16080] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ac63c923()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 16100.
script[16100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_079d3d9b()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 16120.
script[16120] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_a1362407()
	if vm.skipping() then
		return skip(1)
	end
	event.SetBitCtrl(8, 1)
	event.LoadDungeonMapFile("s31")
	event.LoadScript("s31/s31.stb", 510)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 17020.
script[17020] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_8bb82531()
	if vm.skipping() then
		return skip(1)
	end
end

return script
