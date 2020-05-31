---------------------------------------------------------------------------------
-- scene 1.lua
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Import all modules required to run our game / this interface
---------------------------------------------------------------------------------
local composer      = require( "composer" )
local widget        = require( "widget" )
local globals       = require( "lib.globalData" )
local loadsave      = require( "lib.loadsave" )
local helper        = require( "lib.helper" )
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
--globals.level        = saveDataTable.level        -- Level the player is at
globals.highScore    = saveDataTable.highScore    -- Saved High Score
globals.playerSelect = saveDataTable.playerSelect -- Which player enabled ?
globals.coins        = saveDataTable.coins        -- Coins collected (Total) ?

print("globals.level: "..globals.level)
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
local touchAreaWidth  = screenWidth / 3
local touchAreaHeight = screenHeight

---------------------------------------------------------------------------------
-- Environment Variables
---------------------------------------------------------------------------------
local gameOver                  = false
local gameStarted               = false -- gameStarted becomes [ true ] after the first tap
local isCheckingCollisions      = false
local gameOverDim               = false -- Make the Background Dark on Game Over?
local gameOverDimAmount         = 0.3   -- If true, how much Dark tint? 0=None, 1=solid
local gameOverArea

---------------------------------------------------------------------------------
-- Scoring Variables
---------------------------------------------------------------------------------
local score        = 0
local scoreText
local newHighscore = globals.highScore -- Data collected from Device
local highScoreText
local coinsText

---------------------------------------------------------------------------------
--Define our Background Touch Area variables
---------------------------------------------------------------------------------
local leftArea
local middleArea
local rightArea

---------------------------------------------------------------------------------
--Define our Floor area variables
---------------------------------------------------------------------------------
local floorArea
local floorHeight = 157

---------------------------------------------------------------------------------
--Define our Player variables
---------------------------------------------------------------------------------
local playerMovedTo           = "Middle"
local player
local playerWidth             = 60
local playerHeight            = 120
local player_X                = screenCentre_X
local player_Y                = screenHeight - floorHeight - 1
local playerLeftPosition      = 0
local playerMiddlePosition    = 0
local playerRightPosition     = 0
local playerMoveSpeed         = 100 -- in Milliseconds
local playerCanMove           = true
local playerHit               = false
local playerShowParticles     = true
local playerParticlesColour   = "#D40000"
local playerNumberOfParticles = 40
local playerParticlesSize     = 5
local playerParticlesY        = -400 -- Lower number = less height
local playerParticlesX        = -400 -- Lower number = less X spread
local playerPreviousPosition  = ""
local playerPositionLocked    = false

---------------------------------------------------------------------------------
--Define our Enemy variables
---------------------------------------------------------------------------------
local enemyCounter = 0
local enemy1
local enemy2
local enemy3
local smokePuff         = {}
local smokePuffShow     = true   -- Show an animated Puff effect
globals.animatedEnemies = true   -- Are we using Animated Enemies?


-- 1={X-X-O}, 2={X-O-X}, 3={O-X-X}, 4={X-O-O}, 5={O-X-O}, 6={O-O-X}
-- Define the Enemies Position / Pattern
local enemyPattern             = 1
local enemyMinY                = levelData.enemyMinY[globals.level]
local enemyMaxY                = player_Y
local enemyPeekY               = levelData.enemyPeekY[globals.level]
local enemyMoveSpeed           = levelData.enemyMoveSpeed[globals.level]
local enemyPeekSpeed           = levelData.enemyPeekSpeed[globals.level]
local enemyPauseSpeed          = levelData.enemyPauseSpeed[globals.level]
local enemyResetSpeed          = levelData.enemyResetSpeed[globals.level]
local enemyActionStarted       = false
local enemiesShowParticles     = true
local enemiesParticlesColour   = "#FFFFFF"
local enemiesNumberOfParticles = 15
local enemiesParticlesSize     = 5
local enemiesParticlesY        = -200 -- Lower number = less height
local enemiesParticlesX        = -300 -- Lower number = less X spread

---------------------------------------------------------------------------------
--Define Tap to Start Variables
---------------------------------------------------------------------------------
local soundButton
local soundStatus = true

---------------------------------------------------------------------------------
--Define Tap to Start Variables
---------------------------------------------------------------------------------
local tapToStart

---------------------------------------------------------------------------------
-- Setup scene Groups
-- Each group to hold our game design parts
---------------------------------------------------------------------------------
local groupBackground       = display.newGroup()
local groupTop              = display.newGroup()
local groupScore            = display.newGroup()
local groupGameOver         = display.newGroup()


---------------------------------------------------------------------------------
-- Scene Create
-- Called when the scene's view does not exist
---------------------------------------------------------------------------------
function scene:create( event )
    local sceneGroup = self.view

    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc

    -- Remove any previous Composer Scenes
    composer.removeScene( "sceneSelect" )
    composer.removeScene( "sceneSelectUpdate" )
    composer.removeScene( "sceneMenu" )
    composer.removeScene( "sceneReset" )

    -----------------------------------------------------------------
    -- Create Touch Zones for the background
    -----------------------------------------------------------------
    local function touchToMove( event )
        -- We passed the name of the area being touched
        -- With this information we can work out what to do next
        local targetPosition = event.target.id

        print("targetPosition: "..targetPosition)

        if event.phase == "began" then

            --Call a function, that will move our Player
            --If the game has not ended
            if (gameOver == false) then
                if ( targetPosition ~= "Sound" ) then
                    playerMove( targetPosition )
                end
            end

        elseif event.phase == "ended" then
            
            if targetPosition == "Restart" then
                print("Restart pressed")
                resetGameFunction()
            elseif targetPosition == "Menu" then
                print("Go to Menu pressed")
                gotoMenuFunction()
            elseif targetPosition == "Sound" then
                print("Sound Button pressed")
                toggleSoundFunction()
            end

        end

        return true
    end


    -----------------------------------------------------------------
    -- Create the Background Area
    -----------------------------------------------------------------
    --local backgroundImage        = display.newRect( 0, 0, 384,693 )
    local backgroundImage        = display.newImageRect( globals.imagePath.."Background"..globals.level..".png", 384,693 )
    backgroundImage.x            = screenCentre_X
    backgroundImage.y            = screenCentre_Y
    --backgroundImage:setFillColor(   helper.hex2rgb("#f2d118") )

    -- Insert the Background Image/Area into the Background Group
    groupBackground:insert( backgroundImage )


    -----------------------------------------------------------------
    -- Create the Left - Touch Zone
    -----------------------------------------------------------------
    leftArea              = display.newRect( 0, 0, touchAreaWidth, touchAreaHeight )
    leftArea.id           = "Left"
    leftArea.anchorX      = 0.5
    leftArea.anchorY      = 0.5
    leftArea.x            = touchAreaWidth / 2
    leftArea.y            = touchAreaHeight / 2
    leftArea.rotation     = 0
    leftArea.alpha        = 0.01
    leftArea.strokeWidth  = 1
    leftArea:setFillColor(   helper.hex2rgb("#FF78D3") )
    leftArea:setStrokeColor( helper.hex2rgb("#FFFFFF") )

    -- Add a Touch listener to the Rectangle
    leftArea:addEventListener( "touch", touchToMove )

    -- Insert the Left Rectangle / Touch zone into the Background Group
    groupBackground:insert( leftArea )


    -----------------------------------------------------------------
    -- Create the Middle - Touch Zone
    -----------------------------------------------------------------
    middleArea              = display.newRect( 0, 0, touchAreaWidth, touchAreaHeight )
    middleArea.id           = "Middle"
    middleArea.anchorX      = 0.5
    middleArea.anchorY      = 0.5
    middleArea.x            = leftArea.x + touchAreaWidth
    middleArea.y            = touchAreaHeight / 2
    middleArea.rotation     = 0
    middleArea.alpha        = 0.01
    middleArea.strokeWidth  = 1
    middleArea:setFillColor( helper.hex2rgb("#9675B0") )
    middleArea:setStrokeColor( helper.hex2rgb("#FFFFFF") )

    -- Add a Touch listener to the Rectangle
    middleArea:addEventListener( "touch", touchToMove )

    -- Insert the Middle Rectangle / Touch zone into the Background Group
    groupBackground:insert( middleArea )


    -----------------------------------------------------------------
    -- Create the Right - Touch Zone
    -----------------------------------------------------------------
    rightArea              = display.newRect( 0, 0, touchAreaWidth, touchAreaHeight )
    rightArea.id           = "Right"
    rightArea.anchorX      = 0.5
    rightArea.anchorY      = 0.5
    rightArea.x            = middleArea.x + touchAreaWidth
    rightArea.y            = touchAreaHeight / 2
    rightArea.rotation     = 0
    rightArea.alpha        = 0.01
    rightArea.strokeWidth  = 1
    rightArea:setFillColor( helper.hex2rgb("#3775B0") )
    rightArea:setStrokeColor( helper.hex2rgb("#FFFFFF") )

    -- Add a Touch listener to the Rectangle
    rightArea:addEventListener( "touch", touchToMove )

    -- Insert the Right Rectangle / Touch zone into the Background Group
    groupBackground:insert( rightArea )


    -----------------------------------------------------------------
    -- Create the Floor Area [ floorArea]
    -----------------------------------------------------------------
    --floorArea              = display.newRect( 0, 0, globals._w, floorHeight )
    floorArea              = display.newImageRect( globals.imagePath.."Floor"..globals.level..".png", screenWidth,floorHeight )
    floorArea.id           = "Floor"
    floorArea.anchorX      = 0.5
    floorArea.anchorY      = 1.0
    floorArea.x            = screenCentre_X
    floorArea.y            = screenHeight
    floorArea.rotation     = 0
    floorArea.alpha        = 1
    --floorArea.strokeWidth  = 1
    --floorArea:setFillColor( helper.hex2rgb("#57EB00") )
    --floorArea:setStrokeColor( helper.hex2rgb("#FFFFFF") )

    -- Insert the Right Rectangle / Touch zone into the Background Group
    groupBackground:insert( floorArea )

    -----------------------------------------------------------------
    -- Create the Player
    -----------------------------------------------------------------
    if (globals.level == 1)  then
        player = display.newSprite( globals.spritesAnimationSheet1, globals.animationData1 )
        player:setSequence( "player1")
    elseif (globals.level == 2)  then
        player = display.newSprite( globals.spritesAnimationSheet2, globals.animationData2 )
        player:setSequence( "player2")
    elseif (globals.level == 3)  then
        player = display.newSprite( globals.spritesAnimationSheet3, globals.animationData3 )
        player:setSequence( "player3")
    end

    player.id           = "Player"
    player.currentFrame = 1
    player.anchorY      = 1.0
    player.x            = player_X
    player.y            = player_Y + 20
    player:play()

--[[
    player              = display.newRect( 0, 0, playerWidth, playerHeight )
    player.id           = "Player"
    player.anchorX      = 0.5
    player.anchorY      = 1.0
    player.x            = player_X
    player.y            = player_Y
    player.rotation     = 0
    player.alpha        = 0.4
    player.strokeWidth  = 1
    player:setFillColor( helper.hex2rgb("#6800AD") )
    player:setStrokeColor( helper.hex2rgb("#FFFFFF") )
--]]
    -- Insert the Player into the Top Group
    groupTop:insert( player )


    -----------------------------------------------------------------
    -- Create the 3 x enemies
    -- We'll manage their actions later
    -----------------------------------------------------------------
    -- Enemy 1 (Left)
    -----------------------------------------------------------------
    enemy1 = display.newSprite( globals.imageSpriteSheet2, globals.animationSequenceData2 )
    enemy1.id           = "Enemy1"
    enemy1.anchorX      = 0.5
    enemy1.anchorY      = 1.0
    enemy1.x            = leftArea.x
    enemy1.y            = enemyMinY
    enemy1.rotation     = 0
    enemy1.alpha        = 1

    enemy1.currentFrame = 1
    enemy1:setSequence( "enemyType1" )
    enemy1:play()

    groupTop:insert( enemy1 )

--[[
    enemy1              = display.newImageRect( globals.imagePath.."Squasher"..globals.level..".png", 94, screenHeight - floorHeight )
    enemy1.id           = "Enemy1"
    enemy1.anchorX      = 0.5
    enemy1.anchorY      = 1.0
    enemy1.x            = leftArea.x
    enemy1.y            = enemyMinY
    enemy1.rotation     = 0
    enemy1.alpha        = 1
--]]
    -- Insert Enemy 1 into the Top Group
    groupTop:insert( enemy1 )


    -----------------------------------------------------------------
    -- Enemy 2 (Middle)
    -----------------------------------------------------------------

    enemy2 = display.newSprite( globals.imageSpriteSheet2, globals.animationSequenceData2 )
    enemy2.id           = "Enemy2"
    enemy2.anchorX      = 0.5
    enemy2.anchorY      = 1.0
    enemy2.x            = middleArea.x
    enemy2.y            = enemyMinY
    enemy2.rotation     = 0
    enemy2.alpha        = 1
    enemy2.currentFrame = 1
    enemy2:setSequence( "enemyType2" )
    enemy2:play()
    groupTop:insert( enemy2 )


--[[
    enemy2              = display.newImageRect( globals.imagePath.."Squasher"..globals.level..".png", 94, screenHeight - floorHeight )
    enemy2.id           = "Enemy2"
    enemy2.anchorX      = 0.5
    enemy2.anchorY      = 1.0
    enemy2.x            = middleArea.x
    enemy2.y            = enemyMinY
    enemy2.rotation     = 0
    enemy2.alpha        = 1

    -- Insert Enemy 2 into the Top Group
    groupTop:insert( enemy2 )
--]]

    -----------------------------------------------------------------
    -- Enemy 3 (Right)
    -----------------------------------------------------------------
    enemy3 = display.newSprite( globals.imageSpriteSheet2, globals.animationSequenceData2 )
    enemy3.id           = "Enemy3"
    enemy3.anchorX      = 0.5
    enemy3.anchorY      = 1.0
    enemy3.x            = rightArea.x
    enemy3.y            = enemyMinY
    enemy3.rotation     = 0
    enemy3.alpha        = 1
    enemy3.currentFrame = 1
    enemy3:setSequence( "enemyType1" )
    enemy3:play()
    groupTop:insert( enemy3 )

--[[
    enemy3              = display.newImageRect( globals.imagePath.."Squasher"..globals.level..".png", 94, screenHeight - floorHeight )
    enemy3.id           = "Enemy3"
    enemy3.anchorX      = 0.5
    enemy3.anchorY      = 1.0
    enemy3.x            = rightArea.x
    enemy3.y            = enemyMinY
    enemy3.rotation     = 0
    enemy3.alpha        = 1

    -- Insert Enemy 3 into the Top Group
    groupTop:insert( enemy3 )
--]]


    -----------------------------------------------------------------
    -- Add the Sound Button info to the screen [ soundButton ]
    -----------------------------------------------------------------
    soundButton              = display.newImageRect( globals.imagePath.."Sound0.png", 32, 32 )
    --soundButton              = display.newRect( 0, 0, 32, 32 )
    soundButton.id           = "Sound"
    soundButton.x            = 25
    soundButton.y            = screenHeight - 38
    soundButton.rotation     = 0
    soundButton.alpha        = 1
    --soundButton.strokeWidth  = 1
    --soundButton:setFillColor( helper.hex2rgb("#265c78") )
    --soundButton:setStrokeColor( helper.hex2rgb("#FFFFFF") )

     -- Add a Touch listener to the Sound Button / Rectangle
    soundButton:addEventListener( "touch", touchToMove )

    -- Insert Tap to Start into the Top Group
    groupTop:insert( soundButton )

    -----------------------------------------------------------------
    -- Add the Tap to Start info to the screen [ tapToStart ]
    -----------------------------------------------------------------
    tapToStart              = display.newImageRect( globals.imagePath.."TapToStart.png", 200, 200 )
    --tapToStart            = display.newRect( 0, 0, 200, 200 )
    tapToStart.id           = "TapStart"
    tapToStart.x            = middleArea.x
    tapToStart.y            = screenCentre_Y - 100
    tapToStart.rotation     = 0
    tapToStart.alpha        = 1
    --tapToStart.strokeWidth  = 1
    --tapToStart:setFillColor( helper.hex2rgb("#e1e5b0") )
    --tapToStart:setStrokeColor( helper.hex2rgb("#FFFFFF") )

   -- Insert Tap Start info data onto screen
    groupTop:insert( tapToStart )


    -----------------------------------------------------------------
    -- Create Game Over Panel (Group)
    -----------------------------------------------------------------
    -- Group made of 4 x Components
    -- [gameOverArea] [gameOverInfo] [buttonRestart] [buttonMenu]
    -- NOTE: These objects are created locally, as we do not need to
    -- refer to the objects themselves again in the code later.
    -----------------------------------------------------------------
    -----------------------------------------------------------------
    -- Create the Game Over Panel [ gameOverArea ]
    -----------------------------------------------------------------
    gameOverArea              = display.newImageRect( globals.imagePath.."GameOverArea.png", 300, 240 )
    --gameOverArea        = display.newRect( 0, 0, 300, 240 )
    gameOverArea.x            = screenCentre_X
    gameOverArea.y            = screenCentre_Y
    gameOverArea.alpha        = 1.0
    --gameOverArea.strokeWidth  = 1
    --gameOverArea:setFillColor(   helper.hex2rgb("#628352") )
    --gameOverArea:setStrokeColor( helper.hex2rgb("#FFFFFF") )

    -- Insert the local gameOverArea into the Game Over Group
    groupGameOver:insert( gameOverArea )

    -----------------------------------------------------------------
    -- Create the Game Over Info Area [ gameOverInfo ]
    -----------------------------------------------------------------
    local gameOverInfo              = display.newImageRect( globals.imagePath.."GameOverInfo.png", 220, 190 )
    --local gameOverInfo        = display.newRect( 0, 0, 220, 190 )
    gameOverInfo.x            = screenCentre_X
    gameOverInfo.y            = gameOverArea.y - 100
    gameOverInfo.alpha        = 1
    --gameOverInfo.strokeWidth  = 1
    --gameOverInfo:setFillColor(   helper.hex2rgb("#8cd63c") )
    --gameOverInfo:setStrokeColor( helper.hex2rgb("#FFFFFF") )

    -- Insert the local gameOverInfo into the Game Over Group
    groupGameOver:insert( gameOverInfo )

    -----------------------------------------------------------------
    -- Create the Restart Game Button [ buttonRestart ]
    -----------------------------------------------------------------
    local buttonRestart        = display.newImageRect( globals.imagePath.."buttonRestart.png", 80,80 )
    --local buttonRestart        = display.newRect( 0, 0, 80, 80 )
    buttonRestart.id           = "Restart"
    buttonRestart.x            = gameOverArea.x - 50
    buttonRestart.y            = gameOverArea.y + 60
    buttonRestart.alpha        = 1.0
    --buttonRestart.strokeWidth  = 1
    --buttonRestart:setFillColor(   helper.hex2rgb("#62b8cc") )
    --buttonRestart:setStrokeColor( helper.hex2rgb("#FFFFFF") )

    -- Add a Touch listener to restart the game
    buttonRestart:addEventListener( "touch", touchToMove )

    -- Insert the local buttonRestart into the Game Over Group
    groupGameOver:insert( buttonRestart )

    -----------------------------------------------------------------
    -- Create the Goto Menu Button [ buttonMenu ]
    -----------------------------------------------------------------
    local buttonMenu        = display.newImageRect( globals.imagePath.."buttonToMenu.png", 80,80 )
    --local buttonMenu        = display.newRect( 0, 0, 80, 80 )
    buttonMenu.id           = "Menu"
    buttonMenu.x            = gameOverArea.x + 50
    buttonMenu.y            = gameOverArea.y + 60
    buttonMenu.alpha        = 1.0
    --buttonMenu.strokeWidth  = 1
    --buttonMenu:setFillColor(   helper.hex2rgb("#8c623c") )
    --buttonMenu:setStrokeColor( helper.hex2rgb("#FFFFFF") )

    -- Add a Touch listener to take user to the Menu Screen
    buttonMenu:addEventListener( "touch", touchToMove )

    -- Insert the local buttonMenu into the Game Over Group
    groupGameOver:insert( buttonMenu )


    -----------------------------------------------------------------
    -- Create Rectangle to show a coin image [ coinImage ]
    -----------------------------------------------------------------
    local coinImage        = display.newImageRect( globals.imagePath.."CoinImage.png", 32, 32 )
    --local coinImage        = display.newRect( 0, 0, 32, 32 )
    coinImage.id           = "CoinImage"
    coinImage.x            = screenWidth - 25
    coinImage.y            = 50 + globals.topInset
    coinImage.alpha        = 1.0
    --coinImage.strokeWidth  = 1
    --coinImage:setFillColor(   helper.hex2rgb("#8c623c") )
    --coinImage:setStrokeColor( helper.hex2rgb("#FFFFFF") )

    -- We need to store the Coin Counter X Position, to refer to later.
    globals.coinTextX = coinImage.x - 15
    globals.coinTextY = coinImage.y + 28

    -- Insert the local coinImage into the Game Over Group
    groupScore:insert( coinImage )


    -----------------------------------------------------------------
    -- Show Coins Collected [ coinsText ]
    -- Fonts: [ globals.font1 ] [ globals.font2 ] [ globals.font3 ]
    --        [ globals.font4 ] [ globals.font5 ] [ globals.font6 ]
    -----------------------------------------------------------------
    -- bmf:newString( [the font to use], [the text to show] )
    -----------------------------------------------------------------

    coinsText = bmf:newString( globals.font1, globals.coins )
    coinsText.align = "right"
    coinsText.xScale = 0.5
    coinsText.yScale = 0.5
    coinsText.alpha = 0.8
    coinsText.x = globals.coinTextX
    coinsText.y = globals.coinTextY
    groupScore:insert(coinsText)


    -----------------------------------------------------------------
    -- Show the score on the screen [ scoreText ]
    -- Fonts: [ globals.font1 ] [ globals.font2 ] [ globals.font3 ]
    --        [ globals.font4 ] [ globals.font5 ] [ globals.font6 ]
    -----------------------------------------------------------------
    scoreText = bmf:newString( globals.font1, score )
    scoreText.align = "left"
    scoreText.xScale = 0.9
    scoreText.yScale = 0.9
    scoreText.alpha = 0.8
    scoreText.x = 5
    scoreText.y = 90 + globals.topInset
    groupScore:insert(scoreText)


    -----------------------------------------------------------------
    -- Show the Highscore on the screen [ highScoreText ]
    -- Fonts: [ globals.font1 ] [ globals.font2 ] [ globals.font3 ]
    --        [ globals.font4 ] [ globals.font5 ] [ globals.font6 ]
    -----------------------------------------------------------------
    highScoreText = bmf:newString( globals.font1, "Highscore: "..newHighscore  )
    highScoreText.align = "center"
    highScoreText.xScale = 0.32
    highScoreText.yScale = 0.32
    highScoreText.alpha = 0.8
    highScoreText.x = screenCentre_X
    highScoreText.y = floorArea.y - 20
    groupScore:insert(highScoreText)


    globals.debugShowText = bmf:newString( globals.font1, "Sequence: 000"  )
    globals.debugShowText.align = "center"
    globals.debugShowText.xScale = 0.32
    globals.debugShowText.yScale = 0.32
    globals.debugShowText.alpha = 0.0
    globals.debugShowText.x = screenCentre_X
    globals.debugShowText.y = floorArea.y - 60
    groupScore:insert(globals.debugShowText)



--[[



--]]


    -----------------------------------------------------------------
    -- Are we having sound in our game? [true] or [false]
    -----------------------------------------------------------------
    globals.doAudio = true
    


    -----------------------------------------------------------------
    -- Setup the GAME music playing on channel 1
    -----------------------------------------------------------------
    if ( soundButton ~= nil ) then
        if ( globals.doAudio == true ) then
            -----------------------------------------------------------------
            -- Before the background music starts - stop any previous sessions
            -----------------------------------------------------------------       
            audio.stop(1)

            -----------------------------------------------------------------
            -- Start the GAME Music - Looping
            -----------------------------------------------------------------       
            globals.musicGame = audio.play(globals.music_Game, {channel=1, loops = -1})

            soundStatus = globals.soundON

            if (globals.soundON == true) then
                soundOnFunction()
            else
                soundOffFunction()
            end
        end
    end



    -----------------------------------------------------------------
    -- Setup the smoke animation?
    -----------------------------------------------------------------
    for i = 0, 2 do
        smokePuff[i] = display.newSprite( globals.imagePuffSheet1, globals.animationSequencePuffData )
        smokePuff[i]:setSequence( "puffAnimation" )
        smokePuff[i].x = screenCentre_X
        smokePuff[i].y = screenCentre_Y
        groupTop:insert( smokePuff[i] )
        smokePuff[i]:toBack()
    end
    -----------------------------------------------------------------
    -- Are we dimming the Background Area - when Game Over is shown?
    -----------------------------------------------------------------
    if (gameOverDim) then
        if (gameOverArea ~= nil) then
            local dimArea        = display.newRect( 0, 0, screenWidth, screenHeight )
            dimArea.x            = screenCentre_X
            dimArea.y            = screenCentre_Y
            dimArea:setFillColor( helper.hex2rgb("#000000") )
            dimArea.alpha   = gameOverDimAmount
            groupGameOver:insert( dimArea )
            dimArea:toBack( )
        end
    end

    -----------------------------------------------------------------
    --Move the Game Over Panel Offscree, until we need to show it.
    -----------------------------------------------------------------
    if (gameOverArea ~= nil) then
        groupGameOver.y = screenHeight + gameOverArea.height
    end


    -----------------------------------------------------------------
    --We're ready ! Move the Enemies off screen (makes it more fun) :-)
    -----------------------------------------------------------------
    if (highScoreText ~= nil) then
        enemyMinY = 0
        enemy1.y = enemyMinY
        enemy2.y = enemyMinY
        enemy3.y = enemyMinY
    end

    -----------------------------------------------------------------
    --Insert all of the Game GROUPS onto the device screen.
    -----------------------------------------------------------------
    sceneGroup:insert( groupBackground )
    sceneGroup:insert( groupTop )
    sceneGroup:insert( groupScore )
    sceneGroup:insert( groupGameOver )


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



        -----------------------------------------------------------------
        -- We now need to calculate the 3 x possible positions our player
        -- can move to Left, Middle and Right. We'll assign the
        -- 3 x possible positions to variables. We can refer to later.
        -----------------------------------------------------------------
        if( leftArea ~= nil) then
            playerLeftPosition   = leftArea.x
        end
        if( middleArea ~= nil) then
            playerMiddlePosition = middleArea.x
        end
        if( rightArea ~= nil) then
            playerRightPosition  = rightArea.x
        end


        -----------------------------------------------------------------
        -- All of our game called Functions
        -- These actions are called from objects within the main game.
        -----------------------------------------------------------------

        ---------------------------------------------------------------------------------
        -- Add runtime event to check for touch on the player
        ---------------------------------------------------------------------------------
        function gameLoop( event )

            -- Check for a Game Over signal
            if ( gameOver == true ) then

                -- Show game over information
                print("The game is over :(")

                --Play a got hit sound
                if ( soundButton ~= nil ) then
                    if ( globals.doAudio == true ) then
                        audio.play(globals.sfx_HitChoir)
                    end
                end

                --Is there a Coin on the screen? If so remove it!
                if (globals.coin ~= nil) then
                    if (globals.coinOnScreen == true) then
                        globals.coin:removeSelf()
                        globals.coin = nil
                    end
                end

                -- We need to stop the gameLoop code from executing.
                Runtime:removeEventListener( "enterFrame", gameLoop)
                Runtime:removeEventListener( "enterFrame", testCollisions)

                -- Fade and Expand the Player (on game over)
                local function playerFade()
                    local playerMeFade = transition.to(player, {delay=0, y=600,xScale=4.0, yScale=4.0, time=800, alpha=0 } )
                end

                -- Squish our Player
                local squishPlayer = transition.to(player, {delay=0, time=600, height=20,transition=easing.outElastic, onComplete=playerFade } )
                
                -- Are we going to show some Popping Particles?
                if ( playerShowParticles == true ) then
                    explodePlayer(player.x, player.y, playerParticlesColour, playerNumberOfParticles, playerParticlesSize, playerParticlesX, playerParticlesY)
                end

                if (gameOverArea ~= nil) then
                    -- Show Game over panel - with a Restart or Menu button/option
                    local endGameTimer = timer.performWithDelay(1200, showHideGameOver("show") )
                else
                    local endGameTimer = timer.performWithDelay(enemyResetSpeed, resetGameFunction )
                end

            else

                -- It's not game over - keep checking the in-game activity

                -- Should we start a new Enemy movement sequence ?
                if ( enemyActionStarted == false ) then
                    -- Create new Random sequence

                    --local randomPattern = math.random(3)     --> an integer between 1 and 3 (inclusive)
                    --if (randomPattern == enemyPattern) then
                    --    local randomPattern = math.random(3)     --> an integer between 1 and 3 (inclusive)
                    --end
                    --enemyPattern = randomPattern

                    -- It's not game over - keep the enemies going
                    if ( gameStarted == true ) then
                        enemyActionStarted = true
                        
                        timer.performWithDelay(250, enemiesMove )
                        --enemiesMove()
                    end

                end



            end

        end

        -----------------------------------------------------------------
        -- Function to check if the Enemy has hit our Player
        -----------------------------------------------------------------
        function testCollisions()

            if ( gameOver == false ) then

                if (isCheckingCollisions) then
                    return true
                end

                isCheckingCollisions = true

                if helper.hasCollided(globals.coin, enemy1) then
                    coinDestroyedFunction()
                end
                if helper.hasCollided(globals.coin, enemy2) then
                    coinDestroyedFunction()
                end
                if helper.hasCollided(globals.coin, enemy3) then
                    coinDestroyedFunction()
                end

                if helper.hasCollided(globals.coin, player) then
                    -- User has collected a Coin :-)
                    print("Coin Collected")
                    coinCollectedFunction(coinsText.x)
                end

                if helper.hasCollided(enemy1, player) then
                    -- do what you need to do if they hit each other
                    print("Your dead !!")
                    gameOver = true
                    return true
                end

                if helper.hasCollided(enemy2, player) then
                    -- do what you need to do if they hit each other
                    print("Your dead !!")
                    gameOver = true
                    return true
                end

                if helper.hasCollided(enemy3, player) then
                    -- do what you need to do if they hit each other
                    print("Your dead !!")
                    gameOver = true
                    return true
                end

                if (gameOver == false) then
                    isCheckingCollisions = false
                end

                return true
            end
        
        end


        -----------------------------------------------------------------
        -- Function to collect our players position - from a Touch
        -----------------------------------------------------------------
        function playerMove( toPosition )
            
            --Only attempt to move the player, if the user
            --Has tapped a different position
            if ( toPosition ~= playerPreviousPosition ) then

                if ( gameOver == true ) then
                    print("Game Over - can not move")

                else

                    --Have we set the [ gameStarted ] variable to true yet?
                    if ( gameStarted == false ) then
                        gameStarted = true

                        -- Now the Game has started - we'll start the enemies movement
                        enemiesMove()

                        -- And - move the Tap to Start info off screen.
                        hideTapToStart()

                    end

                    print("I moved to the: "..toPosition)

                    local function listener1( obj )
                        --print( "Player finished moving: " .. tostring( obj ) )
                        playerCanMove = true
                    end

                        if ( playerCanMove ) then -- has the player stopped moving?

                            -- Tell The game engine - we're moving the player
                            playerCanMove = false

                            -- Store the current location, so we can check again later
                            playerMovedTo = toPosition

                            --Play Sound, when player moves
                            if ( globals.musicGame ~= nil ) then
                                if ( soundButton ~= nil ) then
                                    local theSound = "slash" .. math.random(1, 3)
                                    audio.play(globals.sfx_slashSounds[theSound])
                                    --audio.play(globals.sfx_Move1)
                                end
                            end

                            -- Move Player to correct position
                            -- When the Process is complete - let the canMove variable know


                                playerPreviousPosition = toPosition

                                -- Now move the Player to the correct position
                                if toPosition == "Left" then
                                    transition.to( player, { time=playerMoveSpeed, x=playerLeftPosition, onComplete=listener1 } )

                                elseif toPosition == "Middle" then
                                    transition.to( player, { time=playerMoveSpeed, x=playerMiddlePosition, onComplete=listener1 } )

                                elseif toPosition == "Right" then
                                    transition.to( player, { time=playerMoveSpeed, x=playerRightPosition, onComplete=listener1 } )
                                end

                        end
                    end

            end

        end


        -----------------------------------------------------------------
        -- Manage our enemies movement and logic
        -- 1={X-X-O}, 2={X-O-X}, 3={O-X-X}, 4={X-O-O}, 5={O-X-O}, 6={O-O-X}
        -----------------------------------------------------------------
        function enemiesMove( )

            -- Increment the Enemies Action counter. We'll use this for scoring later.
            enemyCounter = enemyCounter + 1

            -- Signal the Enemy movement / positioning sequence has started.
            enemyActionStarted = true

            -- Create new Random sequence
            -- We'll make sure the Enemy position is always above our player
            local randomPattern = 0
            local playerPositionLocked = false

            if (playerPositionLocked == false) then

                 playerPositionLocked = true

                if (playerMovedTo == "Left") then
                    local exclude={3,5,6}
                    randomPattern = helper.getRandomPosition(6, exclude)
                elseif (playerMovedTo == "Middle") then
                    local exclude={2,4,6}
                    randomPattern = helper.getRandomPosition(6, exclude)
                else
                    local exclude={1,4,5}
                    randomPattern = helper.getRandomPosition(6, exclude)
                end

                -- Store a reference to the new 'enemy random position'
                -- We'll use this number later in this function to work out
                -- Which of the enemies should be used
                enemyPattern = randomPattern

                -- Reset the [ enemyActionStarted ] variable back to false
                local function enemiesReset(obj)
                    -- restore start positions
                    -- Our main game thread will pick this up - and start the routine over again
                    enemyActionStarted = false

                    globals.sequenceConfirmed = false

                    -- Check if the player wasn't hit, if they wern't,
                    -- we'll give the player a point, based on how many times
                    -- the enemies have been called in the code.
                    if ( gameOver == false ) then
                        checkScore(enemyCounter)
                    end

                    -- Select a random image / animation for our enemies
                    local num1 = math.random(1, 2)
                    if (globals.animatedEnemies == true) then
                        enemy1:setSequence( "enemyType"..num1 )
                        enemy1:play()
                    end

                    local num2 = math.random(1, 2)
                    if (globals.animatedEnemies == true) then
                        enemy2:setSequence( "enemyType"..num2 )
                        enemy2:play()
                    end

                    local num3 = math.random(1, 2)
                    if (globals.animatedEnemies == true) then
                        enemy3:setSequence( "enemyType"..num3 )
                        enemy3:play()
                    end


                end

                -- Functions below are for moving our Enemy Up and Down.and
                -- The sequence starts at [ move1 ], which calls [ move2 ], which calls [ move3 ] etc etc..
                local function move6(obj)

                    if ( enemiesShowParticles == true ) then
                        explodePlayer(obj.x, obj.y, enemiesParticlesColour, enemiesNumberOfParticles, enemiesParticlesSize, enemiesParticlesX, enemiesParticlesY)
                    end

                    --Play Sound, when enemies hit ground
                    if ( globals.musicGame ~= nil ) then
                        if ( soundButton ~= nil ) then
                            if ( globals.doAudio == true ) then
                                --local theSound = "thump" .. math.random(1, 2)
                                --audio.play(globals.sfx_thumpSounds[theSound])
                                audio.play(globals.sfx_Thump1)
                            end
                        end
                    end

                    --If required, show an animated Puff Effect
                    if ( smokePuffShow == true ) then
                        if ( enemyPattern == 1) then
                            showPuffAnimation(enemy1, 0)
                            showPuffAnimation(enemy2, 1)
                        elseif ( enemyPattern == 2) then
                            showPuffAnimation(enemy1, 0)
                            showPuffAnimation(enemy3, 2)
                        elseif ( enemyPattern == 3) then
                            showPuffAnimation(enemy2, 1)
                            showPuffAnimation(enemy3, 2)
                        elseif ( enemyPattern == 4) then
                            showPuffAnimation(enemy1, 0)
                        elseif ( enemyPattern == 5) then
                            showPuffAnimation(enemy2, 1)
                        elseif ( enemyPattern == 6) then
                            showPuffAnimation(enemy3, 2)
                        end
                    end

                    -- Retract the Enemy - back to their default / start postion
                    transition.to(obj, {delay=enemeyPauseSpeed, time=enemyResetSpeed, y=enemyMinY, onComplete=enemiesReset } )
                    

                end

                local function move5(obj)
                    -- This is the Fall to ground - hit player motion !
                    transition.to(obj, {delay=0, time=enemyMoveSpeed, y=enemyMaxY, onComplete=move6 } )
                end

                local function move4(obj)
                   transition.to(obj, {delay=0, time=enemyPeekSpeed, y=enemyMinY, onComplete=move5 } )
                end

                local function move3(obj)
                    transition.to(obj, {delay=0, time=enemyPeekSpeed, y=enemyPeekY, onComplete=move4 } )
                end

                local function move2(obj)
                    transition.to(obj, {delay=0, time=enemyPeekSpeed, y=enemyMinY, onComplete=move3 } )
                end

                local function move1(obj)
                   transition.to(obj, {delay=0, time=enemyPeekSpeed, y=enemyPeekY, onComplete=move2 } )
                end

                function updateDebugInfo()
                    globals.debugShowText.text = "Sq: "..globals.debugSequenceInfo
                end

                -- We've calculated the best 'random' position for our enemies
                -- Set the enemies motion off, using the collected data.
                --Now the enemies have started over - we'll try
                --and show a coin - for the user to collect
                local num = math.random(globals.coinRandomFrom, globals.coinRandomTo)
                print("Coin Random Num: "..num)

                if ( enemyPattern == 1) and (globals.sequenceConfirmed == false) then
                    globals.sequenceConfirmed = true

                    local moveTheEnemies1 = move1(enemy1)
                    local moveTheEnemies2 = move1(enemy2)

                    globals.debugSequenceInfo = "1: 1 & 2"
                    updateDebugInfo()

                    if (num < globals.minRandom ) then
                        showCoin(math.random(1, 2))
                    end

                elseif ( enemyPattern == 2) and (globals.sequenceConfirmed == false) then
                    globals.sequenceConfirmed = true

                    globals.debugSequenceInfo = "2: 1 & 3"
                    updateDebugInfo()

                    local moveTheEnemies1 = move1(enemy1)
                    local moveTheEnemies3 = move1(enemy3)

                    if (num < globals.minRandom ) then
                        showCoin(1)
                    end

                elseif ( enemyPattern == 3) and (globals.sequenceConfirmed == false) then
                    globals.sequenceConfirmed = true

                    globals.debugSequenceInfo = "3: 2 & 3"
                    updateDebugInfo()

                    local moveTheEnemies2 = move1(enemy2)
                    local moveTheEnemies3 = move1(enemy3)
     
                    if (num < globals.minRandom ) then
                        showCoin(3)
                    end

               elseif ( enemyPattern == 4) and (globals.sequenceConfirmed == false) then
                    globals.sequenceConfirmed = true

                    globals.debugSequenceInfo = "4: 1"
                    updateDebugInfo()
                    local moveTheEnemies2 = move1(enemy1)
     
                    if (num < globals.minRandom ) then
                        showCoin(1)
                    end

               elseif ( enemyPattern == 5) and (globals.sequenceConfirmed == false) then
                    globals.sequenceConfirmed = true


                    globals.debugSequenceInfo = "5: 2"
                    updateDebugInfo()

                    local moveTheEnemies2 = move1(enemy2)

                    if (num < globals.minRandom ) then
                        showCoin(2)
                    end

                elseif ( enemyPattern == 6) and (globals.sequenceConfirmed == false) then
                    globals.sequenceConfirmed = true

 
                    globals.debugSequenceInfo = "6: 3"
                    updateDebugInfo()
    
                   local moveTheEnemies3 = move1(enemy3)

                    if (num < globals.minRandom ) then
                        showCoin(3)
                    end

                end

            end
        end


        -----------------------------------------------------------------
        -- Function to show a coin
        -----------------------------------------------------------------
        function showCoin(position)

            if (coinsText ~= nil) then
                if ( globals.coinOnScreen == false ) then

                    print("Coin Position: "..globals.coinNamePosition)

                        --[[
                        globals.coin = display.newRect( 0, player.y - 23, 46, 46 )
                        globals.coin:setFillColor( helper.hex2rgb("#f2d118") )
                        --]]

                        globals.coin = display.newSprite( globals.spriteCoinSheet, globals.animationSequenceData )
                        globals.coin:setSequence( "coinCollect" )
                        globals.coin.width = 46
                        globals.coin.height = 46
                        globals.coin.anchorX = 0.5
                        globals.coin.currentFrame = 1
                        globals.coin:play()

                        groupTop:insert( globals.coin )

                        if ( position == 1) then
                            globals.coinX = enemy1.x
                            globals.coinNamePosition = "Left"
                        elseif ( position == 2) then
                            globals.coinX = enemy2.x
                            globals.coinNamePosition = "Middle"
                        elseif ( position == 3) then
                            globals.coinX = enemy3.x
                            globals.coinNamePosition = "Right"
                        end

                        if ( playerMovedTo == "Left" ) and ( globals.coinNamePosition == "Left" ) then
                            globals.coin.x = enemy3.x
                        end
                        if (playerMovedTo == "Middle" and globals.coinNamePosition == "Middle" ) then
                            globals.coin.x = enemy1.x
                        end
                        if (playerMovedTo == "Right" and globals.coinNamePosition == "Right" ) then
                            globals.coin.x = enemy1.x
                        end

                        if (globals.coin.x < 1 ) then
                            globals.coin.x = enemy1.x
                        end

                        globals.coin.y            = player.y - 43
                        globals.coinOnScreen = true

                end
            end
        end
        
        -----------------------------------------------------------------
        -- Function user has collected a coin.
        -----------------------------------------------------------------
        function coinDestroyedFunction()
            
            globals.coin:removeSelf()
            globals.coin = nil

            --Play a got hit sound
            if ( soundButton ~= nil ) then
                if ( globals.doAudio == true ) then
                    audio.play(globals.sfx_Collect1)
                end
            end

            globals.coinOnScreen = false

        end

        -----------------------------------------------------------------
        -- Function user has collected a coin.
        -----------------------------------------------------------------
        function coinCollectedFunction()
            
            globals.coin:removeSelf()
            globals.coin = nil

            globals.coins = globals.coins + 1

            coinsText:removeSelf()
            coinsText = nil

            coinsText = bmf:newString( globals.font1, globals.coins )
            coinsText.align = "right"
            coinsText.xScale = 0.5
            coinsText.yScale = 0.5
            coinsText.alpha = 0.8
            coinsText.x = globals.coinTextX
            coinsText.y = globals.coinTextY
            groupScore:insert(coinsText)

            --coinsText.text = globals.coins
            --coinsText.align = "right"
            --coinsText.x = globals.coinTextX

            --Play a got hit sound
            if ( soundButton ~= nil ) then
                if ( globals.doAudio == true ) then
                    audio.play(globals.sfx_Bling)
                end
            end

            globals.coinOnScreen = false

            --Save Coins Collected Count to device
            saveDataTable.coins = globals.coins
            loadsave.saveTable(saveDataTable, globals.saveDataFileName..".json")

        end

        -----------------------------------------------------------------
        -- Function To show the animated Puff.
        -----------------------------------------------------------------
        function showPuffAnimation(obj, whichOne)
                local myHeight = smokePuff[whichOne].height
                smokePuff[whichOne].x = obj.x
                smokePuff[whichOne].y = (floorArea.y - floorArea.height) - 25
                smokePuff[whichOne]:play()                        
        end


        -----------------------------------------------------------------
        -- Function Hide the Tap To Move from game beginning.
        -----------------------------------------------------------------
        function hideTapToStart()
            if ( tapToStart ~= nil ) then
                local toY = -300
                local hidePanel = transition.to(tapToStart, {delay=0, time=700, alpha=0.0, y=toY, transition=easing.inOutBack } )
            end
        end

        -----------------------------------------------------------------
        -- Function to reset the game - so the player can start again
        -----------------------------------------------------------------
        function resetGameFunction()

            if ( showSquishedParticles == true ) then
                physics.stop()
            end

            local function triggerReset()
                if ( soundButton ~= nil ) then
                    if ( globals.doAudio == true ) then
                        audio.stop()
                        audio.dispose( globals.musicGame )
                        --audio.dispose( globals.sfx_Fail1 )  
                        audio.dispose() 
                    end
                end

                composer.gotoScene( "sceneReset")
            end

            local endGameTimer1 = timer.performWithDelay(0, showHideGameOver("hide") )

            -- Trigger the Reset after a very short delay
            local endGameTimer2 = timer.performWithDelay(450, triggerReset )

        end


        -----------------------------------------------------------------
        -- Function switch the sound ON / OFF
        -----------------------------------------------------------------
        function toggleSoundFunction()

            if ( soundButton ~= nil ) then

                print("Toggling Sound...")

                if ( soundStatus == true ) then
                    soundOffFunction()
                else
                    soundOnFunction()
                end          
            end      

        end




        -----------------------------------------------------------------
        -- Function to go back to the Main Menu
        -----------------------------------------------------------------
        function gotoMenuFunction()

            if ( showSquishedParticles == true ) then
                physics.stop()
            end

            local function triggerReset()
                if ( soundButton ~= nil ) then
                    if ( globals.doAudio == true ) then

                        --audio.stop(1)

                        local isChannel1Playing = audio.isChannelPlaying( 1 )
                        if isChannel1Playing then
                            audio.stop()
                            audio.dispose( globals.musicGame )
                        end


                    end
                end

                composer.gotoScene( "sceneMenu")
            end

            local endGameTimer1 = timer.performWithDelay(0, showHideGameOver("hide") )

            -- Trigger the Reset after a very short delay
            local endGameTimer2 = timer.performWithDelay(650, triggerReset )

        end



        -----------------------------------------------------------------
        -- Function to Show or Hide our GameOver Panel
        -----------------------------------------------------------------
        function showHideGameOver(showHide)
            print("showHide: "..showHide)
            if showHide == "show" then

                --Stop the GameLoop running
                Runtime:removeEventListener( "enterFrame", gameLoop)

                local curentY = groupGameOver.y
                local showPanel = transition.to(groupGameOver, {delay=0, time=1100, y=0, transition=easing.inOutBounce } )
            elseif showHide == "hide" then
                local toY = -screenHeight-- - (screenHeight*0.5)
                local showPanel = transition.to(groupGameOver, {delay=0, time=400, y=toY, transition=easing.inOutBack } )
            end

        end

        -----------------------------------------------------------------
        -- Function to manage Scores, HighScores and Saving info to device
        -----------------------------------------------------------------
        function checkScore(scoreCheck)

            if ( scoreText ~= nil ) then
                print("Score: "..scoreCheck)

                --Update the Score Variable and Score Text
                score          = scoreCheck
                scoreText.text = scoreCheck

                playerPositionLocked = false

                    --Check if we have a new HighScore
                if ( highScoreText ~= nil ) then
                    if (scoreCheck > newHighscore) then
                        --Yes we do, track the NEW Highscore
                        newHighscore       = scoreCheck

                        --Store Previous Highscore Object details
                        local highscore_xScale = highScoreText.xScale
                        local highscore_yScale = highScoreText.yScale
                        local highscore_alpha = highScoreText.alpha
                        local highscore_x = highScoreText.x
                        local highscore_y = highScoreText.y
                        local highscore_align = highScoreText.align

                        --Remove From Scene
                        highScoreText:removeSelf()
                        highScoreText = nil

                        --Re-construct Highscore data
                        highScoreText = bmf:newString( globals.font1, "Highscore: "..newHighscore  )
                        highScoreText.align = highscore_align
                        highScoreText.xScale = highscore_xScale
                        highScoreText.yScale = highscore_yScale
                        highScoreText.alpha = highscore_alpha
                        highScoreText.x = highscore_x
                        highScoreText.y = highscore_y
                        groupScore:insert(highScoreText)

                        --highScoreText.text = "Highscore: "..scoreCheck

                        print("New HighScore: "..newHighscore)

                        --Save HighScore to device
                        globals.highScore       = newHighscore
                        saveDataTable.highScore = newHighscore
                        loadsave.saveTable(saveDataTable, globals.saveDataFileName..".json")

                        print("HighScore saved on device: "..newHighscore)

                    end
                end
            end

        end


        ---------------------------------------------------------------------------------------------------------
        -- create a exploding sequence for each of the biscuit parts
        ---------------------------------------------------------------------------------------------------------
         function explodePlayer(gotDieX, gotDieY, gotColour, gotCount, gotSize, gotPX, gotPY)
            local physics           = require("physics")
            physics.start()
            physics.setScale( 30 )
            physics.setGravity( 0, 40 )
            physics.setPositionIterations(6)
            ---------------------------------------------------------------------------------------------------------
            -- explode player properties 
            ---------------------------------------------------------------------------------------------------------
            local explodeParticleFadeTime       = 600
            local explodeParticleFadeDelay      = 80
            local minexplodeParticleVelocityX   = gotPX
            local maxexplodeParticleVelocityX   = 300
            local minexplodeParticleVelocityY   = gotPY
            local maxexplodeParticleVelocityY   = 0
            local explodeTransition
            local explodeParticle
            local explodeParticleArray = {}

            ---------------------------------------------------------------------------------------------------------
            -- Create a series of pixels to give effect of explosion.
            ---------------------------------------------------------------------------------------------------------
            for  i = 1, gotCount do
                local random = math.random
                local rndSize = random(gotSize)
                explodeParticle = display.newRect(0,0,rndSize,rndSize)
                groupBackground:insert( explodeParticle )
                explodeParticle:setFillColor( helper.hex2rgb(gotColour) )
                explodeParticle.x = gotDieX
                explodeParticle.y = gotDieY
                local xplFilter = { categoryBits = 1, maskBits = 2046 }

                local explodeMaterial = { "dynamic", density=10.0, friction=1.2, bounce=0.6, radius=explodeParticle.width *0.5, filter=xplFilter }
                physics.addBody(explodeParticle, explodeMaterial)

                ---------------------------------------------------------------------------------------------------------
                -- set each of the exploded bit with a random X, Y velocity.
                ---------------------------------------------------------------------------------------------------------
                local xVelocity = random(minexplodeParticleVelocityX, maxexplodeParticleVelocityX)
                local yVelocity = random(minexplodeParticleVelocityY, maxexplodeParticleVelocityY)
                explodeParticle:setLinearVelocity(xVelocity, yVelocity)
                explodeTransition = transition.to(explodeParticle, {time = explodeParticleFadeTime, delay = explodeParticleFadeDelay, alpha=0, onComplete = function(event) display.remove(explodeParticle) end})       
            end             
        end



    ---------------------------------------------------------------------------------
    -- Add game action events (these run throughout the game)
    ---------------------------------------------------------------------------------
    Runtime:addEventListener("enterFrame", gameLoop) 
    Runtime:addEventListener("enterFrame", testCollisions) 

                
    end 
end


-----------------------------------------------------------------
-- Function Updated the Sound On/Off Button
-----------------------------------------------------------------
function updateSoundButton(status)
    if ( soundButton ~= nil ) then
        if ( status == true ) then
            --Sound is ON - show Sound Off styling
            soundButton:setFillColor( helper.hex2rgb("#FFFFFF") )
        else
            --Sound is OFF - show Sound Off styling
            soundButton:setFillColor( helper.hex2rgb("#6b6b6b") )
        end
    end
end

-----------------------------------------------------------------
-- Function Set Audio OFF
-----------------------------------------------------------------
function soundOffFunction()
    soundStatus     = false
    globals.soundON = false

    for i = 0, 32 do
        audio.setVolume( 0, { channel=i } )
    end                 
    globals.volumeSFX = 0
    print("SFX & Music Volumes at 0")

    updateSoundButton(false)
end

-----------------------------------------------------------------
-- Function Set Audio ON
-----------------------------------------------------------------
function soundOnFunction()
    soundStatus     = true
    globals.soundON = true

    for i = 0, 3 do
        audio.setVolume( globals.volumeMusic, { channel=i } )
    end                 
    print("Music Volumes at "..globals.volumeMusic)

    for i = 4, 32 do
        audio.setVolume( globals.resetVolumeSFX, { channel=i } )
    end                 
    print("SFX Volumes at "..globals.resetVolumeSFX)

    updateSoundButton(true)

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

    ---------------------------------------------------------------------------------
    -- Remove our events (these run throughout the game)
    ---------------------------------------------------------------------------------
    Runtime:removeEventListener( "enterFrame", gameLoop)
    Runtime:removeEventListener( "enterFrame", testCollisions)

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
