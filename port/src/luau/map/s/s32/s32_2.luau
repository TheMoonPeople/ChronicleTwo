--!strict
--- Moon Flower Palace versus Paznos battle sequence of cutscenes.

local vm = require("@lib/vm")
local moon_flower_palace_vs_paznos = require("@lib/event/moon_flower_palace_vs_paznos")
local wait = require("@lib/event/wait")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.initialize_map() end
script[99] = script.initialize_map

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.default_event() end

--- Shows a light rain effect until the button is pressed.
function script.key_open()
	event.initialize_event()
	vm.wait(1)
	event.set_camera_sequence_position(0.0, 1000.0, -100.0)
	event.set_camera_sequence_look_at(0.0, 1000.0, 0.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.initialize_effect_manager(5)
	event.load_effect_base("Ｅ７３２光雨")
	event.create_effect_work_buffer(5)
	event.create_effect("Ｅ７３２光雨")
	event.set_effect_first_vector(0.0, 1000.0, 0.0)
	event.set_effect_second_vector(100.0, 100.0, 100.0)
	event.set_effect_value(0, 240)
	vm.wait(2)
	wait.until_button_pressed(64)
	event.clear_effect_manager()
	event.finish_event()
end

--- Plays the beam shot scene and jumps to s70.
function script.cutscene_beam_shot()
	moon_flower_palace_vs_paznos.play_beam_shot_scene()
	event.jump_to_map_3(-1, "s70", 530)
	vm.wait(2)
end
script[500] = script.cutscene_beam_shot

--- Plays the beam burst scene and jumps to s30.
function script.cutscene_beam_burst()
	moon_flower_palace_vs_paznos.play_beam_burst_scene()
	event.jump_to_map_3(-1, "s30", 620)
	vm.wait(2)
end
script[600] = script.cutscene_beam_burst

--- Plays the cannon charge scene and jumps to s66.
function script.cutscene_cannon_charge()
	moon_flower_palace_vs_paznos.play_cannon_charge_scene()
	event.jump_to_map_3(-1, "s66", 610)
	vm.wait(2)
end
script[610] = script.cutscene_cannon_charge

--- Plays the cannon fire scene and jumps to s66.
function script.cutscene_cannon_fire()
	moon_flower_palace_vs_paznos.play_cannon_fire_scene()
	event.jump_to_map_3(-1, "s66", 620)
	vm.wait(2)
end
script[620] = script.cutscene_cannon_fire

--- Plays the Paznos awakening scene and jumps to s66.
function script.cutscene_paznos_awakening()
	moon_flower_palace_vs_paznos.play_paznos_awakening_scene()
	event.jump_to_map_3(-1, "s66", 630)
	vm.wait(2)
end
script[630] = script.cutscene_paznos_awakening

--- Plays the Moon Flower throw scene and jumps to s66.
function script.cutscene_moon_flower_throw()
	moon_flower_palace_vs_paznos.play_moon_flower_throw_scene()
	event.jump_to_map_3(-1, "s66", 650)
	vm.wait(2)
end
script[640] = script.cutscene_moon_flower_throw

return script
