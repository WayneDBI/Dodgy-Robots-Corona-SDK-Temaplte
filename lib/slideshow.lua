--[[
Corona SDK slideshow module
Handles a number of display objects/groups, displaying only one at a time.
Allows user to swipe left/right to change displayed object. 
Uses callbacks to update other parts of the program when a new object is displayed.

Markus Ranner 2016
--]]

-- State
local _slideshowObjects
local _currentObjectIndex
local _transitionEffectTimeMs
local _transitionEffect
local _swipeSensitivityPixels
local _onChange

local function showObject(objectIndex, disableTransition)
    
    local objectToShow = _slideshowObjects[objectIndex]
    
    -- Update current object index and make a callback if selected object has changed
    if(_currentObjectIndex ~= objectIndex) then
        _currentObjectIndex = objectIndex
        if (_onChange) then
            _onChange(_currentObjectIndex)
        end
    end        
    
    -- Transition all slideshow objects into place
    for i = 1, #_slideshowObjects do
        local object = _slideshowObjects[i]
        local x = _slideshowObjects[i].originalPosition.x - ((objectIndex - 1) * display.contentWidth)
        
        -- If transition has been disabled, update position immediately
        if (disableTransition) then
            object.x = x
        else
            transition.to(object, {
                x = x,            
                time = _transitionEffectTimeMs,            
                transition = _transitionEffect,
            })
        end
    end

end

local function handleSwipe( event )
    local swipedObject = event.target    
    local swipeDistanceX = event.x - event.xStart
    
    if (event.phase == "began") then
        -- Set a focus flag on the object, so that we don't handle touch events that weren't started on the same object
        swipedObject.hasFocus = true
        -- This redirects all futre touch events to the swiped object, even when touch moves outside of its bounds
        display.getCurrentStage():setFocus( swipedObject )            
    elseif ( event.phase == "moved" ) then
        
        if (swipedObject.hasFocus) then
            
            -- Move all objects according to swipe gesture
            for i = 1, #_slideshowObjects do
                local object = _slideshowObjects[i]
                local offsetX = -((_currentObjectIndex - 1) * display.contentWidth)
                local x = object.originalPosition.x + offsetX + swipeDistanceX                
                object.x = x
            end
        end
    elseif( event.phase == "ended" ) then
        -- Reset touch event focus
        swipedObject.hasFocus = false
        display.getCurrentStage():setFocus( nil )            
        
        -- Calculate which object to show next, preventing swiping too far left or right
        local nextObjectIndex = _currentObjectIndex
        if((swipeDistanceX >= _swipeSensitivityPixels) and (_currentObjectIndex > 1)) then
            nextObjectIndex = _currentObjectIndex - 1
        elseif((swipeDistanceX <= -_swipeSensitivityPixels) and (_currentObjectIndex < #_slideshowObjects)) then
            nextObjectIndex = _currentObjectIndex + 1
        end
        
        -- Finally, show the selected object in the slideshow
        showObject(nextObjectIndex)
        
    elseif( event.phase == "cancelled" ) then
        -- Reset touch event focus
        swipedObject.hasFocus = false
        display.getCurrentStage():setFocus( nil )            
    end
    
    return true
end     

local function showObjectAtIndex(objectIndex, disableTransition)
    showObject(objectIndex, disableTransition)
end

local function init( slideshowObjects, params ) 
    if (not params) then
        params = {}
    end
    
    -- Set initial state for slideshow component
    _transitionEffect = params.transitionEffect or easing.outCirc
    _transitionEffectTimeMs = params.transitionEffectTimeMs or 200
    _slideshowObjects = slideshowObjects
    _swipeSensitivityPixels = params.swipeSensitivityPixels or 100
    _onChange = params.onChange or nil
    
    local y = params.y or display.contentCenterY
    
    -- Position each slideshow object and setup a touch handler for each one
    for i = 1, #slideshowObjects do
        local obj = slideshowObjects[i]
        
        -- Set initial position for every slideshow object        
        obj.x = display.contentCenterX + ((i - 1) * display.contentWidth)
        obj.y = y
        
        -- For display groups, we need to set the anchorChildren property to true to correctly position the child objects
        obj.anchorChildren = true
        
        -- The originalPosition will be used to position all slideshow objects correctly while swiping
        obj.originalPosition = { x = obj.x , y = obj.y }
        
        obj:addEventListener( "touch", handleSwipe )     
    end
    
    -- Show selected start object
    local startIndex = params.startIndex or 1
    local disableTransition = true
    showObject(startIndex, disableTransition)
end

local function cleanUp()
    _slideshowObjects = nil    
    _currentObjectIndex = nil
end

return {
    init = init,
    cleanUp = cleanUp,
    showObjectAtIndex = showObjectAtIndex,
}