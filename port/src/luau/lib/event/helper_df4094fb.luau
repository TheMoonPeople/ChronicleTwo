--!strict
-- Shared event helper used by 24 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_df4094fb(arg0: s32)
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		return 0
	end
	var3 = event.GetCnt(1) or var3
	print("CheckTrainDoor,station_id=", var3, ",lr=", arg0, "-----------------------------\n")
	if var3 == 2 then
		if arg0 ~= 0 then
			return 1
		else
			return 0
		end
	end
	if var3 == 3 then
		if arg0 ~= 0 then
			return 1
		else
			return 0
		end
	end
	if var3 == 4 then
		if arg0 ~= 0 then
			return 0
		else
			return 1
		end
	end
	if var3 == 5 then
		if arg0 ~= 0 then
			return 0
		else
			return 1
		end
	end
	if var3 == 6 then
		if arg0 ~= 0 then
			return 0
		else
			return 1
		end
	end
	if var3 == 7 then
		if arg0 ~= 0 then
			return 1
		else
			return 0
		end
	end
	if var3 == 8 then
		if arg0 ~= 0 then
			return 0
		else
			return 1
		end
	end
	if var3 == 9 then
		if arg0 ~= 0 then
			return 1
		else
			return 0
		end
	end
	if arg0 ~= 0 then
		return 0
	else
		return 1
	end
end

return helper_df4094fb
