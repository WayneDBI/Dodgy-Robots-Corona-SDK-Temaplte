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
local levelData     = require( "sceneLevelData" )
local scene         = composer.newScene()


---------------------------------------------------------------------------------
-- Scene setup
-- "scene:create()"
---------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view

        -- Remove any previous Composer Scenes
        composer.removeScene( "sceneSelect" )
        composer.removeScene( "scene1" )
        composer.removeScene( "sceneMenu" )

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

        --Reset core variables to setup state
        saveDataTable.level                 = 1
        saveDataTable.highScore             = 0
        saveDataTable.playerSelect          = 1
        saveDataTable.coins                 = 0
        saveDataTable.player1Unlocked       = true
        saveDataTable.player2Unlocked       = false
        saveDataTable.player3Unlocked       = false
        saveDataTable.level1Unlocked        = true
        saveDataTable.level2Unlocked        = false
        saveDataTable.level3Unlocked        = false

        ---------------------------------------------------------------------------------
        -- Save the new json file, for referencing later..
        ---------------------------------------------------------------------------------
        loadsave.saveTable(saveDataTable, globals.saveDataFileName..".json")

        ---------------------------------------------------------------------------------
        -- Load in the Data
        ---------------------------------------------------------------------------------
        saveDataTable = loadsave.loadTable(globals.saveDataFileName..".json")
        ---------------------------------------------------------------------------------

        globals.levelStartIndex     = 1                          -- Level Select start position
        globals.unlockCoinsLevel1   = levelData.coinsRequired[1] -- How many Coimns to unlock Level 1?
        globals.unlockCoinsLevel2   = levelData.coinsRequired[2] -- How many Coimns to unlock Level 2?
        globals.unlockCoinsLevel3   = levelData.coinsRequired[3] -- How many Coimns to unlock Level 3?
        globals.numberOfLevels      = 3                          -- How many levels does our game have?
        globals.level               = 1                          -- Level the player is at
        globals.highScore           = 0                          -- Saved High Score
        globals.playerSelect        = 1                          -- Which player enabled ?
        globals.coins               = 0                          -- Coins collected ?
        globals.player1Unlocked     = saveDataTable.player1Unlocked -- is player 1 unlocked
        globals.player2Unlocked     = saveDataTable.player2Unlocked -- is player 2 unlocked
        globals.player3Unlocked     = saveDataTable.player3Unlocked -- is player 3 unlocked
        globals.level1Unlocked      = saveDataTable.level1Unlocked -- is level 1 unlocked
        globals.level2Unlocked      = saveDataTable.level2Unlocked -- is level 1 unlocked
        globals.level3Unlocked      = saveDataTable.level3Unlocked -- is level 1 unlocked


        local function resetApp()
            composer.gotoScene( "sceneMenu") --This is our main menu
            --buttonClicked = false
        end


        -- Start game engine after short delay
        timer.performWithDelay(250, resetApp )

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