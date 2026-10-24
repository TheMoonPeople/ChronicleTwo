--!strict
-- Shared event helper used by 24 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_40e84721(arg0: s32, arg1: s32)
	local chara_id: s32 = 0
	chara_id = event.GetCharaId(arg0) or chara_id
	event.CharaActive(arg1, chara_id)
end

return helper_40e84721
