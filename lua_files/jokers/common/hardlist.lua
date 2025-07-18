-- region hardlist

local hardlist = {
	name = "ccc_hardlist",
	key = "hardlist",
	config = { extra = { mult = 20, sub = 4 } }, -- mult should be a multiple of sub for this card
	pos = { x = 5, y = 3 },
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
	},
	description = "+20 Mult. -4 Mult on purchase of a Joker or Buffon Pack"
}



hardlist.calculate = function(self, card, context)
	if (context.buying_card and context.card.config.center.set == "Joker" and not (context.card == card)) or (context.ccc_paid_booster and context.card.ability.name:find('Buffoon')) then -- raaaah thunk giving us too little info
		if not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.sub
			if card.ability.extra.mult <= 0 then
				G.E_MANAGER:add_event(Event({
					func = function()
						card_eval_status_text(card, 'extra', nil, nil, nil, {
							message = localize('k_ccc_standard_ex'),
							colour = G.C.RED
						});
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							func = function()
								play_sound('tarot1')
								card.T.r = -0.2
								card:juice_up(0.3, 0.4)
								card.states.drag.is = true
								card.children.center.pinch.x = true
								G.E_MANAGER:add_event(Event({
									trigger = 'after',
									delay = 0.3,
									blockable = false,
									func = function()
										G.jokers:remove_card(card)
										card:remove()
										card = nil
										return true;
									end
								}))
								return true
							end
						}))
						return true
					end
				}))
			else
				G.E_MANAGER:add_event(Event({
					func = function()
						card_eval_status_text(card, 'extra', nil, nil, nil, {
							message = localize { type = 'variable', key = 'ccc_hardlist_star', vars = { card.ability.extra.mult / card.ability.extra.sub } },
							colour = G.C.RED
						}); return true
					end
				}))
			end
		end
	elseif context.joker_main then
		return {
			message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
			mult_mod = card.ability.extra.mult
		}
	end
end


function hardlist.loc_vars(self, info_queue, card)
	return { vars = { card.ability.extra.mult, card.ability.extra.sub } }
end

return hardlist
-- endregion hardlist