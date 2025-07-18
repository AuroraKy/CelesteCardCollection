-- region joker.ppt

local jokerppt = {
	name = "ccc_joker_ppt",
	key = "jokerppt",
	config = {extra = {winged_poker_hand = 'Pair', active = false}},
	pixel_size = { w = 71, h = 81 },
	pos = {x = 5, y = 6},
	rarity = 1,
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "9Ts",
		code = "toneblock",
		concept = "9Ts"
	},
    description = "If a specific hand (changes every round) is played, create it's planet at the end of round"
}

-- i just copied most of this code from moon berry

jokerppt.set_ability = function(self, card, initial, delay_sprites)
	local _poker_hands = {}
	for k, v in pairs(G.GAME.hands) do
		if v.visible then
			_poker_hands[#_poker_hands+1] = k 
		end
	end
	card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('powerpoint'))
	card.ability.extra.old_hand = card.ability.extra.winged_poker_hand
end

jokerppt.calculate = function(self, card, context)
	if context.setting_blind then
		card.ability.extra.old_hand = card.ability.extra.winged_poker_hand
		card.ability.extra.active = false
	end
	if context.joker_main and context.scoring_name == card.ability.extra.winged_poker_hand and (not card.ability.extra.active) and (not context.blueprint) then
		card.ability.extra.active = true
		card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_ccc_active_ex'), colour = G.C.FILTER})
	end
	if context.end_of_round and not context.individual and not context.repetition then
		if (#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit) and card.ability.extra.active then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			G.E_MANAGER:add_event(Event({
			trigger = 'before',
			delay = 0.0,
			func = (function()
				local _planet = 0
				for k, v in pairs(G.P_CENTER_POOLS.Planet) do
					if v.config.hand_type == card.ability.extra.old_hand then
						_planet = v.key
					end
				end
                    		local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, _planet, 'blusl')
                    		card:add_to_deck()
                    		G.consumeables:emplace(card)
				G.GAME.consumeable_buffer = 0
                		return true
            		end)}))
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
		end
		if not context.blueprint then
			G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.0,
			func = (function()
			local _poker_hands = {}
                    	for k, v in pairs(G.GAME.hands) do
                      	  	if v.visible and k ~= card.ability.extra.winged_poker_hand then 
					_poker_hands[#_poker_hands+1] = k 
				end
                    	end
			card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('powerpoint'))
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_ccc_reset'), colour = G.C.FILTER})
			return true
            		end)}))
		end
	end
end

function jokerppt.loc_vars(self, info_queue, card)
	return {vars = { localize(card.ability.extra.winged_poker_hand, "poker_hands") }}
end

return jokerppt
-- endregion joker.ppt