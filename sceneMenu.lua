---------------------------------------------------------------------------------
-- sceneMenu.lua
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Load external modules as required.
local composer      = require( "composer" )
local widget        = require( "widget" )
local globals       = require( "lib.globalData" )
local loadsave      = require( "lib.loadsave" )
local helper        = require( "lib.helper" )
local levelData     = require( "sceneLevelData" )
local scene         = composer.newScene()

---------------------------------------------------------------------------------
-- Load in the latest Data from the users devcie
---------------------------------------------------------------------------------
saveDataTable = loadsave.loadTable(globals.saveDataFileName..".json")


---------------------------------------------------------------------------------
-- Assign the Level and other variables to the game variables.
---------------------------------------------------------------------------------
globals.level        = saveDataTable.level        -- Level the player is at
globals.highScore    = saveDataTable.highScore    -- Saved High Score
globals.playerSelect = saveDataTable.playerSelect -- Which player enabled ?
globals.coins        = saveDataTable.coins        -- Coins collected (Total) ?


---------------------------------------------------------------------------------
-- Define quick reference variables
---------------------------------------------------------------------------------
local screenWidth     = globals._w
local screenHeight    = globals._h
local screenCentre_X  = globals._w / 2
local screenCentre_Y  = globals._h / 2
local screenLeft      = 0
local screenRight     = globals._w
local screenTop       = 0
local screenBottom    = globals._h

---------------------------------------------------------------------------------
-- Scene setup
-- "scene:create()"
---------------------------------------------------------------------------------

function scene:create( event )

    local sceneGroup = self.view

    -- Remove any previous Composer Scenes
    composer.removeScene( "sceneSelect" )
    composer.removeScene( "scene1" )

    -- Initialize the scene here
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.

    -----------------------------------------------------------------
    -- Create Touch Zone messages and actions
    -----------------------------------------------------------------
    local function resetInfo( event )
        if ( event.action == "clicked" ) then
            local i = event.index

            if ( i == 1 ) then
                -- Do nothing; dialog will simply dismiss
            elseif ( i == 2 ) then
                -- User wants to unlock the level

                composer.gotoScene("sceneAppReset")
            end

        end
    end

    local function messageInfo( event )
        if ( event.action == "clicked" ) then
            local i = event.index

            if ( i == 1 ) then
                -- Do nothing; dialog will simply dismiss
            end

        end
    end


    local function infoShow( event )
        -- We passed the name of the area being touched
        -- With this information we can work out what to do next
        if event.phase == "began" then

        elseif event.phase == "ended" then
            
            -- show info panel
            local alert = native.showAlert( levelData.infoHeader, levelData.infoBody, {infoOK}, messageInfo )

        end

        return true
    end


    local function resetShow( event )
        -- We passed the name of the area being touched
        -- With this information we can work out what to do next
        if event.phase == "began" then

        elseif event.phase == "ended" then
            
            -- show info panel
            local alert = native.showAlert( levelData.resetHeader, levelData.resetBody, {"Cancel", "Reset"}, resetInfo )

        end

        return true
    end

    local function touchFunction( event )
        -- We passed the name of the area being touched
        -- With this information we can work out what to do next
        local touchName = event.target.id

        print("touchName: "..touchName)

        if event.phase == "began" then

        elseif event.phase == "ended" then
            
            if touchName == "Start" then
                gameStartFunction()
            end

        end

        return true
    end

        local function specialAction( event )
        -- We passed the name of the area being touched
        -- With this information we can work out what to do next
        if event.phase == "began" then

        elseif event.phase == "ended" then
            
            saveDataTable.player1Unlocked       = true
            saveDataTable.player2Unlocked       = false
            saveDataTable.player3Unlocked       = false
            saveDataTable.level1Unlocked        = true
            saveDataTable.level2Unlocked        = false
            saveDataTable.level3Unlocked        = false
            saveDataTable.coins                 = 300
            saveDataTable.highScore             = 250
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
            globals.level               = 1                          -- Level the player is at
            globals.highScore           = saveDataTable.highScore                          -- Saved High Score
            globals.playerSelect        = 1                          -- Which player enabled ?
            globals.coins               = saveDataTable.coins                          -- Coins collected ?
            globals.player1Unlocked     = saveDataTable.player1Unlocked -- is player 1 unlocked
            globals.player2Unlocked     = saveDataTable.player2Unlocked -- is player 2 unlocked
            globals.player3Unlocked     = saveDataTable.player3Unlocked -- is player 3 unlocked
            globals.level1Unlocked      = saveDataTable.level1Unlocked -- is level 1 unlocked
            globals.level2Unlocked      = saveDataTable.level2Unlocked -- is level 1 unlocked
            globals.level3Unlocked      = saveDataTable.level3Unlocked -- is level 1 unlocked

        end

        return true
    end



    -----------------------------------------------------------------
    -- Create the Background Area
    -----------------------------------------------------------------
    --local backgroundImage        = display.newRect( 0, 0, 384, 693 )
    local backgroundImage        = display.newImageRect( globals.imagePath.."Background1.png", 384, 693 )
    backgroundImage.x            = screenCentre_X
    backgroundImage.y            = screenCentre_Y
    --backgroundImage:setFillColor(   helper.hex2rgb("#6b9f6b") )

    -- Insert the Background Image/Area into the Background Group
    sceneGroup:insert( backgroundImage )

    -----------------------------------------------------------------
    -- Create Logo Area
    -----------------------------------------------------------------
    --local logoArea        = display.newRect( 0, 0, 284, 272)
    local logoArea        = display.newImageRect( globals.imagePath.."gameLogo.png", 284, 272 )
    logoArea.x            = screenCentre_X
    logoArea.y            = screenCentre_Y - 100
    --logoArea:setFillColor(   helper.hex2rgb("#6bf0a1") )

    -- Insert the Background Image/Area into the Background Group
    sceneGroup:insert( logoArea )



    -----------------------------------------------------------------
    -- Create Buttona Start Area
    -----------------------------------------------------------------
    --local buttonStart        = display.newRect( 0, 0, 122, 50)
    local buttonStart        = display.newImageRect( globals.imagePath.."buttonStart.png", 122, 50 )
    buttonStart.id           = "Start"
    buttonStart.x            = screenCentre_X
    buttonStart.y            = screenCentre_Y + 100
    --buttonStart:setFillColor(   helper.hex2rgb("#c27fa1") )

    -- Add a Touch listener to the Start Button
    buttonStart:addEventListener( "touch", touchFunction )

    -- Insert the Background Image/Area into the Background Group
    sceneGroup:insert( buttonStart )

    -----------------------------------------------------------------
    -- Add an INFO Button [ infoButton ]
    -----------------------------------------------------------------
    local infoButton         = display.newImageRect( globals.imagePath.."buttonInfo.png", 32, 32 )
    --infoButton             = display.newRect( 0, 0, 32, 32 )
    infoButton.id           = "Sound"
    infoButton.x            = 25
    infoButton.y            = 40
    infoButton.rotation     = 0
    infoButton.alpha        = 1
    --infoButton.strokeWidth  = 1
    --infoButton:setFillColor( helper.hex2rgb("#265c78") )
    --infoButton:setStrokeColor( helper.hex2rgb("#FFFFFF") )

     -- Add a Touch listener to the Sound Button / Rectangle
    infoButton:addEventListener( "touch", infoShow )

    -- Insert Tap to Start into the Top Group
    sceneGroup:insert( infoButton )


    -----------------------------------------------------------------
    -- Add a RESET Button [ resetButton ]
    -----------------------------------------------------------------
    local resetButton              = display.newImageRect( globals.imagePath.."buttonCog.png", 32, 32 )
    --resetButton              = display.newRect( 0, 0, 32, 32 )
    resetButton.id           = "Sound"
    resetButton.x            = screenWidth - 25
    resetButton.y            = 40
    resetButton.rotation     = 0
    resetButton.alpha        = 1
    --resetButton.strokeWidth  = 1
    --resetButton:setFillColor( helper.hex2rgb("#265c78") )
    --resetButton:setStrokeColor( helper.hex2rgb("#FFFFFF") )

     -- Add a Touch listener to the Sound Button / Rectangle
    resetButton:addEventListener( "touch", resetShow )

    -- Insert Tap to Start into the Top Group
    sceneGroup:insert( resetButton )

    local specialButton        = display.newImageRect( globals.imagePath.."buttonCog.png", 32, 32 )
    --specialButton            = display.newRect( 0, 0, 32, 32 )
    specialButton.id           = "Sound"
    specialButton.x            = 25
    specialButton.y            = screenHeight - 25
    specialButton.rotation     = 0
    specialButton.alpha        = 0.02
    --specialButton.strokeWidth  = 1
    --specialButton:setFillColor( helper.hex2rgb("#265c78") )
    --specialButton:setStrokeColor( helper.hex2rgb("#FFFFFF") )

     -- Add a Touch listener to the Sound Button / Rectangle
    specialButton:addEventListener( "touch", specialAction )

    -- Insert Tap to Start into the Top Group
    sceneGroup:insert( specialButton )



    -----------------------------------------------------------------
    -- Create bottom Developed by Area
    -----------------------------------------------------------------
    --local logoArea        = display.newRect( 0, 0, 321, 107)
    local logoArea        = display.newImageRect( globals.imagePath.."infoMadeBy.png", 321, 107 )
    logoArea.x            = screenCentre_X
    logoArea.y            = buttonStart.y + 100
    --logoArea:setFillColor(   helper.hex2rgb("#503d7f") )

    -- Insert the Background Image/Area into the Background Group
    sceneGroup:insert( logoArea )



    -----------------------------------------------------------------
    -- Before the background music starts - stop any previous sessions
    -----------------------------------------------------------------   
    --[[    
    local isChannel1Playing = audio.isChannelPlaying( 1 )
    if isChannel1Playing then
        audio.stop(1)
    end

    --]]

    -----------------------------------------------------------------
    -- Start the GAME Music - Looping
    -----------------------------------------------------------------       
    --globals.musicMenu = audio.play(globals.music_Menu, {channel=1, loops = -1})

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


    elseif ( phase == "did" ) then

        ---------------------------------------------------------------------------------
        -- Animate all the scene elements into position
        ---------------------------------------------------------------------------------


        -- Called when the scene is now on screen
        -- Insert code here to make the scene come alive
        -- Example: start timers, begin animation, play audio, etc.

        function gameStartFunction()

            --audio.stop()
            --audio.dispose( globals.musicMenu )
            --audio.dispose() 

            composer.gotoScene( "sceneSelect") --This is our main game
        end


        local function startMusic(  )
            -----------------------------------------------------------------
            -- Before the background music starts - stop any previous sessions
            -----------------------------------------------------------------       
            audio.stop(2)

            -----------------------------------------------------------------
            -- Start the GAME Music - Looping
            -----------------------------------------------------------------       
            globals.musicMenu = audio.play(globals.music_Game, {channel=2, loops = -1})
        end

        timer.performWithDelay(450, startMusic )


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