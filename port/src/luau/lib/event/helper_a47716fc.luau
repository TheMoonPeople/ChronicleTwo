--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7b50e496 = require("@lib/event/helper_7b50e496")
local helper_ccc22d40 = require("@lib/event/helper_ccc22d40")
local helper_df58599d = require("@lib/event/helper_df58599d")
local helper_e8b18690 = require("@lib/event/helper_e8b18690")

--- Helper function.
local function helper_a47716fc()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var3: s32 = 0
	local angle: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_df58599d(2)
		end
		if at <= 2 then
			helper_df58599d(2)
		end
		if at <= 3 then
			helper_7b50e496()
		end
		if at <= 4 then
			helper_7b50e496()
		end
		if at <= 5 then
			helper_e8b18690(18)
		end
		if at <= 6 then
			helper_e8b18690(5)
		end
		if at <= 7 then
			helper_df58599d(2)
		end
		if at <= 8 then
			helper_df58599d(0)
		end
		if at <= 9 then
			helper_e8b18690(18)
		end
		if at <= 10 then
			helper_e8b18690(5)
		end
		if at <= 11 then
			helper_df58599d(2)
		end
		if at <= 12 then
			helper_e8b18690(30)
		end
		if at <= 13 then
			var3 = 0
			angle = vm.f32(-2.9)
			var6 = 0
			var6 = vm.f32(var6 + vm.f32(0.04619989))
			var5 = vm.f32(vm.sin(var6) * vm.f32(0.3))
			angle = vm.f32(angle + var5)
			var3 = var3 + 1
		end
		if at <= 15 then
			helper_ccc22d40(64)
		end
	end
	event.Initialize()
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMotion(5, "event/lm/e250r/e250_mints.gltf", "info", 0)
	event.SetCharaPos(0, -211.18, 0.0, 11.07)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetMotion(0, "上見立ち", 4)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(1, 8)
	event.LoadEquip(5, 1, 4, "info", 8)
	event.LoadEquip(5, 1, 3, "info", 8)
	event.LoadEquip(5, 1, 2, "info", 8, 13)
	event.CharaActive(13)
	event.SetCharaPos(8, -173.24, 0.0, 0.0)
	event.SetCharaRot(8, 0.0, 0.0, 0.0)
	event.LoadMotion(5, "event/lm/e250r/e250_monica.gltf", "info", 8)
	event.SetMotion(8, "上見立ち", 4)
	event.EohSyncChara(1, 8)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "event/lm/e250r/e250_toryon.gltf", "info", 9)
	event.CharaActive(9)
	event.SetCharaPos(9, -1121.01, 394.47, -2048.83)
	event.SetCharaRot(9, 0.0, 0.0, 0.0)
	event.EohSyncChara(2, 9)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/lm/e250r/e250_tree.gltf", "info", 10)
	event.SetCharaRot(10, 0.0, 3.14, 0.0)
	event.CharaActive(0, 10)
	event.SetReference(9, "R_tree", 10)
	event.LoadChara(5, "event/lm/e250r/e250_tree.gltf", "info", 11)
	event.SetCharaRot(11, 0.0, 3.14, 0.0)
	event.CharaActive(0, 11)
	event.SetReference(9, "L_tree", 11)
	event.EohSyncChrobj(6, 9, "puropera")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsRotation(6, 0.0, -0.2, 0.0, -1)
	event.CmrsInit()
	event.CmrsSetPos(-601.29, 522.11, 100.72)
	event.CmrsSetRef(-689.32, 571.24, -105.58)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove2(2, -1121.01, 995.31, -2048.83, 60, 2, 0.5)
	event.ObjsRotation(2, 0.0, -3.14, 0.0, 40)
	event.ObjsRotation(2, 0.0, 1.57, 0.0, 20)
	event.ObjsRotation2(2, 0.0, 0.16, 0.0, 20, 2, 0.5)
	helper_df58599d(2)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove2(2, -671.63, 447.09, -193.49, 80, 1, 0.4)
	event.CmrsMove2(-601.29, 522.11, 100.72, -654.5, 581.35, -117.24, 60, 0, 0.4)
	helper_df58599d(2)
	if vm.skipping() then
		return skip(3)
	end
	helper_7b50e496()
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-298.8, 199.33, -185.86)
	event.CmrsSetRef(-194.57, 243.43, 136.45)
	event.CharaActive(1, 10)
	event.CharaActive(1, 11)
	event.SetCharaPos(9, -221.16, 0.0, 293.2)
	event.SetCharaRot(9, 0.0, 3.14, 0.0)
	event.SetMotion(9, "木持ち浮遊", 4)
	event.CmrsMove2(-299.31, 60.07, -348.88, -167.05, 136.09, 169.13, 60, 0, 0.5)
	helper_7b50e496()
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(2, "右の木を植える", 2)
	event.ObjsNextMotion(2, "右の木を植えるL", 4)
	helper_e8b18690(18)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(0, "右へよける", 6)
	event.SetMotion(8, "左へよける", 6)
	helper_e8b18690(5)
	if vm.skipping() then
		return skip(7)
	end
	do
		local out1, _, out3 = event.EohGetFramePos(2, "R_tree")
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	event.DelReference(10)
	event.SetCharaPos(10, pos_x, 0.0, pos_z)
	event.SetMotion(10, "ぷるん", 6)
	event.CmrsQuake(0.0, 4.0, 0.0, 20)
	helper_df58599d(2)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(-280.52, 44.63, 49.11)
	event.CmrsSetRef(-280.82, 14.35, 12.64)
	event.SetCharaPos(0, -281.18, 0.0, 11.07)
	event.SetCharaPos(9, -291.16, 0.0, 293.2)
	event.ObjsSetMotion(0, "前を見る", 6)
	event.ObjsNextMotion(0, "前を見るL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目・おどろき")
	event.ObjsTexAnime(0, 1, "口・はっ")
	helper_df58599d(0)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(-299.31, 60.07, -348.88)
	event.CmrsSetRef(-167.05, 136.09, 169.13)
	event.ObjsSetMotion(2, "左の木を植える", 2)
	event.ObjsNextMotion(2, "左の木を植えるL", 4)
	helper_e8b18690(18)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(0, "左へよける", 6)
	helper_e8b18690(5)
	if vm.skipping() then
		return skip(11)
	end
	do
		local out1, _, out3 = event.EohGetFramePos(2, "L_tree")
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	event.DelReference(11)
	event.SetCharaPos(11, pos_x, 0.0, pos_z)
	event.SetMotion(11, "ぷるん", 6)
	event.CmrsQuake(0.0, 4.0, 0.0, 20)
	helper_df58599d(2)
	if vm.skipping() then
		return skip(12)
	end
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(-814.87, 217.76, -136.29)
	event.CmrsSetRef(-388.48, 229.58, 435.09)
	event.CmrsMove2(-647.69, 217.76, 87.74, -388.48, 229.58, 435.09, 64, 2, 0.5)
	event.SetCharaPos(9, -360.96, 101.44, 464.93)
	event.SetCharaRot(9, 0.0, -2.9, 0.0)
	event.ObjsSetMotion(2, "まわる", 6)
	event.ObjsNextMotion(2, "まわるL", 6)
	event.ObjsMotionDelay(2, 1)
	event.ObjsSetStep(2, 1.0)
	event.ObjsNextMotion(2, "ピース", 6)
	event.ObjsNextMotion(2, "ピースL", 4)
	var3 = 0
	angle = vm.f32(-2.9)
	var6 = 0
	while var3 < 68 do
		var6 = vm.f32(var6 + vm.f32(0.04619989))
		var5 = vm.f32(vm.sin(var6) * vm.f32(0.3))
		angle = vm.f32(angle + var5)
		angle = event.AngleLimit(angle) or angle
		event.SetCharaRot(9, 0.0, angle, 0.0)
		var3 = var3 + 1
		if vm.wait() then
			return skip(14)
		end
	end
	if vm.wait() then
		return skip(15)
	end
	helper_ccc22d40(64)
	if vm.skipping() then
		return skip(16)
	end
	event.DelExtMotion(0)
	event.DeleteChara(8)
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.DeleteChara(11)
	event.DeleteChara(13)
end

return helper_a47716fc
