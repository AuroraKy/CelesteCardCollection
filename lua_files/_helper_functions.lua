


-- print contents of table (Debug)
function dump(o, i)
    i = i or 5
    if i <= 0 then
        return "..."
    end
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v, i-1) .. ','
       end
       return s .. '} '
    elseif type(o) == "function" then
      local info = debug.getinfo(o, "nS")
      return "FUNCTION{ " .. "linedefined: " .. info.linedefined .. ", source: " .. info.source .. " }"
    else
       return tostring(o)
    end
end


CCCHELPER = {}

function CCCHELPER.in_pack()
   return  G.STATE == G.STATES.TAROT_PACK or 
           G.STATE == G.STATES.PLANET_PACK or 
           G.STATE == G.STATES.SPECTRAL_PACK or 
           G.STATE == G.STATES.STANDARD_PACK or 
           G.STATE == G.STATES.BUFFOON_PACK
end

-- check if table has an item
function CCCHELPER.has_value (tab, val)
   for index, value in ipairs(tab) do
       if value == val then
           return true
       end
   end

   return false
end

-- Joker in possession?

function CCCHELPER.has_joker(card, debuffed)
   return #SMODS.find_card(card, debuffed or false) >= 1
end