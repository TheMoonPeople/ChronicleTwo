--!strict
--- Butterfly event utilities and boss monster placement of the Rainbow Butterfly Wood.

local vm = require("@lib/vm")

local rainbow_butterfly_wood_butterfly_event = {}

--- Adds a full turn to an angle in radians and subtracts it again, returning the angle with that float rounding.
function rainbow_butterfly_wood_butterfly_event.apply_full_turn_round_trip(angle: f32)
	local _ = angle < vm.f32(-3.1415927)
	angle = vm.f32(angle + vm.f32(6.2831855))
	local _ = vm.f32(3.1415927) < angle
	angle = vm.f32(angle - vm.f32(6.2831855))
	return angle
end

--- Disables saving by setting the save control bit.
function rainbow_butterfly_wood_butterfly_event.disable_saving()
	event.set_save_control_bits(1, 1)
end

--- Loads monsters 501 to 509 of the butterfly event, places 501 to 508 and places six copies of 509 in a ring around the center.
function rainbow_butterfly_wood_butterfly_event.place_boss_monsters()
	local ring_angle: f32 = 0
	local facing_angle: f32 = 0
	event.load_dungeon_monster(501, 1)
	event.load_dungeon_monster(502, 0)
	event.load_dungeon_monster(503, 0)
	event.load_dungeon_monster(504, 0)
	event.load_dungeon_monster(505, 0)
	event.load_dungeon_monster(506, 0)
	event.load_dungeon_monster(507, 0)
	event.load_dungeon_monster(508, 0)
	event.load_dungeon_monster(509, 0)
	event.place_dungeon_monster(501, 0, 0, 0)
	event.place_dungeon_monster(502, 0, 0, 0)
	event.place_dungeon_monster(503, 0, 0, 0)
	event.place_dungeon_monster(504, 0, 0, 0)
	event.place_dungeon_monster(505, 0, 0, 0)
	event.place_dungeon_monster(506, 0, 0, 0)
	event.place_dungeon_monster(507, 0, 0, 0)
	event.place_dungeon_monster(508, 0, 0, 0)
	ring_angle = 0.0
	facing_angle = vm.f32(3.1415927)
	event.place_dungeon_monster(
		509,
		vm.f32(268.802) + vm.f32(vm.sin(ring_angle) * vm.f32(46.1983)),
		772.7575,
		vm.f32(-322.002) + vm.f32(vm.cos(ring_angle) * vm.f32(46.1983)),
		0.0,
		facing_angle,
		0.0
	)
	ring_angle = vm.f32(3.1415927)
	facing_angle = 0.0
	event.place_dungeon_monster(
		509,
		vm.f32(268.802) + vm.f32(vm.sin(ring_angle) * vm.f32(46.1983)),
		772.7575,
		vm.f32(-322.002) + vm.f32(vm.cos(ring_angle) * vm.f32(46.1983)),
		0.0,
		facing_angle,
		0.0
	)
	ring_angle = vm.f32(1.0471976)
	facing_angle = vm.f32(-6.2831855)
	facing_angle = vm.f32(facing_angle / 3.0)
	event.place_dungeon_monster(
		509,
		vm.f32(268.802) + vm.f32(vm.sin(ring_angle) * vm.f32(46.1983)),
		772.7575,
		vm.f32(-322.002) + vm.f32(vm.cos(ring_angle) * vm.f32(46.1983)),
		0.0,
		facing_angle,
		0.0
	)
	ring_angle = vm.f32(-6.2831855)
	ring_angle = vm.f32(ring_angle / 3.0)
	facing_angle = vm.f32(1.0471976)
	event.place_dungeon_monster(
		509,
		vm.f32(268.802) + vm.f32(vm.sin(ring_angle) * vm.f32(46.1983)),
		772.7575,
		vm.f32(-322.002) + vm.f32(vm.cos(ring_angle) * vm.f32(46.1983)),
		0.0,
		facing_angle,
		0.0
	)
	ring_angle = vm.f32(-1.0471976)
	facing_angle = vm.f32(6.2831855)
	facing_angle = vm.f32(facing_angle / 3.0)
	event.place_dungeon_monster(
		509,
		vm.f32(268.802) + vm.f32(vm.sin(ring_angle) * vm.f32(46.1983)),
		772.7575,
		vm.f32(-322.002) + vm.f32(vm.cos(ring_angle) * vm.f32(46.1983)),
		0.0,
		facing_angle,
		0.0
	)
	facing_angle = vm.f32(-1.0471976)
	ring_angle = vm.f32(6.2831855)
	ring_angle = vm.f32(ring_angle / 3.0)
	event.place_dungeon_monster(
		509,
		vm.f32(268.802) + vm.f32(vm.sin(ring_angle) * vm.f32(46.1983)),
		772.7575,
		vm.f32(-322.002) + vm.f32(vm.cos(ring_angle) * vm.f32(46.1983)),
		0.0,
		facing_angle,
		0.0
	)
	vm.wait(1)
end

--- Returns an angle in radians wrapped into the range from minus pi to pi.
function rainbow_butterfly_wood_butterfly_event.wrap_angle(angle: f32)
	if angle < vm.f32(-3.1415927) then
		angle = vm.f32(angle + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < angle then
		angle = vm.f32(angle - vm.f32(6.2831855))
	end
	return angle
end

return rainbow_butterfly_wood_butterfly_event
