--!strict
-- Shared event helper used by 54 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_854bd6cf(arg0: s32, arg1: s32, arg2: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	print("station_id=", arg0, ",train_id=", arg1, ",lr_id=", arg2, "\n")
	pos_x = -220.0
	pos_y = vm.f32(35.8)
	pos_z = vm.f32(-1570.4)
	rot_y = vm.f32(-1.57)
	if arg1 == 1 then
		pos_z = vm.f32(-1251.8)
	end
	if arg1 == 2 then
		pos_z = vm.f32(-737.4)
	end
	if arg1 == 3 then
		pos_z = vm.f32(-219.7)
	end
	if arg0 == 2 then
		pos_y = 0.0
		pos_x = -120.0
		rot_y = vm.f32(-1.57)
		pos_z = 445.0
		if arg1 == 1 then
			pos_z = 150.0
		end
		if arg1 == 2 then
			pos_z = -365.0
		end
		if arg1 == 3 then
			pos_z = -880.0
		end
	end
	if arg0 == 3 then
		pos_x = -100.0
		pos_y = 36.0
		rot_y = vm.f32(-1.57)
		pos_z = 303.5
		if arg1 == 1 then
			pos_z = vm.f32(-9.6)
		end
		if arg1 == 2 then
			pos_z = -526.5
		end
		if arg1 == 3 then
			pos_z = vm.f32(-1042.8)
		end
	end
	if arg0 == 4 then
		pos_y = vm.f32(29.2)
		pos_z = -100.0
		rot_y = vm.f32(3.1415927)
		pos_x = vm.f32(-1173.2)
		if arg1 == 1 then
			pos_x = vm.f32(-1472.9)
		end
		if arg1 == 2 then
			pos_x = vm.f32(-1993.4)
		end
		if arg1 == 3 then
			pos_x = -2506.0
		end
	end
	if arg0 == 5 then
		pos_y = 0.0
		rot_y = vm.f32(-2.355)
		pos_x = 2586.0
		pos_z = 1378.0
		if arg1 == 1 then
			pos_x = 2370.0
			pos_z = 1610.0
		end
		if arg1 == 2 then
			pos_x = 2037.0
			pos_z = 2000.0
		end
		if arg1 == 3 then
			pos_x = 1694.0
			pos_z = 2389.0
		end
	end
	if arg0 == 6 then
		pos_x = 690.0
		if arg1 == 2 then
			pos_x = vm.f32(347.8)
		end
		if arg1 == 2 then
			pos_x = vm.f32(-168.4)
		end
		if arg1 == 3 then
			pos_x = -687.5
		end
		pos_y = vm.f32(-268.4)
		pos_z = 3240.0
		rot_y = vm.f32(3.1415927)
	end
	if arg0 == 7 then
		pos_x = -590.0
		if arg1 == 1 then
			pos_x = vm.f32(-245.2)
		end
		if arg1 == 2 then
			pos_x = vm.f32(273.3)
		end
		if arg1 == 3 then
			pos_x = vm.f32(790.2)
		end
		pos_y = 0.0
		pos_z = 4400.0
		rot_y = vm.f32(3.1415927)
	end
	if arg0 == 8 then
		pos_x = 590.0
		if arg1 == 1 then
			pos_x = 240.0
		end
		if arg1 == 2 then
			pos_x = -270.0
		end
		if arg1 == 3 then
			pos_x = -790.0
		end
		pos_y = 0.0
		pos_z = 3450.0
		rot_y = vm.f32(3.1415927)
	end
	if arg0 == 9 then
		pos_x = -590.0
		if arg1 == 1 then
			pos_x = vm.f32(-245.2)
		end
		if arg1 == 2 then
			pos_x = vm.f32(273.3)
		end
		if arg1 == 3 then
			pos_x = vm.f32(790.2)
		end
		pos_y = 0.0
		pos_z = 4400.0
		rot_y = vm.f32(3.1415927)
	end
	event.set_character_position(0, pos_x, pos_y, pos_z)
	event.set_character_rotation(0, 0.0, rot_y, 0.0)
end

return helper_854bd6cf
