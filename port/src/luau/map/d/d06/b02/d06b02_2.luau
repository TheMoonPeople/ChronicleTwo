--!strict
-- map/d/d06/b02/d06b02_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_018b520e = require("@lib/event/helper_018b520e")
local helper_474c5bc8 = require("@lib/event/helper_474c5bc8")
local helper_497c11db = require("@lib/event/helper_497c11db")
local helper_6e062c19 = require("@lib/event/helper_6e062c19")
local helper_90a05e04 = require("@lib/event/helper_90a05e04")
local helper_d5df2b67 = require("@lib/event/helper_d5df2b67")
local helper_da6a0db9 = require("@lib/event/helper_da6a0db9")
local helper_dc7a969c = require("@lib/event/helper_dc7a969c")
local helper_e270fa6c = require("@lib/event/helper_e270fa6c")

--- Program 99.
local function program_99() end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		print("btl_snd_id = ", var1, "\n")
		helper_6e062c19(vm.f32(3846.1), vm.f32(1622.3), vm.f32(-2002.6), vm.f32(0.69))
	end
	program_99()
	flag = event.GetFlag(728) or flag
	if flag == 1 then
		helper_dc7a969c()
		if vm.skipping() then
			return skip(1)
		end
		event.LoadSound(7691)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.SetStatusbarShow(1, 1.0)
		var1 = event.GetSndId(4) or var1
		print("btl_snd_id = ", var1, "\n")
		event.SetCharaExSoundid(0, var1)
		event.ActchrSoundInfoCopy(0)
		helper_6e062c19(vm.f32(3846.1), vm.f32(1622.3), vm.f32(-2002.6), vm.f32(0.69))
		event.SetCameraPos(3744.75, 1652.31, -2126.35)
		event.SetCameraRef(3846.14, 1652.31, -2002.58)
		event.ResetCamera(0)
		event.LoadMonsterFile(603, 1)
		event.AutoSetMonster(603, 4034.9, 1622.3, -1778.2, 0.0, -2.46, 0.0)
	end
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.EohSyncObj(0, "p11_d06b02-1")
	helper_d5df2b67()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.EohSyncObj(0, "p11_d06b02-3")
	helper_d5df2b67()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.EohSyncObj(0, "p11_d06b02-5")
	helper_d5df2b67()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 503.
script[503] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.EohSyncObj(0, "p11_d06b02-7")
	helper_d5df2b67()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 504.
script[504] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.EohSyncObj(0, "p11_d06b02-9")
	helper_d5df2b67()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 550.
script[550] = function()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_da6a0db9()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.FuncPointShow("", "2f", 0)
		event.EohSyncObj(0, "p11_d06b02-2")
		do
			local out1, out2, out3 = event.EohGetPos(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.EohSetPos(0, pos_x, pos_y + 200.0, pos_z)
		event.EohSyncObj(0, "p11_d06b02-3")
		do
			local out1, out2, out3 = event.EohGetPos(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.EohSetPos(0, pos_x, pos_y + 200.0, pos_z)
		event.LoadMonsterFile(604, 1)
		event.AutoSetMonster(604, 3220.8, 2411.4, 3458.1, 0.0, 1.91, 0.0)
		event.SetCharaPos(0, 3482.7, 2411.4, 3361.8)
		event.SetCharaRot(0, 0.0, -1.21, 0.0)
		event.SetCameraPos(3776.37, 2452.2, 3256.29)
		event.SetCameraRef(3625.59, 2441.42, 3309.81)
		event.ResetCamera(0)
		event.SetFadeIn(20)
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(20)
	helper_474c5bc8(20)
	if vm.skipping() then
		return skip(1)
	end
	helper_da6a0db9()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 551.
script[551] = function()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_90a05e04()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.FuncPointShow("", "3f", 0)
		event.EohSyncObj(0, "p11_d06b02-4")
		do
			local out1, out2, out3 = event.EohGetPos(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.EohSetPos(0, pos_x, pos_y + 200.0, pos_z)
		event.EohSyncObj(0, "p11_d06b02-5")
		do
			local out1, out2, out3 = event.EohGetPos(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.EohSetPos(0, pos_x, pos_y + 200.0, pos_z)
		event.LoadMonsterFile(605, 1)
		event.AutoSetMonster(605, -5000.8, 3914.3, 1335.4, 0.0, 0.5, 0.0)
		event.SetCharaPos(0, -4878.4, 3914.3, 1557.6)
		event.SetCharaRot(0, 0.0, -2.64, 0.0)
		event.SetCameraPos(-4801.28, 3960.04, 1697.72)
		event.SetCameraRef(-4878.44, 3944.32, 1557.56)
		event.ResetCamera(0)
		event.SetFadeIn(20)
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(20)
	helper_474c5bc8(20)
	if vm.skipping() then
		return skip(1)
	end
	helper_90a05e04()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 552.
script[552] = function()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_497c11db()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.FuncPointShow("", "4f", 0)
		event.EohSyncObj(0, "p11_d06b02-6")
		do
			local out1, out2, out3 = event.EohGetPos(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.EohSetPos(0, pos_x, pos_y + 200.0, pos_z)
		event.EohSyncObj(0, "p11_d06b02-7")
		do
			local out1, out2, out3 = event.EohGetPos(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.EohSetPos(0, pos_x, pos_y + 200.0, pos_z)
		event.LoadMonsterFile(606, 1)
		event.AutoSetMonster(606, -1126.9, 5303.1, -3005.0, 0.0, -1.78, 0.0)
		event.SetCharaPos(0, -1380.3, 5303.1, -3061.2)
		event.SetCharaRot(0, 0.0, 1.37, 0.0)
		event.SetCameraPos(-1537.07, 5363.09, -3093.39)
		event.SetCameraRef(-1380.34, 5333.14, -3061.24)
		event.ResetCamera(0)
		event.SetFadeIn(20)
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(20)
	helper_474c5bc8(20)
	if vm.skipping() then
		return skip(1)
	end
	helper_497c11db()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 553.
script[553] = function()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_018b520e()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.FuncPointShow("", "5f", 0)
		event.EohSyncObj(0, "p11_d06b02-8")
		do
			local out1, out2, out3 = event.EohGetPos(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.EohSetPos(0, pos_x, pos_y + 200.0, pos_z)
		event.EohSyncObj(0, "p11_d06b02-9")
		do
			local out1, out2, out3 = event.EohGetPos(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.EohSetPos(0, pos_x, pos_y + 200.0, pos_z)
		event.LoadMonsterFile(607, 1)
		event.LoadMonsterFile(608, 0)
		event.AutoSetMonster(607, -3980.8, 7277.16, 3321.3, 0.0, 1.46, 0.0)
		event.AutoSetMonster(608, -3947.0, 7277.16, 3460.7, 0.0, 2.07, 0.0)
		event.SetCharaPos(0, -3745.89, 7277.16, 3354.1)
		event.SetCharaRot(0, 0.0, -1.38, 0.0)
		event.SetCameraPos(-3588.72, 7334.8, 3324.13)
		event.SetCameraRef(-3745.89, 7307.16, 3354.1)
		event.ResetCamera(0)
		event.SetFadeIn(20)
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(20)
	helper_474c5bc8(20)
	if vm.skipping() then
		return skip(1)
	end
	helper_018b520e()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 554.
script[554] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(20)
	helper_474c5bc8(20)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d06b03")
	event.LoadScript("d06b03/d06b03.stb", 100)
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_e270fa6c(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 27020.
script[27020] = function()
	event.Initialize()
	event.SetFlag(728, 1)
	event.LoadMonsterFile(603, 1)
	event.AutoSetMonster(603, 4034.9, 1622.3, -1778.2, 0.0, -2.46, 0.0)
	helper_6e062c19(3760.0, vm.f32(1622.3), -2117.0, vm.f32(0.68))
	event.SetCameraPos(3660.11, 1666.73, -2241.34)
	event.SetCameraRef(3760.76, 1652.31, -2116.96)
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Program 27030.
script[27030] = function()
	event.Initialize()
	event.SetFlag(728, 1)
	event.LoadMonsterFile(604, 1)
	event.AutoSetMonster(604, 3220.8, 2411.4, 3458.1, 0.0, 1.91, 0.0)
	event.SetCharaPos(0, 3482.7, 2411.4, 3361.8)
	event.SetCharaRot(0, 0.0, -1.21, 0.0)
	event.SetCameraPos(3776.37, 2452.2, 3256.29)
	event.SetCameraRef(3625.59, 2441.42, 3309.81)
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Program 27040.
script[27040] = function()
	event.Initialize()
	event.SetFlag(728, 1)
	event.LoadMonsterFile(605, 1)
	event.AutoSetMonster(605, -5000.8, 3914.3, 1335.4, 0.0, 0.5, 0.0)
	event.SetCharaPos(0, -4878.4, 3914.3, 1557.6)
	event.SetCharaRot(0, 0.0, -2.64, 0.0)
	event.SetCameraPos(-4801.28, 3960.04, 1697.72)
	event.SetCameraRef(-4878.44, 3944.32, 1557.56)
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Program 27050.
script[27050] = function()
	event.Initialize()
	event.SetFlag(728, 1)
	event.LoadMonsterFile(606, 1)
	event.AutoSetMonster(606, -1126.9, 5303.1, -3005.0, 0.0, -1.78, 0.0)
	event.SetCharaPos(0, -1380.3, 5303.1, -3061.2)
	event.SetCharaRot(0, 0.0, 1.37, 0.0)
	event.SetCameraPos(-1537.07, 5363.09, -3093.39)
	event.SetCameraRef(-1380.34, 5333.14, -3061.24)
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Program 27060.
script[27060] = function()
	event.Initialize()
	event.SetFlag(728, 1)
	event.LoadMonsterFile(607, 1)
	event.LoadMonsterFile(608, 0)
	event.AutoSetMonster(607, -3980.8, 7277.16, 3321.3, 0.0, 1.46, 0.0)
	event.AutoSetMonster(608, -3947.0, 7277.16, 3460.7, 0.0, 2.07, 0.0)
	event.SetCharaPos(0, -3745.89, 7277.16, 3354.1)
	event.SetCharaRot(0, 0.0, -1.38, 0.0)
	event.SetCameraPos(-3588.72, 7334.8, 3324.13)
	event.SetCameraRef(-3745.89, 7307.16, 3354.1)
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

return script
