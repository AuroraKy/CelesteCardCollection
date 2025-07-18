
local crystalheart = {
	name = "ccc_Crystal Heart",
	key = "crystalheart",
    config = {extra = {cards = 2}},
	pos = {x = 7, y = 4},
	rarity = 'ccc_secret',
	cost = 15,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	},
    description = "If you play a single Ace of Hearts add a random Edition to a card held in hand (Unaffected by retriggers)"
}

crystalheart.calculate = function(self, card, context)

	if context.before and #context.full_hand == 1 and context.full_hand[1]:get_id() == 14 and context.full_hand[1]:is_suit('Hearts', true) then
		local edition_card_candidates = {}
		for i = 1, #G.hand.cards do
			if not G.hand.cards[i].edition then
				edition_card_candidates[#edition_card_candidates + 1] = G.hand.cards[i]
			end
		end
		if #edition_card_candidates > (G.GAME.ccc_edition_buffer and G.GAME.ccc_edition_buffer or 0) then
			G.GAME.ccc_edition_buffer = (G.GAME.ccc_edition_buffer and G.GAME.ccc_edition_buffer or 0) + card.ability.extra.cards
			return {
				G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
					for i = 1, card.ability.extra.cards do
						local edition_card_candidates_2 = {}
						for i = 1, #G.hand.cards do
							if not G.hand.cards[i].edition then
								edition_card_candidates_2[#edition_card_candidates_2 + 1] = G.hand.cards[i]
							end
						end
						if #edition_card_candidates_2 > 0 then
							local edition_card = pseudorandom_element(edition_card_candidates_2, pseudoseed('crystal_heart_card'))
							local edition = poll_edition('crystal_heart_ed', nil, true, true)
							edition_card:set_edition(edition, true)
							card:juice_up()
						end
						G.GAME.ccc_edition_buffer = G.GAME.ccc_edition_buffer - 1
					end
				return true end })),
				message = localize('k_ccc_applied'),
				colour = G.C.DARK_EDITION
			}
		end
	end
end

function crystalheart.loc_vars(self, info_queue, card)
	return { vars = { card.ability.extra.cards } }
end

crystalheart.yes_pool_flag = 'secretheart'

return crystalheart