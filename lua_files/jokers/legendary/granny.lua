
local granny = {
	name = "ccc_Granny",
	key = "granny",
	config = {extra = {draw = 1, discarded = {amount = 0}}},
	pos = {x = 2, y = 5},
	soul_pos = {x = 2, y = 6},
	rarity = 4,
	cost = 20,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "MiiK",
		code = "toneblock",
		concept = "Fytos"
	}
    ,description = "After discarding cards, draw one additional card for each card discarded"
}

granny.calculate = function(self, card, context)
	card.ability.extra.discarded = card.ability.extra.discarded or {amount = 0}
	if context.setting_blind then -- prevent carrying over discards from other rounds (only really possible by playing a winning hand during The Hook)
		card.ability.extra.discarded.amount = 0
	end

	if context.discard and not context.blueprint then
		card.ability.extra.discarded.amount = #context.full_hand
	end

	if context.hand_drawn then--and (G.GAME.ccc_after_discard and G.GAME.ccc_after_discard > 0) and #G.deck.cards > 0 then

		-- don't try to draw more cards than you have (doesn't crash but would give you incorrect status text)
		local draw = math.min(card.ability.extra.discarded.amount, #G.deck.cards) 
		if draw == 0 then return nil end
		card.ability.extra.discarded.amount = 0

		local _card = context.blueprint_card or card

		G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
			card_eval_status_text(
				_card, 'extra', nil, nil, nil, {
					message = localize { type = 'variable', key = draw ~= 1 and 'ccc_a_cards' or 'ccc_a_card', vars = { draw } }, 
					colour = G.C.FILTER 
				}
			)
			SMODS.draw_cards(draw)
		return true end }))
	end

	--[[
	if context.ccc_hand_drawn and (G.GAME.ccc_after_discard and G.GAME.ccc_after_discard > 0) and #G.deck.cards > 0 then
		G.GAME.ccc_after_discard_buffer = G.GAME.ccc_after_discard
		local _card = context.blueprint_card or card
		return {
			G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
				card_eval_status_text(
					_card, 'extra', nil, nil, nil, {
						message = localize { type = 'variable', key = 'ccc_a_cards', vars = { card.ability.extra.draw*G.GAME.ccc_after_discard_buffer } }, 
						colour = G.C.FILTER 
					}
				)
				G.FUNCS.draw_from_deck_to_hand(card.ability.extra.draw*G.GAME.ccc_after_discard_buffer)
				G.GAME.ccc_after_discard = 0
			return true end }))
		}
		
	end
	]]--
end

function granny.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.draw}}
end

return granny