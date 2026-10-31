local feather = {
	name = "ccc_Feather",
	key = "feather",
	config = {extra = {xmult = 1, mult_scale = 0.04}},
	pos = {x = 0, y = 0},
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "toneblock"
	},
    description = "Gains X0.04 for each card drawn, resets at end of round"
}

feather.calculate = function(self, card, context)

    if context.hand_drawn and not context.blueprint then
		-- card.ability.extra.xmult = card.ability.extra.xmult + (card.ability.extra.mult_scale * #context.hand_drawn)
		SMODS.scale_card(card, {
			ref_table = card.ability.extra,
            ref_value = "xmult",
			scalar_value = "mult_scale",
			scalar_factor = #context.hand_drawn,
			no_message = true,
			--message_key = "a_xmult",
			--message_colour = G.C.RED
		})
	end
	
    if context.joker_main then
		return {
			xmult = card.ability.extra.xmult, 
		}
    end
	
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
		-- card.ability.extra.xmult = 1
		-- card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_ccc_reset'), colour = G.C.FILTER})
		SMODS.reset_card(card, {
            ref_table = card.ability.extra,
            ref_value = 'xmult',
            reset_value = 1,
            message_colour = G.C.FILTER
        })
	end
end

function feather.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.mult_scale, card.ability.extra.xmult}}
end

return feather