--!strict
-- Shared event helper used by 13 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_52115bbf()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		var1 = event.GetRoboMoveType() or var1
		if var1 == 1 then
			event.SetMotion(0, "立ち-足")
		end
		if var1 == 2 then
			event.SetMotion(0, "立ち-キャタピラ")
		end
	else
		event.SetMotion(0, "立ち")
	end
end

return helper_52115bbf
