--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_0c718064(arg0: s32)
	if arg0 >= 2 then
		event.add_inventory_item(296, 2)
		event.add_inventory_item(388, 1)
	end
	if arg0 >= 3 then
		event.set_party_member(1, 1)
		event.set_character_change_enabled(1, 1)
		event.set_character_change_unmasked(1, 1)
		event.add_inventory_item(296, 4)
		event.add_inventory_item(388, 2)
		event.add_inventory_item(389, 2)
	end
	if arg0 >= 4 then
		event.add_inventory_item(296, 8)
		event.add_inventory_item(388, 3)
		event.add_inventory_item(389, 3)
	end
	if arg0 >= 5 then
		event.add_inventory_item(296, 8)
		event.add_inventory_item(388, 3)
		event.add_inventory_item(389, 3)
	end
	if arg0 >= 6 then
		event.add_inventory_item(296, 8)
		event.add_inventory_item(388, 4)
		event.add_inventory_item(389, 4)
	end
	if arg0 >= 7 then
		event.add_inventory_item(296, 10)
		event.add_inventory_item(388, 5)
		event.add_inventory_item(389, 5)
	end
end

return helper_0c718064
