--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_100ac525 = require("@lib/event/helper_100ac525")
local helper_6232e03e = require("@lib/event/helper_6232e03e")
local helper_fc8fdf1e = require("@lib/event/helper_fc8fdf1e")

--- Helper function.
local function helper_ac1d9bd8(arg0: s32)
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_100ac525(4)
		end
		if at <= 2 then
			helper_fc8fdf1e(64)
		end
		if at <= 3 then
			helper_100ac525(4)
		end
	end
	event.SetMotion(0, "立ち")
	event.AssignStack(5)
	event.ClearStack(5)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	if arg0 == 0 then
		event.SetLoadbgFile("textures/event/etc/heki401.json")
	end
	if arg0 == 1 then
		event.SetLoadbgFile("textures/event/etc/heki402.json")
	end
	if arg0 == 2 then
		event.SetLoadbgFile("textures/event/etc/heki403.json")
	end
	if arg0 == 3 then
		event.SetLoadbgFile("textures/event/etc/heki404.json")
	end
	if arg0 == 4 then
		event.SetLoadbgFile("textures/event/etc/heki405.json")
	end
	if arg0 == 5 then
		event.SetLoadbgFile("textures/event/etc/heki406.json")
	end
	if arg0 == 6 then
		event.SetLoadbgFile("textures/event/etc/heki407.json")
	end
	if arg0 == 7 then
		event.SetLoadbgFile("textures/event/etc/heki408.json")
	end
	helper_6232e03e()
	if vm.skipping() then
		return skip(1)
	end
	if arg0 == 0 then
		block = event.LoadImg_4(5, "textures/event/etc/heki401.json", 0) or block
		event.SpriteSetTexture(0, "heki401", block)
	end
	if arg0 == 1 then
		block = event.LoadImg_4(5, "textures/event/etc/heki402.json", 0) or block
		event.SpriteSetTexture(0, "heki402", block)
	end
	if arg0 == 2 then
		block = event.LoadImg_4(5, "textures/event/etc/heki403.json", 0) or block
		event.SpriteSetTexture(0, "heki403", block)
	end
	if arg0 == 3 then
		block = event.LoadImg_4(5, "textures/event/etc/heki404.json", 0) or block
		event.SpriteSetTexture(0, "heki404", block)
	end
	if arg0 == 4 then
		block = event.LoadImg_4(5, "textures/event/etc/heki405.json", 0) or block
		event.SpriteSetTexture(0, "heki405", block)
	end
	if arg0 == 5 then
		block = event.LoadImg_4(5, "textures/event/etc/heki406.json", 0) or block
		event.SpriteSetTexture(0, "heki406", block)
	end
	if arg0 == 6 then
		block = event.LoadImg_4(5, "textures/event/etc/heki407.json", 0) or block
		event.SpriteSetTexture(0, "heki407", block)
	end
	if arg0 == 7 then
		block = event.LoadImg_4(5, "textures/event/etc/heki408.json", 0) or block
		event.SpriteSetTexture(0, "heki408", block)
	end
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 416)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(0, 128.0, 128.0, 128.0, 128.0, 4)
	helper_100ac525(4)
	if vm.skipping() then
		return skip(2)
	end
	helper_fc8fdf1e(64)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetColor(0, 128.0, 128.0, 128.0, 0.0, 4)
	helper_100ac525(4)
	if vm.skipping() then
		return skip(4)
	end
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(0, 0)
	event.DelImg(0)
end

return helper_ac1d9bd8
