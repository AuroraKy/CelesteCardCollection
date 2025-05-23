-- region Zipper

local zipper = {
	name = "ccc_Zipper",
	key = "zipper",
	config = { extra = { chips = 0, chips_scale = 35 } },
	pos = { x = 4, y = 0 },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "toneblock"
	}
}

zipper.set_ability = function(self, card, initial, delay_sprites)
	card.ability.extra.chips = G.GAME.skips * card.ability.extra.chips_scale
end

zipper.calculate = function(self, card, context)
	card.ability.extra.chips = G.GAME.skips * card.ability.extra.chips_scale
	if context.skip_blind then
		if not context.blueprint then
			G.E_MANAGER:add_event(Event({
				func = function()
					card_eval_status_text(card, 'extra', nil, nil, nil, {
						message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } },
						colour = G.C.CHIPS
					})
					return true
				end
			}))
		end
	end
	if context.joker_main then
		if card.ability.extra.chips ~= 0 then
			return {
				message = localize {
					type = 'variable',
					key = 'a_chips',
					vars = { card.ability.extra.chips }
				},
				chip_mod = card.ability.extra.chips
			}
		end
	end
end

function zipper.loc_vars(self, info_queue, card)
	return { vars = { card.ability.extra.chips, card.ability.extra.chips_scale } }
end

return zipper
-- endregion Zipper