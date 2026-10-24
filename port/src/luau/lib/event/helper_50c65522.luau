--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_50c65522()
	event.CharaActive(1, 0)
	event.DeleteChara(11)
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.DelImg(0)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
end

return helper_50c65522
