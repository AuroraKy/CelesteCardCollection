
-- region Badeline

local badeline = {
	name = "ccc_Badeline",
	key = "badeline",
	config = {extra = {xmult = 1.25}},
	pos = {x = 0, y = 5},
	soul_pos = {x = 0, y = 6},
	rarity = 4,
	cost = 20,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie + Fytos"
	},
    description = "Sustain Mirrored and Glass cards, they give X1.25 if scored"
}

badeline.yes_pool_flag = 'preventsoulspawn'

-- huge jank on calculate but i don't even know tbh... card = card????????? it shouldn't need that...
-- apparently you're passing card (the object) to card (the return value) so you do need that

badeline.calculate = function(self, card, context)
	--[[
	if context.repetition then
		if context.cardarea == G.play then
			if (context.other_card.edition and context.other_card.edition.ccc_mirrored) or SMODS.has_enhancement(context.other_card, 'm_glass') then
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = card
				}
			end
		elseif context.cardarea == G.hand then
			if ((context.other_card.edition and context.other_card.edition.ccc_mirrored) or SMODS.has_enhancement(context.other_card, 'm_glass')) and (next(context.card_effects[1]) or #context.card_effects > 1) then
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = card
				}
			end
		end
	end
	]]
	if context.individual and context.cardarea == G.play then
		if (context.other_card.edition and context.other_card.edition.ccc_mirrored) or SMODS.has_enhancement(context.other_card, 'm_glass') then
			return {
				x_mult = card.ability.extra.xmult,
				card = card
			}
		end
	end
	if context.fix_probability and context.identifier == 'glass' and not context.blueprint then
		return {
			numerator = 0,
			denominator = math.max(1, context.denominator)
		}
	end
end

function badeline.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'e_mirrored', set = 'Other'}
	info_queue[#info_queue+1] = G.P_CENTERS.m_glass
	return {vars = {card.ability.extra.xmult}}
end

return badeline
-- endregion Badeline