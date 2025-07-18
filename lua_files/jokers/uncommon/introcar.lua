-- region Intro Car

local introcar = {
	name = "ccc_Intro Car",
	key = "introcar",
	config = { extra = { add = 5 } },
	pos = { x = 7, y = 3 },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Bred + Fytos"
	},
    description = "Before each 5 or 8 is scored, swap current Chips and Mult"
}

introcar.calculate = function(self, card, context)
	if context.individual then
		if context.cardarea == G.play then
			if context.other_card:get_id() == 5 or context.other_card:get_id() == 8 then -- this is all faked with delays and stuff because it simply does not work with event manager
				delay(0.2)
				local temp_chips = hand_chips
				local temp_mult = mult
				hand_chips = mod_chips(temp_mult)
				mult = mod_mult(temp_chips)
				update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
				card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_ccc_swapped'), colour = G.C.FILTER })
				delay(0.2)
			end
		end
	end
end

function introcar.loc_vars(self, info_queue, card)
	return { vars = { card.ability.extra.add } }
end

return introcar
-- endregion Intro Car