-- region Coyote Jump

local coyotejump = {
	name = "ccc_Coyote Jump",
	key = "coyotejump",
    config = {extra = {discards = 1}},
	pixel_size = { w = 71, h = 81 },
	pos = {x = 9, y = 0},
	rarity = 3,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "goose! & Gappie",
		code = "toneblock",
		concept = "Bred"
	},
    description = "If cards held in hand do not form a pair, straight or flush gain 1 discard."
}

coyotejump.calculate = function(self, card, context) -- thank you bred?????

	if context.before and not context.blueprint then
		coyotejump_card_array = {}
		coyotejump_ranks = {}
	end

	if context.individual and context.poker_hands ~= nil and not context.blueprint then
       		if context.cardarea == G.hand then
			coyotejump_card_array[#coyotejump_card_array + 1] = context.other_card
			if not coyotejump_ranks[context.other_card:get_id()] then
				coyotejump_ranks[context.other_card:get_id()] = 1
			else
				coyotejump_ranks[context.other_card:get_id()] = coyotejump_ranks[context.other_card:get_id()] + 1
			end
		end
	end
	
	if context.joker_main and context.poker_hands ~= nil then
		local pair_found = false
		for i = 2, 14 do
			if coyotejump_ranks[i] then 
				if coyotejump_ranks[i] > 1 then
					pair_found = true
				end
			end
		end		
		local parts = {
			_flush = get_flush(coyotejump_card_array),
			_straight = get_straight(coyotejump_card_array)
		}
		if next(parts._straight) then
			G.E_MANAGER:add_event(Event({trigger = 'before', delay = immediate, func = function()
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("Straight", "poker_hands"), colour = G.C.RED})
			return true end }))
		elseif next(parts._flush) then
			G.E_MANAGER:add_event(Event({trigger = 'before', delay = immediate, func = function()
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("Flush", "poker_hands"), colour = G.C.RED})
			return true end }))
		elseif pair_found == true then
			G.E_MANAGER:add_event(Event({trigger = 'before', delay = immediate, func = function()
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("Pair", "poker_hands"), colour = G.C.RED})
			return true end }))
		else
			G.E_MANAGER:add_event(Event({trigger = 'before', delay = immediate, func = function()
				ease_discard(card.ability.extra.discards, nil, true)
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize { type = 'variable', key = 'ccc_a_discard', vars = { card.ability.extra.discards } }, colour = G.C.RED})
			return true end }))
		end
	end
end

function coyotejump.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.discards}}
end

return coyotejump
-- endregion Coyote Jump