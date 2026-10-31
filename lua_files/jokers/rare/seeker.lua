-- region seeker
--cursed idea

local seeker = {
	name = "ccc_Seeker",
	key = "seeker",
	config = { extra = { suit = "Hearts", rank = "Ace", triggered = false} },
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
		if not SMODS.has_no_rank(card) then
			ranks[card.base.value] = (ranks[card.base.value] or 0) + 1
		end
		if not SMODS.has_no_suit(card) then
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

	local drawn_cards = (context.hand_drawn or context.other_drawn)

	if context.pre_discard or context.before then -- if for some reason the block persisted, before a hand/discard is a safe place to reset it
		G.GAME.ccc_seeker_block = false
	end
	
	if drawn_cards and not context.blueprint and not G.GAME.ccc_seeker_block and not card.ability.extra.triggered then -- custom context created in lovely

		local card_pos = {}
		local card_redraw_candidates = {}
		G.deck:shuffle('see' .. G.GAME.round_resets.ante) -- shuffle is early, otherwise card drawing gets messed up
		hand_size = #drawn_cards
		for k, card_drawn in pairs(drawn_cards) do
			if ((not (card_drawn.base.value == G.GAME.pool_flags.seeker_table.rank or card_drawn:is_suit(G.GAME.pool_flags.seeker_table.suit, true)))
					or (SMODS.has_no_suit(card_drawn) or SMODS.has_no_rank(card_drawn))) and (card_drawn.facing ~= 'back') then
				card_redraw_candidates[#card_redraw_candidates + 1] = card_drawn
				card_pos[#card_pos + 1] = i
			end
		end
		if #card_redraw_candidates > 0 then
			G.GAME.ccc_seeker_block = true -- this is an immediate blocker, so other seekers don't try to evaluate the same draw
			G.E_MANAGER:add_event(Event({
				func = function()
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_ccc_redraw'), colour = G.C.FILTER })
					local hand_count = #card_redraw_candidates
					for i = 1, hand_count do
						draw_card(G.hand, G.deck, i * 100 / hand_count, 'down', nil, card_redraw_candidates[i], 0.08)
					end
					G.GAME.ccc_seeker_block = false -- what should happen is seekers will evaluate the card drawn by this seeker 
					card.ability.extra.triggered = true -- except of course, the seeker itself
					--recursion happens here, but you're so triggered it won't happen again
					SMODS.draw_cards(hand_count)
					G.E_MANAGER:add_event(Event({
						func = function()
							-- seekers get triggered one by one until all of them are triggered, i.e. the complete evaluation is done, then we know we can untrigger them all for next time something is drawn
							local this_evaluation_done = true
							for key, seeker in pairs(SMODS.find_card(card.config.center_key), true) do
								if not seeker.ability.extra.triggered then
									this_evaluation_done = false
									break
								end
							end

							if this_evaluation_done then
								--need to add an event here, otherwise this would run *before* the events created by SMODS.draw_cards and create a loop
								G.E_MANAGER:add_event(Event({
									func = function()
										G.GAME.ccc_seeker_block = false;
										for key, seeker in pairs(SMODS.find_card(card.config.center_key), true) do
											seeker.ability.extra.triggered = false
										end
										return true 
									end
								}))
							end

							G.GAME.ccc_seeker_block = false; 
							return true 
						end
					}))
					
					return true
				end
			}))
		else -- hand is all right, so end early
			G.E_MANAGER:add_event(Event({
				func = function()
					G.GAME.ccc_seeker_block = false;
					for key, seeker in pairs(SMODS.find_card(card.config.center_key), true) do
						seeker.ability.extra.triggered = false
					end
					return true 
				end
			}))
		end
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