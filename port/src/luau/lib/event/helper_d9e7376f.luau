--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")

--- Helper function.
local function helper_d9e7376f(arg0: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c1c32f84(72)
		end
		if at <= 2 then
			helper_c1c32f84(20)
		end
		if at <= 3 then
			helper_c1c32f84(10)
		end
		if at <= 4 then
			helper_c1c32f84(15)
		end
		if at <= 5 then
			helper_c1c32f84(30)
		end
		if at <= 6 then
			helper_c1c32f84(60)
		end
		if at <= 7 then
			helper_c1c32f84(15)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, out2, out3 = event.EohGetPos(3)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSetPos(3, pos_x - 50.0, pos_y, pos_z)
	event.ObjsSetRot(3, 0.0, 0.0, 0.08726647)
	event.ObjsSetRot(5, 0.0, -1.5707964, 0.0)
	event.ObjsSetRot(6, 0.0, 1.5707964, 0.0)
	event.ObjsSetRot(22, 0.0, -1.5707964, 0.0)
	event.ObjsSetRot(9, 0.0, 1.5707964, 0.0)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsSetMotion(1, "歩き", 4)
	event.EohSetFootSoundId(0, 6)
	event.EohSetFootSoundId(1, 6)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 90)
	event.ObjsAddPas(0, -160.36, 2.7, 634.04)
	event.ObjsAddPas(0, -124.87, 2.7, 630.96)
	event.ObjsAddPas(0, -89.31, 4.88, 627.74)
	event.ObjsAddPas(0, -78.59, 9.51, 627.52)
	event.ObjsAddPas(0, -58.26, 12.02, 627.52)
	event.ObjsAddPas(0, -23.27, 22.08, 626.47)
	event.ObjsStartPas(0)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 90)
	event.ObjsAddPas(1, -117.93, 2.01, 644.18)
	event.ObjsAddPas(1, -87.39, 5.06, 643.55)
	event.ObjsAddPas(1, -79.65, 10.25, 643.38)
	event.ObjsAddPas(1, -61.53, 13.02, 643.01)
	event.ObjsAddPas(1, -15.8, 26.38, 642.06)
	event.ObjsStartPas(1)
	helper_c1c32f84(72)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetFootSoundId(0, 4)
	event.EohSetFootSoundId(1, 4)
	event.SndSePlay(arg0, 12)
	event.ObjsRotation(6, 0.0, 0.0, 0.0, 30)
	event.ObjsRotation(5, 0.0, 0.0, 0.0, 30)
	event.ObjsRotation(22, 0.0, 0.0, 0.0, 30)
	event.ObjsRotation(9, 0.0, 0.0, 0.0, 30)
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsRotation(0, 0.0, 3.03, 0.0, 30)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(4)
	end
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(arg0, 13)
	event.ObjsRotation(3, 0.0, 0.0, 0.0, 30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(arg0, 14)
	event.ObjsMove(3, pos_x, pos_y, pos_z, 60)
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(7)
	end
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(8)
	end
end

return helper_d9e7376f
