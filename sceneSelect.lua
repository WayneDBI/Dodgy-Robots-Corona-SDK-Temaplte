---------------------------------------------------------------------------------
-- scene 2.lua
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Import all modules required to run our game / this interface
---------------------------------------------------------------------------------
local composer      = require( "composer" )
local widget        = require( "widget" )
local globals       = require( "lib.globalData" )
local loadsave      = require( "lib.loadsave" )
local helper        = require( "lib.helper" )
local slideshow     = require( "lib.slideshow" )
local levelData     = require( "sceneLevelData" )
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
globals.highScore    = saveDataTable.highScore    -- Saved High Score
globals.coins        = saveDataTable.coins        -- Coins collected (Total) ?

---------------------------------------------------------------------------------
-- Define quick reference variables
---------------------------------------------------------------------------------
local screenWidth     = globals._w
local screenHeight    = globals._h
local screenCentre_X  = globals._w / 2
local screenCentre_Y  = globals._h / 2


---------------------------------------------------------------------------------
-- Define Game local variables here
---------------------------------------------------------------------------------
local levelSelected = 0
local levelRequiredCoins = 0

--Button information text
--[[
local notEnoughHeader   = "Not enough Coins"
local notEnoughBody     = "You don't have enough coins to unlock this level."
local messageAreYouSure = "Are you sure you want to unlock this level?"
local infoCancel        = "Cancel"
local infoUnlock        = "Unlock Level"
local infoOK            = "Aww man !!"
--]]
---------------------------------------------------------------------------------
-- Setup scene Groups
-- Each group to hold our game design parts
---------------------------------------------------------------------------------
local groupInfo             = display.newGroup()
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

    local function triggerReload()
        composer.gotoScene( "sceneSelectUpdate")
    end


    local function unlockLevelFunction( )
        if (levelSelected == 1) then
            saveDataTable.coins = saveDataTable.coins - globals.unlockCoinsLevel1
            saveDataTable.level1Unlocked  = true
            saveDataTable.player1Unlocked = true
        elseif (levelSelected == 2) then
            saveDataTable.coins = saveDataTable.coins - globals.unlockCoinsLevel2
            saveDataTable.level2Unlocked  = true
            saveDataTable.player2Unlocked = true
        elseif (levelSelected == 3) then
            saveDataTable.coins = saveDataTable.coins - globals.unlockCoinsLevel3
            saveDataTable.level3Unlocked  = true
            saveDataTable.player3Unlocked = true
        end

        --Save the action on users device
        loadsave.saveTable(saveDataTable, globals.saveDataFileName..".json")

        --Prepare the level and game variables, with the adjusted data
        globals.coins           = saveDataTable.coins
        globals.levelStartIndex = levelSelected
        globals.level           = levelSelected

        -- reload the Level Select screen, with updated details
        local levelSelectReload = timer.performWithDelay(150, triggerReload )

    end


    local function messgeNotEnough( event )
        if ( event.action == "clicked" ) then
            local i = event.index

            if ( i == 1 ) then
                -- Do nothing; dialog will simply dismiss
            end

        end
    end

    local function showUnlockMessage( event )
        if ( event.action == "clicked" ) then
            local i = event.index

            if ( i == 1 ) then
                -- Do nothing; dialog will simply dismiss
            elseif ( i == 2 ) then
                -- User wants to unlock the level
                unlockLevelFunction()
            end

        end
    end
          

    local function startGame()

        audio.stop()
        audio.dispose( globals.musicMenu )
        --audio.dispose( globals.sfx_Fail1 )  
        audio.dispose() 

        composer.gotoScene( "scene1") --This is our main menu
        --buttonClicked = false
    end




    local function touchEvent( event )
        -- We passed the name of the area being touched
        -- With this information we can work out what to do next
        local targetPosition = event.target.id


        if event.phase == "began" then

        elseif event.phase == "ended" then

            print("targetPosition: "..targetPosition)

            if (targetPosition == "play_1") then
                globals.level = 1
                levelSelected = 1
                timer.performWithDelay(150, startGame )
            elseif (targetPosition == "play_2") then
                globals.level = 2
                levelSelected = 2
                timer.performWithDelay(150, startGame )
            elseif (targetPosition == "play_3") then
                globals.level = 3
                levelSelected = 3
                timer.performWithDelay(150, startGame )
            elseif (targetPosition == "unlock_1") then
                levelSelected = 1
                if (saveDataTable.coins >= globals.unlockCoinsLevel1) then
                    local alert = native.showAlert( "Unlock Level "..levelSelected, levelData.messageAreYouSure, { levelData.infoCancel, levelData.infoUnlock }, showUnlockMessage )
                else
                    local alert = native.showAlert( levelData.notEnoughHeader, levelData.notEnoughBody, {levelData.infoOK}, messgeNotEnough )
                end
            elseif (targetPosition == "unlock_2") then
                levelSelected = 2
                if (saveDataTable.coins >= globals.unlockCoinsLevel2) then
                    local alert = native.showAlert( "Unlock Level "..levelSelected, levelData.messageAreYouSure, { levelData.infoCancel, levelData.infoUnlock }, showUnlockMessage )
                else
                    local alert = native.showAlert( levelData.notEnoughHeader, levelData.notEnoughBody, {levelData.infoOK}, messgeNotEnough )
                end
            elseif (targetPosition == "unlock_3") then
                levelSelected = 3
                if (saveDataTable.coins >= globals.unlockCoinsLevel3) then
                    local alert = native.showAlert( "Unlock Level "..levelSelected, levelData.messageAreYouSure, { levelData.infoCancel, levelData.infoUnlock }, showUnlockMessage )
                else
                    local alert = native.showAlert( levelData.notEnoughHeader, levelData.notEnoughBody, {levelData.infoOK}, messgeNotEnough )
                end
            end

        end

        return true
    end

        function backToMenuFunction() 
            composer.gotoScene( "sceneMenu") --This is our main game
        end

    local function backTouch( event )
        -- We passed the name of the area being touched
        -- With this information we can work out what to do next
        if event.phase == "began" then

        elseif event.phase == "ended" then
            
            timer.performWithDelay(50, backToMenuFunction )

        end

        return true
    end





    -----------------------------------------------------------------
    -- Create the Background Area
    -----------------------------------------------------------------
    --local backgroundImage        = display.newRect( 0, 0, 384,693 )
    local backgroundImage        = display.newImageRect( globals.imagePath.."Background1.png", 384,693 )
    backgroundImage.x            = screenCentre_X
    backgroundImage.y            = screenCentre_Y
    --backgroundImage:setFillColor(   helper.hex2rgb("#f2d118") )

    -- Insert the Background Image/Area into the Background Group
    groupInfo:insert( backgroundImage )



    -----------------------------------------------------------------
    -- Add a HOME Button [ homeButton ]
    -----------------------------------------------------------------
    local homeButton              = display.newImageRect( globals.imagePath.."buttonHome.png", 32, 32 )
    --homeButton              = display.newRect( 0, 0, 32, 32 )
    homeButton.id           = "Sound"
    homeButton.x            = 25
    homeButton.y            = 40
    homeButton.rotation     = 0
    homeButton.alpha        = 1
    --homeButton.strokeWidth  = 1
    --homeButton:setFillColor( helper.hex2rgb("#265c78") )
    --homeButton:setStrokeColor( helper.hex2rgb("#FFFFFF") )

     -- Add a Touch listener to the Sound Button / Rectangle
    homeButton:addEventListener( "touch", backTouch )

    -- Insert Tap to Start into the Top Group
    groupInfo:insert( homeButton )


    -----------------------------------------------------------------
    -- Show Coins Collected [ coinsText ]
    -- Fonts: [ globals.font1 ] [ globals.font2 ] [ globals.font3 ]
    --        [ globals.font4 ] [ globals.font5 ] [ globals.font6 ]
    -----------------------------------------------------------------
    -- bmf:newString( [the font to use], [the text to show] )
    -----------------------------------------------------------------
    local levelSelectText = bmf:newString( globals.font1, "Level SeLect" )
    levelSelectText.align = "center"
    levelSelectText.xScale = 0.46
    levelSelectText.yScale = 0.46
    levelSelectText.alpha = 1.0
    levelSelectText.x = screenCentre_X
    levelSelectText.y = screenCentre_Y - 190
    groupInfo:insert(levelSelectText)


    -----------------------------------------------------------------
    -- Create Rectangle to show a coin image [ coinImage ]
    -----------------------------------------------------------------
    local coinImage        = display.newImageRect( globals.imagePath.."CoinImage.png", 38, 38 )
    --local coinImage        = display.newRect( 0, 0, 38, 38 )
    coinImage.id           = "CoinImage"
    coinImage.x            = screenCentre_X + 40
    coinImage.y            = levelSelectText.y + 28
    coinImage.alpha        = 1.0
    --coinImage.strokeWidth  = 1
    --coinImage:setFillColor(   helper.hex2rgb("#8c623c") )
    --coinImage:setStrokeColor( helper.hex2rgb("#FFFFFF") )

    -- Insert the local coinImage into the Game Over Group
    groupInfo:insert( coinImage )


    -----------------------------------------------------------------
    -- Show Coins Collected [ coinsText ]
    -- Fonts: [ globals.font1 ] [ globals.font2 ] [ globals.font3 ]
    --        [ globals.font4 ] [ globals.font5 ] [ globals.font6 ]
    -----------------------------------------------------------------
    -- bmf:newString( [the font to use], [the text to show] )
    -----------------------------------------------------------------
    local coinsText = bmf:newString( globals.font1, globals.coins )
    coinsText.align = "right"
    coinsText.xScale = 0.6
    coinsText.yScale = 0.6
    coinsText.alpha = 1.0
    coinsText.x = coinImage.x - 20
    coinsText.y = coinImage.y + 31
    groupInfo:insert(coinsText)


    -----------------------------------------------------------------
    -- Show Coins Collected [ coinsText ]
    -- Fonts: [ globals.font1 ] [ globals.font2 ] [ globals.font3 ]
    --        [ globals.font4 ] [ globals.font5 ] [ globals.font6 ]
    -----------------------------------------------------------------
    -- bmf:newString( [the font to use], [the text to show] )
    -----------------------------------------------------------------
    local yourCoinsText = bmf:newString( globals.font1, "Your Coins" )
    yourCoinsText.align = "center"
    yourCoinsText.xScale = 0.4
    yourCoinsText.yScale = 0.4
    yourCoinsText.alpha = 1.0
    yourCoinsText.x = screenCentre_X
    yourCoinsText.y = coinsText.y + 40
    groupInfo:insert(yourCoinsText)






    --Insert the Info group into the main Scene Group
    sceneGroup:insert( groupInfo )


    local function createSlideshowObjects(numberOfObjects)    
        local objects             = {}
        local unlockedLevelState  = {}
        local unlockedPlayerState = {}
        local unlockValue         = {}

        --Collect the saved content states of the UNLOCKED levels / players.
        for i = 1, numberOfObjects do
            if (i == 1) then
                unlockedLevelState[#unlockedLevelState + 1]   = saveDataTable.level1Unlocked
                unlockedPlayerState[#unlockedPlayerState + 1] = saveDataTable.player1Unlocked
                unlockValue[#unlockValue + 1] = globals.unlockCoinsLevel1
            elseif (i == 2) then
                unlockedLevelState[#unlockedLevelState + 1]   = saveDataTable.level2Unlocked
                unlockedPlayerState[#unlockedPlayerState + 1] = saveDataTable.player2Unlocked
                unlockValue[#unlockValue + 1] = globals.unlockCoinsLevel2
            elseif (i == 3) then
                unlockedLevelState[#unlockedLevelState + 1]   = saveDataTable.level3Unlocked
                unlockedPlayerState[#unlockedPlayerState + 1] = saveDataTable.player3Unlocked
                unlockValue[#unlockValue + 1] = globals.unlockCoinsLevel3
            end
        end

        --Create the level select panels - and logic.
        for i = 1, numberOfObjects do

            -- Each slideshow object is added to its own display group.
            local group = display.newGroup()     
       
            local levelImage = display.newImageRect( globals.imagePath.."levelSelect"..i..".png", 184,242 )
            --local levelImage = display.newRect(0, 0, 184,242)
            --levelImage.fillColor = { math.random(), math.random(), math.random(), 1 }         
            --levelImage:setFillColor(unpack(levelImage.fillColor))
            group:insert(levelImage)    

            if (unlockedLevelState[i] == false) then
                local unlockButton = display.newImageRect( globals.imagePath.."unlock.png", 208,88 )
                --local unlockButton = display.newRect(0,84,208,88)
                unlockButton.x = 6
                unlockButton.y = 84
                unlockButton.alpha = 1.0       
                --unlockButton.fillColor = { math.random(), math.random(), math.random(), 2 }         
                --unlockButton:setFillColor(unpack(unlockButton.fillColor))
                unlockButton.id = "unlock_"..i
                unlockButton:addEventListener( "touch", touchEvent )
                group:insert(unlockButton) 

                --local coinImage        = display.newRect( 0, 0, 32, 32 )
                local coinImage        = display.newImageRect( globals.imagePath.."CoinImage.png", 32, 32 )
                coinImage.id           = "CoinImage"
                coinImage.x            = levelImage.x + (levelImage.width/2) - 25
                coinImage.y            = levelImage.y - (levelImage.height/2) + 25
                coinImage.alpha        = 1.0
                group:insert(coinImage) 

                local yourCoinsText = bmf:newString( globals.font1, unlockValue[i] )
                yourCoinsText.align = "right"
                yourCoinsText.xScale = 0.4
                yourCoinsText.yScale = 0.4
                yourCoinsText.alpha = 1.0
                yourCoinsText.x = coinImage.x - 17
                yourCoinsText.y = coinImage.y + 21
                group:insert(yourCoinsText)

            end

            objects[#objects + 1] = group

            local playButton = display.newImageRect( globals.imagePath.."buttonSelect.png", 174,50 )
            --local playButton = display.newRect(0,160,174,50)
            playButton.x = 0
            playButton.y = 160
            --playButton.fillColor = { math.random(), math.random(), math.random(), 2 }         
            --playButton:setFillColor(unpack(playButton.fillColor))
            playButton.id = "play_"..i
            playButton:addEventListener( "touch", touchEvent )
            group:insert(playButton)   

            if (unlockedLevelState[i] == true) then
                playButton.alpha = 1.0
            else
                playButton.alpha = 0.0
            end
            sceneGroup:insert( group )


        end

        return objects
    end



    --[[
    Create and return a display group containing a thumbnail for each of the slideshow objects
    --]]
    function createThumbnails(slideshowObjects)
        local group = display.newGroup()    
        local thumbSize = 30
        local thumbMargin = 10
        
        for i = 1, #slideshowObjects do
            -- Since we added the slideshow objects to a display group, we get the first (only) object of the group here to find out its color
            local obj = slideshowObjects[i][1]
            local thumb = display.newCircle((i - 1) * (thumbSize + thumbMargin), 0, thumbSize / 2, thumbSize / 2)        
            thumb:setFillColor(unpack(obj.fillColor))
            thumb:setStrokeColor(1, 1, 1, 1.0)
            thumb.strokeWidth = 0
            thumb.anchorX = 0
            
            -- Setup a tap handler for each thumb that will quick jump to selected object index
            thumb:addEventListener("tap", function()
                local disableTransition = false
                slideshow.showObjectAtIndex(i, disableTransition)
            end)
            
            group:insert(thumb)
        end

        group.x = display.contentCenterX - (#slideshowObjects / 2 * (thumbSize + thumbMargin))
        group.y = display.contentHeight - 100

        sceneGroup:insert( group )

        return group
    end

    math.randomseed( os.time() )

    -- Setup the objects and thumbnails to use for the slideshow
    local slideshowObjects = createSlideshowObjects( globals.numberOfLevels )
    --local thumbnailsGroup = createThumbnails(slideshowObjects)

    local function updateThumbnails(selectedObjectIndex)
        -- Highlight the stroke of the selected object's corresponding thumbnail
        for i = 1, thumbnailsGroup.numChildren do
            local thumb = thumbnailsGroup[i]
            if (i == selectedObjectIndex) then
                thumb.strokeWidth = 3            
            else
                thumb.strokeWidth = 0
            end
        end
    end

    --[[
    Start the slideshow
    This example shows all the customizable parameters, but all the parameters are optional
    --]]
    local slideshowParams = {    
        startIndex = globals.levelStartIndex,
        transitionEffect = easing.outCubic,
        transitionEffectTimeMs = 250,
        y = display.contentCenterY + 70 ,
        swipeSensitivityPixels = 50,
        --onChange = updateThumbnails,
    }
    slideshow.init(slideshowObjects, slideshowParams)




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
