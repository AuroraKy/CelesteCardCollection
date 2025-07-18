-- region Mechanical Heart

local mechanicalheart = {
	name = "ccc_Mechanical Heart",
	key = "mechanicalheart",
	config = {extra = {xmult = 2}},
	pos = { x = 0, y = 8 },
	rarity = 'ccc_secret',
	cost = 15,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "9Ts",
		code = "toneblock",
		concept = "Fytos"
	},
    description = "If played hand is a single Ace of Clubs, turn all Clubs held in hand into Steel Cards (Unaffected by retriggers)"
}

mechanicalheart.calculate = function(self, card, context)
	if context.before and #context.full_hand == 1 and context.full_hand[1]:get_id() == 14 and context.full_hand[1]:is_suit('Clubs', true) then
		local steels = 0
		for i = 1, #G.hand.cards do
			if G.hand.cards[i]:is_suit('Clubs', true) then
				G.hand.cards[i]:set_ability(G.P_CENTERS.m_steel, nil, true)
				G.hand.cards[i].ability.h_x_mult = card.ability.extra.xmult
				G.hand.cards[i]:juice_up()
				steels = steels + 1
			end
		end
		if steels > 0 then
			return {
				message = localize('k_ccc_steel'),
				colour = lighten(G.C.BLACK, 0.5)
			}
		end
	end
end

mechanicalheart.yes_pool_flag = 'secretheart'

return mechanicalheart
-- endregion Mechanical Heart