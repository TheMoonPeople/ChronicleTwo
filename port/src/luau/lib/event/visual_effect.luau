--!strict
--- Controls event sprites and visual effects.


local visual_effect = {}

--- Removes all 48 event sprites from the draw pass.
function visual_effect.hide_all_sprites()
	for i = 0, 47 do
		event.set_event_sprite_draw_pass(i, 0)
	end
end

--- Steps a sprite index through all 48 event sprites without drawing; this stands in for visual_effect.hide_all_sprites when events are skipped.
function visual_effect.hide_all_sprites_skipping()
	local i: s32 = 0
	i = 0
	local _ = i < 48
	i = i + 1
end

return visual_effect
