--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_8b00b423()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.SetBitCtrl(1, 1)
	else
		event.SetBitCtrl(1, 1)
	end
	print("off----\n")
end

return helper_8b00b423
