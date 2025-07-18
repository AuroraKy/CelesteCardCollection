-- region Blue Spinner

local bluespinner = {
	name = "ccc_Blue Spinner",
	key = "bluespinner",
	config = { extra = { prob_success = 2 } },
	pos = { x = 0, y = 4 },
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
	},
    description = "When a card with a Blue Seal is scored, 1 in 2 Chance to add a Blue Seal to each adjacent card in scored hand (Unaffected by retriggers)"
}

bluespinner.calculate = function(self, card, context)
	if context.before and not context.blueprint then
		local rainbow_spinner_seal_override = false
		if next(find_joker('ccc_Rainbow Spinner')) then
			rainbow_spinner_seal_override = true
		else
			rainbow_spinner_seal_override = false
		end
		bluespinner_seal_candidates = {}
		local function check(_card)
			if _card.seal == 'Blue' or (rainbow_spinner_seal_override == true and _card.seal == 'Gold') then
				if SMODS.pseudorandom_probability(card, 'blue_spinner', 1, card.ability.extra.prob_success) then
					return true
				end
			end
			return false
		end
		for k = 1, #context.scoring_hand do
			if k == 1 then
				if k ~= #context.scoring_hand then
					if check(context.scoring_hand[k + 1]) then
						bluespinner_seal_candidates[#bluespinner_seal_candidates + 1] = context.scoring_hand[k]
					end
				end
			elseif k == #context.scoring_hand then
				if k ~= 1 then
					if check(context.scoring_hand[k - 1]) then
						bluespinner_seal_candidates[#bluespinner_seal_candidates + 1] = context.scoring_hand[k]
					end
				end
			else
				if check(context.scoring_hand[k + 1]) then
					bluespinner_seal_candidates[#bluespinner_seal_candidates + 1] = context.scoring_hand[k]
				elseif check(context.scoring_hand[k - 1]) then
					bluespinner_seal_candidates[#bluespinner_seal_candidates + 1] = context.scoring_hand[k]
				end
			end
		end
		if #bluespinner_seal_candidates > 0 then
			for k = 1, #bluespinner_seal_candidates do
				if (rainbow_spinner_seal_override == true and bluespinner_seal_candidates[k].seal ~= 'Blue' and bluespinner_seal_candidates[k].seal ~= 'Gold') or (rainbow_spinner_seal_override == false and bluespinner_seal_candidates[k].seal ~= 'Blue') then
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.0,
						func = function()
							bluespinner_seal_candidates[k]:set_seal('Blue', true, false)
							bluespinner_seal_candidates[k]:juice_up()
							play_sound('gold_seal', 1.2, 0.4)
							card:juice_up()
							return true
						end
					}))
					delay(0.5)
				end
			end
			return nil, true
		end
	end
end

function bluespinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue + 1] = { key = 'blue_seal', set = 'Other' }
	local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.prob_success, 'blue_spinner')
	return { vars = { numerator, denominator } }
end

function bluespinner.in_pool(self)
	for i, v in ipairs(G.playing_cards) do
		if v.seal and v.seal == 'Blue' then return true end
	end
	return false
end

return bluespinner
-- endregion Blue Spinner