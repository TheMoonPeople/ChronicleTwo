--!strict
--- Ejects spent shell casings by moving character copies to the buggy gun position.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Periodically moves a pair of casing copies to the gun attachment point in turn.
function script.on_start()
	local owner_id: s32 = 0
	local copy_index: s32 = 0
	local frame: s32 = 0
	local gun_x: f32 = 0
	local gun_y: f32 = 0
	local gun_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	owner_id = effect.get_owner_character() or owner_id
	effect.create_effect_character_copies(2)
	effect.set_effect_character_position(250, 80, -1000)
	copy_index = 0
	frame = 0
	while true do
		if vm.imod(frame, 15) == 0 then
			do
				local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "dcol00")
				gun_x = out1 or gun_x
				gun_y = out2 or gun_y
				gun_z = out3 or gun_z
			end
			do
				local out1, out2, out3 = effect.get_scene_character_frame_rotation(owner_id, "dcol00")
				rotation_x = out1 or rotation_x
				rotation_y = out2 or rotation_y
				rotation_z = out3 or rotation_z
			end
			print("POS = ", vm.float(gun_x), ",", vm.float(gun_y), ",", vm.float(gun_z), "\n")
			print("ROT = ", vm.float(rotation_x), ",", vm.float(rotation_y), ",", vm.float(rotation_z), "\n")
			effect.set_character_copy_position(copy_index, gun_x, gun_y + 30.0, gun_z)
			copy_index = copy_index + 1
			if copy_index >= 2 then
				copy_index = 0
			end
		end
		frame = vm.i32(frame + 1)
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
