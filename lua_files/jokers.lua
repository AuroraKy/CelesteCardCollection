

-- Used by seeker and feather (no more, see context.hand_drawn and context.other_drawn)
--[[
local drawcardref = G.FUNCS.draw_from_deck_to_hand
G.FUNCS.draw_from_deck_to_hand = function(e)
	local hand_space = e or math.min(#G.deck.cards, G.hand.config.card_limit - #G.hand.cards)
	if G.GAME.blind.name == 'The Serpent' and
		not G.GAME.blind.disabled and
		(G.GAME.current_round.hands_played > 0 or
			G.GAME.current_round.discards_used > 0) then
		hand_space = math.min(#G.deck.cards, 3)
	end
	SMODS.calculate_context({ ccc_drawfromdeck = true, ccc_amount = hand_space })
	drawcardref(e)
end
]]

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



sendDebugMessage("[CCC] Joker main file loaded")

-- order jokers are loaded in (for collection)
return [[
j_ccc_feather
j_ccc_zipper
j_ccc_templeeyes
j_ccc_miniheart
j_ccc_bird
j_ccc_partofyou
j_ccc_towels
j_ccc_chests
j_ccc_books
j_ccc_ominousmirror
j_ccc_strawberry
j_ccc_wingedstrawberry
j_ccc_goldenstrawberry
j_ccc_wingedgoldenstrawberry
j_ccc_moonberry
j_ccc_tothesummit
j_ccc_coreswitch
j_ccc_templerock
j_ccc_strongwinds
j_ccc_coyotejump
j_ccc_climbinggear
j_ccc_bluespinner
j_ccc_purplespinner
j_ccc_redspinner
j_ccc_rainbowspinner
j_ccc_lettinggo
j_ccc_greenbooster
j_ccc_redbooster
j_ccc_cassetteblock
j_ccc_bumper
j_ccc_waterfall
j_ccc_collapsingbridge
j_ccc_switchgate
j_ccc_checkpoint
j_ccc_theocrystal
j_ccc_lapidary
j_ccc_hardlist
j_ccc_cloud
j_ccc_brittlecloud
j_ccc_seeker
j_ccc_pointlessmachines
j_ccc_crystalheart
j_ccc_mechanicalheart
j_ccc_quietheart
j_ccc_heavyheart
j_ccc_eventhorizon
j_ccc_introcar
j_ccc_secretshrine
j_ccc_kevin
j_ccc_strawberrypie
j_ccc_1up
j_ccc_thecrowd
j_ccc_jump
j_ccc_grab
j_ccc_dash
j_ccc_bunnyhop
j_ccc_hyperdash
j_ccc_cornerjump
j_ccc_bubsdrop
j_ccc_shattersong
j_ccc_slightmiscalculation
j_ccc_freeze
j_ccc_moveblock
j_ccc_jokerppt
j_ccc_berryseeds
j_ccc_fireball
j_ccc_iceball
j_ccc_crumblejoker
j_ccc_pico8joker
j_ccc_refundpolicy
j_ccc_smotsgaming
j_ccc_madeline
j_ccc_badeline
j_ccc_granny
j_ccc_thelastjoker
]]