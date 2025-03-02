--region CREDITS
-- Code to allow for credits

local generate_UIBox_ability_table_ref = Card.generate_UIBox_ability_table

function Card.generate_UIBox_ability_table(self, vars_only)
	local AUT = generate_UIBox_ability_table_ref(self, vars_only)
	if not vars_only then AUT.mod_credit = self.config.center.credit or nil end
	return AUT
end

-- local card_h_popup_ref = G.UIDEF.card_h_popup

-- function G.UIDEF.card_h_popup(card)
-- 	local ret = card_h_popup_ref(card)
	
--     if card.ability_UIBox_table and ret.nodes then
-- 		local AUT = card.ability_UIBox_table
-- 		if AUT.mod_credit then
-- 			local main = ret.nodes[1]
-- 			local thing = {n=G.UIT.ROOT,  config={align = "cm", r = 0.1, padding = 0.05, emboss = 0.05}, nodes={
-- 				{n=G.UIT.R, config={align = "cm", colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, padding = 0.05, emboss = 0.05}, nodes={
-- 				{n=G.UIT.R, config={align = "cm", colour = lighten(G.C.GREY, 0.15), r = 0.1, padding=0.2}, nodes={
-- 				{n=G.UIT.R, config={align = "cm"}, nodes={
-- 					{n=G.UIT.O, config={object = DynaText({string = "Art by ", colours = {G.C.WHITE}, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.33})}},
-- 					{n=G.UIT.O, config={object = DynaText({string = AUT.mod_credit.art, colours = {G.C.CCC_COLOUR}, float = true, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.33})}}}},
-- 				{n=G.UIT.R, config={align = "cm"}, nodes={
-- 					{n=G.UIT.O, config={object = DynaText({string = "Code by ", colours = {G.C.WHITE}, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.33})}},
-- 					{n=G.UIT.O, config={object = DynaText({string = AUT.mod_credit.code, colours = {G.C.CCC_COLOUR }, float = true, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.33})}}}},
-- 				{n=G.UIT.R, config={align = "cm"}, nodes={
-- 					{n=G.UIT.O, config={object = DynaText({string = "Concept by ", colours = {G.C.WHITE}, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.33})}},
-- 					{n=G.UIT.O, config={object = DynaText({string = AUT.mod_credit.concept, colours = {G.C.CCC_COLOUR }, float = true, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.33})}}}},
-- 			}}}}}}

-- 			main.children = main.children or {}
-- 			main.children.credits = UIBox{
-- 				definition = thing,
-- 				config = {offset = {x=  0.03,y=0}, align = 'cr', parent = main}
-- 			}
-- 			main.children.credits:align_to_major()
-- 		end
-- 	end
-- 	return ret 
-- end

--endregion CREDITS


-- region Feather

local feather = SMODS.Joker({
	name = "ccc_Feather",
	key = "feather",
    config = {extra = {xmult = 1, mult_scale = 0.04}},
	pos = {x = 0, y = 0},
	loc_txt = {
        name = 'Feather',
        text = {
	"Gains {X:mult,C:white} X#1# {} Mult when a",
	"card is {C:attention}drawn{} from deck,",
	"{C:red}resets{} at end of round",
	"{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult){}"
        }
    },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "toneblock"
	}
})

feather.calculate = function(self, card, context)

        if context.ccc_drawfromdeck then
		if not context.blueprint then
                	card.ability.extra.xmult = card.ability.extra.xmult+(card.ability.extra.mult_scale*context.ccc_amount)
		end
	end
	
        if context.joker_main then
		return {
			message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
			Xmult_mod = card.ability.extra.xmult, 
			colour = G.C.MULT
		}
        end
	
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
		card.ability.extra.xmult = 1
		card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Reset", colour = G.C.FILTER})
	end
end

function feather.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.mult_scale, card.ability.extra.xmult}}
end

local drawcardref = G.FUNCS.draw_from_deck_to_hand	-- additionally used for seeker
G.FUNCS.draw_from_deck_to_hand = function(e)
	local hand_space = e or math.min(#G.deck.cards, G.hand.config.card_limit - #G.hand.cards)
	if G.GAME.blind.name == 'The Serpent' and
	not G.GAME.blind.disabled and
	(G.GAME.current_round.hands_played > 0 or
	G.GAME.current_round.discards_used > 0) then
		hand_space = math.min(#G.deck.cards, 3)
	end
	SMODS.calculate_context({ccc_drawfromdeck = true, ccc_amount = hand_space})
	drawcardref(e)
end

--endregion Feather

-- region Zipper

local zipper = SMODS.Joker({
	name = "ccc_Zipper",
	key = "zipper",
    config = {extra = {chips = 0, chips_scale = 35}},
	pos = {x = 4, y = 0},
	loc_txt = {
        name = 'Zipper',
        text = {
	"Gains {C:chips}+#2#{} Chips for each",
	"{C:attention}Blind{} skipped this run",
	"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
        }
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "toneblock"
	}
})

zipper.set_ability = function(self, card, initial, delay_sprites)
	card.ability.extra.chips = G.GAME.skips*card.ability.extra.chips_scale
end

zipper.calculate = function(self, card, context)
	card.ability.extra.chips = G.GAME.skips*card.ability.extra.chips_scale
        if context.skip_blind then
            if not context.blueprint then
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}},
                                colour = G.C.CHIPS
                        }) 
                        return true
                    end}))
            end
	end
	if context.joker_main then
		if card.ability.extra.chips ~= 0 then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_chips',
                        vars = { card.ability.extra.chips }
                    },
                    chip_mod = card.ability.extra.chips
                }
end
end
end

function zipper.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.chips, card.ability.extra.chips_scale}}
end

-- endregion Zipper

--region Temple Eyes

local templeeyes = SMODS.Joker({
	name = "ccc_Temple Eyes",
	key = "templeeyes",
    config = {extra = {max_money = 4}},
	pos = {x = 1, y = 0},
	loc_txt = {
        name = 'Temple Eyes',
        text = {
	"If {C:attention}Blind{} is selected with",
	"{C:money}$#1#{} or less, create a",
	"{C:tarot}Hanged Man{}",
	"{C:inactive}(Must have room)"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "toneblock"
	}
})

templeeyes.calculate = function(self, card, context)
	if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
		if to_big(G.GAME.dollars) <= to_big(card.ability.extra.max_money) then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			return {
				G.E_MANAGER:add_event(Event({
					func = (function()
					G.E_MANAGER:add_event(Event({
						func = function() 
						local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_hanged_man', 'see')
						card:add_to_deck()
						G.consumeables:emplace(card)
						G.GAME.consumeable_buffer = 0
						return true
					end}))   
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})                       
					return true
				end)}))
			}
		end
        end
end

function templeeyes.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.c_hanged_man
	return {vars = {card.ability.extra.max_money}}
end

-- endregion Temple Eyes

-- region Mini Heart

local miniheart = SMODS.Joker({
	name = "ccc_Mini Heart",
	key = "miniheart",
    config = {extra = {prob_success = 18}},
	pos = {x = 5, y = 0},
	loc_txt = {
        name = 'Mini Heart',
        text = {
	"{C:green}#1# in #2#{} chance to add {C:dark_edition}Foil{}",
	"edition to scored cards",
	"{C:attention}before scoring{}"
        }
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "toneblock"
	}
})

miniheart.calculate = function(self, card, context)
	if context.before then
		local applied = false
		for i, v in ipairs(context.scoring_hand) do
			if not v.edition then
				if pseudorandom('crystal') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
					applied = true
					v:set_edition({foil = true})
					if context.blueprint then	-- idk why i need to put blueprint check here, should work without? but it doesn't
						context.blueprint_card:juice_up()
					else
						card:juice_up()
					end
				end
			end
		end
		if applied then return nil, true end
	end
end

function miniheart.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.e_foil
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.prob_success}}
end

-- endregion Mini Heart

--region Bird

local bird = SMODS.Joker({
	name = "ccc_Bird",
	key = "bird",
    config = {extra = {draw = 4, active = false}},
	pos = {x = 2, y = 0},
	loc_txt = {
        name = 'Bird',
        text = {
	"Whenever a {C:planet}Planet{} card",
	"is used, {C:attention}draw{} {C:attention}#1#{} cards"
        }
    },
	rarity = 3,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "toneblock"
	}
})

bird.calculate = function(self, card, context)

	if context.using_consumeable then
		if context.consumeable.ability.set == 'Planet' then
			if (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) or (G.GAME and G.GAME.blind and G.GAME.blind.in_blind) then
				G.E_MANAGER:add_event(Event({
					func = function() 
						card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..card.ability.extra.draw.." Cards", colour = G.C.FILTER})
						G.FUNCS.draw_from_deck_to_hand(card.ability.extra.draw)          
					return true
					end
				}))
				return nil, true
			end
		end
	end

end

function bird.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.draw}}
end

-- endregion Bird

-- region Part Of You

local partofyou = SMODS.Joker({
	name = "ccc_Part Of You",
	key = "partofyou",
    config = {},
	pos = {x = 3, y = 0},
	loc_txt = {
        name = 'Part Of You',
        text = {
	"If {C:attention}first hand{} of round",
	"contains exactly {C:attention}2{} cards,",
	"convert their {C:attention}ranks{}",
	"into their {C:attention}complements{}"
        }
    },
	rarity = 3,
	cost = 7,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "Fytos"
	}
})

partofyou.calculate = function(self, card, context)

	if context.before and not context.blueprint then
		if G.GAME.current_round.hands_played == 0 and #context.full_hand == 2 then
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.75,func = function() context.full_hand[1]:flip();play_sound('card1', 1, 0.6);context.full_hand[1]:juice_up(0.3, 0.3);return true end }))
                	G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() context.full_hand[2]:flip();play_sound('card1', 1, 0.6);context.full_hand[2]:juice_up(0.3, 0.3);return true end }))
			G.E_MANAGER:add_event(Event({trigger = 'before',
				func = function() 
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Mirrored!", colour = G.C.FILTER})   
					return true
				end
			}))
			for i = 1, 2 do
				local suit = string.sub(context.full_hand[i].config.card.suit, 1, 1) .. "_"
				local _table = {"", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2", "A", "K"}
				local rank = _table[context.full_hand[i]:get_id()]
				G.P_CARDS[suit .. rank].delay_change = {
					suit = context.full_hand[i].config.card.suit,
					value = context.full_hand[i].config.card.value,
					pos = copy_table(context.full_hand[i].config.card.pos),
				}
				context.full_hand[i]:set_base(G.P_CARDS[suit .. rank])
				
				G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,
					func = function()  
						G.P_CARDS[suit .. rank].delay_change = nil	-- this is blasphemous but it shouldn't break anything????????
						context.full_hand[i]:set_base(G.P_CARDS[suit .. rank])
						return true 
					end 
				}))
			end
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.75,func = function() context.full_hand[1]:flip();play_sound('tarot2', 1, 0.6);context.full_hand[1]:juice_up(0.3, 0.3);return true end }))
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() context.full_hand[2]:flip();play_sound('tarot2', 1, 0.6);context.full_hand[2]:juice_up(0.3, 0.3);return true end }))
			delay(0.4)
			return nil, true
		end
	end

end

function partofyou.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'partofyou_complements', set = 'Other'}
end

-- scuffed

local gfsiref = get_front_spriteinfo
function get_front_spriteinfo(_front)
	if _front and _front.delay_change then
		return gfsiref(_front.delay_change)
	else
		return gfsiref(_front)
	end
end		

-- endregion Part Of You

-- region Huge Mess: Towels

local towels = SMODS.Joker({
	name = "ccc_Huge Mess: Towels",
	key = "towels",
    config = {extra = {chips = 0, chips_scale = 7}},
	pos = {x = 0, y = 3},
	loc_txt = {
        name = 'Huge Mess: Towels',
        text = {
	"When played hand contains a",
	"{C:attention}Flush{}, gains {C:chips}+#2#{} Chips for",
	"each card held in hand that",
	"shares the same {C:attention}suit{}",
	"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "Bred"
	}
})

towels.calculate = function(self, card, context)

	if context.before and context.poker_hands ~= nil and next(context.poker_hands['Flush']) and not context.blueprint then

		local suits = {}
		local used_suits = {}
		for i = 1, #context.scoring_hand do
			if context.scoring_hand[i].ability.name ~= 'Wild Card' then
				if not suits[context.scoring_hand[i].base.suit] then
					suits[context.scoring_hand[i].base.suit] = 1
					used_suits[#used_suits + 1] = context.scoring_hand[i].base.suit
				else
					suits[context.scoring_hand[i].base.suit] = suits[context.scoring_hand[i].base.suit] + 1
				end
			end
		end
		local value = 0
		if #used_suits ~= 0 then
			for i = 1, #used_suits do
				if suits[used_suits[i]] > value then
					towels_flush_suit = used_suits[i]
					value = suits[used_suits[i]]
				end
			end
		else
			towels_flush_suit = 'Wild'
		end
	end	

	if context.individual and context.poker_hands ~= nil and next(context.poker_hands['Flush']) and not context.blueprint then
        	if context.cardarea == G.hand then
	         	if context.other_card:is_suit(towels_flush_suit, true) or towels_flush_suit == 'Wild' then
                        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_scale
                        return {
                            	message = localize('k_upgrade_ex'),
                            	colour = G.C.CHIPS,
				card = card
                        }
        		end
	        end
	end
	if context.joker_main then
            if card.ability.extra.chips ~= 0 then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_chips',
                        vars = { card.ability.extra.chips }
                    },
                    chip_mod = card.ability.extra.chips
                }
	    end
	end
end

function towels.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.chips, card.ability.extra.chips_scale}}
end

-- endregion Huge Mess: Towels

-- region Huge Mess: Chests

local chests = SMODS.Joker({
	name = "ccc_Huge Mess: Chests",
	key = "chests",
    config = {extra = {mult = 0, mult_scale = 3}},
	pos = {x = 1, y = 3},
	loc_txt = {
        name = 'Huge Mess: Chests',
        text = {
	"When played hand contains a",
	"{C:attention}Three of a Kind{}, gains",
	"{C:mult}+#2#{} Mult for each possible",
	"{C:attention}Pair{} held in hand",
	"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "Bred"
	}
})

chests.calculate = function(self, card, context)

	if context.before and not context.blueprint then
		card.boxes_rank_array = {}
		card.boxes_card_array_length = 0
		card.boxes_pair_amounts = 0
		card.boxes_card_pair_candidate = 0
	end

	if context.individual and context.poker_hands ~= nil and ((next(context.poker_hands['Three of a Kind']) or next(context.poker_hands['Full House']) or next(context.poker_hands['Four of a Kind']) or next(context.poker_hands['Five of a Kind']) or next(context.poker_hands['Flush Five']))) and not context.blueprint then
       		if context.cardarea == G.hand then
			card.boxes_card_array_length = card.boxes_card_array_length + 1
			card.boxes_rank_array[card.boxes_card_array_length] = context.other_card:get_id()
		end
	end

	if context.joker_main and not context.blueprint then
		for v = 1, 13 do
			card.boxes_card_pair_candidate = 0
			for i = 1, card.boxes_card_array_length do
				if card.boxes_rank_array[i] == v + 1 then
					card.boxes_card_pair_candidate = card.boxes_card_pair_candidate + 1
				end
			end
			card.boxes_pair_amounts = card.boxes_pair_amounts + ((card.boxes_card_pair_candidate - 1)*(card.boxes_card_pair_candidate)) / 2
		end
		if card.boxes_pair_amounts > 0 then
			card.ability.extra.mult = card.ability.extra.mult + (card.boxes_pair_amounts)*card.ability.extra.mult_scale
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!", colour = G.C.MULT}) 
		end
	end
	if context.joker_main then
		if card.ability.extra.mult ~= 0 then
                	return {
                   	message = localize {
                  		type = 'variable',
                   		key = 'a_mult',
                  		vars = { card.ability.extra.mult }
                		},
                	mult_mod = card.ability.extra.mult
                	}
		end
	end
end

function chests.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.mult, card.ability.extra.mult_scale}}
end

-- endregion Huge Mess: Chests

-- region Huge Mess: Books

local books = SMODS.Joker({
	name = "ccc_Huge Mess: Books",
	key = "books",
    config = {extra = {xmult = 1, xmult_scale = 0.14}},
	pos = {x = 2, y = 3},
	loc_txt = {
	default = {
        name = 'Huge Mess: Books',
        text = {
	"When played hand contains a",
	"{C:attention}Straight{}, gains {X:mult,C:white} X#2# {} Mult for",
	"each additional card held in hand",
	"that extends the played {C:attention}Straight{}",
	"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult){}"
        }
    },
	fr = {
        name = 'Huge Mess: Books',
        text = {
	"When played hand contains a",
	"{C:attention}Straight{}, gains {X:mult,C:white} X#2# {} Mult",
	"for each additional card in",
	"the {C:attention}sequence{} held in hand",
	"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult){}"
        }
    }
},
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "Bred"
	}
})

-- i need to rework the logic here at some point

books.calculate = function(self, card, context)

	if context.before and not context.blueprint then
		card.books_rank_array = {}
		card.books_card_array_length = 0
		card.books_pair_amounts = 0
		card.books_card_pair_candidate = 0
		card.books_scoring_straight_array = {}
		card.books_scoring_pair = false
		card.books_highest_rank_found = false
		card.books_lowest_rank_found = false
		card.books_additional_sequence_cards = 0
		card.books_straight_border_high = 0
		card.books_straight_border_low = 0
		card.books_ace_high_scored = false
		card.books_ace_high_scored_in_hand = false
		card.books_ace_low_scored = false
		card.books_skipped_ranks = false
		card.books_allowed_skipped_ranks = {}
		card.books_repeat_non_shortcut = true
		card.books_ranks_used = {}
		card.books_vip_cards = {}
	end

	if context.before and context.poker_hands ~= nil and (next(context.poker_hands['Straight'])) and not context.blueprint then
       		for i = 1, #G.hand.cards do
			card.books_card_array_length = card.books_card_array_length + 1
			card.books_rank_array[card.books_card_array_length] = G.hand.cards[i]:get_id()
			table.sort(card.books_rank_array)
		end
		for i = 1, #context.scoring_hand do
			card.books_scoring_straight_array[i] = context.scoring_hand[i]:get_id()
		end
		table.sort(card.books_scoring_straight_array)

		if not next(find_joker('Four Fingers')) then
			if not next(find_joker('Shortcut')) then
				if card.books_scoring_straight_array[#card.books_scoring_straight_array] == 14 then
					if card.books_scoring_straight_array[1] == 2 then
						card.books_ace_low_scored = true
						card.books_scoring_straight_array[#card.books_scoring_straight_array] = 1
						table.sort(card.books_scoring_straight_array)
					else
						card.books_ace_high_scored = true
					end
				end
			else
				if card.books_scoring_straight_array[#card.books_scoring_straight_array] == 14 then
					if card.books_scoring_straight_array[1] == 2 or card.books_scoring_straight_array[1] == 3 then
						card.books_ace_low_scored = true
						card.books_scoring_straight_array[#card.books_scoring_straight_array] = 1
						table.sort(card.books_scoring_straight_array)
					else
						card.books_ace_high_scored = true
					end
				end
			end
		end

		if next(find_joker('Four Fingers')) then 	-- things get a whole lot more complicated, that's what :(
			for i = 1, (#card.books_scoring_straight_array - 1) do
				if card.books_scoring_straight_array[i] == card.books_scoring_straight_array[i + 1] then
					card.books_scoring_pair = true	
				end
			end
			if card.books_scoring_pair ~= true then
				if not next(find_joker('Shortcut')) then
					if card.books_scoring_straight_array[1] ~= card.books_scoring_straight_array[2] - 1 then
						table.remove(card.books_scoring_straight_array, 1)
					end
					if card.books_scoring_straight_array[#card.books_scoring_straight_array] ~= card.books_scoring_straight_array[#card.books_scoring_straight_array - 1] + 1 then
						if card.books_scoring_straight_array[#card.books_scoring_straight_array] == 14 then
							if card.books_scoring_straight_array[1] == 2 then
								card.books_ace_low_scored = true
								card.books_scoring_straight_array[#card.books_scoring_straight_array] = 1
								table.sort(card.books_scoring_straight_array)
								if card.books_scoring_straight_array[#card.books_scoring_straight_array] ~= card.books_scoring_straight_array[#card.books_scoring_straight_array - 1] + 1 then
									card.books_scoring_straight_array[#card.books_scoring_straight_array] = nil
								end
							else
								card.books_scoring_straight_array[#card.books_scoring_straight_array] = nil
							end
						else
							card.books_scoring_straight_array[#card.books_scoring_straight_array] = nil
						end
					end
					if card.books_ace_low_scored == false and card.books_scoring_straight_array[#card.books_scoring_straight_array] == 14 then
						card.books_ace_high_scored = true
					end
				else
					if (card.books_scoring_straight_array[1] ~= card.books_scoring_straight_array[2] - 1) and (card.books_scoring_straight_array[1] ~= card.books_scoring_straight_array[2] - 2) then
						table.remove(card.books_scoring_straight_array, 1)
					end
					if (card.books_scoring_straight_array[#card.books_scoring_straight_array] ~= card.books_scoring_straight_array[#card.books_scoring_straight_array - 1] + 1) and (card.books_scoring_straight_array[#card.books_scoring_straight_array] ~= card.books_scoring_straight_array[#card.books_scoring_straight_array - 1] + 2) then
						if card.books_scoring_straight_array[#card.books_scoring_straight_array] == 14 then
							if card.books_scoring_straight_array[1] == 2 or card.books_scoring_straight_array[1] == 3 then
								card.books_ace_low_scored = true
								card.books_scoring_straight_array[#card.books_scoring_straight_array] = 1
								table.sort(card.books_scoring_straight_array)
								if (card.books_scoring_straight_array[#card.books_scoring_straight_array] ~= card.books_scoring_straight_array[#card.books_scoring_straight_array - 1] + 1) and (card.books_scoring_straight_array[#card.books_scoring_straight_array] ~= card.books_scoring_straight_array[#card.books_scoring_straight_array - 1] + 2) then
									card.books_scoring_straight_array[#card.books_scoring_straight_array] = nil
								end
							else
								card.books_scoring_straight_array[#card.books_scoring_straight_array] = nil
							end
						else
							card.books_scoring_straight_array[#card.books_scoring_straight_array] = nil
						end
					end
					if card.books_ace_low_scored == false and card.books_scoring_straight_array[#card.books_scoring_straight_array] == 14 then
						card.books_ace_high_scored = true
					end
				end
			else
				if card.books_scoring_straight_array[#card.books_scoring_straight_array] == 14 then
					if card.books_scoring_straight_array[1] == 2 then
						card.books_ace_low_scored = true
						card.books_scoring_straight_array[#card.books_scoring_straight_array] = 1
						table.sort(card.books_scoring_straight_array)
					else
						card.books_ace_high_scored = true
					end
				end
				if card.books_scoring_straight_array[#card.books_scoring_straight_array] == 14 then
					if card.books_scoring_straight_array[1] == 2 or card.books_scoring_straight_array[1] == 3 then
						card.books_ace_low_scored = true
						card.books_scoring_straight_array[#card.books_scoring_straight_array] = 1
						table.sort(card.books_scoring_straight_array)
					else
						card.books_ace_high_scored = true
					end
				end
			end			
			if card.books_scoring_straight_array[#card.books_scoring_straight_array] == 14 and card.books_ace_low_scored == true then 	-- have to check if the player played another fucking ace in a low ace straight for whatever reason
				card.books_scoring_straight_array[#card.books_scoring_straight_array] = nil
			end
		end
		
		-- now we have an accurate books_scoring_straight_array! woo i sure hope there aren't any other problems!
		
		if next(find_joker('Shortcut')) then
			if (card.books_scoring_straight_array[#card.books_scoring_straight_array] - card.books_scoring_straight_array[1]) > (#card.books_scoring_straight_array - 1) then
				card.books_skipped_ranks = true
				for i = 1, (#card.books_scoring_straight_array - 1) do
					if card.books_scoring_straight_array[i] == (card.books_scoring_straight_array[i + 1] - 2) then
						card.books_allowed_skipped_ranks[#card.books_allowed_skipped_ranks + 1] = card.books_scoring_straight_array[i] + 1
					end
				end
			end
		end
		
		card.books_straight_border_low = card.books_scoring_straight_array[1]
		card.books_straight_border_high = card.books_scoring_straight_array[#card.books_scoring_straight_array]
		
		if not next(find_joker('Shortcut')) then
			while card.books_highest_rank_found == false do
				card.books_highest_rank_found = true
				for i = 1, card.books_card_array_length do
					if card.books_rank_array[i] == card.books_straight_border_high + 1 then
						if card.books_rank_array[i] == 14 and card.books_ace_high_scored == false then
							card.books_ace_high_scored = true
							card.books_ace_high_scored_in_hand = true
							card.books_straight_border_high = card.books_rank_array[i]
							card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
							card.books_ranks_used[#card.books_ranks_used + 1] = card.books_rank_array[i]
						end
						if card.books_rank_array[i] ~= 14 then
							card.books_highest_rank_found = false
							card.books_straight_border_high = card.books_rank_array[i]
							card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
							card.books_ranks_used[#card.books_ranks_used + 1] = card.books_rank_array[i]
						end
					end
				end
			end
			while card.books_lowest_rank_found == false do
				card.books_lowest_rank_found = true
				for i = 1, card.books_card_array_length do
					if card.books_rank_array[i] == card.books_straight_border_low - 1 then
						if card.books_rank_array[i] ~= 14 then
							card.books_lowest_rank_found = false
							card.books_straight_border_low = card.books_rank_array[i]
							card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
							card.books_ranks_used[#card.books_ranks_used + 1] = card.books_rank_array[i]
						end
					end
				end
				if card.books_straight_border_low - 1 == 1 then
					if card.books_rank_array[#card.books_rank_array] == 14 and card.books_ace_low_scored == false then
						if card.books_ace_high_scored_in_hand == true then
							if card.books_rank_array[#card.books_rank_array - 1] == 14 then
								card.books_ace_low_scored = true
								card.books_straight_border_low = 1
								card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
								card.books_ranks_used[#card.books_ranks_used + 1] = 1
							end
						else
							card.books_ace_low_scored = true
							card.books_straight_border_low = 1
							card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
							card.books_ranks_used[#card.books_ranks_used + 1] = 1
						end
					end	
				end		
			end
		else
			while card.books_highest_rank_found == false do
				card.books_highest_rank_found = true
				while card.books_repeat_non_shortcut == true do
					card.books_repeat_non_shortcut = false
					for i = 1, card.books_card_array_length do
						if card.books_rank_array[i] == card.books_straight_border_high + 1 then
							if card.books_rank_array[i] == 14 and card.books_ace_high_scored == false then
								card.books_ace_high_scored = true
								card.books_ace_high_scored_in_hand = true
								card.books_straight_border_high = card.books_rank_array[i]
								card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
								card.books_ranks_used[#card.books_ranks_used + 1] = card.books_rank_array[i]
							end
							if card.books_rank_array[i] ~= 14 then
								card.books_highest_rank_found = false
								card.books_repeat_non_shortcut = true
								card.books_straight_border_high = card.books_rank_array[i]
								card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
								card.books_ranks_used[#card.books_ranks_used + 1] = card.books_rank_array[i]
							end
						end
					end
				end
				for i = 1, card.books_card_array_length do
					if card.books_repeat_non_shortcut == false then
						if card.books_rank_array[i] == (card.books_straight_border_high + 2) then
							if card.books_rank_array[i] == 14 and card.books_ace_high_scored == false then
								card.books_ace_high_scored = true
								card.books_ace_high_scored_in_hand = true
								card.books_straight_border_high = card.books_rank_array[i]
								card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
								card.books_ranks_used[#card.books_ranks_used + 1] = card.books_rank_array[i]
							end
							if card.books_rank_array[i] ~= 14 then
								card.books_highest_rank_found = false
								card.books_repeat_non_shortcut = true
								card.books_straight_border_high = card.books_rank_array[i]
								card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
								card.books_ranks_used[#card.books_ranks_used + 1] = card.books_rank_array[i]
							end				
						end
					end
				end
			end
			card.books_repeat_non_shortcut = true
			while card.books_lowest_rank_found == false do
				card.books_lowest_rank_found = true
				while card.books_repeat_non_shortcut == true do
					card.books_repeat_non_shortcut = false
					for i = 1, card.books_card_array_length do
						if card.books_rank_array[i] == card.books_straight_border_low - 1 then
							if card.books_rank_array[i] ~= 14 then
								card.books_lowest_rank_found = false
								card.books_repeat_non_shortcut = true
								card.books_straight_border_low = card.books_rank_array[i]
								card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
								card.books_ranks_used[#card.books_ranks_used + 1] = card.books_rank_array[i]
							end
						end
					end
					if card.books_straight_border_low - 1 == 1 then
						if card.books_rank_array[#card.books_rank_array] == 14 and card.books_ace_low_scored == false then
							if card.books_ace_high_scored_in_hand == true then
								if card.books_rank_array[#card.books_rank_array - 1] == 14 then
									card.books_ace_low_scored = true
									card.books_straight_border_low = 1
									card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
									card.books_ranks_used[#card.books_ranks_used + 1] = 1
								end
							else
								card.books_ace_low_scored = true
								card.books_straight_border_low = 1
								card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
								card.books_ranks_used[#card.books_ranks_used + 1] = 1
							end
						end
					end
				end
				for i = 1, card.books_card_array_length do
					if card.books_repeat_non_shortcut == false then
						if card.books_rank_array[i] == card.books_straight_border_low - 2 then
							if card.books_rank_array[i] ~= 14 then
								card.books_lowest_rank_found = false
								card.books_repeat_non_shortcut = true
								card.books_straight_border_low = card.books_rank_array[i]
								card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
								card.books_ranks_used[#card.books_ranks_used + 1] = card.books_rank_array[i]
							end
						end				
					end
				end
				if card.books_straight_border_low - 1 == 1 then
					if card.books_rank_array[#card.books_rank_array] == 14 and card.books_ace_low_scored == false then
						if card.books_ace_high_scored_in_hand == true then
							if card.books_rank_array[#card.books_rank_array - 1] == 14 then
								card.books_ace_low_scored = true
								card.books_straight_border_low = 1
								card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
								card.books_ranks_used[#card.books_ranks_used + 1] = 1
							end
						else
							card.books_ace_low_scored = true
							card.books_straight_border_low = 1
							card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
							card.books_ranks_used[#card.books_ranks_used + 1] = 1
						end
					end
				end
			end
			if card.books_skipped_ranks == true then
				for i = 1, #card.books_allowed_skipped_ranks do
					for v = 1, #card.books_rank_array do
						if card.books_rank_array[v] == card.books_allowed_skipped_ranks[i] then
							card.books_additional_sequence_cards = card.books_additional_sequence_cards + 1
							card.books_allowed_skipped_ranks[i] = 0
							card.books_ranks_used[#card.books_ranks_used + 1] = card.books_rank_array[v] 
						end
					end
				end
			end
		end
	end
	
	if context.individual and context.poker_hands ~= nil and next(context.poker_hands['Straight']) and not context.blueprint then	-- there is totally a better way to do this... it's fine... i think
        	if context.cardarea == G.hand then
			local triggered = false
			for i = 1, #card.books_ranks_used do
	         		if (context.other_card:get_id() == card.books_ranks_used[i]) or (context.other_card:get_id() == 14 and card.books_ranks_used[i] == 1) then
					table.remove(card.books_ranks_used,i)
					card.books_vip_cards[#card.books_vip_cards + 1] = context.other_card
					card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_scale
					triggered = true
                        		return {
						message = localize('k_upgrade_ex'),
						colour = G.C.MULT,
						card = card
					}
				end
			end
			if triggered == false then
				for k = 1, #card.books_vip_cards do
					if context.other_card == card.books_vip_cards[k] then
						card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_scale
						return {
							message = localize('k_upgrade_ex'),
							colour = G.C.MULT,
							card = card
						}
					end
				end
			end
	        end
	end
	if context.joker_main then
		if card.ability.extra.xmult ~= 1 then
                	return {
                   	message = localize {
                  		type = 'variable',
                   		key = 'a_xmult',
                  		vars = { card.ability.extra.xmult }
                		},
                	mult_mod = card.ability.extra.xmult
                	}
		end
	end
end

function books.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_scale}}
end

-- endregion Huge Mess: Books

-- region Ominous Mirror

local ominousmirror = SMODS.Joker({
	name = "ccc_Ominous Mirror",
	key = "ominousmirror",
    config = {extra = {broken = false, pos_override = {x = 0, y = 2}, prob_success = 3, prob_break = 7}},
	pos = {x = 0, y = 2},
	loc_txt = {
        name = ('Ominous Mirror'),
        text = {
	"{C:green}#1# in #3#{} chance to add a",
	"permanent, {C:dark_edition}Mirrored{} copy of",
	"each scored card to your hand,",
	"{C:green}#1# in #4#{} chance to {C:inactive}break{}",
	"at end of round, becoming",
	"a {C:attention}Broken Mirror{}"
        }
    },
	rarity = 3,
	cost = 11,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie & sunsetquasar",
		code = "toneblock & Aurora Aquir",
		concept = "Gappie"
	},
	process_loc_text = function(self)
		SMODS.process_loc_text(G.localization.descriptions[self.set], self.key, self.loc_txt)
		SMODS.process_loc_text(G.localization.descriptions[self.set], "Broken Mirror", {
				name = ('Broken Mirror'),
				text = {
					"{C:inactive}Does nothing."
				}
		})
	end,
	afterload = function(self, card, card_table, other_card)
		card.children.center:set_sprite_pos(card_table.ability.extra.pos_override)
	end
})

ominousmirror.set_ability = function(self, card, initial, delay_sprites)
	card.children.center:set_sprite_pos(card.ability.extra.pos_override)
end


ominousmirror.calculate = function(self, card, context)
	card.children.center:set_sprite_pos(card.ability.extra.pos_override)
	if context.before and card.ability.extra.broken == false then
		if not context.repetition and not context.individual and card.ability.extra.broken == false then
			local _cards = {} 
			for k, v in ipairs(context.scoring_hand) do
				if pseudorandom('ominous') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
					local _card = copy_card(v, nil, nil, G.playing_card)
					_cards[#_cards+1] = _card
                           		_card.states.visible = nil
					G.hand:emplace(_card)
					G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.3, func = function()
						card:juice_up()
						v:juice_up()
						_card:add_to_deck()
						_card:set_edition({ccc_mirrored = true}, true, true)
						G.deck.config.card_limit = G.deck.config.card_limit + 1
						table.insert(G.playing_cards, _card)
                                   		_card:start_materialize()
						return true
					end}))
				end
			end
			if #_cards > 0 then
				playing_card_joker_effects(_cards)
				return nil, true
			end
		end
	end
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual and card.ability.extra.broken == false then
		if pseudorandom('oopsidroppedit') < G.GAME.probabilities.normal/card.ability.extra.prob_break then 
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, 
				func = function()
				play_sound('glass'..math.random(1, 6), math.random()*0.2 + 0.9,0.5)
				local childParts = Particles(0, 0, 0,0, {
					timer_type = 'TOTAL',
					timer = 0.007*1,
					scale = 0.3,
					speed = 4,
					lifespan = 0.5*1,
					attach = card,
					colours = {G.C.MULT},
					fill = true
				})
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					blockable = false,
					delay =  0.5*1,
					func = (function() childParts:fade(0.30*1) return true end)
				}))
				card.T.r = -0.2
				card:juice_up(0.3, 0.4)
				card.ability.extra.broken = true
				card.ability.extra.pos_override.x = 1
				card.ability.extra.pos_override.y = 2
				G.GAME.pool_flags.badeline_break = true
				return true
				end
			}))
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Broken", colour = G.C.MULT})
		else
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Safe..?", colour = G.C.FILTER})
		end
	end
end

function ominousmirror.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'e_mirrored', set = 'Other'}
	return {key = card.ability.extra.broken and "Broken Mirror" or card.config.center.key, vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.broken, card.ability.extra.prob_success, card.ability.extra.prob_break}}
end

-- endregion Ominous Mirror

-- region ALL BERRIES

-- region Strawberry

local strawberry = SMODS.Joker({
	name = "ccc_Strawberry",
	key = "strawberry",
    config = {extra = {money = 7, money_reduce = 1}},
	pos = {x = 1, y = 1},
	loc_txt = {
        name = 'Strawberry',
        text = {
	"Earn {C:money}$#1#{} at end of",
	"round, reduces by {C:money}$#2#{}",
	"upon cashing out"
        }
    },
	rarity = 1,
	cost = 6,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	}
})

-- for some goddamn reason there's no easy way to add the dollar bonus at calculation... so i injected it via lovely. should work though
-- THERE IS!!! FUCK YOU PAST ME
-- i'm still not changing it

strawberry.calculate = function(self, card, context)
	if context.ccc_cash_out and not context.blueprint then	-- custom cashout context in lovely
		if card.ability.extra.money > card.ability.extra.money_reduce then
			card.ability.extra.money = card.ability.extra.money - card.ability.extra.money_reduce
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-$"..card.ability.extra.money_reduce, colour = G.C.MONEY})
		else
			G.E_MANAGER:add_event(Event({
				func = function()
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Eaten!", colour = G.C.FILTER})
				play_sound('tarot1')
				card.T.r = -0.2
				card:juice_up(0.3, 0.4)
				card.states.drag.is = true
				card.children.center.pinch.x = true
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
					func = function()
						G.jokers:remove_card(card)
						card:remove()
						card = nil
					return true; end})) 
				return true
			end
                       	}))
		end 
	end
end

function strawberry.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.money, card.ability.extra.money_reduce}}
end


-- endregion Strawberry

-- region Winged Strawberry

local wingedstrawberry = SMODS.Joker({
	name = "ccc_Winged Strawberry",
	key = "wingedstrawberry",
    config = {extra = {winged_poker_hand = 'Pair', money = 2}},
	pos = {x = 2, y = 1},
	loc_txt = {
        name = 'Winged Strawberry',
        text = {
	"Earn {C:money}$#2#{} if {C:attention}poker hand{} does",
	"not contain a {C:attention}#1#{},",
	"{s:0.8}poker hand changes at end of round"
        }
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	}
})

wingedstrawberry.set_ability = function(self, card, initial, delay_sprites)
	local _poker_hands = {}
	for k, v in pairs(G.GAME.hands) do
		if v.visible and k ~= 'High Card' then
			_poker_hands[#_poker_hands+1] = k 
		end
	end
	card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('winged'))
end

wingedstrawberry.calculate = function(self, card, context)
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
		if not context.blueprint then
                    local _poker_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible and k ~= card.ability.extra.winged_poker_hand and k ~= 'High Card' then 
				_poker_hands[#_poker_hands+1] = k 
			end
                    end
                    card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('winged'))
		end
		card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Reset", colour = G.C.FILTER})
	end
        if context.cardarea == G.jokers then
		if context.before and not context.end_of_round then
			if not next(context.poker_hands[card.ability.extra.winged_poker_hand]) then
				G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
				G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
				return {
					dollars = card.ability.extra.money,
					colour = G.C.MONEY
				}
			end
		end
	end
end
		
	

function wingedstrawberry.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.winged_poker_hand, card.ability.extra.money}}
end

-- endregion Winged Strawberry

-- region Golden Strawberry

local goldenstrawberry = SMODS.Joker({
	name = "ccc_Golden Strawberry",
	key = "goldenstrawberry",
    config = {extra = {after_boss = false, money = 15}},
	pos = {x = 3, y = 1},
	loc_txt = {
        name = 'Golden Strawberry',
        text = {
	"Earn {C:money}$#1#{} at end of",
	"{C:attention}Boss Blind{}"
        }
    },
	rarity = 2,
	cost = 8,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	}
})

-- literally the simplest code in the entire mod lmao

goldenstrawberry.calculate = function(self, card, context)
	if context.setting_blind and not context.blueprint then
		if context.blind.boss or G.GAME.selected_back.effect.config.everything_is_boss then
			card.ability.extra.after_boss = true
		else
			card.ability.extra.after_boss = false
		end
	end
end

function goldenstrawberry.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.money}}
end

-- endregion Golden Strawberry

-- region Winged Golden Strawberry

local wingedgoldenstrawberry = SMODS.Joker({
	name = "ccc_Winged Golden Strawberry",
	key = "wingedgoldenstrawberry",
    config = {extra = {condition_satisfied = 'true', winged_poker_hand = 'Pair', after_boss = false, money = 18}},
	pos = {x = 4, y = 1},
	loc_txt = {
        name = 'Winged Golden Strawberry',
        text = {
	"Earn {C:money}$#2#{} at end of {C:attention}Boss Blind{} if",
	"beaten without playing a hand",
	"that contains a {C:attention}#1#{},",
	"{s:0.8}poker hand changes at end of round"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	}
})

wingedgoldenstrawberry.set_ability = function(self, card, initial, delay_sprites)
	local _poker_hands = {}
	for k, v in pairs(G.GAME.hands) do
		if v.visible and k ~= 'High Card' then
			_poker_hands[#_poker_hands+1] = k 
		end
	end
	card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('wingedgolden'))
end

wingedgoldenstrawberry.calculate = function(self, card, context)
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
		if not context.blueprint then
                    local _poker_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible and k ~= card.ability.extra.winged_poker_hand and k ~= 'High Card' then 
				_poker_hands[#_poker_hands+1] = k 
			end
                    end
                    card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('wingedgolden'))
		end
		card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Reset", colour = G.C.FILTER})
	end
        if context.cardarea == G.jokers then
		if context.before and not context.end_of_round then
			if next(context.poker_hands[card.ability.extra.winged_poker_hand]) then
				card.ability.extra.condition_satisfied = false
			end
		end
	end
	if context.setting_blind then
		card.ability.extra.condition_satisfied = true
		if context.blind.boss or G.GAME.selected_back.effect.config.everything_is_boss then
			card.ability.extra.after_boss = true
		else
			card.ability.extra.after_boss = false
		end
	end
end

function wingedgoldenstrawberry.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.winged_poker_hand, card.ability.extra.money}}
end

-- endregion Winged Golden Strawberry

-- region Moon Berry

local moonberry = SMODS.Joker({
	name = "ccc_Moon Berry",
	key = "moonberry",
    config = {extra = {condition_satisfied = false, winged_poker_hand = 'Pair', old_winged_poker_hand = 'Pair'}},	-- old_winged_poker_hand is internal, winged_poker_hand is external
	pos = {x = 5, y = 1},
	loc_txt = {
        name = 'Moon Berry',
        text = {
	"If round ends without playing",
	"hand that contains a {C:attention}#1#{},",
	"create its {C:planet}Planet{} card with",
	"added {C:dark_edition}Negative{} edition,",
	"{s:0.8}poker hand changes at end of round"
        }
    },
	rarity = 2,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	}
})

moonberry.set_ability = function(self, card, initial, delay_sprites)
	local _poker_hands = {}
	for k, v in pairs(G.GAME.hands) do
		if v.visible and k ~= 'High Card' then
			_poker_hands[#_poker_hands+1] = k 
		end
	end
	card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('SPAAAAAAAACE'))
	card.ability.extra.old_winged_poker_hand = card.ability.extra.winged_poker_hand
end

moonberry.calculate = function(self, card, context)
	if context.setting_blind and not context.blueprint then
		card.ability.extra.old_winged_poker_hand = card.ability.extra.winged_poker_hand		-- delay old_winged_poker_hand from changing due to brainstorm
	end
	if context.end_of_round and not context.repetition and not context.individual then
		local card_type = 'Planet'
		if card.ability.extra.condition_satisfied == true then
			G.E_MANAGER:add_event(Event({
			trigger = 'before',
			delay = 0.0,
			func = (function()
				local _planet = 0
				for k, v in pairs(G.P_CENTER_POOLS.Planet) do
					if v.config.hand_type == card.ability.extra.old_winged_poker_hand then		-- use old_winged_poker_hand
						_planet = v.key
					end
				end
                    		local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, _planet, 'blusl')
				card:set_edition({negative = true}, true)
                    		card:add_to_deck()
                    		G.consumeables:emplace(card)
                		return true
            		end)}))
		end
		if not context.blueprint then
			G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.0,
			func = (function()
			local _poker_hands = {}
                    	for k, v in pairs(G.GAME.hands) do
                      	  	if v.visible and k ~= card.ability.extra.winged_poker_hand and k ~= 'High Card' then 
					_poker_hands[#_poker_hands+1] = k 
				end
                    	end
			card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('SPAAAAAAAACE'))	-- change winged_poker_hand
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Reset", colour = G.C.FILTER})
			return true
            		end)}))
		end
		if card.ability.extra.condition_satisfied == true then
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
			return nil, true
		end
	end
        if context.cardarea == G.jokers then
		if context.before and not context.end_of_round then
			if next(context.poker_hands[card.ability.extra.winged_poker_hand]) then
				card.ability.extra.condition_satisfied = false
			end
		end
	end
	if context.setting_blind then
		card.ability.extra.condition_satisfied = true
	end
end

function moonberry.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
	return {vars = {card.ability.extra.winged_poker_hand}}
end

-- endregion Moon Berry

-- endregion ALL BERRIES

-- region To The Summit

local tothesummit = SMODS.Joker({
	name = "ccc_To The Summit",
	key = "tothesummit",
    config = {extra = {xmult = 1, min_money = 0, xmult_scale = 0.25}},	-- rip debt lovers
	pos = {x = 0, y = 1},
	loc_txt = {
        name = 'To The Summit',
        text = {
	"Gains {X:mult,C:white} X#3# {} Mult for each",
	"{C:attention}consecutive Blind{} selected",
	"with more {C:money}money{} than",
	"the {C:attention}previous Blind{}",
	"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
	"{C:inactive}(Previous: {C:money}$#2#{C:inactive})"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Aurora Aquir"
	}
})

tothesummit.calculate = function(self, card, context)
	if context.setting_blind and not context.blueprint then
		if to_big(card.ability.extra.min_money) >= math.max(0,(to_big(G.GAME.dollars) + (to_big(G.GAME.dollar_buffer) or 0))) then
			local last_xmult = card.ability.extra.xmult
			card.ability.extra.xmult = 1
			if last_xmult > 1 then
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Reset", colour = G.C.FILTER})
			end
			card.ability.extra.min_money = math.max(0,(G.GAME.dollars + (G.GAME.dollar_buffer or 0)))
		elseif to_big(card.ability.extra.min_money) < math.max(0,(G.GAME.dollars + (G.GAME.dollar_buffer or 0))) then
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_scale
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}}})
			card.ability.extra.min_money = math.max(0,(G.GAME.dollars + (G.GAME.dollar_buffer or 0)))
		end
	end		
	if context.joker_main then
            	if card.ability.extra.xmult ~= 1 then
                	return {
                    	message = localize {
                        	type = 'variable',
                        	key = 'a_xmult',
                        	vars = { card.ability.extra.xmult }
                    	},
			Xmult_mod = card.ability.extra.xmult
                	}
		end
	end
end

function tothesummit.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.xmult, card.ability.extra.min_money, card.ability.extra.xmult_scale}}
end

-- endregion To The Summit

-- region Core Switch

local coreswitch = SMODS.Joker({
	name = "ccc_Core Switch",
	key = "coreswitch",
    config = {extra = {pos_override = {x = 6, y = 0}, discards = 1}},
	pos = {x = 6, y = 0},
	loc_txt = {
        name = 'Core Switch',
        text = {
	"Swap {C:blue}hands{} and {C:red}discards{}",
	"on blind select",
	"{C:red}+#1#{} discard after swap"
        }
    },
	rarity = 1,
	cost = 3,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie & Aurora Aquir",
		code = "toneblock",
		concept = "Aurora Aquir"
	},
	afterload = function(self, card, card_table, other_card)
		card.children.center:set_sprite_pos(card_table.ability.extra.pos_override)
	end
})

coreswitch.set_ability = function(self, card, initial, delay_sprites)
	card.ability.extra.pos_override.x = pseudorandom_element({6, 7}, pseudoseed('coreswitch'))
	card.children.center:set_sprite_pos(card.ability.extra.pos_override)
end

coreswitch.calculate = function(self, card, context)
	card.children.center:set_sprite_pos(card.ability.extra.pos_override)
	if context.first_hand_drawn and not card.getting_sliced and not context.blueprint and not context.individual then
		G.E_MANAGER:add_event(Event({trigger = 'before', delay = immediate, func = function()
			local coreswitch_hand_juggle = G.GAME.current_round.discards_left
			ease_discard(card.ability.extra.discards + (G.GAME.current_round.hands_left - G.GAME.current_round.discards_left), nil, true)
			ease_hands_played(coreswitch_hand_juggle - G.GAME.current_round.hands_left, nil, true)
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Swapped", colour = G.C.FILTER})
			if card.ability.extra.pos_override.x == 6 then 
				card.ability.extra.pos_override.x = 7
				SMODS.calculate_context({ccc_switch = {ice = true}})
			else
				card.ability.extra.pos_override.x = 6
				SMODS.calculate_context({ccc_switch = {fire = true}})
			end
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.0,
				func = function()
					save_run()
					return true
				end
			}))
			if coreswitch_hand_juggle == 0 then  -- you're a dumbass lol
				end_round()
			end
		return true end }))
		return nil, true
	end
end

function coreswitch.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.discards}}
end

-- endregion Core Switch

-- region Temple Rock

local templerock = SMODS.Joker({
	name = "ccc_Temple Rock",
	key = "templerock",
    config = {extra = {chips = 66}},
	pos = {x = 8, y = 0},
	loc_txt = {
        name = 'Temple Rock',
        text = {
	"Each {C:attention}Stone Card{} held",
	"in hand gives {C:chips}+#1#{} chips"
        }
    },
	rarity = 1,
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	enhancement_gate = "m_stone",
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "sunsetquasar"
	}
})

templerock.calculate = function(self, card, context)
	if context.individual and context.poker_hands ~= nil then
        	if context.cardarea == G.hand then
	         	if context.other_card.ability.name == 'Stone Card' then
                        	return {
                    			message = localize {
                        			type = 'variable',
                        			key = 'a_chips',
                        			vars = { card.ability.extra.chips }
                    				},
					chip_mod = card.ability.extra.chips
				}
			end
        	end
	end
end

function templerock.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.m_stone
	return {vars = {card.ability.extra.chips}}
end

-- endregion Temple Rock

-- region Strong Winds

local strongwinds = SMODS.Joker({
	name = "ccc_Strong Winds",
	key = "strongwinds",
    config = {extra = {xmult = 2.22}},
	pos = {x = 4, y = 2},
	loc_txt = {
        name = 'Strong Winds',
        text = {
	"{X:mult,C:white} X#1# {} Mult",
	"The highest-{C:attention}ranked{} scoring",
	"card is {C:red}destroyed{}"
        }
    },
	rarity = 3,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "goose!"
	}
})

strongwinds.calculate = function(self, card, context)
	if context.cardarea == G.jokers then
		if context.joker_main then
			return {
				message = localize {
					type = 'variable',
					key = 'a_xmult',
					vars = { card.ability.extra.xmult }
				},
				Xmult_mod = card.ability.extra.xmult
			}
		end
	end
	if context.cardarea == G.play and context.destroying_card then
		local bitch = context.scoring_hand[1] or nil
		for k = 1, #context.scoring_hand do
			if context.scoring_hand[k].ability.name ~= 'Stone Card' then
				if context.scoring_hand[k]:get_id() > bitch:get_id() then
					bitch = context.scoring_hand[k]
				end
			end
		end
		if bitch and bitch == context.destroy_card then
			return {remove = true}
		end
	end
end

function strongwinds.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.xmult}}
end
		
-- endregion Strong Winds

-- region Coyote Jump

local coyotejump = SMODS.Joker({
	name = "ccc_Coyote Jump",
	key = "coyotejump",
    config = {extra = {discards = 1}},
	pos = {x = 9, y = 0},
	loc_txt = {
        name = 'Coyote Jump',
        text = {
	"If cards held in hand",
	"do not form a {C:attention}Pair{},",
	"{C:attention}Straight{}, or {C:attention}Flush{},",
	"gain {C:red}+#1#{} discard"
        }
    },
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
	}
})

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
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Straight", colour = G.C.RED})
			return true end }))
		elseif next(parts._flush) then
			G.E_MANAGER:add_event(Event({trigger = 'before', delay = immediate, func = function()
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Flush", colour = G.C.RED})
			return true end }))
		elseif pair_found == true then
			G.E_MANAGER:add_event(Event({trigger = 'before', delay = immediate, func = function()
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Pair", colour = G.C.RED})
			return true end }))
		else
			G.E_MANAGER:add_event(Event({trigger = 'before', delay = immediate, func = function()
				ease_discard(card.ability.extra.discards, nil, true)
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..card.ability.extra.discards.." Discard", colour = G.C.RED})
			return true end }))
		end
	end
end

function coyotejump.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.discards}}
end

-- endregion Coyote Jump

-- region Climbing Gear

local climbinggear = SMODS.Joker({
	name = "ccc_Climbing Gear",
	key = "climbinggear",
    config = {d_size = 3},
	pos = {x = 6, y = 1},
	loc_txt = {
        name = 'Climbing Gear',
        text = {
	"{C:red}+#1#{} discards",
	"Played and discarded cards",
	"are reshuffled into deck"
        }
    },
	rarity = 2,
	cost = 5,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "goose!"
	}
})

-- literally NO code needs to be here, it's all done in lovely patches

function climbinggear.loc_vars(self, info_queue, card)
	return {vars = {card.ability.d_size}}
end

-- endregion Climbing Gear

-- all 3 spinners have basically the same code lol

-- region Blue Spinner

local bluespinner = SMODS.Joker({
	name = "ccc_Blue Spinner",
	key = "bluespinner",
    config = {extra = {prob_success = 2}},
	pos = {x = 0, y = 4},
	loc_txt = {
        name = 'Blue Spinner',
        text = {
	"When a card with a {C:planet}Blue Seal{}",
	"is scored, {C:green}#1# in #2#{} chance",
	"to add a {C:planet}Blue Seal{} to each",
	"{C:attention}adjacent{} card in scored hand",
	"{C:inactive,s:0.87}(Unaffected by retriggers){}"
        }
    },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "sunsetquasar"
	}
})

bluespinner.calculate = function(self, card, context)

	if context.before and not context.blueprint then
		local rainbow_spinner_seal_override = false
		if next(find_joker('ccc_Rainbow Spinner')) then
			rainbow_spinner_seal_override = true
		else
			rainbow_spinner_seal_override = false
		end
		bluespinner_seal_candidates = {}
		for k = 1, #context.scoring_hand do
			if k == 1 then
				if k ~= #context.scoring_hand then
					if context.scoring_hand[k + 1].seal == 'Blue' or (rainbow_spinner_seal_override == true and context.scoring_hand[k + 1].seal == 'Gold') then
						if pseudorandom('bloo1') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
							bluespinner_seal_candidates[#bluespinner_seal_candidates + 1] = context.scoring_hand[k]
						end
					end
				end
			elseif k == #context.scoring_hand then
				if k ~= 1 then
					if context.scoring_hand[k - 1].seal == 'Blue' or (rainbow_spinner_seal_override == true and context.scoring_hand[k - 1].seal == 'Gold') then
						if pseudorandom('bloo2') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
							bluespinner_seal_candidates[#bluespinner_seal_candidates + 1] = context.scoring_hand[k]
						end
					end
				end
			else
				if context.scoring_hand[k + 1].seal == 'Blue' or (rainbow_spinner_seal_override == true and context.scoring_hand[k + 1].seal == 'Gold') then
					if pseudorandom('bloo3') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
						bluespinner_seal_candidates[#bluespinner_seal_candidates + 1] = context.scoring_hand[k]
					end
				elseif context.scoring_hand[k - 1].seal == 'Blue' or (rainbow_spinner_seal_override == true and context.scoring_hand[k - 1].seal == 'Gold') then
					if pseudorandom('bloo4') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
						bluespinner_seal_candidates[#bluespinner_seal_candidates + 1] = context.scoring_hand[k]
					end
				end
			end
		end
		if #bluespinner_seal_candidates > 0 then
			for k = 1, #bluespinner_seal_candidates do
				if (rainbow_spinner_seal_override == true and bluespinner_seal_candidates[k].seal ~= 'Blue' and bluespinner_seal_candidates[k].seal ~= 'Gold') or (rainbow_spinner_seal_override == false and bluespinner_seal_candidates[k].seal ~= 'Blue') then
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.0, func = function()
           					bluespinner_seal_candidates[k]:set_seal('Blue', true, false)
						bluespinner_seal_candidates[k]:juice_up()
						play_sound('gold_seal', 1.2, 0.4)
						card:juice_up()
            				return true end }))
					delay(0.5)
				end
			end
			return nil, true
		end
	end
end

function bluespinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'blue_seal', set = 'Other'}
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.prob_success}}
end

function bluespinner.in_pool(self)
	for i, v in ipairs(G.playing_cards) do
		if v.seal and v.seal == 'Blue' then return true end
	end
	return false
end

-- endregion Blue Spinner

-- region Purple Spinner

local purplespinner = SMODS.Joker({
	name = "ccc_Purple Spinner",
	key = "purplespinner",
    config = {extra = {prob_success = 2}},
	pos = {x = 1, y = 4},
	loc_txt = {
        name = 'Purple Spinner',
        text = {
	"When a card with a {C:tarot}Purple Seal{}",
	"is {C:attention}held{} in hand at end of round,",
	"{C:green}#1# in #2#{} chance to add a {C:tarot}Purple Seal{}",
	"to each {C:attention}adjacent{} card in hand",
	"{C:inactive,s:0.87}(Unaffected by retriggers){}"
        }
    },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "sunsetquasar"
	}
})

purplespinner.calculate = function(self, card, context)

	if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
		local rainbow_spinner_seal_override = false
		if next(find_joker('ccc_Rainbow Spinner')) then
			rainbow_spinner_seal_override = true
		else
			rainbow_spinner_seal_override = false
		end
		purplespinner_seal_candidates = {}
		for k = 1, #G.hand.cards do
			if k == 1 then
				if k ~= #G.hand.cards then
					if G.hand.cards[k + 1].seal == 'Purple' or (rainbow_spinner_seal_override == true and G.hand.cards[k + 1].seal == 'Gold') then
						if pseudorandom('purple1') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
							purplespinner_seal_candidates[#purplespinner_seal_candidates + 1] = G.hand.cards[k]
						end
					end
				end
			elseif k == #G.hand.cards then
				if k ~= 1 then
					if G.hand.cards[k - 1].seal == 'Purple' or (rainbow_spinner_seal_override == true and G.hand.cards[k - 1].seal == 'Gold') then
						if pseudorandom('is2') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
							purplespinner_seal_candidates[#purplespinner_seal_candidates + 1] = G.hand.cards[k]
						end
					end
				end
			else
				if G.hand.cards[k + 1].seal == 'Purple' or (rainbow_spinner_seal_override == true and G.hand.cards[k + 1].seal == 'Gold') then
					if pseudorandom('best3') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
						purplespinner_seal_candidates[#purplespinner_seal_candidates + 1] = G.hand.cards[k]
					end
				elseif G.hand.cards[k - 1].seal == 'Purple' or (rainbow_spinner_seal_override == true and G.hand.cards[k - 1].seal == 'Gold') then
					if pseudorandom('colour4') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
						purplespinner_seal_candidates[#purplespinner_seal_candidates + 1] = G.hand.cards[k]
					end
				end
			end
		end
		if #purplespinner_seal_candidates > 0 then
			for k = 1, #purplespinner_seal_candidates do
				if (rainbow_spinner_seal_override == true and purplespinner_seal_candidates[k].seal ~= 'Purple' and purplespinner_seal_candidates[k].seal ~= 'Gold') or (rainbow_spinner_seal_override == false and purplespinner_seal_candidates[k].seal ~= 'Purple') then
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.0, func = function()
           					purplespinner_seal_candidates[k]:set_seal('Purple', true, false)
						purplespinner_seal_candidates[k]:juice_up()
						play_sound('gold_seal', 1.2, 0.4)
						card:juice_up()
            				return true end }))
					delay(0.5)
				end
			end
			return nil, true
		end
	end
end

function purplespinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'purple_seal', set = 'Other'}
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.prob_success}}
end

function purplespinner.in_pool(self)
	for i, v in ipairs(G.playing_cards) do
		if v.seal and v.seal == 'Purple' then return true end
	end
	return false
end

-- region Red Spinner

local redspinner = SMODS.Joker({
	name = "ccc_Red Spinner",
	key = "redspinner",
    config = {extra = {prob_success = 2}},
	pos = {x = 2, y = 4},
	loc_txt = {
        name = 'Red Spinner',
        text = {
	"When a card with a {C:red}Red Seal{}",
	"is {C:attention}discarded{}, {C:green}#1# in #2#{} chance",
	"to add a {C:red}Red Seal{} to each",
	"{C:attention}adjacent{} card in discarded hand",
	"{C:inactive,s:0.87}(Unaffected by retriggers){}"
        }
    },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "sunsetquasar"
	}
})

redspinner.calculate = function(self, card, context)

	if context.pre_discard and not context.blueprint then
		local rainbow_spinner_seal_override = false
		if next(find_joker('ccc_Rainbow Spinner')) then
			rainbow_spinner_seal_override = true
		else
			rainbow_spinner_seal_override = false
		end
		redspinner_seal_candidates = {}
		for k = 1, #G.hand.highlighted do
			if k == 1 then
				if k ~= #G.hand.highlighted then
					if G.hand.highlighted[k + 1].seal == 'Red' or (rainbow_spinner_seal_override == true and G.hand.highlighted[k + 1].seal == 'Gold') then
						if pseudorandom('RED1') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
							redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
						end
					end
				end
			elseif k == #G.hand.highlighted then
				if k ~= 1 then
					if G.hand.highlighted[k - 1].seal == 'Red' or (rainbow_spinner_seal_override == true and G.hand.highlighted[k - 1].seal == 'Gold') then
						if pseudorandom('redge2') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
							redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
						end
					end
				end
			else
				if G.hand.highlighted[k + 1].seal == 'Red' or (rainbow_spinner_seal_override == true and G.hand.highlighted[k + 1].seal == 'Gold') then
					if pseudorandom('reeeeeeeed3') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
						redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
					end
				elseif G.hand.highlighted[k - 1].seal == 'Red' or (rainbow_spinner_seal_override == true and G.hand.highlighted[k - 1].seal == 'Gold') then
					if pseudorandom('dontknowhattoputhere4') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
						redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
					end
				end
			end
		end
		if #redspinner_seal_candidates > 0 then
			for k = 1, #redspinner_seal_candidates do
				if (rainbow_spinner_seal_override == true and redspinner_seal_candidates[k].seal ~= 'Red' and redspinner_seal_candidates[k].seal ~= 'Gold') or (rainbow_spinner_seal_override == false and redspinner_seal_candidates[k].seal ~= 'Red') then
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.0, func = function()
           					redspinner_seal_candidates[k]:set_seal('Red', true, false)
						redspinner_seal_candidates[k]:juice_up()
						play_sound('gold_seal', 1.2, 0.4)
						card:juice_up()
            				return true end }))
					delay(0.5)
				end
			end
			return nil, true
		end
	end
end

function redspinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'red_seal', set = 'Other'}
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.prob_success}}
end

function redspinner.in_pool(self)
	for i, v in ipairs(G.playing_cards) do
		if v.seal and v.seal == 'Red' then return true end
	end
	return false
end

-- endregion Red Spinner

-- region Rainbow Spinner

local rainbowspinner = SMODS.Joker({
	name = "ccc_Rainbow Spinner",
	key = "rainbowspinner",
    config = {},
	pos = {x = 3, y = 4},
	loc_txt = {
        name = 'Rainbow Spinner',
        text = {
	"{C:money}Gold Seals{} act as",
	"{C:attention}every{} {C:money}s{C:red}e{C:tarot}a{C:planet}l"
        }
    },
	rarity = 3,
	cost = 11,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "sunsetquasar"
	}
})

-- this hook handles red and purple, still need lovely for blue

local sealref = Card.calculate_seal
function Card:calculate_seal(context)
	if next(SMODS.find_card('j_ccc_rainbowspinner')) and self.seal == 'Gold' then
		local oldseal = self.seal
		local ret, post = nil, nil
		for k, v in pairs(G.P_SEALS) do
			self.seal = k
			ret, post = sealref(self, context)
			if ret or post then break end
		end
		self.seal = oldseal
		return ret, post
	else
		local ret, post = sealref(self, context)
		return ret, post
	end
end

function rainbowspinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'gold_seal', set = 'Other'}
end

function rainbowspinner.in_pool(self)
	for i, v in ipairs(G.playing_cards) do
		if v.seal and v.seal == 'Gold' then return true end
	end
	return false
end

-- endregion Rainbow Spinner

-- region Letting Go

local lettinggo = SMODS.Joker({
	name = "ccc_Letting Go",
	key = "lettinggo",
    config = {extra = {xmult = 1, prob_success = 2, xmult_scale = 0.15}},
	pos = {x = 2, y = 2},
	loc_txt = {
        name = 'Letting Go',
        text = {
	"When a card is destroyed,",
	"{C:green}#1# in #3#{} chance to create",
	"a {C:tarot}Death{}",
	"{C:inactive}(Must have room)",
	"Gains {X:mult,C:white} X#4# {} Mult for each",
	"{C:tarot}Death{} used",
	"{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
        }
    },
	rarity = 3,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "bein",
		code = "toneblock",
		concept = "Gappie"
	}
})

lettinggo.calculate = function(self, card, context)

	if context.cards_destroyed then
                local death_chances = 0
		for k, v in ipairs(context.glass_shattered) do
			death_chances = death_chances + 1
                end
		for i = 1, death_chances do
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				if pseudorandom('lettinggo') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					G.E_MANAGER:add_event(Event({
                    			func = (function()
                        			G.E_MANAGER:add_event(Event({
                            			func = function() 
                                			local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_death', 'lgo')
                               				card:add_to_deck()
                                			G.consumeables:emplace(card)
                                			G.GAME.consumeable_buffer = 0
                                			return true
                            			end}))   
                            			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})                       
                        		return true
                    			end)}))
				end
			end
		end
		return nil, true
	end
	
	if context.remove_playing_cards and context.removed ~= nil then -- it's just the same thing as before, folks
		local death_chances = 0
		for k, val in ipairs(context.removed) do
			death_chances = death_chances + 1
		end
		for i = 1, death_chances do
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				if pseudorandom('lettinggo') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					G.E_MANAGER:add_event(Event({
                    			func = (function()
                        			G.E_MANAGER:add_event(Event({
                            			func = function() 
                                			local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_death', 'lgo')
                               				card:add_to_deck()
                                			G.consumeables:emplace(card)
                                			G.GAME.consumeable_buffer = 0
                                			return true
                            			end}))   
                            			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})                       
                        		return true
                    			end)}))
				end
			end
		end
		return nil, true
	end

	if context.using_consumeable then
		if context.consumeable.ability.name == 'Death' then
			if not context.blueprint then
				card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_scale
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}}})
			end
		end
	end

	if context.joker_main then
		if card.ability.extra.xmult > 1 then
                	return {
                   	message = localize {
                  		type = 'variable',
                   		key = 'a_xmult',
                  		vars = { card.ability.extra.xmult }
                		},
                	Xmult_mod = card.ability.extra.xmult
                	}
		end
	end
end

function lettinggo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.c_death
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.xmult, card.ability.extra.prob_success, card.ability.extra.xmult_scale}}
end

-- endregion Letting Go

-- region Green Bubble

local greenbooster = SMODS.Joker({
	name = "ccc_Green Booster",
	key = "greenbooster",
    config = {extra = {choices = 1}},
	pos = {x = 3, y = 2},
	loc_txt = {
        name = 'Green Booster',
        text = {
	"Adds {C:attention}#1#{} extra option",
	"to all {C:attention}Booster Packs{}"
        }
    },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "bein",
		code = "toneblock",
		concept = "sunsetquasar"
	}
})

-- lovely abuse

greenbooster.calculate = function(self, card, context)
	if context.open_booster then
		ccc_grubble_bonus_choices = (ccc_grubble_bonus_choices or 0) + card.ability.extra.choices
		card:juice_up()
	end
end

function greenbooster.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.choices}}
end


-- endregion Green Booster

-- region Red Booster

local redbooster = SMODS.Joker({
	name = "ccc_Red Booster",
	key = "redbooster",
    config = {extra = {choices = 1}},
	pos = {x = 3, y = 3},
	loc_txt = {
        name = 'Red Booster',
        text = {
	"Allows you to {C:attention}pick{}",
	"{C:attention}#1#{} extra card from",
	"all {C:attention}Booster Packs{}"
        }
    },
	rarity = 3,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "bein",
		code = "toneblock",
		concept = "sunsetquasar"
	}
})

-- more lovely abuse

redbooster.calculate = function(self, card, context)
	if context.open_booster then
		ccc_rrubble_bonus_choices = (ccc_rrubble_bonus_choices or 0) + card.ability.extra.choices
		card:juice_up()
	end
end

function redbooster.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.choices}}
end

-- endregion Red Booster

-- region Cassette Block

local cassetteblock = SMODS.Joker({
	name = "ccc_Cassette Block",
	key = "cassetteblock",
    config = {extra = {chips = 0, mult = 0, chips_scale = 8, mult_scale = 3, pink = false, pos_override = {x = 6, y = 2}}},
	pos = {x = 6, y = 2},
	loc_txt = {
        name = ('Cassette Block'),
        text = {
	"Gains {C:chips}+#3#{} Chips for each",
	"{C:attention}unused{} {C:chips}hand{} at end of round",
	"{C:mult}Swaps{} at start of round",
	"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips){}",
        }
    },
	rarity = 2,
	cost = 8,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	},
	process_loc_text = function(self)
		SMODS.process_loc_text(G.localization.descriptions[self.set], self.key, self.loc_txt)
		SMODS.process_loc_text(G.localization.descriptions[self.set], "Cassette Block", {
				name = ('Cassette Block'),
				text = {
					"Gains {C:mult}+#4#{} Mult for each",
					"{C:attention}unused{} {C:mult}discard{} at end of round",
					"{C:chips}Swaps{} at start of round",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult){}",
				}
		})
	end,
	afterload = function(self, card, card_table, other_card)
		card.children.center:set_sprite_pos(card_table.ability.extra.pos_override)
	end
})

cassetteblock.calculate = function(self, card, context)

	if context.setting_blind and not context.blueprint then

		if card.ability.extra.pink == false then
			return {
			G.E_MANAGER:add_event(Event({func = function()
			
				G.E_MANAGER:add_event(Event({func = function()
			
				card.ability.extra.pink = true
				card.ability.extra.pos_override.x = 7
				card.children.center:set_sprite_pos(card.ability.extra.pos_override)
			
				return true end }))
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Swap", colour = G.C.RED})
			return true end }))
			}
		else
			return {
			G.E_MANAGER:add_event(Event({func = function()
			
				G.E_MANAGER:add_event(Event({func = function()
			
				card.ability.extra.pink = false
				card.ability.extra.pos_override.x = 6
				card.children.center:set_sprite_pos(card.ability.extra.pos_override)
			
				return true end }))
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Swap", colour = G.C.BLUE})
			return true end }))
			}
		end
	end

	if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then

		if card.ability.extra.pink == false then
			if G.GAME.current_round.hands_left > 0 then
				card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_scale*G.GAME.current_round.hands_left

				G.E_MANAGER:add_event(Event({func = function()
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Upgrade!", colour = G.C.FILTER})
				return true end }))
			end
		else
			if G.GAME.current_round.discards_left > 0 then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_scale*G.GAME.current_round.discards_left

				G.E_MANAGER:add_event(Event({func = function()
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Upgrade!", colour = G.C.FILTER})
				return true end }))
			end
		end
	end

	if context.joker_main then
		if card.ability.extra.pink == false then
			if card.ability.extra.chips ~= 0 then
                		return {
                  	 	message = localize {
                  			type = 'variable',
                   			key = 'a_chips',
                  			vars = { card.ability.extra.chips }
                			},
                		chip_mod = card.ability.extra.chips
                		}
			end
		else
			if card.ability.extra.mult ~= 0 then
                		return {
                  	 	message = localize {
                  			type = 'variable',
                   			key = 'a_mult',
                  			vars = { card.ability.extra.mult }
                			},
                		mult_mod = card.ability.extra.mult
                		}
			end
		end
	end
end

function cassetteblock.loc_vars(self, info_queue, card)
	return {key = (card.ability.extra.pink and "Cassette Block" or card.config.center.key), vars = {card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.chips_scale, card.ability.extra.mult_scale, card.ability.extra.pink}}
end

-- region Bumper

local bumper = SMODS.Joker({
	name = "ccc_Bumper",
	key = "bumper",
    config = {extra = {mult = 16, chips = 60}},
	pos = {x = 7, y = 1},
	loc_txt = {
        name = 'Bumper',
        text = {
	"If {C:mult}discards{} {C:attention}>{} {C:chips}hands{}, {C:mult}+#1#{} Mult",
	"If {C:chips}hands{} {C:attention}>{} {C:mult}discards{}, {C:chips}+#2#{} Chips",
	"If both are {C:attention}equal{}, does {C:inactive}nothing{}"
        }
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "9Ts",
		code = "toneblock",
		concept = "Aurora Aquir"
	}
})

bumper.calculate = function(self, card, context)
	
	if context.joker_main then

		if G.GAME.current_round.hands_left > G.GAME.current_round.discards_left then
                	return {
                  	 message = localize {
                  		type = 'variable',
                   		key = 'a_chips',
                  		vars = { card.ability.extra.chips }
                		},
                	chip_mod = card.ability.extra.chips
                	}
		elseif G.GAME.current_round.discards_left > G.GAME.current_round.hands_left then
                	return {
                  	 message = localize {
                  		type = 'variable',
                   		key = 'a_mult',
                  		vars = { card.ability.extra.mult }
                		},
                	mult_mod = card.ability.extra.mult
                	}
		else
			if not context.blueprint then
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Equal", colour = G.C.RED})
			end
		end
	end
end

function bumper.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.mult, card.ability.extra.chips}}
end

-- endregion Bumper

-- region Waterfall

local waterfall = SMODS.Joker({
	name = "ccc_Waterfall",
	key = "waterfall",
    config = {},
	pos = {x = 5, y = 2},
	loc_txt = {
        name = 'Waterfall',
        text = {
	"If played hand contains a",
	"{C:attention}Flush{}, convert a random",
	"card {C:attention}held{} in hand to",
	"the same {C:attention}suit{}"
        }
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "Bred"
	}
})

waterfall.calculate = function(self, card, context)
	if context.before and context.poker_hands ~= nil and next(context.poker_hands['Flush']) then

		local suits = {}
		local used_suits = {}
		for i = 1, #context.scoring_hand do
			if context.scoring_hand[i].ability.name ~= 'Wild Card' then
				if not suits[context.scoring_hand[i].base.suit] then
					suits[context.scoring_hand[i].base.suit] = 1
					used_suits[#used_suits + 1] = context.scoring_hand[i].base.suit
				else
					suits[context.scoring_hand[i].base.suit] = suits[context.scoring_hand[i].base.suit] + 1
				end
			end
		end
		local value = 0
		if #used_suits ~= 0 then
			for i = 1, #used_suits do
				if suits[used_suits[i]] > value then
					ccc_waterfall_flush_suit = used_suits[i]
					value = suits[used_suits[i]]
				end
			end
		else
			ccc_waterfall_flush_suit = 'Wild'
		end

		local waterfall_card_candidates = {}
		if ccc_waterfall_flush_suit ~= 'Wild' then
			for i = 1, #G.hand.cards do
				if not G.hand.cards[i]:is_suit(ccc_waterfall_flush_suit, true) then
					waterfall_card_candidates[#waterfall_card_candidates + 1] = G.hand.cards[i]
				end
			end
		else
			for i = 1, #G.hand.cards do
				if G.hand.cards[i].ability.name ~= 'Wild Card' or G.hand.cards[i].ability.name ~= 'Steel Card' or G.hand.cards[i].ability.name ~= 'Gold Card' then
					waterfall_card_candidates[#waterfall_card_candidates + 1] = G.hand.cards[i]
				end
			end
		end
		if #waterfall_card_candidates > 0 then	-- this used to be bunco code but i changed it
			return {
				message = "Applied",
				G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
					if #waterfall_card_candidates > 0 then
						local waterfall_card = pseudorandom_element(waterfall_card_candidates, pseudoseed('waterfall'))
						if ccc_waterfall_flush_suit ~= 'Wild' then
							waterfall_card:change_suit(ccc_waterfall_flush_suit)
						else
							waterfall_card:set_ability(G.P_CENTERS.m_wild)
						end
						waterfall_card:juice_up()
						play_sound('tarot1', 0.8, 0.4)
					end
				return true end }))
			}
		end
	end
end
				
-- endregion Waterfall

-- region Collapsing Bridge

local collapsingbridge = SMODS.Joker({
	name = "ccc_Collapsing Bridge",
	key = "collapsingbridge",
    config = {extra = {xmult = 5, prob_success = 5}},
	pos = {x = 8, y = 1},
	loc_txt = {
        name = 'Collapsing Bridge',
        text = {
	"{X:mult,C:white} X#2# {} Mult when played hand",
	"contains a {C:attention}Straight{}",
	"All {C:attention}played{} cards have a {C:green}#1# in #3#{}",
	"chance of being {C:red}destroyed{}"
        }
    },
	rarity = 3,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	}
})

collapsingbridge.calculate = function(self, card, context)
	
	if context.joker_main then
		if next(context.poker_hands['Straight']) then
                	return {
			message = localize {
				type = 'variable',
				key = 'a_xmult',
				vars = { card.ability.extra.xmult }
                		},
                	Xmult_mod = card.ability.extra.xmult
                	}
		end
	end

	if context.destroying_card and (context.cardarea == G.play or context.cardarea == "unscored") then
		if pseudorandom('bridge') < G.GAME.probabilities.normal/card.ability.extra.prob_success then
			return {remove = true}
		end
	end
end

function collapsingbridge.loc_vars(self, info_queue, card)
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.xmult, card.ability.extra.prob_success}}
end

-- endregion Collapsing Bridge

-- region Switch Gate

local switchgate = SMODS.Joker({
	name = "ccc_Switch Gate",
	key = "switchgate",
	config = {extra = {chips = 0, chips_scale = 8, cards = {[1] = {rank = 'Ace', suit = 'Spades', id = 14}, [2] = {rank = 'Ace', suit = 'Hearts', id = 14}, [3] = {rank = 'Ace', suit = 'Clubs', id = 14}}}},
	pos = {x = 4, y = 3},
	loc_txt = {
	name = 'Switch Gate',
	text = {
	"Gains {C:chips}+#8#{} Chips if {C:attention}any{} of the",
	"following cards are scored:",
	"{C:attention}#2#{} of {V:1}#3#{}",
	"{C:attention}#4#{} of {V:2}#5#{}",
	"{C:attention}#6#{} of {V:3}#7#{}",
	"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips){}",
	"{s:0.8}Cards change every round"
	}
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	}
})

switchgate.set_ability = function(self, card, initial, delay_sprites)	-- shamelessly copied from idol
	local valid_gate_cards = {}
	if G.playing_cards ~= nil then
		for k, v in ipairs(G.playing_cards) do
			if v.ability.effect ~= 'Stone Card' then
				valid_gate_cards[#valid_gate_cards+1] = v
			end
		end
		if valid_gate_cards[1] then
			for i = 1, 3 do
				local gate_card = pseudorandom_element(valid_gate_cards, pseudoseed('switchgate'..G.GAME.round_resets.ante))
				card.ability.extra.cards[i].rank = gate_card.base.value
				card.ability.extra.cards[i].suit = gate_card.base.suit
				card.ability.extra.cards[i].id = gate_card.base.id
			end
		end
	end
end

-- this may work. but it may also break. i hope it doesn't but i won't be surprised if it does

switchgate.calculate = function(self, card, context)

	if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
		local valid_gate_cards = {}
		for k, v in ipairs(G.playing_cards) do
			if v.ability.effect ~= 'Stone Card' then
				valid_gate_cards[#valid_gate_cards+1] = v
			end
		end
		if valid_gate_cards[1] then
			for i = 1, 3 do
				local gate_card = pseudorandom_element(valid_gate_cards, pseudoseed('switchgate'..G.GAME.round_resets.ante))
				card.ability.extra.cards[i].rank = gate_card.base.value
				card.ability.extra.cards[i].suit = gate_card.base.suit
				card.ability.extra.cards[i].id = gate_card.base.id
			end
		end
	end

	if context.individual and not context.blueprint then
		if context.cardarea == G.play then
			local count = 0
			for i = 1, 3 do
				if context.other_card:get_id() == card.ability.extra.cards[i].id and context.other_card:is_suit(card.ability.extra.cards[i].suit) then
					count = count + 1
				end
			end
			if count > 0 then
				card.ability.extra.chips = card.ability.extra.chips + (card.ability.extra.chips_scale*count)
				return {
					extra = {focus = card, message = localize('k_upgrade_ex')},
					colour = G.C.CHIPS,	-- why doesn't this work???????? it's fine but it should really be chip coloured
					card = card
				}
			end
		end
	end

	if context.joker_main then
		if card.ability.extra.chips ~= 0 then
                	return {
                    	message = localize {
                        	type = 'variable',
                        	key = 'a_chips',
                        	vars = { card.ability.extra.chips }
                    	},
			chip_mod = card.ability.extra.chips
                	}
		end
	end
end

function switchgate.loc_vars(self, info_queue, card)	-- what a mess
	return {vars = {
		card.ability.extra.chips,
		localize(card.ability.extra.cards[1].rank, 'ranks'), 
		localize(card.ability.extra.cards[1].suit, 'suits_plural'), 
		localize(card.ability.extra.cards[2].rank, 'ranks'), 
		localize(card.ability.extra.cards[2].suit, 'suits_plural'), 
		localize(card.ability.extra.cards[3].rank, 'ranks'), 
		localize(card.ability.extra.cards[3].suit, 'suits_plural'),
		card.ability.extra.chips_scale,
		colours = {
			G.C.SUITS[card.ability.extra.cards[1].suit], 
			G.C.SUITS[card.ability.extra.cards[2].suit], 
			G.C.SUITS[card.ability.extra.cards[3].suit]
		}
	}
}
end

-- endregion Switch Gate	

-- region Checkpoint

local checkpoint = SMODS.Joker({
	name = "ccc_Checkpoint",
	key = "checkpoint",
    config = {extra = {xmult = 1, xmult_scale = 0.75, did_you_discard = false, after_boss = false}},
	pos = {x = 8, y = 2},
	loc_txt = {
        name = 'Checkpoint',
        text = {
	"Gains {X:mult,C:white} X#2#{} Mult if",
	"{C:attention}Boss Blind{} is defeated",
	"without {C:red}discarding{}",
	"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)"
        }
    },
	rarity = 3,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	}
})


checkpoint.calculate = function(self, card, context)

	if context.setting_blind and not context.blueprint then
		card.ability.extra.did_you_discard = false
		if context.blind.boss or G.GAME.selected_back.effect.config.everything_is_boss then
			card.ability.extra.after_boss = true
		else
			card.ability.extra.after_boss = false
		end
	end

	if context.discard and not context.blueprint then
		if card.ability.extra.after_boss == true and card.ability.extra.did_you_discard == false then
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Discarded", colour = G.C.RED})
			card.ability.extra.did_you_discard = true
		end
	end
	
	if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
		if card.ability.extra.after_boss == true and card.ability.extra.did_you_discard == false then
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_scale
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}}})
		end
	end
		
	if context.joker_main then
            	if card.ability.extra.xmult ~= 1 then
                	return {
                    	message = localize {
                        	type = 'variable',
                        	key = 'a_xmult',
                        	vars = { card.ability.extra.xmult }
                    	},
			Xmult_mod = card.ability.extra.xmult
                	}
		end
	end
end

function checkpoint.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_scale}}
end

-- endregion Checkpoint

-- region Theo Crystal

local theocrystal = SMODS.Joker({
	name = "ccc_Theo Crystal",
	key = "theocrystal",
	config = {extra = {base_probs = 0, base_scale = 1, scale = 1, probs = 0}},
	pixel_size = { w = 71, h = 71 },
	pos = {x = 9, y = 2},
	loc_txt = {
	name = 'Theo Crystal',
	text = {
	"Forces 1 card to",
	"{C:attention}always{} be selected",
	"Adds {C:green}+#1#{} to all {C:attention}listed{}",
	"{C:green,E:1}probabilities{} at round end",
	"{C:inactive}(ex: {C:green}2 in 7{C:inactive} -> {C:green}3 in 7{C:inactive})",
	"{C:inactive}(Currently {C:green}+#2#{C:inactive})"
	}
    },
	rarity = 3,
	cost = 9,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	add_to_deck = function (self, card, from_debuff)
		local oops_factor = 1
		if G.jokers ~= nil then	-- this is always true?
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i].ability.set == 'Joker' then
					if G.jokers.cards[i].ability.name == 'Oops! All 6s' then
						oops_factor = oops_factor*2
					end
				end
			end
			for k, v in pairs(G.GAME.probabilities) do 
				G.GAME.probabilities[k] = v + (card.ability.extra.base_probs*oops_factor)
			end
		end
	end,
	remove_from_deck = function (self, card, from_debuff)
		local oops_factor = 1
		if G.jokers ~= nil then
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i].ability.set == 'Joker' then
					if G.jokers.cards[i].ability.name == 'Oops! All 6s' then
						oops_factor = oops_factor*2
					end
				end
			end
		end
		for k, v in ipairs(G.hand.cards) do
			if v.ability.forced_selection then
				v.ability.forced_selection = false
			end
		end
		for k, v in pairs(G.GAME.probabilities) do 
			G.GAME.probabilities[k] = v - (card.ability.extra.base_probs*oops_factor)
		end
	end,
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "toneblock"
	}
})

-- lovely injections to deal with the probability system (what a pain)

-- scale and probs are only for display purposes and are not actually used

-- also using lovely to hijack Blind:drawn_to_hand? this is so scuffed

theocrystal.calculate = function(self, card, context)

	if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
		card.ability.extra.base_probs = card.ability.extra.base_probs + card.ability.extra.base_scale
		local oops_factor = 1
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].ability.set == 'Joker' then
				if G.jokers.cards[i].ability.name == 'Oops! All 6s' then
					oops_factor = oops_factor*2
				end
			end
		end
		for k, v in pairs(G.GAME.probabilities) do 
			G.GAME.probabilities[k] = v + card.ability.extra.base_scale*oops_factor		-- this is fragile but should work in normal circumstances
		end
		card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+"..(oops_factor), colour = G.C.GREEN})
	end
end

function theocrystal.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.scale, card.ability.extra.probs}}
end

-- endregion Theo Crystal	

-- region Lapidary

local lapidary = SMODS.Joker({
	name = "ccc_Lapidary",
	key = "lapidary",
    config = {extra = 1.5},
	pos = {x = 6, y = 3},
	loc_txt = {
        name = 'Lapidary',
        text = {
	"Jokers with a",
	"{C:attention}unique{} rarity each",
	"give {X:mult,C:white}X#1#{} Mult",
        }
    },
	rarity = 2,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	}
})

lapidary.calculate = function(self, card, context)
	if context.other_joker and not context.other_consumable then	-- ?????
		local uniqueRarity = true 
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i] ~= context.other_joker and G.jokers.cards[i].config.center.rarity == context.other_joker.config.center.rarity then
				uniqueRarity = false
				break
			end
		end

		if uniqueRarity then
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			})) 
			return {
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra}},
				Xmult_mod = card.ability.extra
			}
		end
	end
end

function lapidary.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra}}
end

-- endregion lapidary

-- region hardlist

local hardlist = SMODS.Joker({
	name = "ccc_hardlist",
	key = "hardlist",
    config = {extra = {mult = 20, sub = 4}}, -- mult should be a multiple of sub for this card
	pos = {x = 5, y = 3},
	loc_txt = {
        name = '5-Star Hardlist',
        text = {
			"{C:mult}+#1#{} Mult",
			"{C:mult}-#2#{} Mult on purchase of a",
			"{C:attention}Joker{} or {C:attention}Buffoon Pack{}",
        }
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Aurora Aquir",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	}
})



hardlist.calculate = function(self, card, context)
	if (context.buying_card and context.card.config.center.set == "Joker" and not (context.card == card)) or (context.ccc_paid_booster and context.card.ability.name:find('Buffoon')) then		-- raaaah thunk giving us too little info
		if not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.sub
			if card.ability.extra.mult <= 0 then
				G.E_MANAGER:add_event(Event({
				func = function()
					card_eval_status_text(card, 'extra', nil, nil, nil, {
						message = "Standard!",
						colour = G.C.RED
					});
					G.E_MANAGER:add_event(Event({trigger = 'after',
						func = function()
							play_sound('tarot1')
							card.T.r = -0.2
							card:juice_up(0.3, 0.4)
							card.states.drag.is = true
							card.children.center.pinch.x = true
							G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
								func = function()
										G.jokers:remove_card(card)
										card:remove()
										card = nil
									return true; end})) 
							return true
						end
					})) 
					return true
				end}))
			else
				G.E_MANAGER:add_event(Event({
					func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {
						message = string.format("%d-Star!", card.ability.extra.mult/card.ability.extra.sub),
						colour = G.C.RED
					}); return true
					end}))
			end
		end
	elseif context.joker_main then
		return {
			message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
			mult_mod = card.ability.extra.mult
		}
	end
end


function hardlist.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.mult, card.ability.extra.sub}}
end
-- endregion hardlist

-- region cloud

local cloud = SMODS.Joker({
	name = "ccc_cloud",
	key = "cloud",
    config = {extra = {chips = 0, add = 30}},
	pos = {x = 4, y = 4},
	loc_txt = {
        name = 'Cloud',
        text = {
			"Gains {C:chips}+#1#{} Chips",
			"{C:attention}after{} each hand",
			"played this round",
			"{C:inactive}(Currently {C:blue}+#2#{C:inactive} Chips)"
        }
    },
	rarity = 1,
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	}
})



cloud.calculate = function(self, card, context)

	if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
		card.ability.extra.chips = 0
	elseif context.cardarea == G.jokers and context.after and not context.blueprint then
		card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.add
	elseif context.joker_main and card.ability.extra.chips > 0 then
		return {
			message = localize {
				type = 'variable',
				key = 'a_chips',
				vars = { card.ability.extra.chips }
			},
			chip_mod = card.ability.extra.chips
		}
	end
end


function cloud.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.add, card.ability.extra.chips}}
end
-- endregion cloud

-- region brittle cloud

local brittlecloud = SMODS.Joker({
	name = "ccc_brittlecloud",
	key = "brittlecloud",
    config = {extra = {chips = 125}},
	pos = {x = 5, y = 4},
	loc_txt = {
        name = 'Brittle Cloud',
        text = {
			"{C:chips}+#1#{} Chips in",
			"{C:attention}first{} hand of round",
        }
    },
	rarity = 1,
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	}
})


brittlecloud.calculate = function(self, card, context)

	if context.joker_main and G.GAME.current_round.hands_played == 0 then
		return {
			message = localize {
				type = 'variable',
				key = 'a_chips',
				vars = { card.ability.extra.chips }
			},
			chip_mod = card.ability.extra.chips
		}
	end
end


function brittlecloud.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.chips}}
end
-- endregion brittle cloud

-- region seeker
--cursed idea

local seeker = SMODS.Joker({
	name = "ccc_Seeker",
	key = "seeker",
    config = {extra = {suit = "Hearts", rank = "Ace"}},
	pos = {x = 6, y = 4},
	loc_txt = {
        name = 'Seeker',
        text = {
			"If card is drawn {C:attention}face up{} and",
			"is not most owned {C:attention}rank{} ({C:attention}#1#{})",
			"or {C:attention}suit{} ({V:1}#2#{}), reshuffle",
			"it into {C:attention}deck{} and {C:attention}draw another"
        }
    },
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
	load = function (self, card, card_table, other_card)
		G.GAME.pool_flags.seeker_table = {
			rank = card_table.ability.extra.rank,
			suit = card_table.ability.extra.suit,
		}
		for i, card in ipairs(G.play.cards) do
			draw_card(G.play, G.deck, i*100/math.min(#G.deck.cards, G.hand.config.card_limit - #G.hand.cards),'up', true)
		end
	end,
	remove_from_deck = function (self, card, from_debuff)
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
})

seeker.get_common_suit_and_ranks = function (card)
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
	local most_common_rank= {
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
	seeker.get_common_suit_and_ranks(card)		-- could possibly just put this function into Card:update instead of calling it frequently? similar to secret shrine

	if context.ccc_drawfromdeck and not context.blueprint and not GLOBAL_seeker_proc == true then		-- custom context created in lovely

		GLOBAL_seeker_proc = true
		
		local card_pos = {}
		local card_redraw_candidates = {}
		G.deck:shuffle('see'..G.GAME.round_resets.ante)			-- shuffle is early, otherwise card drawing gets messed up
		hand_size = context.ccc_amount
		for i = 1, hand_size do
			local future_card = G.deck.cards[(#G.deck.cards - (i - 1))]		-- end of G.deck.cards currently has the cards that are about to be drawn
			local ranks = {"", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"}
			local future_card_rank = ranks[future_card:get_id()] or "0"
			local stay_flipped = G.GAME and G.GAME.blind and G.GAME.blind:stay_flipped(G.hand, G.deck.cards[(#G.deck.cards - (i - 1))])
			if ((not (future_card_rank == G.GAME.pool_flags.seeker_table.rank or future_card:is_suit(G.GAME.pool_flags.seeker_table.suit, true))) 
			or (future_card.ability.name == 'Stone Card')) and (not stay_flipped == true) then
				card_redraw_candidates[#card_redraw_candidates + 1] = future_card
				card_pos[#card_pos + 1] = i
			end
		end
		if #card_redraw_candidates > 0 then
			G.E_MANAGER:add_event(Event({
			trigger = "after",
			func = function () 
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Redraw", colour = G.C.FILTER})
				local hand_count = #card_redraw_candidates
				for i=1, hand_count do
					draw_card(G.hand, G.deck, i*100/hand_count,'down', nil, card_redraw_candidates[i],  0.08)
				end
				G.FUNCS.draw_from_deck_to_hand(hand_count)
				return true 
			end}))
		end
		G.E_MANAGER:add_event(Event({
		trigger = "after",
		func = function ()
			GLOBAL_seeker_proc = false
			return true 
		end}))
	end
end

function seeker.loc_vars(self, info_queue, card)
	return {vars = {
		localize(card.ability.extra.rank, 'ranks'), 
		localize(card.ability.extra.suit, 'suits_plural'),
		colours = {
			G.C.SUITS[card.ability.extra.suit], }}}
end

-- endregion seeker

-- region Pointless Machines

local pointlessmachines = SMODS.Joker({
	name = "ccc_Pointless Machines",
	key = "pointlessmachines",
    config = {extra = {chosen = 'Spades', incorrect = false, reset = false, count = 0, req = 3, suits = {[1] = 'Hearts', [2] = 'Spades', [3] = 'Diamonds', [4] = 'Clubs', [5] = 'Hearts'}}},
	pos = {x = 9, y = 1},
	loc_txt = {
        name = 'Pointless Machines',
        text = {
	"Bad signal?"
        }
    },
	rarity = 2,
	cost = 4,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "goose!",
		code = "toneblock",
		concept = "Fytos"
	}
})

pointlessmachines.set_ability = function(self, card, initial, delay_sprites)
	card.ability.extra.chosen = pseudorandom_element({'Hearts', 'Spades', 'Diamonds', 'Clubs'}, pseudoseed('initialize'))
        for i = 1, 5 do
		card.ability.extra.suits[i] = pseudorandom_element({'Hearts', 'Spades', 'Diamonds', 'Clubs', card.ability.extra.chosen}, pseudoseed('initialize2'))
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
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Correct", colour = G.C.GREEN})
			if card.ability.extra.count >= card.ability.extra.req then
				G.E_MANAGER:add_event(Event({
					trigger = 'after',delay = 0.75,func = function()
						G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.75,func = function() 
							card:flip();play_sound('card1', 1, 0.6);card:juice_up(0.3, 0.3)
						return true end }))
						G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.75,
							func = function()
								local centers = {'j_ccc_crystalheart', 'j_ccc_mechanicalheart', 'j_ccc_quietheart', 'j_ccc_heavyheart'}
								local suits = {'Hearts', 'Clubs', 'Spades', 'Diamonds'}
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
						G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.75,func = function() 
							card:flip();play_sound('tarot2', 1, 0.6);card:juice_up(0.3, 0.3)
						return true end }))
						G.E_MANAGER:add_event(Event({
							trigger = 'after',delay = 1.25,func = function() 
								local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_grim', 'thisispointless')
								card:set_edition({negative = true}, true)
								card:add_to_deck()
								G.consumeables:emplace(card)
							return true end
						}))
						card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
					return true end
				}))
			else
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = card.ability.extra.count.."/"..card.ability.extra.req, colour = G.C.FILTER})
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
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Incorrect", colour = G.C.RED})
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
			card.ability.extra.suits[i] = pseudorandom_element({'Hearts', 'Spades', 'Diamonds', 'Clubs', card.ability.extra.chosen}, pseudoseed('reinitialize'))
		end
		card.ability.extra.reset = false
	end
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
					cards[i] = true		-- idk why this is done but sure
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
									_cards[i]:set_seal("Red", true, true)
								end
								if _suit == 'Spades' then
									_cards[i].ability.perma_bonus = _cards[i].ability.perma_bonus or 0
									_cards[i].ability.perma_bonus = _cards[i].ability.perma_bonus + 75
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

SMODS.Rarity{
    key = "secret",
    loc_txt = {name = 'Secret'},
    badge_colour = HEX('ffc0ff'),
}

-- endregion Pointless Machines

-- region Crystal Heart

local crystalheart = SMODS.Joker({
	name = "ccc_Crystal Heart",
	key = "crystalheart",
    config = {},
	pos = {x = 7, y = 4},
	loc_txt = {
        name = 'Crystal Heart',
        text = {
			"If played hand is a",
			"single {C:attention}Ace{} of {C:hearts}Hearts{},",
			"apply a random {C:dark_edition}Edition{}",
			"to a card held in hand",
			"{C:inactive,s:0.87}(Unaffected by retriggers){}"
        }
    },
	rarity = 'ccc_secret',
	cost = 15,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	}
})

crystalheart.calculate = function(self, card, context)

	if context.before and #context.full_hand == 1 and context.full_hand[1]:get_id() == 14 and context.full_hand[1]:is_suit('Hearts', true) then
		local edition_card_candidates = {}
		for i = 1, #G.hand.cards do
			if not G.hand.cards[i].edition then
				edition_card_candidates[#edition_card_candidates + 1] = G.hand.cards[i]
			end
		end
		if #edition_card_candidates > (G.GAME.ccc_edition_buffer and G.GAME.ccc_edition_buffer or 0) then
			G.GAME.ccc_edition_buffer = (G.GAME.ccc_edition_buffer and G.GAME.ccc_edition_buffer or 0) + 1 
			return {
				G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
					local edition_card_candidates_2 = {}
					for i = 1, #G.hand.cards do
						if not G.hand.cards[i].edition then
							edition_card_candidates_2[#edition_card_candidates_2 + 1] = G.hand.cards[i]
						end
					end
					if #edition_card_candidates_2 > 0 then
						local edition_card = pseudorandom_element(edition_card_candidates_2, pseudoseed('crystal_heart'))
						local edition = poll_edition('crystal_heart', nil, true, true)
						edition_card:set_edition(edition, true)
						card:juice_up()
					end
					G.GAME.ccc_edition_buffer = G.GAME.ccc_edition_buffer - 1 
				return true end })),
				message = "Applied",
				colour = G.C.DARK_EDITION
			}
		end
	end
end

crystalheart.yes_pool_flag = 'secretheart'

-- endregion Crystal Heart

-- region Mechanical Heart

local mechanicalheart = SMODS.Joker({
	name = "ccc_Mechanical Heart",
	key = "mechanicalheart",
    config = {},
	pos = {x = 9, y = 4},
	loc_txt = {
        name = 'Mechanical Heart',
        text = {
			"If played hand is a",
			"single {C:attention}Ace{} of {C:clubs}Clubs{},",
			"turn {C:attention}all{} {C:clubs}Clubs{} held in",
			"hand into {C:attention}Steel Cards{}",
			"{C:inactive,s:0.87}(Unaffected by retriggers){}"
        }
    },
	rarity = 'ccc_secret',
	cost = 15,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "Fytos"
	}
})

mechanicalheart.calculate = function(self, card, context)

	if context.before and #context.full_hand == 1 and context.full_hand[1]:get_id() == 14 and context.full_hand[1]:is_suit('Clubs', true) then
		local steels = 0
		for i = 1, #G.hand.cards do
			if G.hand.cards[i]:is_suit('Clubs', true) then
				G.hand.cards[i]:set_ability(G.P_CENTERS.m_steel, nil, true)
				G.hand.cards[i]:juice_up()
				steels = steels + 1
			end
		end
		if steels > 0 then
			return {
				message = "Steel",
				colour = lighten(G.C.BLACK, 0.5)
			}
		end
	end
end

mechanicalheart.yes_pool_flag = 'secretheart'

-- endregion Mechanical Heart

-- region Quiet Heart

local quietheart = SMODS.Joker({
	name = "ccc_Quiet Heart",
	key = "quietheart",
    config = {extra = {add = 15}},
	pos = {x = 9, y = 4},
	loc_txt = {
        name = 'Quiet Heart',
        text = {
			"If played hand is a",
			"single {C:attention}Ace{} of {C:spades}Spades{},",
			"give permanent {C:chips}+#1#{} Chips",
			"to {C:attention}all{} cards held in hand",
			"{C:inactive,s:0.87}(Unaffected by retriggers){}"
        }
    },
	rarity = 'ccc_secret',
	cost = 15,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "Fytos"
	}
})

quietheart.calculate = function(self, card, context)

	if context.before and #context.full_hand == 1 and context.full_hand[1]:get_id() == 14 and context.full_hand[1]:is_suit('Spades', true) then
		for i = 1, #G.hand.cards do
	         	G.hand.cards[i].perma_bonus = G.hand.cards[i].ability.perma_bonus or 0
                        G.hand.cards[i].ability.perma_bonus = G.hand.cards[i].ability.perma_bonus + card.ability.extra.add
		end
		if #G.hand.cards > 0 then
			return {
				message = "Upgraded",
				colour = G.C.CHIPS
			}
		end
	end
end

quietheart.yes_pool_flag = 'secretheart'

function quietheart.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.add}}
end

-- endregion Quiet Heart

-- region Heavy Heart

local heavyheart = SMODS.Joker({
	name = "ccc_Heavy Heart",
	key = "heavyheart",
    config = {extra = {money = 2}},
	pos = {x = 9, y = 4},
	loc_txt = {
        name = 'Heavy Heart',
        text = {
			"If played hand is a",
			"single {C:attention}Ace{} of {C:diamonds}Diamonds{},",
			"gives {C:money}$#1#{} {C:attention}multiplied{} by the",
			"{C:attention}amount{} of cards held in hand",
			"{C:inactive,s:0.87}(Unaffected by retriggers){}"
        }
    },
	rarity = 'ccc_secret',
	cost = 15,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "Fytos"
	}
})

heavyheart.calculate = function(self, card, context)

	if context.before and #context.full_hand == 1 and context.full_hand[1]:get_id() == 14 and context.full_hand[1]:is_suit('Diamonds', true) then
		local money = 0
		for i = 1, #G.hand.cards do
	         	money = money + card.ability.extra.money
		end
		if #G.hand.cards > 0 then
			return {
				dollars = money,
				colour = G.C.MONEY
			}
		end
	end
end

heavyheart.yes_pool_flag = 'secretheart'

function heavyheart.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.money}}
end

-- endregion Heavy Heart

-- region Event Horizon

local eventhorizon = SMODS.Joker({
	name = "ccc_Event Horizon",
	key = "eventhorizon",
    config = {extra = {uses = 0}},
	pos = {x = 8, y = 4},
	loc_txt = {
        name = 'Event Horizon',
        text = {
			"Every {C:attention}5th{} {C:planet}Planet{} card",
			"used acts as a",
			"{C:legendary,E:1,S:1.1}Black Hole{}",
			"{C:inactive}(Currently {C:attention}#1#{C:inactive}/{C:attention}5{C:inactive})"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "sunsetquasar + toneblock",
		code = "toneblock",
		concept = "Fytos"
	}
})

eventhorizon.calculate = function(self, card, context)

	if context.using_consumeable then
		if context.consumeable.ability.set == 'Planet' and not context.blueprint then

			if card.ability.extra.uses < 3 then
				return {
					G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
						card.ability.extra.uses = card.ability.extra.uses + 1
						card_eval_status_text(card, 'extra', nil, nil, nil, {message = card.ability.extra.uses.."/5", colour = G.C.FILTER})
					return true end })),
				}
			end
			if card.ability.extra.uses == 3 then
				return {
					G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
						card.ability.extra.uses = card.ability.extra.uses + 1
						card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_active_ex'), colour = G.C.FILTER})
						ccc_GLOBAL_eventhorizon_override = (0 or ccc_GLOBAL_eventhorizon_override) + 1
					return true end })),
				}
			end
			if card.ability.extra.uses == 4 then
				card:juice_up()
				card.ability.extra.uses = 0
				return {
					G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
						if card.ability.extra.uses == 0 then
							ccc_GLOBAL_eventhorizon_override = ccc_GLOBAL_eventhorizon_override - 1													end
						card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_reset'), colour = G.C.FILTER})
					return true end })),
				}
			end
		end
	end
end

function eventhorizon.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.c_black_hole
	return {vars = {card.ability.extra.uses}}
end

-- endregion Event Horizon

-- region Intro Car

local introcar = SMODS.Joker({
	name = "ccc_Intro Car",
	key = "introcar",
    config = {extra = {add = 5}},
	pos = {x = 7, y = 3},
	loc_txt = {
        name = 'Intro Car',
        text = {
			"Before each {C:attention}5{} or {C:attention}8{} is",
			"scored, {C:attention}swap{} current",
			"{C:chips}Chips{} and {C:mult}Mult{}"
        }
    },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Bred + Fytos"
	}
})

introcar.calculate = function(self, card, context)
	if context.individual then
		if context.cardarea == G.play then
			if context.other_card:get_id() == 5 or context.other_card:get_id() == 8 then	-- this is all faked with delays and stuff because it simply does not work with event manager
				delay(0.2)
				local temp_chips = hand_chips
				local temp_mult = mult
				hand_chips = mod_chips(temp_mult)
				mult = mod_mult(temp_chips)
				update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Swap", colour = G.C.FILTER})
				delay(0.2)
			end
		end
	end
end

function introcar.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.add}}
end

-- endregion Intro Car

-- region Secret Shrine

local secretshrine = SMODS.Joker({
	name = "ccc_Secret Shrine",
	key = "secretshrine",
    config = {extra = {seven_tally = 4, factor = 3}},
	pos = {x = 6, y = 5},
	loc_txt = {
        name = 'Secret Shrine',
        text = {
			"Gives {C:mult}+#2#{} Mult for",
			"each {C:attention}7{} in {C:attention}full deck{}",
			"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult){}"
        }
    },
	rarity = 1,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "9Ts",
		code = "toneblock",
		concept = "Aurora Aquir"
	}
})

-- lovely used to update seven_tally

secretshrine.calculate = function(self, card, context)
	if context.joker_main then
		if card.ability.extra.seven_tally ~= 0 then
                	return {
                   	message = localize {
                  		type = 'variable',
                   		key = 'a_mult',
                  		vars = { card.ability.extra.factor*card.ability.extra.seven_tally }
                		},
                	mult_mod = card.ability.extra.factor*card.ability.extra.seven_tally
                	}
		end
	end
end

function secretshrine.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.factor*card.ability.extra.seven_tally, card.ability.extra.factor}}
end

-- endregion Secret Shrine

-- region Kevin

local kevin = SMODS.Joker({
	name = "ccc_Kevin",
	key = "kevin",
    config = {},
	pos = {x = 8, y = 3},
	loc_txt = {
        name = 'Kevin',
        text = {
			"Scoring {C:attention}face cards{} act",
			"as a copy of the",
			"{C:attention}rightmost{} played card",
        }
    },
	rarity = 3,
	cost = 8,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	}
})

local evalcard_ref = eval_card
function eval_card(card, context)
	local ccard = card
	if context.cardarea == G.play and card:is_face() and #SMODS.find_card('j_ccc_kevin') >= 1 then
		ccard = G.play.cards[#G.play.cards]
	end
	return evalcard_ref(ccard, context)
end

-- endregion Kevin

-- region Strawberry Pie

local strawberrypie = SMODS.Joker({
	name = "ccc_Strawberry Pie",
	key = "strawberrypie",
    config = {extra = {mult = 45, chips = 120, xmult = 5}},
	pos = {x = 8, y = 5},
	loc_txt = {
        name = 'Strawberry Pie',
        text = {
			"Grants a large bonus",
			"based on current {C:money}money{}:",	-- scuffed text centering
			"  {C:white}ii{}{C:money}$30{}-{C:money}$79{}: {C:chips}+#1#{} Chips",
			"{C:money}$80{}-{C:money}$174{}: {C:mult}+#2#{} Mult",
			"   {C:money}$175+{}: {X:mult,C:white} X#3# {} Mult{C:white}i{}",
        }
    },
	rarity = 3,
	cost = 13,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Kol_Oss"
	}
})

strawberrypie.calculate = function(self, card, context)

	if context.joker_main then
		local dollars = math.max( 0, ( to_big(G.GAME.dollars) + (to_big(G.GAME.dollar_buffer) or 0)) )	-- idk what to wrap in to_big
		if to_big(dollars) >= to_big(30) and to_big(dollars) < to_big(80) then
			return {
			message = localize {
				type = 'variable',
				key = 'a_chips',
				vars = { card.ability.extra.chips }
				},
			chip_mod = card.ability.extra.chips
                	}
		elseif to_big(dollars) >= to_big(80) and to_big(dollars) < to_big(175) then
                	return {
			message = localize {
				type = 'variable',
				key = 'a_mult',
				vars = { card.ability.extra.mult }
				},
			mult_mod = card.ability.extra.mult
                	}
		elseif to_big(dollars) >= to_big(175) then
			return {
			message = localize {
				type = 'variable',
				key = 'a_xmult',
				vars = { card.ability.extra.xmult }
				},
			Xmult_mod = card.ability.extra.xmult
                	}
		end

	end
end

function strawberrypie.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.xmult}}
end

-- endregion Strawberry Pie

-- region 1UP

local oneup = SMODS.Joker({
	name = "ccc_1UP",
	key = "1up",
    config = {extra = {money = 2, money_mod = 4, money_minus = 1}},
	pos = {x = 9, y = 3},
	loc_txt = {
        name = '1UP',
        text = {
			"Earn {C:money}$#1#{} at end of round,",
			"This Joker increases by {C:money}$#2#{} when",
			"any {C:attention}Strawberry{} is sold, then",
			"reduces its increase by {C:money}$#3#{}",
			"{C:inactive}(Minimum of {C:money}$1{C:inactive})",
        }
    },
	rarity = 2,
	cost = 5,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Kol_Oss"
	}
})

local strawberries = {
	"j_ccc_strawberry", 
	"j_ccc_wingedstrawberry", 
	"j_ccc_goldenstrawberry", 
	"j_ccc_wingedgoldenstrawberry", 
	"j_ccc_moonberry", 
	"j_ccc_strawberrypie",
	"j_ccc_thecrowd",
}

oneup.calculate = function(self, card, context)

	if (context.selling_card and context.card.config.center.set == "Joker" and not (context.card == card)) then
		for i = 1, #strawberries do
			if context.card.config.center.key == strawberries[i] then
				card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_mod
				card.ability.extra.money_mod = math.max(1, card.ability.extra.money_mod - card.ability.extra.money_minus)
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.FILTER})
				break
			end
		end
	end

end

function oneup.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.money, card.ability.extra.money_mod, card.ability.extra.money_minus}}
end

-- endregion 1UP

-- region The Crowd

local thecrowd = SMODS.Joker({
	name = "ccc_The Crowd",
	key = "thecrowd",
	config = {extra = {xmult = 1.1, money = 1}},
	pos = {x = 7, y = 5},
	loc_txt = {
        name = 'The Crowd',
        text = {
			"If played hand contains a",
			"{C:attention}Five of a Kind{}, {C:attention}scoring{} cards",
			"give {C:money}$#2#{}. Afterwards, create the",
			"played poker hand's {C:planet}Planet{} card",
			"{C:inactive}(Must have room){}",
        }
    },
	rarity = 3,
	cost = 12,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Kol_Oss"
	}
})

thecrowd.calculate = function(self, card, context)

	if context.joker_main then
		
		if (next(context.poker_hands['Five of a Kind'])) then
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = function()
						G.E_MANAGER:add_event(Event({
							func = function() 
								local _planet = 0
								for k, v in pairs(G.P_CENTER_POOLS.Planet) do
									if v.config.hand_type == context.scoring_name then
										_planet = v.key
									end
								end
                    						local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, _planet, 'blusl')
								G.GAME.consumeable_buffer = 0
                    						card:add_to_deck()
								G.consumeables:emplace(card)
               							return true
							end
						}))   
						card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
						return true
					end
				}))
			end
			-- the consumable addition happens quite late but you know... it's fine, it feels good enough
			-- unsure how to fix that
			--[[
			return {
				message = localize {
					type = 'variable',
					key = 'a_xmult',
					vars = { card.ability.extra.xmult }
				},
				Xmult_mod = card.ability.extra.xmult
                	}, true
			]]
		end
		
	end
	if context.individual and not context.blueprint then
		if context.cardarea == G.play then
			if (next(context.poker_hands['Five of a Kind'])) then
				return {
					dollars = card.ability.extra.money,
					-- xmult = card.ability.extra.xmult,
					card = card
				}
			end
		end
	end

end

function thecrowd.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.xmult, card.ability.extra.money}}
end

function thecrowd.in_pool(self)
	if G.GAME.hands["Flush Five"].played > 0 or G.GAME.hands["Five of a Kind"].played > 0 then
		return true
	end
	return false
end

-- endregion The Crowd

-- region Jump

local jump = SMODS.Joker({
	name = "ccc_Jump",
	key = "jump",
    config = {extra = {chips = 40}},
	pixel_size = { w = 71, h = 81 },
	pos = {x = 9, y = 7},
	loc_txt = {
        name = 'Jump',
        text = {
			"{C:chips}+#1#{} Chips",
        }
    },
	rarity = 1,
	cost = 2,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Fytos"
	}
})

jump.calculate = function(self, card, context)

	if context.joker_main then
		return {
			message = localize {
				type = 'variable',
				key = 'a_chips',
				vars = { card.ability.extra.chips }
			},
			chip_mod = card.ability.extra.chips
		}
	end

end

function jump.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.chips}}
end

-- endregion Jump

-- region Grab

local grab = SMODS.Joker({
	name = "ccc_Grab",
	key = "grab",
    config = {extra = {mult = 6}},
	pixel_size = { w = 71, h = 81 },
	pos = {x = 8, y = 7},
	loc_txt = {
        name = 'Grab',
        text = {
			"{C:mult}+#1#{} Mult if there is",
			"a {C:attention}Joker{} to the right",
        }
    },
	rarity = 1,
	cost = 2,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Fytos"
	}
})

grab.calculate = function(self, card, context)

	if context.joker_main and G.jokers.cards[#G.jokers.cards] ~= card then
		return {
			message = localize {
				type = 'variable',
				key = 'a_mult',
				vars = { card.ability.extra.mult }
			},
			mult_mod = card.ability.extra.mult
		}
	end

end

function grab.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.mult}}
end

-- endregion Grab

-- region Dash

local dash = SMODS.Joker({
	name = "ccc_Dash",
	key = "dash",
    config = {extra = {mult = 1.5}},
	pixel_size = { w = 71, h = 81 },
	pos = {x = 7, y = 7},
	loc_txt = {
        name = 'Dash',
        text = {
			"{X:mult,C:white} X#1#{} Mult",
        }
    },
	rarity = 1,
	cost = 2,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Fytos"
	}
})

dash.calculate = function(self, card, context)

	if context.joker_main then
		return {
			message = localize {
				type = 'variable',
				key = 'a_xmult',
				vars = { card.ability.extra.mult }
			},
			Xmult_mod = card.ability.extra.mult
		}
	end

end

function dash.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.mult}}
end

-- endregion Dash

-- region Bunny Hop

local bunnyhop = SMODS.Joker({
	name = "ccc_Bunny Hop",
	key = "bunnyhop",
    config = {extra = {chips = 1}},
	pixel_size = { w = 71, h = 81 },
	pos = {x = 9, y = 6},
	loc_txt = {
        name = 'Bunny Hop',
        text = {
			"Permanently give {C:chips}+#1#{} Chip",
			"to {C:attention}all{} cards held in hand",
			"on discarding a {C:attention}card{}",
        }
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Aurora Aquir"
	}
})

bunnyhop.calculate = function(self, card, context)
	if context.discard then
		for i = 1, #G.hand.cards do
			local discarded = false
			for j = 1, #G.hand.highlighted do
				if G.hand.cards[i] == G.hand.highlighted[j] then discarded = true break end
			end
			if not discarded then
				G.hand.cards[i].perma_bonus = G.hand.cards[i].ability.perma_bonus or 0
				G.hand.cards[i].ability.perma_bonus = G.hand.cards[i].ability.perma_bonus + card.ability.extra.chips
			end
		end
		return {
			delay = 0.2,
			message = localize('k_upgrade_ex'),
			card = card,
			colour = G.C.CHIPS
                }
	end
end

function bunnyhop.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.chips}}
end

-- endregion Bunny Hop

-- region Hyperdash

local hyperdash = SMODS.Joker({
	name = "ccc_Hyperdash",
	key = "hyperdash",
    config = {extra = {mult = 3}},
	pixel_size = { w = 71, h = 81 },
	pos = {x = 6, y = 6},
	loc_txt = {
        name = 'Hyperdash',
        text = {
			"After {C:attention}discarding{} a hand that",
			"contains {C:attention}Two Pair{}, {X:mult,C:white} X#1# {} Mult",
			"for the {C:attention}next{} played hand"
        }
    },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Fytos"
	}
})

hyperdash.calculate = function(self, card, context)

	if context.pre_discard and not context.blueprint then
		local poker_hands = evaluate_poker_hand(G.hand.highlighted)
		if next(poker_hands["Two Pair"]) then
			card.ability.active = true
			local thunk = function(_card) return _card.ability.active == true end
                	juice_card_until(card, thunk, true)
			return {
				message = localize('k_active_ex'),
			}
		end
	end
			

	if context.joker_main and card.ability.active then
		card.ability.active = false
		return {
			message = localize {
				type = 'variable',
				key = 'a_xmult',
				vars = { card.ability.extra.mult }
			},
			Xmult_mod = card.ability.extra.mult
		}
	end
			
end

function hyperdash.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.mult}}
end

-- endregion Hyperdash

-- region Cornerjump

local cornerjump = SMODS.Joker({
	name = "ccc_Cornerjump",
	key = "cornerjump",
    config = {extra = {chips = 90}},
	pixel_size = { w = 71, h = 81 },
	pos = {x = 8, y = 6},
	loc_txt = {
        name = 'Cornerjump',
        text = {
			"{C:chips}+#1#{} Chips if played hand",
			"contains an {C:attention}Ace{}, and",
			"either a {C:attention}King{} or a {C:attention}2{}",
        }
    },
	rarity = 1,
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Fytos"
	}
})

cornerjump.calculate = function(self, card, context)
	if context.joker_main then
		local ace_con = false
		local tk_con = false
		for i = 1, #context.full_hand do
	         	if context.full_hand[i]:get_id() == 14 then ace_con = true end
			if context.full_hand[i]:get_id() == 2 or context.full_hand[i]:get_id() == 13 then tk_con = true end
		end
		if ace_con and tk_con then
			return {
				message = localize {
					type = 'variable',
					key = 'a_chips',
					vars = { card.ability.extra.chips }
				},
				chip_mod = card.ability.extra.chips
			}
		end
	end
end

function cornerjump.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.chips}}
end

-- endregion Cornerjump

-- region Bubsdrop

local bubsdrop = SMODS.Joker({
	name = "ccc_Bubsdrop",
	key = "bubsdrop",
    config = {extra = {ante = 1, money = 15}},
	pixel_size = { w = 71, h = 81 },
	pos = {x = 7, y = 6},
	loc_txt = {
        name = 'Bubsdrop',
        text = {
			"On defeat of {C:attention}Boss Blind{},",
			"{C:red}-$#2#{} and {C:attention}-#1#{} Ante, then",
			"{C:red}disable{} this card",
        }
    },
	rarity = 3,
	cost = 10,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "9Ts"
	}
})

bubsdrop.no_pool_flag = 'bubsdropused'

bubsdrop.calculate = function(self, card, context)
	if context.setting_blind and not context.blueprint then
		if context.blind.boss or G.GAME.selected_back.effect.config.everything_is_boss then
			card.ability.extra.boss = true
		else
			card.ability.extra.boss = false
		end
	end
	
	if context.end_of_round and (not context.blueprint) and (not context.repetition) and (not context.individual) and card.ability.extra.boss then
		G.GAME.pool_flags.bubsdropused = true
		G.E_MANAGER:add_event(Event({
			func = function() 
				ease_dollars(-card.ability.extra.money)
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-$"..card.ability.extra.money, colour = G.C.RED})
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			func = function() 
				ease_ante(-card.ability.extra.ante)
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-"..card.ability.extra.ante.." Ante", colour = G.C.FILTER})
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			func = function()
				card.ability.perma_debuff = true
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_disabled_ex'),colour = G.C.FILTER})
				return true
			end
		}))
	end
end

function bubsdrop.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.ante, card.ability.extra.money}}
end

-- endregion Bubsdrop

--[[ region Shattersong

local shattersong = SMODS.Joker({
	name = "ccc_Shattersong",
	key = "shattersong",
    config = {extra = {mult = 0, mult_scale = 4}},
	pos = {x = 9, y = 4},
	loc_txt = {
        name = 'Shattersong',
        text = {
		"This Joker gains {C:mult}+#2#{} Mult",
		"for each {C:attention}consecutive{} hand that",
		"contains a {C:attention}scoring 7{}, {C:attention}10{}, or {C:attention}King{},",
		"{C:red}resets{} on beating {C:attention}Boss Blind",
		"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
        }
    },
	rarity = 2,
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "estending"
	}
})

-- unfinished

shattersong.calculate = function(self, card, context)
	if context.before and not context.blueprint then
		for i = 1, #context.scoring_hand do
			if context.scoring_hand[i]:get_id() == 7 
			or context.scoring_hand[i]:get_id() == 10 
			or context.scoring_hand[i]:get_id() == 13 then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_scale
				return {
					extra = {focus = card, message = localize('k_upgrade_ex')},
					colour = G.C.MULT,
					card = card
				}
			end
		end
	end

	if context.joker_main then
		if card.ability.extra.mult ~= 0 then
                	return {
                    	message = localize {
                        	type = 'variable',
                        	key = 'a_mult',
                        	vars = { card.ability.extra.mult }
                    	},
			mult_mod = card.ability.extra.mult
                	}
		end
	end
end

function shattersong.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.mult, card.ability.extra.mult_scale}}
end
]]
-- endregion Shattersong

-- region Slight Miscalculation

local slightmiscalculation = SMODS.Joker({
	name = "ccc_Slight Miscalculation",
	key = "slightmiscalculation",
    config = {extra = {mult = 9}},
	pos = {x = 9, y = 5},
	loc_txt = {
        name = 'Slight Miscalculation',
        text = {
			"{C:mult}+#1#{} Mult if {C:attention}scoring hand{} starts",
			"and ends with the {C:attention}same{} rank",
			"{C:inactive}(ex: 3, 7, 7, 3)"
        }
    },
	rarity = 1,
	cost = 3,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Mr. Wolf",
		code = "toneblock",
		concept = "Fytos"
	}
})

slightmiscalculation.calculate = function(self, card, context)

	if context.joker_main then
		if (context.scoring_hand[1] and (context.scoring_hand[1]:get_id() == context.scoring_hand[#context.scoring_hand]:get_id())) or
		-- keevin doesn't work well with this! so i'm hardcoding the interaction
		(#SMODS.find_card('j_ccc_kevin') >= 1 and G.play.cards[#G.play.cards] == context.scoring_hand[#context.scoring_hand] and context.scoring_hand[1]:is_face()) then
			return {
				message = localize {
					type = 'variable',
					key = 'a_mult',
					vars = { card.ability.extra.mult }
				},
				mult_mod = card.ability.extra.mult
                	}
		end		
	end

end

function slightmiscalculation.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.mult}}
end

-- endregion Slight Miscalculation

-- region Freeze

local freeze = SMODS.Joker({
	name = "ccc_Freeze",
	key = "freeze",
    config = {extra = {chips = 15}},
	pos = {x = 0, y = 7},
	loc_txt = {
        name = 'Freeze',
        text = {
			"Cards held in hand",
			"gain {C:chips}+#1#{} Chips",
			"until end of round",
        }
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "9Ts",
		code = "toneblock",
		concept = "Fytos"
	}
})

freeze.calculate = function(self, card, context)
	if context.individual and not (context.end_of_round or context.repetition) then
        	if context.cardarea == G.hand then
			-- scuffed
	         	context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
                        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + card.ability.extra.chips
			context.other_card.ability.temp_bonus = context.other_card.ability.temp_bonus or 0
                        context.other_card.ability.temp_bonus = context.other_card.ability.temp_bonus + card.ability.extra.chips
                        return {
                            	extra = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
                            	colour = G.C.CHIPS,
				card = card
                        }
	        end
	end
end

function freeze.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.chips}}
end
local endroundref = end_round
function end_round()
	for i, v in ipairs(G.playing_cards) do
		if v.ability.perma_bonus and v.ability.temp_bonus then
			v.ability.perma_bonus = v.ability.perma_bonus - v.ability.temp_bonus
			v.ability.temp_bonus = 0
		end
	end
	endroundref()
end

-- endregion Freeze

-- region Move Block

local moveblock = SMODS.Joker({
	name = "ccc_Move Block",
	key = "moveblock",
    config = {extra = {mult = 0, mult_scale = 1}},
	pos = {x = 5, y = 5},
	pixel_size = { w = 71, h = 91 },
	loc_txt = {
        name = 'Move Block',
        text = {
			"{C:mult}+#1#{} Mult per discard,",
			"{C:attention}resets{} if played hand",
			"contains a {C:attention}Pair",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
        }
    },
	rarity = 2,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "9Ts",
		code = "toneblock",
		concept = "9Ts"
	}
})

moveblock.calculate = function(self, card, context)
	if context.discard then
		if not context.blueprint and context.other_card == context.full_hand[#context.full_hand] then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_scale
			return {
				card = card,
				message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult_scale}}
                        }
		end
	end
	if context.before and not context.blueprint then
		if next(context.poker_hands['Pair']) then
			card.ability.extra.mult = 0
			return {
				message = localize('k_reset')
			}
		end
	end
	if context.joker_main then
		if card.ability.extra.mult ~= 0 then
			return {
				message = localize {
					type = 'variable',
					key = 'a_mult',
					vars = { card.ability.extra.mult }
                		},
				mult_mod = card.ability.extra.mult
                	}
		end
	end
end

function moveblock.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.mult_scale, card.ability.extra.mult}}
end

-- better way to do this probably
-- for now i'm the hookmaster

local mblockcupdref = Card.update
function Card:update(dt)
	
	if self.config.center.key == 'j_ccc_moveblock' then
		local _dt = G.TIMERS.REAL - (self.old_timer or G.TIMERS.REAL)
		self.moveblock_active = self.moveblock_active or 0
		if self.states.focus.is or self.states.drag.is or self.highlighted then
			self.moveblock_active = math.min(self.moveblock_active + _dt, 1)
		else
			self.moveblock_active = math.max(self.moveblock_active - _dt, 0)
		end
		self.old_timer = G.TIMERS.REAL
	end
	if mblockcupdref then
		mblockcupdref(self, dt)
	end
end

local mblockdrawref = Card.draw
function Card:draw(layer)
	if self.config.center.key == 'j_ccc_moveblock' then
		moveblock:set_sprites(self)
	end
	if mblockdrawref then
		mblockdrawref(self, layer)
	end
end

function moveblock.set_sprites(self, card, front)
	local _pr = G.ASSET_ATLAS["ccc_moveblock_pr"]
	local _rl = G.ASSET_ATLAS["ccc_moveblock_rl"]
	local pos = {x = 0, y = 0}
	local active = card.moveblock_active or 0
	local current = card.states.drag.is and _pr or _rl
	if active > 0.01 then
		active = tostring(math.floor((active * 100) - 1))
		active = #active < 2 and '0'..active or ''..active
		pos = {x = tonumber(string.sub(active, 2, 2)), y = tonumber(string.sub(active, 1, 1))}
	else
		pos = {x = 5, y = 5}
		current = G.ASSET_ATLAS["ccc_j_ccc_jokers"]
	end
	if not card.old_pos then card.old_pos = {x = pos.x, y = pos.y} end
	if not card.old_at then card.old_at = current end
	if card.old_pos.x ~= pos.x or card.old_pos.y ~= pos.y or card.old_at ~= current then
		card.children.center.atlas = current
		card.children.center:set_sprite_pos(pos)
	end
	card.old_pos.x = pos.x
	card.old_pos.y = pos.y
	card.old_at = current
end

-- endregion Move Block

-- region joker.ppt

local jokerppt = SMODS.Joker({
	name = "ccc_joker_ppt",
	key = "jokerppt",
    config = {extra = {winged_poker_hand = 'Pair', active = false}},
	pixel_size = { w = 71, h = 81 },
	pos = {x = 5, y = 6},
	loc_txt = {
        name = 'joker.ppt',
        text = {
			"If {C:attention}#1#{} is played {C:attention}during",
			"the round, create its {C:planet}Planet{}",
			"card at the end of round,",
			"{s:0.8}poker hand changes at end of round",
        }
    },
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
	}
})

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
		card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Active!", colour = G.C.FILTER})
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
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Reset", colour = G.C.FILTER})
			return true
            		end)}))
		end
	end
end

function jokerppt.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.winged_poker_hand}}
end

-- endregion joker.ppt

-- region Berry Seeds

local berryseeds = SMODS.Joker({
	name = "ccc_Berry Seeds",
	key = "berryseeds",
    config = {extra = {suit = 'Spades', count = 0, req = 8}},
	pos = {x = 4, y = 7},
	loc_txt = {
        name = 'Berry Seeds',
        text = {
			"After scoring {C:attention}#2#{} {V:1}#3#{} cards,",
			"sell this card to {C:attention}create{}",
			"a random {C:attention}Strawberry{}",
			"{C:inactive}(Currently {C:attention}#1#{C:inactive}/#2#)",
        }
    },
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
	}
})

berryseeds.set_ability = function(self, card, initial, delay_sprites)
	local suits = {}
	for k, v in pairs(SMODS.Suits) do
		suits[#suits+1] = v.key
	end
	card.ability.extra.suit = pseudorandom_element(suits, pseudoseed('berryseeds'))
end

berryseeds.calculate = function(self, card, context)
	if context.individual and context.other_card:is_suit(card.ability.extra.suit, true) then	-- i could put a check here but then it doesn't infinitely scale and that's no fun
		if context.cardarea == G.play and not context.blueprint then
			card.ability.extra.count = card.ability.extra.count + 1
			if card.ability.extra.count >= card.ability.extra.req then
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.0,
					func = (function()
						local eval = function(_card) return not _card.REMOVED end
						juice_card_until(card, eval, true)
						return true
					end)
				}))
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
		card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Strawberry!'})
		
		local rarities = {{},{},{}}
		
		for i, berry in ipairs(strawberries) do	-- defined in 1up region
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
				print('added: '..berry..' to'..v.rarity)
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

-- endregion Berry Seeds

-- region Fireball

local fireball = SMODS.Joker({
	name = "ccc_Fireball",
	key = "fireball",
    config = {extra = {active = false, count = 0}},
	pos = {x = 5, y = 7},
	loc_txt = {
        name = 'Fireball',
        text = {
			"If your {C:attention}score display{} catches {C:attention}fire{}",
			"during the round, next shop will",
			"have an {C:attention}extra Mega{} booster pack",
        }
    },
	rarity = 2,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "9Ts",
		code = "toneblock",
		concept = "AstralightSky"
	}
})

fireball.calculate = function(self, card, context)
	if context.ccc_switch and context.ccc_switch['ice'] and not context.blueprint then
		local old_count = card.ability.extra.count
		card:set_ability(G.P_CENTERS['j_ccc_iceball'])
		card.ability.extra.count = old_count
		card.ability.extra.active = card.ability.extra.count == 0 and true or false
	end
	if context.setting_blind and not context.blueprint then
		card.ability.extra.active = false
	end
	if context.ccc_fire and not context.blueprint then
		card.ability.extra.active = true
		card.ability.extra.count = 2
		card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Fire!", colour = G.C.RED})
	end
	if context.end_of_round and context.main_eval and not context.blueprint then
		card.ability.extra.count = math.max(0, card.ability.extra.count - 1)
	end
	if context.ccc_shop_trigger and card.ability.extra.active then
		card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+1 Pack'})
		
		local mega = false
		local center = get_pack('ccc_fireball')
		local c = 0
		
		while c <= 1000 and mega == false do
			if not center.name:find('Mega') then
				center = get_pack('ccc_fireball')
			else
				mega = true
			end
			c = c + 1
		end
		local i = #G.GAME.current_round.used_packs + 1
		local _card = Card(G.shop_booster.T.x + G.shop_booster.T.w/2, G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, center, {bypass_discovery_center = true, bypass_discovery_ui = true})
		create_shop_card_ui(_card, 'Booster', G.shop_booster)
		G.GAME.current_round.used_packs[i] = center.key
		_card.ability.booster_pos = i
		_card:start_materialize()
		G.shop_booster:emplace(_card)
	end
end

local fireballerref = end_round
function end_round()
	G.GAME.ccc_fire_triggered = false
	fireballerref()
end

function fireball.loc_vars(self, info_queue, card)
	return {vars = {}}
end

-- endregion Fireball

-- region Iceball

local iceball = SMODS.Joker({
	name = "ccc_Iceball",
	key = "iceball",
    config = {extra = {active = true, xmult = 3, count = 0}},
	pos = {x = 5, y = 8},
	loc_txt = {
        name = 'Iceball',
        text = {
			"If your {C:attention}score display{} didn't",
			"catch {C:attention}fire{} during the",
			"{C:attention}previous{} round, {C:white,X:red}X3{} Mult",
        }
    },
	rarity = 2,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "9Ts",
		code = "toneblock",
		concept = "Fytos"
	}
})

iceball.calculate = function(self, card, context)
	if context.ccc_switch and context.ccc_switch['fire'] and not context.blueprint then
		local old_count = card.ability.extra.count
		card:set_ability(G.P_CENTERS['j_ccc_fireball'])
		card.ability.extra.count = old_count
	end
	if context.ccc_fire and not context.blueprint then
		card.ability.extra.count = 2	-- this int is to track state
		card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Fire", colour = G.C.RED})
	end
	if context.end_of_round and context.main_eval and not context.blueprint then
		card.ability.extra.count = math.max(0, card.ability.extra.count - 1)
		card.ability.extra.active = card.ability.extra.count == 0 and true or false
	end
	if context.joker_main then
		if card.ability.extra.active then
			return {
				message = localize {
					type = 'variable',
					key = 'a_xmult',
					vars = { card.ability.extra.xmult }
				},
				Xmult_mod = card.ability.extra.xmult
			}
		end
	end
end

function iceball.loc_vars(self, info_queue, card)
	return {vars = {}}
end

-- endregion Iceball

-- region Badeline

local badeline = SMODS.Joker({
	name = "ccc_Badeline",
	key = "badeline",
    config = {extra = {xmult = 1.2}},
	pos = {x = 0, y = 5},
	soul_pos = {x = 0, y = 6},
	loc_txt = {
        name = 'Badeline',
        text = {
	"Retrigger and {C:attention}sustain{} all",
	"{C:dark_edition}Mirrored{} and/or {C:attention}Glass{} cards,",
	"they give {X:mult,C:white} X#1# {} Mult when scored",
        }
    },
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
	}
})

badeline.yes_pool_flag = 'preventsoulspawn'

-- huge jank on calculate but i don't even know tbh... card = card????????? it shouldn't need that...
-- apparently you're passing card (the object) to card (the return value) so you do need that

badeline.calculate = function(self, card, context)
	if context.repetition then
		if context.cardarea == G.play then
			if (context.other_card.edition and context.other_card.edition.ccc_mirrored) or context.other_card.ability.effect == 'Glass Card' then
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = card
				}
			end
		elseif context.cardarea == G.hand then
			if ((context.other_card.edition and context.other_card.edition.ccc_mirrored) or context.other_card.ability.effect == 'Glass Card') and (next(context.card_effects[1]) or #context.card_effects > 1) then
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = card
				}
			end
		end
	end
	if context.individual and context.cardarea == G.play then
		if (context.other_card.edition and context.other_card.edition.ccc_mirrored) or context.other_card.ability.effect == 'Glass Card' then
			return {
				x_mult = card.ability.extra.xmult,
				card = card
			}
		end
	end
end

function badeline.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'e_mirrored', set = 'Other'}
	info_queue[#info_queue+1] = G.P_CENTERS.m_glass
	return {vars = {card.ability.extra.xmult}}
end

-- endregion Badeline

-- region Madeline

-- USES GLOBAL VARIABLE
local madeline = SMODS.Joker({
	name = "ccc_Madeline",
	key = "madeline",
    config = {},
	pos = {x = 1, y = 5},
	soul_pos = {x = 1, y = 6},
	loc_txt = {
        name = 'Madeline',
        text = {
			"{C:attention}Prevents{} reduction and",
			"resets of Joker {C:attention}values{}",
			"through owned abilities"
        }
    },
	rarity = 4,
	cost = 20,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	},
	add_to_deck = function (self, card, from_debuff)
		G.GAME.pool_flags.madeline_in_hand = card
	end,
	remove_from_deck = function (self, card, from_debuff)
		G.GAME.pool_flags.madeline_in_hand = nil
		for _, v in ipairs(G.jokers.cards) do
			if v ~= card and v.ability.name == "ccc_Madeline" and not v.debuff then
				G.GAME.pool_flags.madeline_in_hand = v
			end
		end
	end,
	load = function (self, card, card_table, other_card)
		G.GAME.pool_flags.madeline_in_hand = card
	end
})

local calculate_joker_ref = Card.calculate_joker
function Card.calculate_joker(self, context)
	local prevent = G.GAME.pool_flags.madeline_in_hand or false
	local orig_values = {}
	if self.ability and self.ability.set == "Joker" then
		if prevent then
			for index, value in pairs(self.ability) do
				if type(value) == "number" then
					orig_values[index] = value
				end
			end

			if type(self.ability.extra) == "table" then
				orig_values["extra"] = {}
				for index, value in pairs(self.ability.extra) do
					if type(value) == "number" then
						orig_values.extra[index] = value
					end
				end
			end

		end
	end
	local ret, post = calculate_joker_ref(self, context)
	if prevent then
		for index, value in pairs(orig_values) do
			if type(value) == "number" and self.ability[index] < orig_values[index]  then
				self.ability[index] = orig_values[index] 
				card_eval_status_text(prevent, 'extra', nil, nil, nil, {
					message = "Prevent!",
					colour = G.C.RED
				});
			end
		end

		if type(self.ability.extra) == "table" and (orig_values.extra and type(orig_values.extra) == "table") then
			for index, value in pairs(orig_values.extra) do
				if type(value) == "number" and self.ability.extra[index] < orig_values.extra[index]  then
					self.ability.extra[index] = orig_values.extra[index] 
					card_eval_status_text(prevent, 'extra', nil, nil, nil, {
						message = "Prevent!",
						colour = G.C.RED
					})
					-- Give back hand size from turtle bean that would be taken (if bean will not be destroyed)
					if self.ability.name == 'Turtle Bean' and not context.blueprint and index == "h_size" and self.ability.extra.h_size > 1 then
						G.hand:change_size(self.ability.extra.h_mod)
					end
				end
			end
			
		end
	end

	return ret, post
end

-- endregion Madeline

-- region Theo

-- endregion Theo

-- region Granny

local granny = SMODS.Joker({
	name = "ccc_Granny",
	key = "granny",
    config = {extra = {draw = 1}},
	pos = {x = 9, y = 4}, --pos = {x = 0, y = 5},
	--soul_pos = {x = 0, y = 6},
	loc_txt = {
        name = 'Granny',
        text = {
	"After {C:red}discarding{} cards,",
	"{C:attention}draw{} {C:attention}#1#{} additional card",
	"for each card discarded"
        }
    },
	rarity = 4,
	cost = 20,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "Fytos"
	}
})

granny.calculate = function(self, card, context)
	if context.discard and not context.blueprint then
		G.GAME.ccc_after_discard = #context.full_hand
	end
	if context.ccc_hand_drawn and (G.GAME.ccc_after_discard and G.GAME.ccc_after_discard > 0) and #G.deck.cards > 0 then
		G.GAME.ccc_after_discard_buffer = G.GAME.ccc_after_discard
		return {
			G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..card.ability.extra.draw*G.GAME.ccc_after_discard_buffer.." Cards", colour = G.C.FILTER})
				G.FUNCS.draw_from_deck_to_hand(card.ability.extra.draw*G.GAME.ccc_after_discard_buffer)
				G.GAME.ccc_after_discard = 0
			return true end }))
		}
		
	end
end

function granny.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.draw}}
end

-- endregion Granny


sendDebugMessage("[CCC] Jokers loaded")
