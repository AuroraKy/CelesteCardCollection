-- region Mini Heart

local miniheart = {
	name = "ccc_Mini Heart",
	key = "miniheart",
	config = { extra = { prob_success = 15 } },
	pos = { x = 5, y = 0 },
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
	},
    description = "1 in 15 chance to add Foil edition to scored cards before scoring"
}

miniheart.calculate = function(self, card, context)
	if context.before then
		local applied = false
		for i, v in ipairs(context.scoring_hand) do
			if not v.edition then
				if pseudorandom('crystal') < G.GAME.probabilities.normal / card.ability.extra.prob_success then
					applied = true
					v:set_edition({ foil = true })
					if context.blueprint then -- idk why i need to put blueprint check here, should work without? but it doesn't
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
	info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
	return { vars = { '' .. (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.prob_success } }
end

return miniheart
-- endregion Mini Heart