-- region Secret Shrine

local secretshrine = {
	name = "ccc_Secret Shrine",
	key = "secretshrine",
	config = { extra = { seven_tally = 4, factor = 3 } },
	pos = { x = 6, y = 5 },
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
	},
	description = "Gives +4 Mult for each 7 in full deck"
}

-- lovely used to update seven_tally

secretshrine.calculate = function(self, card, context)
	if context.joker_main then
		card.ability.extra.seven_tally = 0
		for k, v in pairs(G.playing_cards) do
			if v:get_id() == 7 then card.ability.extra.seven_tally = card.ability.extra.seven_tally+1 end
		end
		if card.ability.extra.seven_tally ~= 0 then
			return {
				message = localize {
					type = 'variable',
					key = 'a_mult',
					vars = { card.ability.extra.factor * card.ability.extra.seven_tally }
				},
				mult_mod = card.ability.extra.factor * card.ability.extra.seven_tally
			}
		end
	end
end

function secretshrine.loc_vars(self, info_queue, card)
	if G.STAGE == G.STAGES.RUN then
		card.ability.extra.seven_tally = 0
		for k, v in pairs(G.playing_cards) do
			if v:get_id() == 7 then card.ability.extra.seven_tally = card.ability.extra.seven_tally+1 end
		end
	end
	return { vars = { card.ability.extra.factor * card.ability.extra.seven_tally, card.ability.extra.factor } }
end

return secretshrine
-- endregion Secret Shrine