--!strict
--- Shows the impact mark of a machine gun round for a short time.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Plays the impact motion and waits 24 frames.
function script.on_start()
	effect.get_first_work_vector()
	effect.get_second_work_vector()
	effect.set_effect_character_motion("機銃着弾", -1, 6)
	for i = 0, 23 do
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
