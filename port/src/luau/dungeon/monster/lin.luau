--!strict
--- Controls Lin, who cowers in a frightened stance and reacts to the nearest monster.

local vm = require("@lib/vm")
local calc = require("@lib/monster/calc")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local state = require("@lib/monster/state")
local timer = require("@lib/monster/timer")

--- Stores flags describing how near, far or off-angle the nearest monster is.
local function update_situation_flags()
	local situation_flags: s32 = 0
	local nearest_x: f32 = 0
	local nearest_y: f32 = 0
	local nearest_z: f32 = 0
	local nearest_distance: f32 = 0
	local angle_to_monster: f32 = 0
	local rotation_y: f32 = 0
	situation_flags = 0
	do
		local out1, out2, out3, out4 = monster.get_nearest_monster_position()
		nearest_x = out1 or nearest_x
		nearest_y = out2 or nearest_y
		nearest_z = out3 or nearest_z
		nearest_distance = out4 or nearest_distance
	end
	if nearest_distance ~= -1.0 and nearest_distance < 6.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 8))
	end
	if nearest_distance ~= -1.0 and nearest_distance < 100.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 1))
	end
	if nearest_distance ~= -1.0 and nearest_distance > 260.0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 2))
	end
	do
		local _, out2, _ = monster.get_rotation()
		rotation_y = out2 or rotation_y
	end
	angle_to_monster = monster.get_angle_to_position(nearest_x, nearest_y, nearest_z) or angle_to_monster
	if calc.compare_angles(angle_to_monster, rotation_y, vm.f32(0.2)) ~= 0 then
		situation_flags = vm.i32(bit32.bor(situation_flags, 4))
	end
	monster.set_variable(0, situation_flags)
end

--- Chooses the next reaction from the situation flags and the queued reactions.
local function choose_reaction()
	local situation_flags: s32 = 0
	local queued_reaction: s32 = 0
	local following_reaction: s32 = 0
	situation_flags = monster.get_variable(0) or situation_flags
	if bit32.band(situation_flags, 8) ~= 0 then
		monster.set_variable(1, 1)
		return
	end
	queued_reaction = monster.get_variable(2) or queued_reaction
	if queued_reaction ~= -1 then
		if bit32.band(situation_flags, 1) ~= 0 and queued_reaction == 6 then
			monster.set_variable(1, 6)
			monster.set_variable(2, 6)
			return
		end
		following_reaction = monster.get_variable(3) or following_reaction
		monster.set_variable(1, queued_reaction)
		monster.set_variable(2, following_reaction)
		monster.set_variable(3, -1)
		return
	end
	if bit32.band(situation_flags, 8) ~= 0 then
		monster.set_variable(1, 1)
		return
	end
	if bit32.band(situation_flags, 1) ~= 0 then
		monster.set_variable(1, 5)
		monster.set_variable(2, 6)
		return
	else
		if bit32.band(situation_flags, 2) ~= 0 then
			monster.set_variable(1, 4)
			monster.set_variable(2, 2)
		end
		if bit32.band(situation_flags, 4) ~= 0 then
			monster.set_variable(1, 4)
			monster.set_variable(2, 0)
			monster.set_variable(3, 2)
			return
		end
	end
	monster.set_variable(1, 3)
end

--- Requests the event script that plays when a monster is very close.
local function request_close_monster_event()
	monster.request_event_script(520)
	vm.wait()
end

--- Waits until the rotation is within a tolerance of an angle.
local function wait_until_facing(target_angle: f32, tolerance: f32)
	local rotation_y: f32 = 0
	while true do
		vm.wait()
		do
			local _, out2, _ = monster.get_rotation()
			rotation_y = out2 or rotation_y
		end
		if vm.f32(target_angle + tolerance) > rotation_y and vm.f32(target_angle - tolerance) < rotation_y then
			break
		end
	end
end

--- Turns toward the nearest monster while walking and then returns to the frightened stance.
local function turn_toward_nearest_monster()
	local nearest_x: f32 = 0
	local nearest_y: f32 = 0
	local nearest_z: f32 = 0
	local angle_to_monster: f32 = 0
	do
		local out1, out2, out3, _ = monster.get_nearest_monster_position()
		nearest_x = out1 or nearest_x
		nearest_y = out2 or nearest_y
		nearest_z = out3 or nearest_z
	end
	angle_to_monster = monster.get_angle_to_position(nearest_x, nearest_y, nearest_z) or angle_to_monster
	monster.turn_toward_angle(angle_to_monster, 0.06981317)
	monster.set_motion("歩き")
	wait_until_facing(angle_to_monster, vm.f32(0.13962634))
	monster.set_motion("おびえ立ち")
end

--- Waits out the stored idle time and resets it.
local function wait_idle_timer()
	local idle_frames: s32 = 0
	idle_frames = monster.get_variable(4) or idle_frames
	timer.wait_frames_countdown(idle_frames)
	monster.set_variable(4, 30)
end

--- Plays the motion for the chosen reaction.
local function perform_reaction()
	local reaction: s32 = 0
	reaction = monster.get_variable(1) or reaction
	if reaction == 1 then
		request_close_monster_event()
	end
	if reaction == 4 then
		monster.set_motion("キョロキョロ", -1, 2)
		motion.wait_until_finished()
	end
	if reaction == 5 then
		monster.set_motion("驚く", -1, 2)
		vm.wait()
		motion.wait_until_ended()
	end
	if reaction == 6 then
		monster.set_motion("驚くL", -1, 4)
	end
	if reaction == 0 then
		turn_toward_nearest_monster()
	end
	if reaction == 2 then
		monster.set_motion("おびえ立ち")
		wait_idle_timer()
	end
	if reaction == 3 then
		monster.set_motion("おびえ立ち")
	end
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Clears the reaction state and starts the frightened stance.
function script.init()
	monster.set_variable(0, 0)
	monster.set_variable(1, 0)
	monster.set_variable(2, -1)
	monster.set_variable(3, -1)
	monster.set_variable(4, 30)
	monster.set_motion("おびえ立ち", -1, 4)
	monster.set_monster_attributes(33, 1)
end

--- Updates the situation, chooses a reaction and plays it every frame.
function script.loop()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
	monster.set_action_status(0)
	monster.set_motion("おびえ立ち")
	while true do
		update_situation_flags()
		choose_reaction()
		perform_reaction()
		vm.wait()
	end
end

--- Reacts to a hit that staggers it.
script.on_damage = state.reset_variables

--- Reacts to a hit that knocks it over.
script.on_knockdown = state.reset_variables

--- Guards against a hit.
script.on_guard = state.reset_variables

--- Dodges the target's first kind of attack.
script.on_dodge_1 = state.reset_variables

--- Dodges the target's second kind of attack.
script.on_dodge_2 = state.reset_variables

--- Plays the death motion and the death effects.
function script.on_death()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	monster.stop_moving()
	movement.stop_turning()
	monster.start_death()
	monster.set_motion("死に", -1, 6)
	motion.wait_until_finished()
	monster.spawn_death_effects()
	while true do
		vm.wait()
	end
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores being caught.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores landing.
function script.on_land() end

--- Stops moving and turning without reacting.
function script.on_stun()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.stop_moving()
	movement.stop_turning()
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

return script
