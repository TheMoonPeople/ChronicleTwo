--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_e3a22687()
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	block = event.LoadImg_4(5, "textures/event/e200/e207/e207_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e20701", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 416)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(20, 0)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e20702", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 416)
	event.SpriteSetPutsize(1, 512, 416)
	event.SpriteSetPos(1, 256, 208)
	event.SpriteSetDraw(1, 0)
	event.EohSyncSprite(21, 1)
	event.ObjsInit(21)
	event.ObjsSyncObj(21, 21)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "e20703", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 416)
	event.SpriteSetPutsize(2, 512, 416)
	event.SpriteSetPos(2, 256, 208)
	event.SpriteSetDraw(2, 0)
	event.EohSyncSprite(22, 2)
	event.ObjsInit(22)
	event.ObjsSyncObj(22, 22)
	event.SpriteInit(3)
	event.SpriteSetType(3, 0)
	event.SpriteSetTexture(3, "e20704", block)
	event.SpriteSetColor(3, 128, 128, 128, 0)
	event.SpriteSetUvsize(3, 0, 0, 512.0, 416)
	event.SpriteSetPutsize(3, 512, 416)
	event.SpriteSetPos(3, 256, 208)
	event.SpriteSetDraw(3, 0)
	event.EohSyncSprite(23, 3)
	event.ObjsInit(23)
	event.ObjsSyncObj(23, 23)
end

return helper_e3a22687
