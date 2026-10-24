--!strict
-- map/g/g01/rush_g01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ca202fe = require("@lib/event/helper_1ca202fe")
local helper_4a3f6e53 = require("@lib/event/helper_4a3f6e53")
local helper_58984813 = require("@lib/event/helper_58984813")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_938babbf = require("@lib/event/helper_938babbf")
local helper_9ca592a1 = require("@lib/event/helper_9ca592a1")
local helper_c72a3649 = require("@lib/event/helper_c72a3649")
local helper_d1cc53b1 = require("@lib/event/helper_d1cc53b1")
local helper_fa983e23 = require("@lib/event/helper_fa983e23")

local global2: s32 = 0
local global3: s32 = 0

--- Helper function.
local function helper_196f4()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global2 = 0
		global3 = 9
		event.LoadMotion(5, "event/e200/e208/e208_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global3)
		event.LoadMotion(5, "event/e200/e208/e208_monica.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadEquip(5, 1, 4, "info", global3)
		event.LoadEquip(5, 1, 3, "info", global3)
		event.LoadEquip(5, 1, 2, "info", global3, 37)
		event.CharaActive(0, global3)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global2 = 8
		global3 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global2)
		event.LoadMotion(5, "event/e200/e208/e208_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadEquip(5, 0, 4, "info", global2)
		event.LoadEquip(5, 0, 3, "info", global2)
		event.LoadEquip(5, 0, 2, "info", global2, 37)
		event.CharaActive(0, global2)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/e200/e208/e208_monica.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global3)
	end
	event.LoadChara(5, "event/e200/e208/e208_rococo.gltf", "info", 39)
	event.EohSyncChara(2, 39)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 39)
	event.EohSyncEditObj(6, "p01_g010701", "g010707-m")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 6)
	event.ObjsSetPos(10, 1.0461, 59.1891, 78.8974)
	event.ObjsSetRot(10, 0.0, -1.5707964, 0.0)
	event.EohSyncEditObj(7, "p01_g010701", "g010708-m")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 7)
	event.ObjsSetPos(11, 1.0461, 59.1891, 78.8974)
	event.ObjsSetRot(11, 0.0, -1.5707964, 0.0)
	event.LoadMes(0, 5, "event/e200/e208/e208.txt")
end

--- Helper function.
local function helper_17718()
	event.ObjsSetMotion(0, "小人見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "小人見立ち", 4, -1.0, 1)
	helper_888ab2a3(15)
	event.ObjsSetMotion(1, "のぞきこむ", 6, -1.0, 1)
	event.ObjsNextMotion(1, "のぞきこむL", 0)
	helper_888ab2a3(9)
	helper_888ab2a3(30)
	event.CharaActive(1, global2)
	event.CmrsSetPos(-9.46, 11.43, 119.95)
	event.CmrsSetRef(-13.26, 17.25, 155.84)
	event.ObjsSetPos(0, -5.92, 0.0, 176.73)
	event.ObjsSetRot(0, 0.0, -3.12, 0.0)
	event.ObjsSetPos(1, -22.63, 0.0, 162.64)
	event.ObjsSetRot(1, 0.0, 2.2, 0.0)
	event.ObjsSetPos(2, -4.1, 0.0, 153.36)
	event.ObjsSetRot(2, 0.0, -0.96, 0.0)
	event.CharaActive(1, global2)
	event.CmrsSetPos(42.75, 27.67, 174.35)
	event.CmrsSetRef(-9.0, 19.49, 158.24)
	event.ObjsSetRot(0, 0.0, -3.12, 0.0)
	event.ObjsSetPos(2, -22.63, 0.0, 162.64)
	event.ObjsSetRot(2, 0.0, 2.2, 0.0)
	event.ObjsSetMotion(1, "ひげを引っ張る", 6, -1.0, 1)
	event.ObjsNextMotion(1, "ひげを引っ張るL", 0)
	event.ObjsSetMotion(2, "ひげを引っ張る", 6)
	event.ObjsNextMotion(2, "ひげを引っ張るL", 0)
	helper_888ab2a3(30)
	event.ObjsSetPos(0, -5.92, 0.0, 176.73)
	event.ObjsSetRot(0, 0.0, -3.12, 0.0)
	event.CharaActive(1, global2)
end

--- Helper function.
local function helper_19374()
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global2)
		event.CharaActive(0, global3)
		event.CharaActive(0, 39)
		event.DelExtMotion(global2)
		event.DelExtMotion(global3)
		event.DeleteChara(global3)
		event.DeleteChara(39)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global3)
		event.CharaActive(0, global2)
		event.CharaActive(0, 39)
		event.DelExtMotion(global2)
		event.DelExtMotion(global3)
		event.DeleteChara(global2)
		event.DeleteChara(39)
		event.DeleteChara(37)
	end
end

--- Helper function.
local function helper_1a59c()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	vm.section(function()
		event.SetFlag(208, 1)
		event.Initialize()
		helper_196f4()
		do
			local out1, out2, out3, out4 = event.GetEditPartsPos("p01_g010701")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
			rot_y = out4 or rot_y
		end
		event.SetWorldCoord(pos_x, pos_y, pos_z, rot_y)
		event.SetFadeIn(15)
		event.InitDramaScene()
		event.CharaActive(1, global2)
		event.CharaActive(1, global3)
		event.CharaActive(1, 39)
		event.CmrsSetPos(-26.67, 133.42, 142.95)
		event.CmrsSetRef(-0.63, 135.46, 70.07)
		event.ObjsSetPos(2, 0.0, 0.0, 0.0)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		helper_4a3f6e53()
		event.CharaActive(1, 39)
		event.CmrsSetPos(-252.25, 55.22, 51.91)
		event.CmrsSetRef(-123.33, 64.43, 84.03)
		event.ObjsSetPos(0, -27.16, 0.0, 167.75)
		event.ObjsSetRot(0, 0.0, 2.56, 0.0)
		event.ObjsSetPos(1, 6.29, 0.0, 191.97)
		event.ObjsSetRot(1, 0.0, 3.04, 0.0)
		event.ObjsResetDaPosition(1)
		helper_c72a3649()
		event.CmrsSetPos(-30.99, 21.79, 154.87)
		event.CmrsSetRef(3.56, 19.83, 178.37)
		event.ObjsSetPos(0, -1.67, 0.0, 172.28)
		event.ObjsSetRot(0, 0.0, -2.76, 0.0)
		event.ObjsResetDaPosition(0)
		event.ObjsSetPos(1, -10.54, 0.0, 179.7)
		event.ObjsSetRot(1, 0.0, -3.0, 0.0)
		helper_d1cc53b1()
		event.CharaActive(0, global2)
		event.CharaActive(0, global3)
		event.CmrsSetPos(-5.73, 21.1, 190.37)
		event.CmrsSetRef(5.68, 14.14, 150.47)
		event.ObjsSetPos(2, 4.08, 0.0, 144.54)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		helper_58984813()
		event.CharaActive(1, global2)
		event.CharaActive(1, global3)
		event.CharaActive(1, 39)
		event.CmrsSetPos(-14.34, 22.74, 112.18)
		event.CmrsSetRef(-13.7, 20.99, 152.2)
		event.ObjsSetPos(0, -5.92, 0.0, 176.73)
		event.ObjsSetRot(0, 0.0, -3.12, 0.0)
		event.ObjsSetPos(1, -22.63, 0.0, 162.64)
		event.ObjsSetRot(1, 0.0, 2.2, 0.0)
		event.ObjsSetPos(2, -4.1, 0.0, 153.36)
		event.ObjsSetRot(2, 0.0, -0.96, 0.0)
		helper_17718()
		event.CharaActive(0, global3)
		event.CharaActive(0, 37)
		event.CmrsSetPos(-24.6, 25.86, 163.37)
		event.CmrsSetRef(-10.01, 18.7, 153.1)
		helper_1ca202fe()
		event.CharaActive(1, global3)
		event.CharaActive(1, 37)
		event.CmrsSetPos(-10.38, 27.34, 107.56)
		event.CmrsSetRef(-17.84, 21.69, 164.18)
		event.ObjsSetPos(1, -24.14, 0.0, 161.49)
		event.ObjsSetRot(1, 0.0, 2.44, 0.0)
		helper_9ca592a1()
		event.CharaActive(0, global2)
		event.CmrsSetPos(3.85, 19.27, 183.67)
		event.CmrsSetRef(2.04, 14.46, 113.61)
		event.ObjsSetPos(2, 4.08, 0.0, 144.54)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		helper_938babbf()
		event.CharaActive(1, global2)
		event.CmrsSetPos(10.38, 30.2, 209.13)
		event.CmrsSetRef(20.26, 6.47, 120.39)
		event.ObjsSetPos(0, 33.4, 0.0, 163.7)
		event.ObjsSetRot(0, 0.0, -2.52, 0.0)
		event.ObjsSetPos(1, 19.36, 0.0, 168.87)
		event.ObjsSetRot(1, 0.0, -2.76, 0.0)
		event.ObjsSetPos(2, 4.08, 0.0, 144.54)
		event.ObjsSetRot(2, 0.0, 0.36, 0.0)
		helper_fa983e23()
		event.CancelDramaScene()
	end)
	event.SetFadeOut(30)
	helper_888ab2a3(30)
	event.SetCharaPos(0, pos_x + vm.f32(21.55), pos_y + 0.0, pos_z + vm.f32(189.06))
	event.SetCharaRot(0, 0.0, -3.0 + rot_y, 0.0)
	vm.wait(11)
	helper_19374()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	event.SetFadeIn(30)
	helper_1a59c()
	event.LoadScript("g01/g01.stb", -1)
end

return script
