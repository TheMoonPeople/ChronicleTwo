--!strict
-- Shared event helper used by 100 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_08ff853b = require("@lib/event/helper_08ff853b")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_76929aca = require("@lib/event/helper_76929aca")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_f0c5f5d1 = require("@lib/event/helper_f0c5f5d1")

--- Helper function.
local function helper_653feda2(arg0: s32, arg1: s32, arg2: any, arg3: s32)
	local var4: s32 = 0
	local get_pad_down: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local pressed: s32 = 0
	local pressed_2: s32 = 0
	local var11: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var4 = event.GetMesQuestionGyou(arg0) or var4
		event.SetMesDrawspeed(arg0, 0.0)
		var8 = 0
		var7 = 0
		var6 = 0
		event.SetMesCursor(arg0, -1)
		event.SetMesCursor(arg0, arg2)
		at = 1
		helper_f0c5f5d1(arg0)
		while true do
			var8 = 0
			var7 = helper_08ff853b(arg0)
			if var6 == 0 and var7 == -1 then
				event.MesSePlay(2)
				var8 = -1
			end
			if var6 == 0 and var7 == 1 then
				event.MesSePlay(2)
				var8 = 1
			end
			var6 = var7
			pressed = event.CheckButton(0) or pressed
			pressed_2 = event.CheckButton(1) or pressed_2
			get_pad_down = event.GetPaddown() or get_pad_down
			var11 = event.GetMesWindowMode(arg0) or var11
			if var11 == 5 then
				if bit32.band(get_pad_down, 32768) ~= 0 then
					event.MesSePlay(2)
					var8 = -1
				end
				if bit32.band(get_pad_down, 8192) ~= 0 then
					event.MesSePlay(2)
					var8 = 1
				end
			else
				if bit32.band(get_pad_down, 4096) ~= 0 then
					event.MesSePlay(2)
					var8 = -1
				end
				if bit32.band(get_pad_down, 16384) ~= 0 then
					event.MesSePlay(2)
					var8 = 1
				end
			end
			if pressed_2 ~= 0 then
				event.MesSePlay(3)
				at = 2
				vm.wait(2)
				break
			else
				if pressed ~= 0 then
					event.MesSePlay(1)
					at = 3
					vm.wait(3)
					if arg3 == 0 then
						helper_6992f518(arg0)
						return -1
					end
				end
				if var8 == 1 then
					if arg2 < vm.i32(vm.i32(arg1 - 1) + var4) then
						arg2 = arg2 + 1
					else
						arg2 = vm.i32(vm.i32(arg1 - 1) + var4)
					end
				end
				if var8 == -1 then
					if var4 < arg2 then
						arg2 = arg2 - 1
					else
						arg2 = var4
					end
				end
				event.SetMesCursor(arg0, arg2)
				at = 4
				vm.wait(4)
			end
		end
		helper_6992f518(arg0)
		return arg2
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				var8 = 0
				var7 = helper_76929aca(arg0)
				var8 = -1
				var8 = 1
				local _ = var6 == 0
				local _ = var6 == 0
				var6 = var7
				var8 = -1
				var8 = 1
				var8 = -1
				var8 = 1
			end
			helper_d16eef1e(arg0)
			return -1
		end
		if at <= 4 then
			helper_d16eef1e(arg0)
			return arg2
		end
		return nil
	end)
end

return helper_653feda2
