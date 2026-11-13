--!strict
--- Plays a warp motion at a fixed position.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Plays the warp motion at the target position and waits for it to finish.
function script.on_start()
	local warp_x: f32 = 0
	local warp_y: f32 = 0
	local warp_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		warp_x = out1 or warp_x
		warp_y = out2 or warp_y
		warp_z = out3 or warp_z
	end
	effect.set_effect_character_position(warp_x, warp_y, warp_z)
	effect.set_effect_character_motion("ワープ")
	for frame = 0, 35 do
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
