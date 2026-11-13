--!strict
--- Plays a warp motion that follows the owning character.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Plays the warp motion and keeps it just above the owner for a while.
function script.on_start()
	local warp_x: f32 = 0
	local warp_y: f32 = 0
	local warp_z: f32 = 0
	local owner_id: s32 = 0
	owner_id = effect.get_owner_character() or owner_id
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		warp_x = out1 or warp_x
		warp_y = out2 or warp_y
		warp_z = out3 or warp_z
	end
	effect.set_effect_character_position(warp_x, warp_y, warp_z)
	effect.set_effect_character_motion("ワープ")
	for frame = 0, 35 do
		do
			local out1, out2, out3 = effect.get_scene_character_position(owner_id)
			warp_x = out1 or warp_x
			warp_y = out2 or warp_y
			warp_z = out3 or warp_z
		end
		effect.set_effect_character_position(warp_x, warp_y + 8.0, warp_z)
		vm.wait()
	end
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
