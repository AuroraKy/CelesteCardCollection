-- region Ominous Mirror

local ominousmirror = {
	name = "ccc_Ominous Mirror",
	key = "ominousmirror",
	config = { extra = { broken = false, pos_override = { x = 0, y = 2 }, prob_success = 3, prob_break = 7 } },
	pos = { x = 0, y = 2 },
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
	eternal_compat = false,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie & sunsetquasar",
		code = "toneblock & Aurora Aquir",
		concept = "Gappie"
	},
    description = "1 in 3 chance to add a permanent, Mirrored copy of each scored card to your hand. 1 in 7 chance to break at the end of round becoming Broken Mirror",
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
}

ominousmirror.set_ability = function(self, card, initial, delay_sprites)
	card.children.center:set_sprite_pos(card.ability.extra.pos_override)
end


ominousmirror.calculate = function(self, card, context)
	card.children.center:set_sprite_pos(card.ability.extra.pos_override)
	if context.before and card.ability.extra.broken == false then
		if not context.repetition and not context.individual and card.ability.extra.broken == false then
			local _cards = {}
			for k, v in ipairs(context.scoring_hand) do
				if pseudorandom('ominous') < G.GAME.probabilities.normal / card.ability.extra.prob_success then
					local _card = copy_card(v, nil, nil, G.playing_card)
					_cards[#_cards + 1] = _card
					_card.states.visible = nil
					G.hand:emplace(_card)
					G.E_MANAGER:add_event(Event({
						trigger = 'before',
						delay = 0.3,
						func = function()
							card:juice_up()
							v:juice_up()
							_card:add_to_deck()
							_card:set_edition({ ccc_mirrored = true }, true, true)
							G.deck.config.card_limit = G.deck.config.card_limit + 1
							table.insert(G.playing_cards, _card)
							_card:start_materialize()
							return true
						end
					}))
				end
			end
			if #_cards > 0 then
				playing_card_joker_effects(_cards)
				return nil, true
			end
		end
	end
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual and card.ability.extra.broken == false then
		if pseudorandom('oopsidroppedit') < G.GAME.probabilities.normal / card.ability.extra.prob_break then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.3,
				func = function()
					play_sound('glass' .. math.random(1, 6), math.random() * 0.2 + 0.9, 0.5)
					local childParts = Particles(0, 0, 0, 0, {
						timer_type = 'TOTAL',
						timer = 0.007 * 1,
						scale = 0.3,
						speed = 4,
						lifespan = 0.5 * 1,
						attach = card,
						colours = { G.C.MULT },
						fill = true
					})
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						blockable = false,
						delay = 0.5 * 1,
						func = (function()
							childParts:fade(0.30 * 1)
							return true
						end)
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
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Broken", colour = G.C.MULT })
		else
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Safe..?", colour = G.C.FILTER })
		end
	end
end

function ominousmirror.loc_vars(self, info_queue, card)
	info_queue[#info_queue + 1] = { key = 'e_mirrored', set = 'Other' }
	return { key = card.ability.extra.broken and "Broken Mirror" or card.config.center.key, vars = { '' .. (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.broken, card.ability.extra.prob_success, card.ability.extra.prob_break } }
end

return ominousmirror
-- endregion Ominous Mirror