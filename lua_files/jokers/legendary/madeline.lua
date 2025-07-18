-- region Madeline

-- USES GLOBAL VARIABLE
local madeline = {
	name = "ccc_Madeline",
	key = "madeline",
	config = {},
	pos = {x = 1, y = 5},
	soul_pos = {x = 1, y = 6},
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
    description = "Prevent jokers from trying to lower their own values",
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
}

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
					message = localize('k_ccc_prevent_ex'),
					colour = G.C.RED
				});
			end
		end

		if type(self.ability.extra) == "table" and (orig_values.extra and type(orig_values.extra) == "table") then
			for index, value in pairs(orig_values.extra) do
				if type(value) == "number" and (self.ability.extra[index] and self.ability.extra[index] < orig_values.extra[index]) then
					self.ability.extra[index] = orig_values.extra[index] 
					card_eval_status_text(prevent, 'extra', nil, nil, nil, {
						message = localize('k_ccc_prevent_ex'),
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

return madeline
-- endregion Madeline
