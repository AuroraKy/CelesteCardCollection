-- region seeker
--cursed idea

local seeker = {
	name = "ccc_Seeker",
	key = "seeker",
	config = { extra = { suit = "Hearts", rank = "Ace" } },
	pos = { x = 6, y = 4 },
	rarity = 3,
	cost = 10,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	},
    description = "If card is drawn face up and is not most owned rank or suit, redraw it once.",
	load = function(self, card, card_table, other_card)
		G.GAME.pool_flags.seeker_table = {
			rank = card_table.ability.extra.rank,
			suit = card_table.ability.extra.suit,
		}
		for i, card in ipairs(G.play.cards) do
			draw_card(G.play, G.deck, i * 100 / math.min(#G.deck.cards, G.hand.config.card_limit - #G.hand.cards), 'up',
				true)
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.pool_flags.seeker_table = nil
		for _, v in ipairs(G.jokers.cards) do
			if v ~= card and v.ability.name == "ccc_Seeker" and not v.debuff then
				G.GAME.pool_flags.seeker_table = {
					rank = v.ability.extra.rank,
					suit = v.ability.extra.suit,
				}
			end
		end
	end
}

seeker.get_common_suit_and_ranks = function(card)
	local ranks = {}
	local suits = {}
	if G.playing_cards == nil then
		G.GAME.pool_flags.seeker_table = nil
		return
	end
	for index, card in ipairs(G.playing_cards) do
		if card.ability.effect ~= 'Stone Card' then
			ranks[card.base.value] = (ranks[card.base.value] or 0) + 1
			suits[card.base.suit] = (suits[card.base.suit] or 0) + 1
		end
	end
	local most_common_suit = {
		key = "Hearts",
		value = -1
	}
	local most_common_rank = {
		key = "Ace",
		value = -1
	}
	for key, value in pairs(ranks) do
		if value > most_common_rank.value then
			most_common_rank.key = key
			most_common_rank.value = value
		end
	end
	for key, value in pairs(suits) do
		if value > most_common_suit.value then
			most_common_suit.key = key
			most_common_suit.value = value
		end
	end
	card.ability.extra.rank = most_common_rank.key
	card.ability.extra.suit = most_common_suit.key

	G.GAME.pool_flags.seeker_table = {
		rank = card.ability.extra.rank,
		suit = card.ability.extra.suit,
	}
end

seeker.set_ability = function(self, card, initial, delay_sprites)
	seeker.get_common_suit_and_ranks(card)
end

seeker.calculate = function(self, card, context)
	seeker.get_common_suit_and_ranks(card)                                                     -- could possibly just put this function into Card:update instead of calling it frequently? similar to secret shrine

	if context.ccc_drawfromdeck and not context.blueprint and not GLOBAL_seeker_proc == true then -- custom context created in lovely
		GLOBAL_seeker_proc = true

		local card_pos = {}
		local card_redraw_candidates = {}
		G.deck:shuffle('see' .. G.GAME.round_resets.ante) -- shuffle is early, otherwise card drawing gets messed up
		hand_size = context.ccc_amount
		for i = 1, hand_size do
			local future_card = G.deck.cards
			[(#G.deck.cards - (i - 1))]                        -- end of G.deck.cards currently has the cards that are about to be drawn
			local ranks = { "", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace" }
			local future_card_rank = ranks[future_card:get_id()] or "0"
			local stay_flipped = G.GAME and G.GAME.blind and
			G.GAME.blind:stay_flipped(G.hand, G.deck.cards[(#G.deck.cards - (i - 1))])
			if ((not (future_card_rank == G.GAME.pool_flags.seeker_table.rank or future_card:is_suit(G.GAME.pool_flags.seeker_table.suit, true)))
					or (future_card.ability.name == 'Stone Card')) and (not stay_flipped == true) then
				card_redraw_candidates[#card_redraw_candidates + 1] = future_card
				card_pos[#card_pos + 1] = i
			end
		end
		if #card_redraw_candidates > 0 then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				func = function()
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_ccc_redraw'), colour = G.C.FILTER })
					local hand_count = #card_redraw_candidates
					for i = 1, hand_count do
						draw_card(G.hand, G.deck, i * 100 / hand_count, 'down', nil, card_redraw_candidates[i], 0.08)
					end
					G.FUNCS.draw_from_deck_to_hand(hand_count)
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			func = function()
				GLOBAL_seeker_proc = false
				return true
			end
		}))
	end
end

function seeker.loc_vars(self, info_queue, card)
	return {
		vars = {
			localize(card.ability.extra.rank, 'ranks'),
			localize(card.ability.extra.suit, 'suits_plural'),
			colours = {
				G.C.SUITS[card.ability.extra.suit], }
		}
	}
end

return seeker
-- endregion seeker