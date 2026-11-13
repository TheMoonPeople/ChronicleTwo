--!strict
--- Controls the Death Ark battleship boss, which sails between corners of the arena while its turrets fire and ends the fight when its hull is destroyed.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local movement = require("@lib/monster/movement")
local timer = require("@lib/monster/timer")

--- Limits how far away the monster stays active unless it is a boss.
local function set_clip_distance_for_boss()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Stops the ship sound, requests the defeat event once and idles forever.
local function on_death()
	local character_type: s32 = 0
	local defeat_requested: s32 = 0
	monster.set_camera_mode(0)
	monster.reset_camera_limits()
	character_type = monster.get_character_number() or character_type
	monster.set_variable(68, 1)
	defeat_requested = monster.get_variable(66) or defeat_requested
	if defeat_requested == 0 then
		monster.stop_monster_sound(character_type, 2)
		monster.set_lock_on_mode(0)
		monster.request_event_script(503)
		monster.set_variable(66, 1)
	end
	timer.wait_frames(30)
	while true do
		vm.wait()
	end
end

--- Updates the shared hull life pool from the damage taken and starts the death sequence when the ship life reaches zero.
local function track_damage_and_check_death()
	local previous_life: s32 = 0
	local life: s32 = 0
	local damage_taken: s32 = 0
	previous_life = monster.get_variable(4) or previous_life
	life = monster.get_monster_life(-1) or life
	monster.set_variable(4, life)
	damage_taken = vm.i32(previous_life - life)
	life = monster.get_monster_life(-1) or life
	if life <= 0 then
		print("dead-------------\n")
		on_death()
	end
	life = monster.get_variable(64) or life
	life = vm.i32(life - damage_taken)
	monster.set_variable(64, life)
	if life <= 6000 then
		monster.get_variable(66)
	end
	monster.get_variable(65)
	life = monster.get_variable(64) or life
end

--- Checks the monster state and waits one frame.
local function update_and_wait_frame()
	track_damage_and_check_death()
	vm.wait()
end

--- Counts the turrets still alive on each side of the ship.
local function count_living_turrets_per_side(side_b_count: s32, side_a_count: s32)
	local life_fraction: f32 = 0
	local side_b_alive: s32 = 0
	local side_a_alive: s32 = 0
	side_b_count = 0
	side_a_count = 0
	life_fraction = monster.get_monster_life_fraction(25) or life_fraction
	if life_fraction > 0.0 then
		side_a_alive = side_a_alive + 1
	end
	life_fraction = monster.get_monster_life_fraction(27) or life_fraction
	if life_fraction > 0.0 then
		side_a_alive = side_a_alive + 1
	end
	life_fraction = monster.get_monster_life_fraction(28) or life_fraction
	if life_fraction > 0.0 then
		side_a_alive = side_a_alive + 1
	end
	life_fraction = monster.get_monster_life_fraction(29) or life_fraction
	if life_fraction > 0.0 then
		side_a_alive = side_a_alive + 1
	end
	life_fraction = monster.get_monster_life_fraction(30) or life_fraction
	if life_fraction > 0.0 then
		side_a_alive = side_a_alive + 1
	end
	life_fraction = monster.get_monster_life_fraction(26) or life_fraction
	if life_fraction > 0.0 then
		side_b_alive = side_b_alive + 1
	end
	life_fraction = monster.get_monster_life_fraction(31) or life_fraction
	if life_fraction > 0.0 then
		side_b_alive = side_b_alive + 1
	end
	life_fraction = monster.get_monster_life_fraction(32) or life_fraction
	if life_fraction > 0.0 then
		side_b_alive = side_b_alive + 1
	end
	life_fraction = monster.get_monster_life_fraction(33) or life_fraction
	if life_fraction > 0.0 then
		side_b_alive = side_b_alive + 1
	end
	life_fraction = monster.get_monster_life_fraction(34) or life_fraction
	if life_fraction > 0.0 then
		side_b_alive = side_b_alive + 1
	end
	side_b_count = side_b_alive
	side_a_count = side_a_alive
	return side_b_count, side_a_count
end

--- Returns the angle perpendicular to the target, turning toward the side with fewer living turrets.
local function get_circling_angle()
	local angle: f32 = 0
	local side_b_alive: s32 = 0
	local side_a_alive: s32 = 0
	side_b_alive, side_a_alive = count_living_turrets_per_side(side_b_alive, side_a_alive)
	angle = monster.get_target_angle() or angle
	if side_b_alive < side_a_alive then
		angle = vm.f32(angle + vm.f32(1.5707964))
	else
		angle = vm.f32(angle - vm.f32(1.5707964))
	end
	return angle
end

--- Moves the ship to a point with a speed that decays toward the end, then turns it to a final angle.
local function sail_to_point_and_turn(destination_x: f32, destination_y: f32, destination_z: f32, start_speed: f32, max_frames: s32, final_angle: f32)
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local distance_to_destination: f32 = 0
	local deceleration: f32 = 0
	local speed: f32 = 0
	local frame_index: s32 = 0
	local current_rotation: f32 = 0
	do
		local out1, out2, out3 = monster.get_position_3()
		current_x = out1 or current_x
		current_y = out2 or current_y
		current_z = out3 or current_z
	end
	do
		local out1, out2, out3 = monster.get_position_3()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = monster.copy_vector(destination_x, destination_y, destination_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.subtract_vectors(direction_x, direction_y, direction_z, position_x, position_y, position_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(direction_x, direction_y, direction_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	speed = start_speed
	distance_to_destination = monster.get_distance_between(destination_x, destination_y, destination_z, position_x, position_y, position_z) or distance_to_destination
	deceleration = calc.get_acceleration(distance_to_destination, speed, vm.f32(vm.fdiv(vm.f32(distance_to_destination * vm.f32(1.9)), speed)), deceleration)
	frame_index = 0
	while frame_index < max_frames do
		speed = vm.f32(speed + deceleration)
		if speed < 0.0 then
			break
		end
		do
			local out1, out2, out3 = monster.get_position_3()
			current_x = out1 or current_x
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		do
			local out1, out2, out3 = monster.get_position_3()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		distance_to_destination = monster.get_distance_between(destination_x, destination_y, destination_z, position_x, position_y, position_z) or distance_to_destination
		if distance_to_destination < speed then
			break
		end
		do
			local out1, out2, out3 = monster.copy_vector(direction_x, direction_y, direction_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.scale_vector(step_x, step_y, step_z, speed)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = monster.add_vectors(current_x, current_y, current_z, step_x, step_y, step_z)
			current_x = out1 or current_x
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		monster.set_position(current_x, current_y, current_z)
		monster.turn_toward_angle(final_angle, 0.004363323)
		update_and_wait_frame()
		frame_index = frame_index + 1
		movement.stop_turning()
	end
	while true do
		do
			local _, out2, _ = monster.get_rotation()
			current_rotation = out2 or current_rotation
		end
		monster.turn_toward_angle(final_angle, 0.004363323)
		if calc.compare_angles(current_rotation, final_angle, vm.f32(0.004363323)) == 0 then
			break
		else
			update_and_wait_frame()
		end
	end
	movement.stop_turning()
end

--- Sails the ship out to a point far from the arena centre in the direction of the target and turns it broadside.
local function sail_to_far_point()
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local final_angle: f32 = 0
	final_angle = get_circling_angle()
	do
		local out1, out2, out3 = monster.get_target_position()
		destination_x = out1 or destination_x
		destination_y = out2 or destination_y
		destination_z = out3 or destination_z
	end
	do
		local out1, out2, out3 = monster.normalize_vector(destination_x, destination_y, destination_z)
		destination_x = out1 or destination_x
		destination_y = out2 or destination_y
		destination_z = out3 or destination_z
	end
	do
		local out1, out2, out3 = monster.scale_vector(destination_x, destination_y, destination_z, 1000.0)
		destination_x = out1 or destination_x
		destination_y = out2 or destination_y
		destination_z = out3 or destination_z
	end
	destination_y = 300.0
	sail_to_point_and_turn(destination_x, destination_y, destination_z, 9.0, 180, final_angle)
end

--- Waits until the ship faces a target angle or the frame limit passes, and returns the frames waited.
local function wait_until_facing(target_angle: f32, turn_speed: f32, max_frames: f32)
	local current_angle: f32 = 0
	local elapsed_frames: f32 = 0
	local frame_limit: f32 = 0
	local angle_tolerance: f32 = 0
	target_angle = calc.degrees_to_radians(target_angle)
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	turn_speed = calc.degrees_to_radians(turn_speed)
	frame_limit = max_frames
	if turn_speed < 3.0 then
		angle_tolerance = calc.degrees_to_radians(3.0)
	else
		angle_tolerance = turn_speed
	end
	elapsed_frames = 0.0
	while elapsed_frames < frame_limit do
		do
			local _, out2, _ = monster.get_rotation()
			current_angle = out2 or current_angle
		end
		if current_angle > vm.f32(target_angle - angle_tolerance) and current_angle < vm.f32(target_angle + angle_tolerance) then
			movement.stop_turning()
			break
		elseif calc.compare_angles(target_angle, current_angle, turn_speed) == 0 then
			movement.stop_turning()
			break
		elseif elapsed_frames >= max_frames then
			movement.stop_turning()
			break
		else
			update_and_wait_frame()
			elapsed_frames = vm.f32(elapsed_frames + 1.0)
		end
	end
	movement.stop_turning()
	return elapsed_frames
end

--- Turns the ship toward an angle at a given speed and waits until it faces it.
local function turn_to_angle_and_wait(target_angle: f32, turn_speed: f32)
	target_angle = calc.degrees_to_radians(target_angle)
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	turn_speed = calc.degrees_to_radians(turn_speed)
	if turn_speed > vm.f32(3.1415927) then
		turn_speed = vm.f32(turn_speed - vm.f32(6.2831855))
	end
	if turn_speed <= vm.f32(-3.1415927) then
		turn_speed = vm.f32(turn_speed + vm.f32(6.2831855))
	end
	monster.turn_toward_angle(target_angle, turn_speed)
	local _ = wait_until_facing(
		calc.radians_to_degrees(target_angle),
		calc.radians_to_degrees(turn_speed),
		vm.f32(vm.fdiv(360.0, calc.radians_to_degrees(turn_speed)))
	)
	movement.stop_turning()
end

--- Turns the ship broadside to the target, choosing the side by which has more living turrets.
local function turn_broadside(turn_speed: f32)
	local angle: f32 = 0
	local side_b_alive: s32 = 0
	local side_a_alive: s32 = 0
	side_b_alive, side_a_alive = count_living_turrets_per_side(side_b_alive, side_a_alive)
	angle = monster.get_target_angle() or angle
	if side_b_alive > side_a_alive then
		angle = vm.f32(angle + vm.f32(1.5707964))
	else
		angle = vm.f32(angle - vm.f32(1.5707964))
	end
	turn_to_angle_and_wait(calc.radians_to_degrees(angle), calc.radians_to_degrees(turn_speed))
end

--- Waits for a number of frames.
local function wait_frames(frame_count: any)
	local frame_index: s32 = 0
	frame_index = 0
	while frame_index < frame_count do
		update_and_wait_frame()
		frame_index = vm.i32(frame_index + 1)
	end
end

--- Sails out, turns broadside and then moves along two random corner routes of the arena.
local function sail_between_corners()
	local destination_x: f32 = 0
	local destination_y: f32 = 0
	local destination_z: f32 = 0
	local look_x: f32 = 0
	local look_y: f32 = 0
	local look_z: f32 = 0
	local facing_angle: f32 = 0
	local route: s32 = 0
	update_and_wait_frame()
	sail_to_far_point()
	monster.set_variable(8, 1)
	turn_broadside(vm.f32(0.004363323))
	wait_frames(240)
	monster.set_variable(8, 0)
	for i = 0, 1 do
		route = monster.get_random(4) or route
		if route == 0 then
			destination_x = vm.f32(vm.sin(0.0) * 600.0)
			destination_z = vm.f32(vm.cos(0.0) * 600.0)
			destination_y = 150.0
			look_x = vm.f32(vm.sin(vm.f32(1.5707964)) * 600.0)
			look_z = vm.f32(vm.cos(vm.f32(1.5707964)) * 600.0)
			look_y = 0.0
			facing_angle = monster.get_angle_to_position(look_x, look_y, look_z) or facing_angle
			sail_to_point_and_turn(destination_x, destination_y, destination_z, 9.0, 180, facing_angle)
		end
		if route == 1 then
			destination_x = vm.f32(vm.sin(vm.f32(1.5707964)) * 600.0)
			destination_z = vm.f32(vm.cos(vm.f32(1.5707964)) * 600.0)
			destination_y = 250.0
			look_x = vm.f32(vm.sin(vm.f32(3.1415927)) * 600.0)
			look_z = vm.f32(vm.cos(vm.f32(3.1415927)) * 600.0)
			look_y = 0.0
			facing_angle = monster.get_angle_to_position(look_x, look_y, look_z) or facing_angle
			sail_to_point_and_turn(destination_x, destination_y, destination_z, 9.0, 180, facing_angle)
		end
		if route == 2 then
			destination_x = vm.f32(vm.sin(vm.f32(3.1415927)) * 600.0)
			destination_z = vm.f32(vm.cos(vm.f32(3.1415927)) * 600.0)
			destination_y = 300.0
			look_x = vm.f32(vm.sin(vm.f32(4.712389)) * 600.0)
			look_z = vm.f32(vm.cos(vm.f32(4.712389)) * 600.0)
			look_y = 100.0
			facing_angle = monster.get_angle_to_position(look_x, look_y, look_z) or facing_angle
			sail_to_point_and_turn(destination_x, destination_y, destination_z, 9.0, 180, facing_angle)
		end
		if route == 3 then
			destination_x = vm.f32(vm.sin(vm.f32(4.712389)) * 600.0)
			destination_z = vm.f32(vm.cos(vm.f32(4.712389)) * 600.0)
			destination_y = 250.0
			look_x = vm.f32(vm.sin(0.0) * 600.0)
			look_z = vm.f32(vm.cos(0.0) * 600.0)
			look_y = 200.0
			facing_angle = monster.get_angle_to_position(look_x, look_y, look_z) or facing_angle
			sail_to_point_and_turn(destination_x, destination_y, destination_z, 9.0, 180, facing_angle)
		end
	end
end

local script = {}

--- Does nothing.
function script.setup() end

--- Attaches the ship to the battleship map piece, loads its effects and sets the shared life pool.
function script.init()
	local free_texture_block: s32 = 0
	local first_script_loaded: s32 = 0
	local second_script_loaded: s32 = 0
	local third_script_loaded: s32 = 0
	local life: s32 = 0
	local character_type: s32 = 0
	monster.set_monster_attributes(4, 1)
	monster.set_monster_attributes(8, 1)
	monster.link_map_part("p01_battleship")
	monster.set_position(0.0, 200.0, 0.0)
	monster.set_rotation(0.0, 0.0, 0.0)
	free_texture_block = monster.get_free_texture_block() or free_texture_block
	if free_texture_block ~= -1 then
		first_script_loaded = monster.load_effect_script("Ｍ汎用煙", free_texture_block) or first_script_loaded
		second_script_loaded = monster.load_effect_script("軍艦ダメージ", free_texture_block) or second_script_loaded
		if (if first_script_loaded ~= 0 then 1 else second_script_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	free_texture_block = monster.get_free_texture_block() or free_texture_block
	if free_texture_block ~= -1 then
		first_script_loaded = monster.load_effect_script("機関銃（小）", free_texture_block) or first_script_loaded
		if first_script_loaded ~= 0 then
			monster.reserve_texture_block()
		end
	end
	free_texture_block = monster.get_free_texture_block() or free_texture_block
	if free_texture_block ~= -1 then
		first_script_loaded = monster.load_effect_script("Ｍ爆発大", free_texture_block) or first_script_loaded
		second_script_loaded = monster.load_effect_script("砲弾", free_texture_block) or second_script_loaded
		third_script_loaded = monster.load_effect_script("マズルフラッシュ", free_texture_block) or third_script_loaded
		if (if (if first_script_loaded ~= 0 then 1 else second_script_loaded) ~= 0 then 1 else third_script_loaded) ~= 0 then
			monster.reserve_texture_block()
		end
	end
	monster.set_variable(8, 0)
	monster.set_lock_on_mode(2)
	monster.set_variable(64, 0)
	monster.set_variable(65, 0)
	life = monster.get_monster_life(-1) or life
	monster.set_variable(4, life)
	monster.set_variable(64, life)
	monster.set_variable(65, life)
	monster.set_variable(66, 0)
	character_type = monster.get_character_number() or character_type
	monster.set_variable(67, character_type)
	monster.set_variable(68, 0)
	monster.play_monster_sound(character_type, 2)
	set_clip_distance_for_boss()
	monster.set_visible_monster_limit(15)
	monster.set_monster_attributes(512, 1)
	monster.set_clip_distance(999999.0)
	monster.set_camera_mode(4)
end

--- Repeatedly updates the ship and sails to new positions.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	while true do
		update_and_wait_frame()
		sail_between_corners()
	end
end

--- Reacts to a hit that staggers it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, which suppresses the default damage reaction.
function script.on_damage() end

--- Reacts to a hit that knocks it over.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, which suppresses the default knockdown reaction.
function script.on_knockdown() end

--- Guards against a hit.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, which suppresses the default guard reaction.
function script.on_guard() end

script.on_death = on_death

return script
