--- STEAMODDED HEADER
--- SECONDARY MOD FILE

----------------------------------------------
------------MOD CODE -------------------------

--- Descriptions ---
    local loc_seeker = {
        ["name"] = "Seeker",
        ["text"] = {
            [1] = "If {C:attention}Blind{} is selected with",
            [2] = "{C:money}$4{} or less, create a",
            [3] = "{C:tarot}Hanged Man{}"
        }
    }
    local loc_feather = {
        ["name"] = "Feather",
        ["text"] = {
            [1] = "{X:mult,C:white} X2 {} Mult when",
            [2] = "{C:attention}0{} discards",
            [3] = "remaining"
        }
    }
    local loc_limitless = {
        ["name"] = "Limitless",
        ["text"] = {
            [1] = "The Limit has been {C:red}broken{}",
            [2] = "{s:0.6} (This joker is for a free debug win)"
        }
    }

-- region Seeker 
    local loc_bird = {
        ["name"] = "Bird",
        ["text"] = {
            [1] = "Whenever a {C:planet}Planet{} card",
            [2] = "is used, draw {C:attention}3{} cards",
        }
    }
-- Seeker Start

    -- SMODS.Joker:new(name, slug, config, spritePos, loc_txt, rarity, cost, unlocked, discovered, blueprint_compat, eternal_compat)
    local joker_seeker = SMODS.Joker:new("Seeker", "seeker", {} , {
        x = 1,
        y = 0
    }, loc_seeker, 2, 6, true, true, true, true, "", "b_cccjokers")
    
    joker_seeker:register()


    SMODS.Jokers.j_seeker.tooltip = function(self, info_queue)
    info_queue[#info_queue+1] = G.P_CENTERS.c_hanged_man
    end

SMODS.Jokers.j_seeker.calculate = function(self, context)
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
	if G.GAME.dollars <= 4 then
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
                            card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})                       
                        return true
                    end)}))}
		end
        end
    end

-- endregion Seeker
-- region Feather

    local joker_feather = SMODS.Joker:new("Feather", "feather", { atlas="b_cccjokers" }, {
        x = 0,
        y = 0
    }, loc_feather, 2, 6, true, true, true, true, "", "b_cccjokers")

    joker_feather:register()


SMODS.Jokers.j_feather.calculate = function(self, context)
        if SMODS.end_calculate_context(context) then
		if G.GAME.current_round.discards_left == 0 then
            return {
		message = localize{type='variable',key='a_xmult',vars={2}},
		Xmult_mod = 2
			}
		end
        end
end

-- endregion Feather
-- region Limitless (debug instant win joker)

local joker_limitless = SMODS.Joker:new("Limitless", "limitless", {} , {
    x = 0,
    y = 1
}, loc_limitless, 3, 9999, false, false, false, true, "", "b_cccjokers")

joker_limitless:register()
function SMODS.Jokers.j_limitless.loc_def(card)
    return {card.ability.chips}
end

function SMODS.Jokers.j_limitless.set_ability(card, initial, delay_sprites)
    card.ability.chips = 0
    card.ability.extra = 1
end

function SMODS.Jokers.j_limitless.calculate(self, context)
    if context.setting_blind and not self.getting_sliced then
        G.E_MANAGER:add_event(Event({func = function()
            self.ability.extra = self.ability.extra*2

            --G.GAME.blind.chips = G.GAME.blind.chips*self.ability.extra
            --G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

            card_eval_status_text(self, 'extra', nil, nil, nil, {message = "Blind Increased!"})
        return true end }))
    elseif context.end_of_round then 
        self.ability.chips = 10000000 -- G.GAME.chips
    elseif context.cardarea == G.jokers and not context.before and not context.after then
        return {
            message = localize{type='variable',key='a_chips',vars={self.ability.chips or 0}},
            chip_mod = self.ability.chips or 10000000
        }
    end
end

function SMODS.Jokers.j_limitless.set_badges(card, badges)
    badges[#badges+1] = create_badge('Good luck', HEX('000000'), HEX('FFFFFF'), 1.2)
end
-- endregion Limitless  
-- region Bird

local joker_bird = SMODS.Joker:new("Bird", "bird", { atlas="b_cccjokers" }, {
    x = 2,
    y = 0
}, loc_bird, 3, 8, true, true, true, true, "", "b_cccjokers")

joker_bird:register()

SMODS.Jokers.j_bird.set_ability = function(self, context)
    sendDebugMessage("Hello !", 'MyLogger')
end

SMODS.Jokers.j_bird.calculate = function(self, context)
    if context.using_consumeable then
    if context.consumeable.ability.set == 'Planet'  then
    if G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or (G.GAME.blind:get_type() == "Small") or (G.GAME.blind:get_type() == "Big") or (G.GAME.blind:get_type() == "Boss") then
        return {
    G.E_MANAGER:add_event(Event({
                        func = function() 
            card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = "+3 Cards", colour = G.C.FILTER})
            G.FUNCS.draw_from_deck_to_hand(3)          
                            return true
            end}))}
    end
        end
    end
end


-- endregion
sendDebugMessage("[CCC] Jokers loaded")
----------------------------------------------
------------MOD CODE END----------------------
