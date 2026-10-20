--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_17392973 = require("@lib/event/helper_17392973")
local helper_ed4529cf = require("@lib/event/helper_ed4529cf")

--- Helper function.
local function helper_8d283e19()
	local var0: s32 = 0
	local argc: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_17392973()
		print("cnt=", var0, "-------------------------------------\n")
		print("esaget-------------\n")
		print("apple-------------\n")
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	helper_17392973()
	var0 = event.GetCnt(3) or var0
	print("cnt=", var0, "-------------------------------------\n")
	if var0 >= 8 then
		event.EohSyncObj(0, "p05_s0501", "s050111-m0")
		event.EohSetShow(0, 1)
		event.EohSetPos(0, -2274.43, 37.38, 712.87)
		event.EohSetRot(0, 0.0, 0.0, 0.0)
		event.EohSyncObj(0, "p05_s0501", "s050102-a")
		event.EohSetPos(0, -2274.43, 37.38, 712.87)
		event.EohSetRot(0, 0.0, 0.0, 0.0)
		event.EohSyncObj(0, "p05_s0501", "s050102-c")
		event.EohSetPos(0, -2274.43, 37.38, 712.87)
		event.EohSetRot(0, 0.0, 0.0, 0.0)
		event.FuncPointShow("", "next_floor", 1)
	end
	if var0 > 1 and var0 < 7 then
		print("esaget-------------\n")
		event.FuncPointShow("", "itemget_mimi", 1)
	end
	flag = event.GetFlag(230) or flag
	if flag ~= 0 and var0 < 5 then
		argc = event.GetItemNum(291) or argc
		if argc <= 0 then
			print("apple-------------\n")
			event.FuncPointShow("", "itemget_paplle", 1)
			event.CharaActive(1, 13)
			event.CharaActive(1, 15)
			event.CharaActive(1, 16)
			event.CharaActive(1, 17)
		else
			event.CharaActive(0, 13)
			event.CharaActive(0, 15)
			event.CharaActive(0, 16)
			event.CharaActive(0, 17)
		end
	end
	if var0 <= 2 then
		argc = event.GetItemNum(302) or argc
		if argc <= 0 then
			event.FuncPointShow("", "fc_e220", 1)
		end
	end
	flag = event.GetFlag(230) or flag
	if flag == 0 then
		event.FuncPointShow("", "fc_e230", 1)
		return
	end
	if var0 == 3 then
		event.FuncPointShow("", "fc_e235", 1)
		return
	end
	if var0 == 5 then
		print("haguhagu on--------------\n")
		event.FuncPointShow("", "item_e245", 1)
		return
	end
	if var0 == 6 then
		event.FuncPointShow("", "fc_e247", 1)
		helper_ed4529cf()
		return
	end
	if var0 == 7 then
		flag = event.GetFlag(250) or flag
		if flag == 1 then
			event.FuncPointShow("", "fc_e253", 1)
		end
	end
end

return helper_8d283e19
