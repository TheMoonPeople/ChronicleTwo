--!strict
--- Controls one of the six parts of the Shingala boss, which stomps, goes limp and returns.

local vm = require("@lib/vm")
local death = require("@lib/monster/death")
local motion = require("@lib/monster/motion")
local movement = require("@lib/monster/movement")
local reaction = require("@lib/monster/reaction")
local state = require("@lib/monster/state")

--- Stores which of the six boss parts this monster is.
local function set_part_index(value: s32)
	monster.set_variable(5, value)
end

--- Reads which of the six boss parts this monster is.
local function get_part_index(part_index: s32)
	local value: s32 = 0
	value = 0
	value = monster.get_variable(5) or value
	part_index = value
	return part_index
end

--- Stores the part's current phase.
local function set_phase(value: s32)
	monster.set_variable(2, value)
end

--- Stores how many times the part has been hit.
local function set_hit_count(value: s32)
	monster.set_variable(1, value)
end

--- Sets a wide clip distance for the boss and a short one for the spare parts.
local function configure_clip_distance()
	local boss: s32 = 0
	boss = monster.is_boss() or boss
	if boss == 0 then
		monster.get_position_3()
		monster.set_clip_distance(35.0)
	else
		monster.set_clip_distance(999999.0)
	end
end

--- Reads the part's current phase.
local function get_phase(phase: s32)
	local value: s32 = 0
	value = monster.get_variable(2) or value
	phase = value
	return phase
end

--- Reads whether the part has an attack request pending.
local function get_attack_request_for_part(request: s32)
	local part_index: s32 = 0
	local value: s32 = 0
	part_index = 0
	value = 0
	part_index = get_part_index(part_index)
	value = monster.get_variable(vm.i32(part_index + 20)) or value
	request = value
	return request
end

--- Reads whether this part has an attack request pending.
local function get_attack_request()
	local request: s32 = 0
	request = 0
	request = get_attack_request_for_part(request)
	return request
end

--- Stores the life lost between two readings.
local function store_damage_taken(current_life: s32, previous_life: s32)
	monster.set_variable(4, vm.i32(previous_life - current_life))
end

--- Returns 1 when the life has run out, 2 when it dropped and 0 otherwise.
local function check_life_change()
	local life: s32 = 0
	local value: s32 = 0
	value = monster.get_variable(7) or value
	life = monster.get_monster_life(-1) or life
	if life <= 0 then
		monster.set_variable(7, life)
		return 1
	end
	if vm.i32(life - value) < 0 then
		monster.set_variable(7, life)
		store_damage_taken(life, value)
		return 2
	end
	monster.set_variable(7, life)
	return 0
end

--- Adds one to the part's hit count.
local function increment_hit_count()
	local value: s32 = 0
	value = monster.get_variable(1) or value
	monster.set_variable(1, vm.i32(value + 1))
end

--- Counts damage taken and refills the part's life.
local function refresh_life()
	local life_change: s32 = 0
	local max_life: s32 = 0
	if get_attack_request() ~= 0 then
		life_change = check_life_change()
		if life_change == 2 then
			increment_hit_count()
		end
	end
	max_life = monster.get_monster_max_life(-1) or max_life
	monster.add_monster_life(-1, max_life)
end

--- Refreshes the life and waits one frame.
local function advance_frame()
	refresh_life()
	vm.wait()
end

--- Waits a number of frames while refreshing the life.
local function wait_frames(frame_count: any)
	local frame: s32 = 0
	frame = 0
	while frame < frame_count do
		advance_frame()
		frame = vm.i32(frame + 1)
	end
end

--- Waits until the current motion has finished while refreshing the life.
local function wait_for_motion_end()
	local is_finished: s32 = 0
	while true do
		advance_frame()
		is_finished = monster.is_motion_finished() or is_finished
		if is_finished ~= 0 then
			return
		end
	end
end

--- Stomps the ground and kicks up dust in a ring.
local function attack_stomp()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local vector: f32 = 0
	local vector_3: f32 = 0
	local dust_angle: f32 = 0
	monster.set_motion("攻撃１", -1, 6)
	wait_frames(85)
	do
		local out1, out2, out3 = monster.get_frame_position("marioa_null")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	for dust_index = 0, 4 do
		dust_angle = vm.f32(vm.f32(1.2566371) * dust_index)
		vector = vm.f32(pos_x + vm.f32(vm.sin(dust_angle) * 20.0))
		vector_3 = vm.f32(pos_z + vm.f32(vm.cos(dust_angle) * 20.0))
		monster.create_effect_1("砂煙")
		monster.set_effect_first_vector(-1, vector, 0.0, vector_3)
		vm.wait()
	end
	wait_for_motion_end()
end

--- Shows or hides the map piece that belongs to this part.
local function set_part_marker_visibility(show: s32)
	local part_index: s32 = 0
	part_index = get_part_index(part_index)
	if part_index == 0 then
		monster.set_map_part_visible("p01_boss", "boss-c0", show)
	end
	if part_index == 1 then
		monster.set_map_part_visible("p01_boss", "boss-c1", show)
	end
	if part_index == 2 then
		monster.set_map_part_visible("p01_boss", "boss-c2", show)
	end
	if part_index == 3 then
		monster.set_map_part_visible("p01_boss", "boss-c3", show)
	end
	if part_index == 4 then
		monster.set_map_part_visible("p01_boss", "boss-c4", show)
	end
	if part_index == 5 then
		monster.set_map_part_visible("p01_boss", "boss-c5", show)
	end
end

--- Plays the limp motion.
local function play_limp_motion()
	monster.set_motion("ぐったりL", -1, 0)
end

--- Reads the part's hit count.
local function get_hit_count(hit_count: s32)
	local value: s32 = 0
	value = monster.get_variable(1) or value
	hit_count = value
	return hit_count
end

--- Measures the ground distance to the partner part.
local function get_distance_to_partner(distance: f32)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local partner_x: f32 = 0
	local partner_z: f32 = 0
	local partner_distance: f32 = 0
	local value: s32 = 0
	value = monster.get_variable(30) or value
	do
		local out1, _, out3 = monster.get_monster_position(value)
		partner_x = out1 or partner_x
		partner_z = out3 or partner_z
	end
	do
		local out1, _, out3 = monster.get_position_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	partner_distance = monster.get_distance_between(pos_x, 0.0, pos_z, partner_x, 0.0, partner_z) or partner_distance
	distance = partner_distance
	return distance
end

--- Plays the return motion, with an electric shock if the part was hit.
local function return_to_start()
	local chara_type: s32 = 0
	local value: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_monster_attributes(32, 1)
	monster.set_motion("戻り", -1, 6)
	value = monster.get_variable(10) or value
	if value ~= 0 then
		chara_type = monster.get_character_number() or chara_type
		monster.create_effect_1("Ｍ感電")
		monster.set_effect_owner(-1, chara_type)
		motion.wait_until_finished()
	else
		wait_for_motion_end()
	end
	monster.set_monster_attributes(32, 0)
	monster.set_mask_flags(1, 0)
	monster.set_mask_flags(2, 0)
end

--- Stores whether the part has an attack request pending.
local function set_attack_request(value: s32)
	local part_index: s32 = 0
	part_index = get_part_index(part_index)
	monster.set_variable(vm.i32(part_index + 20), value)
end

--- Clears the movement and faces the player ahead of a reaction.
local function prepare_reaction()
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.reset_motion()
	monster.stop_moving()
	movement.stop_turning()
	movement.face_target_instantly()
	advance_frame()
	monster.set_action_status(1)
end

local script = {}

--- Does nothing at load time.
function script.setup() end

--- Registers the damage hits and works out which boss part this monster is.
function script.init()
	local chara_type: s32 = 0
	local part_index: s32 = 0
	monster.register_damage_hit("吹っ飛び攻撃", 18.0, "攻撃１", 0.219, 0.504, 0)
	monster.register_damage_hit("吹っ飛び攻撃", 20.0, "攻撃１", 0.219, 0.504, 1)
	monster.register_damage_hit("吹っ飛び攻撃", 18.0, "攻撃１", 0.219, 0.504, 2)
	monster.register_damage_hit("シーグラ攻撃", 14.0, "戻り", 0.109, 0.2, 0)
	monster.set_monster_attributes(128, 1)
	monster.set_clip_distance(10000.0)
	monster.set_monster_attributes(512, 1)
	chara_type = monster.get_character_number() or chara_type
	print("user_id=", chara_type, "----------\n")
	print("USERID_INDEX=", 24, "---------------\n")
	if chara_type == 24 then
		print("0---------------\n")
		set_part_index(0)
	end
	if chara_type == 25 then
		print("1---------------\n")
		set_part_index(1)
	end
	if chara_type == 26 then
		print("2---------------\n")
		set_part_index(2)
	end
	if chara_type == 27 then
		print("3---------------\n")
		set_part_index(3)
	end
	if chara_type == 28 then
		print("4---------------\n")
		set_part_index(4)
	end
	if chara_type == 29 then
		print("5---------------\n")
		set_part_index(5)
	end
	monster.load_effect_script("Ｍ感電")
	part_index = get_part_index(part_index)
	print("seag id=", part_index, "------------\n")
	monster.set_variable(vm.i32(part_index + 20), 0)
	monster.set_variable(2, 0)
	monster.set_variable(10, 0)
	set_phase(3)
	set_hit_count(0)
	configure_clip_distance()
end

--- Runs the part's cycle of attacking, staying limp and returning to its start.
function script.loop()
	local partner_distance: f32 = 0
	local phase: s32 = 0
	local hit_count: s32 = 0
	local limp_frames: s32 = 0
	monster.set_mask_flags(1, 1)
	monster.set_mask_flags(2, 1)
	monster.set_action_status(0)
	monster.set_motion("立ち", -1, 0)
	while true do
		phase = get_phase(phase)
		if phase == 1 then
			attack_stomp()
			set_phase(4)
			limp_frames = 0
		end
		if phase == 4 then
			set_part_marker_visibility(1)
			play_limp_motion()
			hit_count = get_hit_count(hit_count)
			partner_distance = get_distance_to_partner(partner_distance)
			if hit_count >= 1 then
				monster.set_variable(10, 1)
				set_phase(2)
				set_hit_count(0)
			end
			if partner_distance > 450.0 and limp_frames > 210 then
				set_phase(2)
				set_hit_count(0)
			end
			limp_frames = vm.i32(limp_frames + 1)
		end
		if phase == 2 then
			set_part_marker_visibility(0)
			return_to_start()
			monster.set_variable(10, 0)
			set_phase(3)
			set_attack_request(0)
		end
		if phase == 3 or phase == 0 then
			if get_attack_request() ~= 0 then
				print("set act attack\n")
				set_phase(1)
			end
			monster.set_motion("立ち", -1, 0)
		end
		advance_frame()
	end
end

--- Flinches from the hit and recovers.
function script.on_damage()
	monster.add_monster_life_fraction(-1, 1.0)
	state.stop_and_clear_action()
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	wait_for_motion_end()
	wait_frames(12)
	monster.set_motion("立ち")
	state.do_nothing()
end

--- Flinches from the hit and recovers.
function script.on_knockdown()
	prepare_reaction()
	monster.set_monster_attributes(32, 0)
	monster.set_motion("ダメージ", -1, 6)
	monster.start_knockback(0.0, 0.0, 0)
	wait_for_motion_end()
	wait_frames(12)
	monster.set_motion("立ち")
	state.unlock_and_clear_action()
end

--- Locks and unlocks without reacting.
function script.on_guard()
	state.lock_and_stop_moving()
	state.unlock()
end

--- Turns toward the target when dodging.
function script.on_dodge_1()
	local target_angle: f32 = 0
	state.lock_and_reset_motion()
	target_angle = monster.get_target_angle() or target_angle
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, target_angle, 0.0)
	advance_frame()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Turns toward the target when dodging.
function script.on_dodge_2()
	local target_angle: f32 = 0
	state.lock_and_reset_motion()
	target_angle = monster.get_target_angle() or target_angle
	if target_angle > vm.f32(3.1415927) then
		target_angle = vm.f32(target_angle - vm.f32(6.2831855))
	end
	if target_angle <= vm.f32(-3.1415927) then
		target_angle = vm.f32(target_angle + vm.f32(6.2831855))
	end
	monster.set_rotation(0.0, target_angle, 0.0)
	advance_frame()
	monster.set_motion("立ち", -1, 0)
	state.unlock()
end

--- Plays the death motion and effects.
function script.on_death()
	death.begin()
	monster.set_motion("死に", -1, 2)
	wait_for_motion_end()
	monster.spawn_death_effects()
	while true do
		advance_frame()
	end
	death.play_effects()
end

--- Reacts to being caught by a frame that lifts it.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores being caught.
function script.on_caught() end

--- Lands the monster after it has been thrown.
-- Defined empty, so the engine runs this instead of its default.
--- Ignores landing.
function script.on_land() end

--- Plays the knockdown and getting-up motions while stunned.
function script.on_stun()
	state.clear_attribute_and_lock()
	monster.set_motion("吹っ飛び", -1, 6)
	wait_for_motion_end()
	monster.set_motion("起き上がり", -1, 6)
	wait_for_motion_end()
	reaction.stun_until_recovered()
end

return script
