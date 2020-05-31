---------------------------------------------------------------------------------
-- sceneReset.lua
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Load external modules as required.
---------------------------------------------------------------------------------
local composer      = require( "composer" )
local widget        = require( "widget" )
local globals       = require( "lib.globalData" )
local loadsave      = require( "lib.loadsave" )
local helper        = require( "lib.helper" )
local scene         = composer.newScene()


---------------------------------------------------------------------------------
-- Scene setup
-- "scene:create()"
---------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view

        -- Remove any previous Composer Scenes
        composer.removeScene( "sceneSelect" )

    -- Initialize the scene here
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end



---------------------------------------------------------------------------------
-- Scene setup
-- "scene:show()"
---------------------------------------------------------------------------------
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase


    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen)


        local function refreshLevelSelect()
            composer.gotoScene( "sceneSelect") --This is our main menu
            --buttonClicked = false
        end


        -- Start game engine after short delay
        timer.performWithDelay(150, refreshLevelSelect )

        ---------------------------------------------------------------------------------




    elseif ( phase == "did" ) then

        ---------------------------------------------------------------------------------
        -- Animate all the scene elements into position
        ---------------------------------------------------------------------------------


        -- Called when the scene is now on screen
        -- Insert code here to make the scene come alive
        -- Example: start timers, begin animation, play audio, etc.
    end
end





---------------------------------------------------------------------------------
-- Function "scene:hide()"
---------------------------------------------------------------------------------
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen)
        -- Insert code here to "pause" the scene
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen
    end
end


---------------------------------------------------------------------------------
-- Function "scene:destroy()"
---------------------------------------------------------------------------------
function scene:destroy( event )

    local sceneGroup = self.view


    --Runtime:removeEventListener( "enterFrame", handleEnterFrame)

    -- Called prior to the removal of scene's view
    -- Insert code here to clean up the scene
    -- Example: remove display objects, save state, etc.
end





---------------------------------------------------------------------------------
-- Listener setup
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------
-- Return the Scene
---------------------------------------------------------------------------------
return scene