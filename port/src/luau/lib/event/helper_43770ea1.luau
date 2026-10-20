--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_43770ea1(arg0: any, arg1: s32, sp: number)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local stream_playing: s32 = 0
	local var7: s32 = 0
	local pressed: s32 = 0
	local pressed_2: s32 = 0
	local pressed_3: s32 = 0
	local pressed_4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		vm.stack(sp + 13)
		var2 = 0
		vm.stack(sp + 13)
		var3 = 0
		vm.stack(sp + 14)
		var2 = 1
		vm.stack(sp + 15)
		var3 = 1
		vm.stack(sp + 16)
		var5 = 1
		vm.stack(sp + 16)
		var5 = 0
		vm.stack(sp + 17)
		var5 = 0
		vm.stack(sp + 18)
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	vm.stack(sp + 13)
	var2 = 0
	vm.stack(sp + 13)
	var3 = 0
	vm.stack(sp + 13)
	if arg1 == 1 then
		vm.stack(sp + 13)
		var2 = 1
	end
	vm.stack(sp + 13)
	if arg1 == 2 then
		vm.stack(sp + 13)
		var3 = 1
	end
	vm.stack(sp + 14)
	var4 = event.GetMesWindowMode(arg0) or var4
	vm.stack(sp + 13)
	var5 = 1
	vm.stack(sp + 13)
	if var4 == 7 then
		vm.stack(sp + 13)
		var5 = 0
	end
	vm.stack(sp + 13)
	if var4 == 0 then
		vm.stack(sp + 13)
		var5 = 0
	end
	vm.stack(sp + 13)
	stream_playing = event.GetMesVoice() or stream_playing
	vm.stack(sp + 14)
	var7 = event.GetMesStatus(arg0) or var7
	vm.stack(sp + 13)
	if var7 == 0 then
		return 0
	end
	vm.stack(sp + 13)
	if var7 == 1 then
		return 0
	end
	vm.stack(sp + 13)
	if var7 == 3 then
		if stream_playing == 0 then
			vm.stack(sp + 13)
			event.TrgPakuAnim(0)
			vm.stack(sp + 13)
			event.TrgPakuMotion(1)
		end
	end
	vm.stack(sp + 13)
	if var7 == 4 then
		return 0
	end
	vm.stack(sp + 13)
	if var7 == 5 then
		if stream_playing == 0 then
			vm.stack(sp + 13)
			event.TrgPakuAnim(0)
			vm.stack(sp + 13)
			event.TrgPakuMotion(1)
		end
	end
	vm.stack(sp + 14)
	pressed = event.CheckButton(0) or pressed
	vm.stack(sp + 14)
	pressed_2 = event.CheckButton(1) or pressed_2
	vm.stack(sp + 14)
	pressed_3 = event.CheckButton(2) or pressed_3
	vm.stack(sp + 14)
	pressed_4 = event.CheckButton(3) or pressed_4
	if
		(
			if (if (if pressed ~= 0 then 1 else pressed_2) ~= 0 then 1 else if var2 ~= 0 then pressed_3 else 0)
					~= 0
				then 1
				else if var3 ~= 0 then pressed_4 else 0
		) ~= 0
	then
		if var5 ~= 0 then
			if pressed_2 ~= 0 then
				vm.stack(sp + 13)
				event.MesSePlay(0)
			end
			if pressed ~= 0 then
				vm.stack(sp + 13)
				event.MesSePlay(1)
			end
			if (if var2 ~= 0 then pressed_3 else 0) ~= 0 then
				vm.stack(sp + 13)
				event.MesSePlay(0)
			end
			if (if var3 ~= 0 then pressed_4 else 0) ~= 0 then
				vm.stack(sp + 13)
				event.MesSePlay(0)
			end
		end
		vm.stack(sp + 13)
		if var7 == 5 then
			vm.stack(sp + 13)
			event.MesNextpage(arg0)
			if stream_playing == 0 then
				vm.stack(sp + 13)
				event.TrgPakuAnim(1)
				vm.stack(sp + 13)
				event.TrgPakuMotion(0)
			end
		end
		vm.stack(sp + 13)
		if var7 == 3 then
			if stream_playing == 0 then
				vm.stack(sp + 13)
				event.TrgPakuAnim(0)
				vm.stack(sp + 13)
				event.TrgPakuMotion(2)
			end
			if (if var2 ~= 0 then pressed_3 else 0) ~= 0 then
				return 2
			end
			if (if var3 ~= 0 then pressed_4 else 0) ~= 0 then
				return 3
			end
			return 1
		end
		vm.stack(sp + 13)
		if var7 ~= 5 and var7 ~= 3 then
			vm.stack(sp + 14)
			event.SetMesDrawspeed(arg0, 0.0)
			vm.stack(sp + 13)
			event.TrgPakuAnim(0)
			vm.stack(sp + 13)
			event.TrgPakuMotion(1)
			if stream_playing ~= 0 then
				vm.stack(sp + 13)
				event.StreamStop(1)
			end
		end
	end
	return 0
end

return helper_43770ea1
