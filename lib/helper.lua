module( ..., package.seeall )


local json = require("json")
 
---------------------------------------------------------------------------------
-- Convert RGB Values to Coronas method
---------------------------------------------------------------------------------
function getRGB(value)
    return value/255
end

---------------------------------------------------------------------------------
-- Convert HEX Colour Values to Coronas method
---------------------------------------------------------------------------------
function hex2rgb (hex)
    local hex = hex:gsub("#","")
    local r, g, b = tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
    return r/255, g/255, b/255
end


---------------------------------------------------------------------------------
-- Format number
---------------------------------------------------------------------------------
function numberFormat(num, places)
    
    local isNegative = false; if num < 0 then isNegative = true end
    local num = math.abs(num)
    local ret
    local placeValue = ("%%.%df"):format(places or 0)
    if not num then
        return 0
    elseif num >= 1000000000000 then
        ret = placeValue:format(num / 1000000000000) .. " TRIL" -- trillion
    elseif num >= 1000000000 then
        ret = placeValue:format(num / 1000000000) .. " BIL" -- billion
    elseif num >= 1000000 then
        ret = placeValue:format(num / 1000000) .. " MIL" -- million
    elseif num >= 1000 then
        ret = string.gsub(num, "^(-?%d+)(%d%d%d)", '%1,%2')
        -- ret = placeValue:format(num / 1000) .. "k" -- thousand
    else
        ret = num -- hundreds
    end
    
    --local currency = "£"
    --if isNegative then currency = "-£" end  
    --return currency .. ret
    
    return ret
end

---------------------------------------------------------------------------------
-- Non Physics based Collision detection.
---------------------------------------------------------------------------------
-- Rectangle Based
---------------------------------------------------------------------------------
function hasCollided(obj1, obj2)
    if obj1 == nil then
     return false
    end
     if obj2 == nil then
        return false
    end
        local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
        local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
        local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
        local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
        return (left or right) and (up or down)

    end

---------------------------------------------------------------------------------
-- Circle Based
---------------------------------------------------------------------------------
function hasCollidedCircle(obj1, obj2)
    if obj1 == nil then
        return false
    end 
    if obj2 == nil then
        return false
    end 
    local sqrt = math.sqrt
    local dx = obj1.x - obj2.x
    local dy = obj1.y - obj2.y
    local distance = sqrt(dx*dx + dy*dy)
    local objectSize = (obj2.contentWidth/2) + (obj1.contentWidth/2)
    if distance < objectSize then
        return true
    end
    return false
end


---------------------------------------------------------------------------------
-- Get a random number, but exclude certain values.
---------------------------------------------------------------------------------
--eg: local exclude={1,5,9}
function getRandomPosition(n, exclude)
  local new={}
  for i=1,n do
    if not table.indexOf( exclude, i ) then new[1+#new]=i end
  end
  if #new==0 then print("too much exclusions") return end

  return new[math.random(#new)]
end






