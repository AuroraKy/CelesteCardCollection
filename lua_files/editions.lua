-- region Mirrored

SMODS.Shader({key = 'mirrored', path = "mirrored.fs"})

local mirrored = SMODS.Edition({
    key = "mirrored",
    discovered = true,
    unlocked = true,
    disable_base_shader = true,
    disable_shadow = true,
    shader = 'mirrored',
    config = {},
    in_shop = false,
	credit = {
		art = "sunsetquasar",
		code = "toneblock",
		concept = "Gappie & Fytos"
	},
    calculate = function(self, card, context)
	-- yeah ngl i took this directly from ortalab... i hope this works?
	if context.repetition_only or (context.retrigger_joker_check and context.other_card == card) then
		if ccc_find_mirror() then
			return {
				repetitions = 1,
				card = card,
				colour = G.C.FILTER,
				message = localize('k_again_ex')
			}     
		end
	end
    end,
})

function ccc_find_mirror()
	local mirrors = {
		'j_ccc_ominousmirror',
		'j_ccc_badeline',
		'j_ccc_partofyou',
	}
	for i = 1, #mirrors do
		if next(SMODS.find_card(mirrors[i])) then
			return true
		end
	end
	return false
end

local gfevref = G.FUNCS.evaluate_round
G.FUNCS.evaluate_round = function()
	gfevref()
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.0,
		func = function()
		local destroyed_cards = {}
		if not ccc_find_mirror() then
			for i, v in ipairs(G.playing_cards) do
				if v.edition and v.edition.ccc_mirrored then
					destroyed_cards[#destroyed_cards+1] = v
				end
			end
		end
		for i=1, #destroyed_cards do
			G.E_MANAGER:add_event(Event({
				func = function()
					if destroyed_cards[i].ability.name == 'Glass Card' then 
						destroyed_cards[i]:shatter()
					else
						destroyed_cards[i]:start_dissolve()
					end
				return true
				end
			}))
		end
		SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
		return true
	end}))
end
-- endregion Mirrored
