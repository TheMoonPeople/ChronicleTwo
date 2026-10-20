--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_3e3c2a0f(arg0: s32, arg1: s32, arg2: s32)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		print("station_id=", arg0, ",train_id=", arg1, ",lr_id=", arg2, "\n")
		var3 = -220.0
		var4 = vm.f32(35.8)
		var5 = vm.f32(-1570.4)
		var6 = vm.f32(-1.57)
		var5 = vm.f32(-1251.8)
		var5 = vm.f32(-737.4)
		var5 = vm.f32(-219.7)
		var4 = 0.0
		var3 = -120.0
		var6 = vm.f32(-1.57)
		var5 = 445.0
		var5 = 150.0
		var5 = -365.0
		var5 = -880.0
		var3 = -100.0
		var4 = 36.0
		var6 = vm.f32(-1.57)
		var5 = 303.5
		var5 = vm.f32(-9.6)
		var5 = -526.5
		var5 = vm.f32(-1042.8)
		var4 = vm.f32(29.2)
		var5 = -100.0
		var6 = vm.f32(3.1415927)
		var3 = vm.f32(-1173.2)
		var3 = vm.f32(-1472.9)
		var3 = vm.f32(-1993.4)
		var3 = -2506.0
		var4 = 0.0
		var6 = vm.f32(-2.355)
		var3 = 2586.0
		var5 = 1378.0
		var3 = 2370.0
		var5 = 1610.0
		var3 = 2037.0
		var5 = 2000.0
		var3 = 1694.0
		var5 = 2389.0
		var3 = 690.0
		var3 = vm.f32(347.8)
		var3 = vm.f32(-168.4)
		var3 = -687.5
		var4 = vm.f32(-268.4)
		var5 = 3240.0
		var6 = vm.f32(3.1415927)
		var3 = -590.0
		var3 = vm.f32(-245.2)
		var3 = vm.f32(273.3)
		var3 = vm.f32(790.2)
		var4 = 0.0
		var5 = 4400.0
		var6 = vm.f32(3.1415927)
		var3 = 590.0
		var3 = 240.0
		var3 = -270.0
		var3 = -790.0
		var4 = 0.0
		var5 = 3450.0
		var6 = vm.f32(3.1415927)
		var3 = -590.0
		var3 = vm.f32(-245.2)
		var3 = vm.f32(273.3)
		var3 = vm.f32(790.2)
		var4 = 0.0
		var5 = 4400.0
		var6 = vm.f32(3.1415927)
	end
	if vm.skipping() then
		return skip(1)
	end
	print("station_id=", arg0, ",train_id=", arg1, ",lr_id=", arg2, "\n")
	var3 = -220.0
	var4 = vm.f32(35.8)
	var5 = vm.f32(-1570.4)
	var6 = vm.f32(-1.57)
	if arg1 == 1 then
		var5 = vm.f32(-1251.8)
	end
	if arg1 == 2 then
		var5 = vm.f32(-737.4)
	end
	if arg1 == 3 then
		var5 = vm.f32(-219.7)
	end
	if arg0 == 2 then
		var4 = 0.0
		var3 = -120.0
		var6 = vm.f32(-1.57)
		var5 = 445.0
		if arg1 == 1 then
			var5 = 150.0
		end
		if arg1 == 2 then
			var5 = -365.0
		end
		if arg1 == 3 then
			var5 = -880.0
		end
	end
	if arg0 == 3 then
		var3 = -100.0
		var4 = 36.0
		var6 = vm.f32(-1.57)
		var5 = 303.5
		if arg1 == 1 then
			var5 = vm.f32(-9.6)
		end
		if arg1 == 2 then
			var5 = -526.5
		end
		if arg1 == 3 then
			var5 = vm.f32(-1042.8)
		end
	end
	if arg0 == 4 then
		var4 = vm.f32(29.2)
		var5 = -100.0
		var6 = vm.f32(3.1415927)
		var3 = vm.f32(-1173.2)
		if arg1 == 1 then
			var3 = vm.f32(-1472.9)
		end
		if arg1 == 2 then
			var3 = vm.f32(-1993.4)
		end
		if arg1 == 3 then
			var3 = -2506.0
		end
	end
	if arg0 == 5 then
		var4 = 0.0
		var6 = vm.f32(-2.355)
		var3 = 2586.0
		var5 = 1378.0
		if arg1 == 1 then
			var3 = 2370.0
			var5 = 1610.0
		end
		if arg1 == 2 then
			var3 = 2037.0
			var5 = 2000.0
		end
		if arg1 == 3 then
			var3 = 1694.0
			var5 = 2389.0
		end
	end
	if arg0 == 6 then
		var3 = 690.0
		if arg1 == 2 then
			var3 = vm.f32(347.8)
		end
		if arg1 == 2 then
			var3 = vm.f32(-168.4)
		end
		if arg1 == 3 then
			var3 = -687.5
		end
		var4 = vm.f32(-268.4)
		var5 = 3240.0
		var6 = vm.f32(3.1415927)
	end
	if arg0 == 7 then
		var3 = -590.0
		if arg1 == 1 then
			var3 = vm.f32(-245.2)
		end
		if arg1 == 2 then
			var3 = vm.f32(273.3)
		end
		if arg1 == 3 then
			var3 = vm.f32(790.2)
		end
		var4 = 0.0
		var5 = 4400.0
		var6 = vm.f32(3.1415927)
	end
	if arg0 == 8 then
		var3 = 590.0
		if arg1 == 1 then
			var3 = 240.0
		end
		if arg1 == 2 then
			var3 = -270.0
		end
		if arg1 == 3 then
			var3 = -790.0
		end
		var4 = 0.0
		var5 = 3450.0
		var6 = vm.f32(3.1415927)
	end
	if arg0 == 9 then
		var3 = -590.0
		if arg1 == 1 then
			var3 = vm.f32(-245.2)
		end
		if arg1 == 2 then
			var3 = vm.f32(273.3)
		end
		if arg1 == 3 then
			var3 = vm.f32(790.2)
		end
		var4 = 0.0
		var5 = 4400.0
		var6 = vm.f32(3.1415927)
	end
	event.SetCharaPos(0, var3, var4, var5)
	event.SetCharaRot(0, 0.0, var6, 0.0)
end

return helper_3e3c2a0f
