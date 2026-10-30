--!strict
-- Shared event helper used by 285 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_31bbf01d = require("@lib/event/helper_31bbf01d")

--- Helper function.
local function helper_4e93f9fc(chara_no: any, arg1: any, arg2: any)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local at: number = 0
	return vm.guard(function()
		if arg2 ~= 0 then
			event.attach_object_handle_to_character(0, chara_no)
			do
				local _, out2, _ = event.get_object_handle_rotation(0)
				rot_y = out2 or rot_y
			end
		end
		player_chara = event.get_player_character_slot() or player_chara
		at = 1
		helper_31bbf01d(player_chara, chara_no, arg1)
		return rot_y
	end, function(received: { any })
		if at <= 1 then
			return rot_y
		end
		return nil
	end)
end

return helper_4e93f9fc
