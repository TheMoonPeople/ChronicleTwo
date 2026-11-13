--!strict
--- Follows a thrown item in the owner's hand and, on release, lobs it and triggers the effect for its item type.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Keeps the effect on the owner's item attachment point until released.
function script.on_start()
	local owner_id: s32 = 0
	local item_x: f32 = 0
	local item_y: f32 = 0
	local item_z: f32 = 0
	owner_id = effect.get_owner_character() or owner_id
	while true do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "item")
			item_x = out1 or item_x
			item_y = out2 or item_y
			item_z = out3 or item_z
		end
		effect.set_effect_character_position(item_x, item_y, item_z)
		vm.wait()
	end
end

--- Throws the item in an arc with bouncing and collision, then spawns the effect matching the item type where it lands.
function script.on_finish()
	local item_x: f32 = 0
	local item_y: f32 = 0
	local item_z: f32 = 0
	local landing_x: f32 = 0
	local landing_y: f32 = 0
	local landing_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local owner_id: s32 = 0
	local item_id: s32 = 0
	local gravity: f32 = 0
	local flight_time: f32 = 0
	local has_item_shape: s32 = 0
	local gift_value_1: s32 = 0
	local gift_value_2: s32 = 0
	local gift_value_3: s32 = 0
	local frame: s32 = 0
	local hit_result: s32 = 0
	local area_kind: s32 = 0
	local foot_sound: s32 = 0
	local footstep_cooldown: s32 = 0
	local surface_x: f32 = 0
	local surface_y: f32 = 0
	local surface_z: f32 = 0
	local normal_x: f32 = 0
	local normal_y: f32 = 0
	local normal_z: f32 = 0
	local probe_x: f32 = 0
	local probe_y: f32 = 0
	local probe_z: f32 = 0
	local speed: f32 = 0
	local remaining_distance: f32 = 0
	local travel_distance: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		landing_x = out1 or landing_x
		landing_y = out2 or landing_y
		landing_z = out3 or landing_z
	end
	owner_id = effect.get_owner_character() or owner_id
	effect.get_script_value(0)
	item_id = effect.get_script_value(1) or item_id
	do
		local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "item")
		item_x = out1 or item_x
		item_y = out2 or item_y
		item_z = out3 or item_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(landing_x, landing_y, landing_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.subtract_vectors(velocity_x, velocity_y, velocity_z, item_x, item_y, item_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.normalize_vector(velocity_x, velocity_y, velocity_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 6.0)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	flight_time = effect.get_distance_between(item_x, item_y, item_z, landing_x, landing_y, landing_z) or flight_time
	gravity = vm.f32(-0.25 + vm.f32(flight_time * vm.f32(0.0004)))
	flight_time = vm.f32(vm.f32(flight_time / 6.0) + 1.0)
	velocity_y = vm.f32(
		vm.fdiv(
			vm.f32(vm.f32(vm.f32(landing_y - item_y) * 2.0) - vm.f32(vm.f32(gravity * flight_time) * flight_time)),
			vm.f32(flight_time * 2.0)
		)
	)
	has_item_shape = 0
	if item_id == 304 then
		effect.create_collision_primitive("ギフト")
		gift_value_1 = effect.get_script_value(2) or gift_value_1
		gift_value_2 = effect.get_script_value(3) or gift_value_2
		gift_value_3 = effect.get_script_value(4) or gift_value_3
		effect.set_collision_primitive_gift(gift_value_1, gift_value_2, gift_value_3)
		has_item_shape = 1
	end
	if item_id == 287 then
		effect.create_collision_primitive("ときめきチェリ")
		has_item_shape = 1
	end
	if item_id == 288 then
		effect.create_collision_primitive("ストーンベリー")
		has_item_shape = 1
	end
	if item_id == 289 then
		effect.create_collision_primitive("ネバピーチ")
		has_item_shape = 1
	end
	if item_id == 291 then
		effect.create_collision_primitive("毒りんご")
		has_item_shape = 1
	end
	if item_id == 281 then
		effect.create_collision_primitive("石コロ")
		has_item_shape = 1
	end
	if has_item_shape == 0 then
		effect.create_collision_primitive("円形チェック用")
	end
	footstep_cooldown = 0
	frame = 0
	while frame < 60 do
		do
			local out1, out2, out3 = effect.copy_vector(item_x, item_y, item_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(item_x, item_y, item_z, velocity_x, velocity_y, velocity_z)
			item_x = out1 or item_x
			item_y = out2 or item_y
			item_z = out3 or item_z
		end
		velocity_y = vm.f32(velocity_y + gravity)
		speed = effect.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
		remaining_distance = speed
		do
			local out1, out2, out3 = effect.copy_vector(velocity_x, velocity_y, velocity_z)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(probe_x, probe_y, probe_z)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(probe_x, probe_y, probe_z, 2.0)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8, out9 = effect.get_intersection_point_16(
				0,
				previous_x,
				previous_y,
				previous_z,
				vm.f32(item_x + probe_x) + velocity_x,
				vm.f32(item_y + probe_y) + velocity_y,
				vm.f32(item_z + probe_z) + velocity_z
			)
			surface_x = out1 or surface_x
			surface_y = out2 or surface_y
			surface_z = out3 or surface_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			hit_result = out7 or hit_result
			area_kind = out8 or area_kind
			foot_sound = out9 or foot_sound
		end
		if
			footstep_cooldown <= 0
			and hit_result >= 0
			and (velocity_y < 0.0 and normal_y > 0.0)
			and (velocity_x > 0.0 and normal_x > 0.0 or velocity_x < 0.0 and normal_x < 0.0)
			and (velocity_z > 0.0 and normal_z > 0.0 or velocity_z < 0.0 and normal_z < 0.0)
		then
			if foot_sound == 1 or foot_sound == 13 then
				effect.create_effect_1("足芝生")
				effect.set_effect_first_work_vector(surface_x, surface_y, surface_z)
				effect.create_effect_1("足砂煙")
				effect.set_effect_first_work_vector(surface_x, surface_y, surface_z)
			end
			if foot_sound == 7 or foot_sound == 14 or foot_sound == 16 then
				effect.create_effect_1("足砂煙")
				effect.set_effect_first_work_vector(surface_x, surface_y, surface_z)
			end
			if foot_sound == 11 or foot_sound == 18 or (area_kind == 1 or area_kind == 7) then
				effect.create_effect_1("足水パシャ")
				effect.set_effect_first_work_vector(surface_x, surface_y, surface_z)
			end
			footstep_cooldown = 10
		end
		if footstep_cooldown > 0 then
			footstep_cooldown = footstep_cooldown - 1
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				effect.get_intersection_point_14(4, previous_x, previous_y, previous_z, item_x + probe_x, item_y + probe_y, item_z + probe_z)
			surface_x = out1 or surface_x
			surface_y = out2 or surface_y
			surface_z = out3 or surface_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			hit_result = out7 or hit_result
		end
		if hit_result >= 0 then
			speed = vm.f32(speed * vm.f32(0.6))
		end
		while hit_result >= 0 do
			do
				local out1, out2, out3 = effect.copy_vector(-probe_x, -probe_y, -probe_z)
				probe_x = out1 or probe_x
				probe_y = out2 or probe_y
				probe_z = out3 or probe_z
			end
			do
				local out1, out2, out3 = effect.add_vectors(surface_x, surface_y, surface_z, probe_x, probe_y, probe_z)
				surface_x = out1 or surface_x
				surface_y = out2 or surface_y
				surface_z = out3 or surface_z
			end
			do
				local out1, out2, out3 = effect.copy_vector(surface_x, surface_y, surface_z)
				item_x = out1 or item_x
				item_y = out2 or item_y
				item_z = out3 or item_z
			end
			travel_distance = effect.get_distance_between(previous_x, previous_y, previous_z, item_x, item_y, item_z) or travel_distance
			do
				local out1, out2, out3 = effect.copy_vector(normal_x, normal_y, normal_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, speed)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			remaining_distance = vm.f32(remaining_distance - travel_distance)
			if remaining_distance <= 0.0 then
				break
			else
				do
					local out1, out2, out3 = effect.scale_vector(normal_x, normal_y, normal_z, remaining_distance)
					normal_x = out1 or normal_x
					normal_y = out2 or normal_y
					normal_z = out3 or normal_z
				end
				do
					local out1, out2, out3 = effect.copy_vector(item_x, item_y, item_z)
					previous_x = out1 or previous_x
					previous_y = out2 or previous_y
					previous_z = out3 or previous_z
				end
				do
					local out1, out2, out3 = effect.add_vectors(item_x, item_y, item_z, normal_x, normal_y, normal_z)
					item_x = out1 or item_x
					item_y = out2 or item_y
					item_z = out3 or item_z
				end
				do
					local out1, out2, out3 = effect.copy_vector(normal_x, normal_y, normal_z)
					probe_x = out1 or probe_x
					probe_y = out2 or probe_y
					probe_z = out3 or probe_z
				end
				do
					local out1, out2, out3 = effect.normalize_vector(probe_x, probe_y, probe_z)
					probe_x = out1 or probe_x
					probe_y = out2 or probe_y
					probe_z = out3 or probe_z
				end
				do
					local out1, out2, out3 = effect.scale_vector(probe_x, probe_y, probe_z, 2.0)
					probe_x = out1 or probe_x
					probe_y = out2 or probe_y
					probe_z = out3 or probe_z
				end
				do
					local out1, out2, out3, out4, out5, out6, out7 = effect.get_intersection_point_14(
						4,
						previous_x,
						previous_y,
						previous_z,
						item_x + probe_x,
						item_y + probe_y,
						item_z + probe_z
					)
					surface_x = out1 or surface_x
					surface_y = out2 or surface_y
					surface_z = out3 or surface_z
					normal_x = out4 or normal_x
					normal_y = out5 or normal_y
					normal_z = out6 or normal_z
					hit_result = out7 or hit_result
				end
			end
		end
		do
			local out1, out2, out3, out4 =
				effect.get_intersection_point_11(4, item_x, item_y, item_z, item_x, item_y - vm.f32(1.9), item_z)
			surface_x = out1 or surface_x
			surface_y = out2 or surface_y
			surface_z = out3 or surface_z
			hit_result = out4 or hit_result
		end
		if hit_result >= 0 then
			velocity_x = vm.f32(velocity_x * vm.f32(0.6))
			velocity_y = -vm.f32(velocity_y * vm.f32(0.6))
			velocity_z = vm.f32(velocity_z * vm.f32(0.6))
			do
				local out1, out2, out3 = effect.copy_vector(surface_x, surface_y + 2.0, surface_z)
				item_x = out1 or item_x
				item_y = out2 or item_y
				item_z = out3 or item_z
			end
		end
		effect.set_collision_primitive_shape(item_x, item_y, item_z, 5.0)
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			break
		else
			effect.set_effect_character_position(item_x, item_y, item_z)
			frame = frame + 1
			vm.wait()
		end
	end
	effect.delete_collision_primitive(-1)
	if item_id == 276 then
		effect.create_effect_1("魔石聖")
		effect.set_effect_first_work_vector(item_x, item_y, item_z)
		effect.set_effect_value(0, 2)
	end
	if item_id == 290 then
		effect.create_effect_1("爆発")
		effect.set_effect_first_work_vector(item_x, item_y, item_z)
		effect.set_effect_value(0, 4)
	end
	if item_id == 280 then
		effect.create_effect_1("爆発")
		effect.set_effect_first_work_vector(item_x, item_y, item_z)
		effect.set_effect_value(0, 1)
	end
	if item_id == 390 then
		effect.create_effect_1("爆発")
		effect.set_effect_first_work_vector(item_x, item_y, item_z)
		effect.set_effect_value(0, 2)
	end
	if item_id == 391 then
		effect.create_effect_1("ＦボムＨ")
		effect.set_effect_first_work_vector(item_x, item_y, item_z)
		effect.set_effect_value(0, 3)
	end
	if item_id == 307 then
		effect.create_effect_1("電光石火")
		effect.set_effect_first_work_vector(item_x, item_y, item_z)
		effect.set_effect_value(0, 3)
	end
	if item_id == 282 then
		effect.create_effect_1("魔石炎")
		effect.set_effect_first_work_vector(item_x, item_y, item_z)
	end
	if item_id == 283 then
		effect.create_effect_1("魔石冷")
		effect.set_effect_first_work_vector(item_x, item_y, item_z)
	end
	if item_id == 284 then
		effect.create_effect_1("魔石雷")
		effect.set_effect_first_work_vector(item_x, item_y, item_z)
	end
	if item_id == 285 then
		effect.create_effect_1("魔石風")
		effect.set_effect_first_work_vector(item_x, item_y, item_z)
	end
	if item_id == 286 then
		effect.create_effect_1("魔石聖")
		effect.set_effect_first_work_vector(item_x, item_y, item_z)
		effect.set_effect_value(0, 1)
	end
end

return script
