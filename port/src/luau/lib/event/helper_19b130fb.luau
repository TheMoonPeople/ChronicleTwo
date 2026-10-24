--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_19b130fb()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.GetFlag(202) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.CharaActive(1, 122)
		event.CharaActive(1, 123)
	else
		event.CharaActive(0, 122)
		event.CharaActive(0, 123)
	end
end

return helper_19b130fb
