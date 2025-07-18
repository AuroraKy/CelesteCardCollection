-- region Red Spinner

local redspinner = {
	name = "ccc_Red Spinner",
	key = "redspinner",
	config = { extra = { prob_success = 2 } },
	pos = { x = 2, y = 4 },
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
    description = "When a card with a Red Seal is discarded, 1 in 2 chance to add a Red Seal to each card in discarded hand (Unaffected by retriggers)"
}

redspinner.calculate = function(self, card, context)
	if context.pre_discard and not context.blueprint then
		local rainbow_spinner_seal_override = false
		if next(find_joker('ccc_Rainbow Spinner')) then
			rainbow_spinner_seal_override = true
		else
			rainbow_spinner_seal_override = false
		end
		redspinner_seal_candidates = {}
		local function check(_card)
			if _card.seal == 'Red' or (rainbow_spinner_seal_override == true and _card.seal == 'Gold') then
				if SMODS.pseudorandom_probability(card, 'red_spinner', 1, card.ability.extra.prob_success) then
					return true
				end
			end
			return false
		end
		for k = 1, #G.hand.highlighted do
			if k == 1 then
				if k ~= #G.hand.highlighted then
					if check(G.hand.highlighted[k + 1]) then
						redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
					end
				end
			elseif k == #G.hand.highlighted then
				if k ~= 1 then
					if check(G.hand.highlighted[k - 1]) then
						redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
					end
				end
			else
				if check(G.hand.highlighted[k + 1]) then
					redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
				elseif check(G.hand.highlighted[k - 1]) then
					redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
				end
			end
		end
		if #redspinner_seal_candidates > 0 then
			for k = 1, #redspinner_seal_candidates do
				if (rainbow_spinner_seal_override == true and redspinner_seal_candidates[k].seal ~= 'Red' and redspinner_seal_candidates[k].seal ~= 'Gold') or (rainbow_spinner_seal_override == false and redspinner_seal_candidates[k].seal ~= 'Red') then
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.0,
						func = function()
							redspinner_seal_candidates[k]:set_seal('Red', true, false)
							redspinner_seal_candidates[k]:juice_up()
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

function redspinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue + 1] = { key = 'red_seal', set = 'Other' }
	local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.prob_success, 'red_spinner')
	return { vars = { numerator, denominator } }
end

function redspinner.in_pool(self)
	for i, v in ipairs(G.playing_cards) do
		if v.seal and v.seal == 'Red' then return true end
	end
	return false
end

return redspinner
-- endregion Red Spinner