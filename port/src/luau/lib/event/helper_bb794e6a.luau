--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_bb794e6a(arg0: s32)
	local count: s32 = 0
	count = event.SphidaGetParCount() or count
	event.SphidaSetParCount(count)
	if count <= 0 then
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.SphidaSetPlayFlag(0)
		if arg0 ~= -1 then
			event.SndSePlay(arg0, 19)
		end
	end
end

return helper_bb794e6a
