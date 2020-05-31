---------------------------------------------------------------------------------
-- scene 3.lua
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Import all modules required to run our game / this interface
---------------------------------------------------------------------------------
local composer      = require( "composer" )
local widget        = require( "widget" )
local globals       = require( "lib.globalData" )
local loadsave      = require( "lib.loadsave" )
local helper        = require( "lib.helper" )
local scene         = composer.newScene()


---------------------------------------------------------------------------------
-- Create a Randomseed value from the os.time()
---------------------------------------------------------------------------------
math.randomseed( os.time() )



---------------------------------------------------------------------------------
-- Load in the latest Data from the users devcie
---------------------------------------------------------------------------------
saveDataTable = loadsave.loadTable(globals.saveDataFileName..".json")



---------------------------------------------------------------------------------
-- Assign the Level and other variables to the game variables.
---------------------------------------------------------------------------------
globals.Level        = saveDataTable.level        -- Level the player is at
globals.highScore    = saveDataTable.highScore    -- Saved High Score
globals.playerSelect = saveDataTable.playerSelect -- Which player enabled ?



---------------------------------------------------------------------------------
-- Define Game local variables here
---------------------------------------------------------------------------------
local myVariable = 1



---------------------------------------------------------------------------------
-- Setup scene Groups
-- Each group to hold our game design parts
---------------------------------------------------------------------------------
local groupBackground       = display.newGroup()



---------------------------------------------------------------------------------
-- Scene Create
-- Called when the scene's view does not exist
---------------------------------------------------------------------------------
function scene:create( event )
    local sceneGroup = self.view

    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc

    -- Remove any previous Composer Scenes
    --composer.removeScene( "gameEngine" )

end


---------------------------------------------------------------------------------
-- Scene Show
-- Called when the scene is still off screen and is about to move on screen
---------------------------------------------------------------------------------
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen

    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc
                
    end 
end


---------------------------------------------------------------------------------
-- Scene Hide
-- Called when the scene is on screen and is about to move off screen
---------------------------------------------------------------------------------
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.)

    elseif phase == "did" then
        -- Called when the scene is now off screen
        -- Remove all Event Listeners

    end 
end


---------------------------------------------------------------------------------
-- Scene Hide
-- Called prior to the removal of scene's "view" (sceneGroup)
---------------------------------------------------------------------------------
function scene:destroy( event )
    local sceneGroup = self.view

    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc
end

---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Listener setup
-- Event Listeners are called every cycle of the app
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Return Scene
-- Inform the Game Engine everything is configured - start
---------------------------------------------------------------------------------
return scene
