-- region Pointless Machines

local pointlessmachines = {
	name = "ccc_Pointless Machines",
	key = "pointlessmachines",
	config = { extra = { chosen = 'Spades', incorrect = false, reset = false, count = 0, req = 3, suits = { [1] = 'Hearts', [2] = 'Spades', [3] = 'Diamonds', [4] = 'Clubs', [5] = 'Hearts' } } },
	pos = { x = 9, y = 1 },
	rarity = 2,
	cost = 4,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "goose!",
		code = "toneblock",
		concept = "Fytos"
	},
    description = "Bad signal?"
}

pointlessmachines.set_ability = function(self, card, initial, delay_sprites)
	card.ability.extra.chosen = pseudorandom_element({ 'Hearts', 'Spades', 'Diamonds', 'Clubs' },
		pseudoseed('pminitialize'))
	for i = 1, 5 do
		card.ability.extra.suits[i] = pseudorandom_element(
		{ 'Hearts', 'Spades', 'Diamonds', 'Clubs', card.ability.extra.chosen }, pseudoseed('pminitialize2'))
	end
end

pointlessmachines.calculate = function(self, card, context)
	if context.before and not context.blueprint then
		card.ability.extra.incorrect = false
		if #context.full_hand >= 5 then
			for i = 1, 5 do
				if not context.full_hand[i]:is_suit(card.ability.extra.suits[i], true) then
					card.ability.extra.incorrect = true
				end
			end
		else
			card.ability.extra.incorrect = true
		end

		if card.ability.extra.incorrect == false then
			card.ability.extra.reset = true
			card.ability.extra.count = card.ability.extra.count + 1
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_ccc_correct'), colour = G.C.GREEN })
			if card.ability.extra.count >= card.ability.extra.req then
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.75,
					func = function()
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.75,
							func = function()
								card:flip(); play_sound('card1', 1, 0.6); card:juice_up(0.3, 0.3)
								return true
							end
						}))
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.75,
							func = function()
								local centers = { 'j_ccc_crystalheart', 'j_ccc_mechanicalheart', 'j_ccc_quietheart',
									'j_ccc_heavyheart' }
								local suits = { 'Hearts', 'Clubs', 'Spades', 'Diamonds' }
								local center = 'j_ccc_crystalheart'
								for i = 1, #suits do
									if card.ability.extra.chosen == suits[i] then
										center = centers[i]
									end
								end
								card:set_ability(G.P_CENTERS[center])
								return true
							end
						}))
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.75,
							func = function()
								card:flip(); play_sound('tarot2', 1, 0.6); card:juice_up(0.3, 0.3)
								return true
							end
						}))
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 1.25,
							func = function()
								local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_grim',
									'thisispointless')
								card:set_edition({ negative = true }, true)
								card:add_to_deck()
								G.consumeables:emplace(card)
								return true
							end
						}))
						card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
							{ message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral })
						return true
					end
				}))
			else
				card_eval_status_text(card, 'extra', nil, nil, nil,
					{ message = card.ability.extra.count .. "/" .. card.ability.extra.req, colour = G.C.FILTER })
			end
			--[[
			local temp_dollars = pseudorandom('littlemoney', 4, 7)
			ease_dollars(temp_dollars)
			G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + temp_dollars
			G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
			return {
				dollars = temp_dollars,
				colour = G.C.MONEY
			}
			]]
		else
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_ccc_incorrect'), colour = G.C.RED })
		end
	end
	--[[
	if context.joker_main and card.ability.extra.incorrect == false and not context.blueprint then	-- 1/3 chance for mult, 2/3 chance for chips
		if pseudorandom('chipsormult', 0, 2) > 1 then
			local temp_Mult = pseudorandom('misprintcopylmao', 18, 45)
                            return {
                                message = localize{type='variable',key='a_mult',vars={temp_Mult}},
                                mult_mod = temp_Mult
                            }
		else
			local temp_chips = pseudorandom('misprintbutchips', 80, 145)
                            return {
                                message = localize{type='variable',key='a_chips',vars={temp_chips}},
                                chip_mod = temp_chips
                            }
		end
	end
	]]
	if context.after and card.ability.extra.reset == true and not context.blueprint then
		for i = 1, 5 do
			card.ability.extra.suits[i] = pseudorandom_element(
			{ 'Hearts', 'Spades', 'Diamonds', 'Clubs', card.ability.extra.chosen }, pseudoseed('pmreinitialize'))
		end
		card.ability.extra.reset = false
	end
end

function ccc_getfirstheart(_key)
	local _t = pseudorandom_element({ 'Hearts', 'Spades', 'Diamonds', 'Clubs' }, pseudoseed('pminitialize', _key))
	return _t
end

-- region Focused Grim

function ccc_heartmatch(name)
	local table = {
		['ccc_Crystal Heart'] = 'Hearts',
		['ccc_Mechanical Heart'] = 'Clubs',
		['ccc_Quiet Heart'] = 'Spades',
		['ccc_Heavy Heart'] = 'Diamonds',
	}
	return table[name]
end

local chighlight = Card.highlight
function Card:highlight(is_higlighted)
	chighlight(self, is_higlighted)
	if self.ability.name == 'Grim' and self.highlighted then
		G.GAME.grim_highlighted = true
		local _card = nil
		for i = 1, #G.jokers.cards do
			if ccc_heartmatch(G.jokers.cards[i].ability.name) then
				_card = G.jokers.cards[i]
				break
			end
		end
		if _card then
			local thunk = function() return G.GAME.grim_highlighted end
			juice_card_until(_card, thunk, true)
		end
	elseif self.ability.name == 'Grim' and not self.highlighted then
		G.GAME.grim_highlighted = false
	end
end

local function random_destroy(used_tarot)
	local destroyed_cards = {}
	destroyed_cards[#destroyed_cards + 1] = pseudorandom_element(G.hand.cards, pseudoseed('random_destroy'))
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.4,
		func = function()
			play_sound('tarot1')
			used_tarot:juice_up(0.3, 0.5)
			return true
		end
	}))
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.1,
		func = function()
			for i = #destroyed_cards, 1, -1 do
				local card = destroyed_cards[i]
				if card.ability.name == 'Glass Card' then
					card:shatter()
				else
					card:start_dissolve(nil, i ~= #destroyed_cards)
				end
			end
			return true
		end
	}))
	return destroyed_cards
end
SMODS.Consumable:take_ownership('grim', {
	use = function(self, card, area, copier)
		local used_tarot = copier or card
		local destroyed_cards = random_destroy(used_tarot)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.7,
			func = function()
				local cards = {}
				local _cards = {}
				for i = 1, card.ability.extra do
					cards[i] = true -- idk why this is done but sure
					-- TODO preserve suit vanilla RNG
					local _suit, _rank =
						pseudorandom_element(SMODS.Suits, pseudoseed('grim_create')).card_key, 'A'
					local cen_pool = {}
					for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
						if v.key ~= 'm_stone' and not v.overrides_base_rank then
							cen_pool[#cen_pool + 1] = v
						end
					end
					_cards[i] = create_playing_card({
						front = G.P_CARDS[_suit .. '_' .. _rank],
						center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
					}, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
				end
				local _joker = nil
				local _suit = nil
				for i = 1, #G.jokers.cards do
					_suit = ccc_heartmatch(G.jokers.cards[i].ability.name)
					if _suit then
						_joker = G.jokers.cards[i]
						break
					end
				end
				if _joker then
					delay(0.5)
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.6,
						func = function()
							play_sound('tarot1')
							_joker:juice_up(0.3, 0.5)
							return true
						end
					}))
					for i = 1, #_cards do
						local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.25,
							func = function()
								_cards[i]:flip(); play_sound('card1', percent); _cards[i]:juice_up(0.3, 0.3); return true
							end
						}))
					end
					for i = 1, #_cards do
						G.E_MANAGER:add_event(Event({
							func = function()
								assert(SMODS.change_base(_cards[i], _suit))
								if _suit == 'Hearts' then
									local edition = poll_edition('crystal_heart', nil, true, true)
									_cards[i]:set_edition(edition, true, true)
								end
								if _suit == 'Clubs' then
									_cards[i]:set_ability(G.P_CENTERS.m_steel, nil, true)
									_cards[i].ability.h_x_mult = _joker.ability.extra.xmult
								end
								if _suit == 'Spades' then
									_cards[i].ability.perma_bonus = _cards[i].ability.perma_bonus or 0
									_cards[i].ability.perma_bonus = _cards[i].ability.perma_bonus + (_joker.ability.extra.add*5)
								end
								if _suit == 'Diamonds' then
									_cards[i]:set_ability(G.P_CENTERS.m_gold, nil, true)
									_cards[i]:set_seal("Gold", true, true)
								end
								return true
							end
						}))
					end
					delay(0.8)
					for i = 1, #_cards do
						local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.25,
							func = function()
								_cards[i]:flip(); play_sound('tarot2', percent, 0.6); _cards[i]:juice_up(0.3, 0.3); return true
							end
						}))
					end
				end
				playing_card_joker_effects(cards)
				return true
			end
		}))
		delay(0.3)
		SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
	end,
})

-- endregion Focused Grim

-- endregion Pointless Machines

return pointlessmachines