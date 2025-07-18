-- region Berry Seeds

local berryseeds = {
	name = "ccc_Berry Seeds",
	key = "berryseeds",
	config = {extra = {suit = 'Spades', count = 0, req = 8}},
	pos = {x = 4, y = 7},
	rarity = 1,
	cost = 2,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "AstralightSky",
		code = "toneblock",
		concept = "bein"
	},
    description = "After scoring 8 cards of a randomly chosen Suit, sell this card to create a random strawberry card"
}

berryseeds.set_ability = function(self, card, initial, delay_sprites)
	card.ability.extra.suit = pseudorandom_element(SMODS.Suits, pseudoseed('berryseeds')).key
end

berryseeds.calculate = function(self, card, context)
	if context.individual and context.other_card:is_suit(card.ability.extra.suit, true) then	-- i could put a check here but then it doesn't infinitely scale and that's no fun
		if context.cardarea == G.play and not context.blueprint then
			card.ability.extra.count = card.ability.extra.count + 1
			if (card.ability.extra.count >= card.ability.extra.req) and not card.ccc_juiced then
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.0,
					func = (function()
						local eval = function(_card) return not _card.REMOVED end
						juice_card_until(card, eval, true)
						return true
					end)
				}))
				card.ccc_juiced = true	-- doesn't get saved but neither does juice_card_until
			end
			if (card.ability.extra.count <= card.ability.extra.req) then
				return {
					message = (card.ability.extra.count < card.ability.extra.req) and (card.ability.extra.count..'/'..card.ability.extra.req) or localize('k_active_ex'),
					colour = G.C.FILTER,
					card = card
				}
			end
		end
	end
	if context.selling_self and (card.ability.extra.count >= card.ability.extra.req) then
		card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_ccc_strawberry_ex')})
		
		local rarities = {{},{},{}}
		
		for i, berry in ipairs(G.ccc_strawberries) do	-- defined in 1up region
			local v = G.P_CENTERS[berry]
			add = true
			
			if v.in_pool and type(v.in_pool) == 'function' then	-- idk why i'm doing all this but it feels right
				add = v.in_pool()
			end
			if v.no_pool_flag and G.GAME.pool_flags[v.no_pool_flag] then add = nil end
			if v.yes_pool_flag and not G.GAME.pool_flags[v.yes_pool_flag] then add = nil end
			if G.GAME.banned_keys[v.key] then add = nil end
			if G.GAME.used_jokers[v.key] and not next(find_joker("Showman")) then add = nil end
			if add then
				rarities[v.rarity][#rarities[v.rarity]+1] = berry
			end
		end
		local _key = nil
		if #rarities[1] > 0 or #rarities[2] > 0 or #rarities[3] > 0 then
			while not _key do
				local _poll = pseudorandom(pseudoseed('berrypoll'))	
				_key = pseudorandom_element(rarities[(_poll > 0.95 and 3) or (_poll > 0.7 and 2) or 1], pseudoseed('berryselect'))
			end
		else
			_key = 'j_ccc_strawberry'
		end
		SMODS.add_card{key = _key}
		return nil, true
	end
end

function berryseeds.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.count, card.ability.extra.req, localize(card.ability.extra.suit, 'suits_singular'), colours = {G.C.SUITS[card.ability.extra.suit]}}}
end

return berryseeds
-- endregion Berry Seeds