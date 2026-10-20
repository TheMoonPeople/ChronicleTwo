--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1f459f58 = require("@lib/event/helper_1f459f58")
local helper_b03eb2e1 = require("@lib/event/helper_b03eb2e1")
local helper_cc7603b9 = require("@lib/event/helper_cc7603b9")
local helper_e5219064 = require("@lib/event/helper_e5219064")

--- Helper function.
local function helper_17b9ae21(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local argc: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_cc7603b9(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_cc7603b9(arg0, -1, 3, 256, 208)
			end
			return helper_1f459f58(arg0)
		end
		if at <= 5 then
			helper_b03eb2e1(arg0, 1)
			helper_e5219064(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_cc7603b9(arg0, -1, 3, 256, 208)
		end
		return helper_1f459f58(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_b03eb2e1(arg0, 1)
		event.MesMake_2(arg0, "Go get me a\nScoop Memo, will ya?")
		if now_map_no == 22 then
			helper_e5219064(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_cc7603b9(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		return 0
	end
	do
		local out1, out2 = event.GetMenuEtc_3(5)
		var5 = out1 or var5
		var6 = out2 or var6
	end
	if var5 == var6 then
		helper_b03eb2e1(arg0, 1)
		event.MesMake_2(arg0, "Looks like there's\nno more scoops to be had.")
		if now_map_no == 22 then
			helper_e5219064(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_cc7603b9(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(4)
			end
		end
		return helper_1f459f58(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_b03eb2e1(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "I figured out [Number1] more scoops.")
		event.SetMesDrawspeed(arg0, 0)
		helper_cc7603b9(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_b03eb2e1(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(arg0, "Come on, man! Quit slackin'!\nWhere's all your new inside scoops?")
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Woo! You got [Number1] new scoops!\nI knew you had it in ya!")
	end
	if now_map_no == 22 then
		helper_e5219064(arg0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		helper_cc7603b9(arg0, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(7)
		end
	end
	return helper_1f459f58(arg0)
end

return helper_17b9ae21
