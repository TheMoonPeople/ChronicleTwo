--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_0c718064(arg0: s32)
	if arg0 >= 2 then
		event.AddItem(296, 2)
		event.AddItem(388, 1)
	end
	if arg0 >= 3 then
		event.ExtTyped(1078, "ii", 1, 1)
		event.SetCharaChangeFlag(1, 1)
		event.SetCharaChangeMask(1, 1)
		event.AddItem(296, 4)
		event.AddItem(388, 2)
		event.AddItem(389, 2)
	end
	if arg0 >= 4 then
		event.AddItem(296, 8)
		event.AddItem(388, 3)
		event.AddItem(389, 3)
	end
	if arg0 >= 5 then
		event.AddItem(296, 8)
		event.AddItem(388, 3)
		event.AddItem(389, 3)
	end
	if arg0 >= 6 then
		event.AddItem(296, 8)
		event.AddItem(388, 4)
		event.AddItem(389, 4)
	end
	if arg0 >= 7 then
		event.AddItem(296, 10)
		event.AddItem(388, 5)
		event.AddItem(389, 5)
	end
end

return helper_0c718064
