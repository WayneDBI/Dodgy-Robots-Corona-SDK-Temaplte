---------------------------------------------------------------------------------
-- Code Invaders
---------------------------------------------------------------------------------
-- Course 1, game development
-- Dodgey Robots Framework
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- main.lua
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Hide the status bar on device
---------------------------------------------------------------------------------
display.setStatusBar( display.HiddenStatusBar )

---------------------------------------------------------------------------------
-- Activate addtional code modules
---------------------------------------------------------------------------------
local composer 			= require "composer"
local globals 		    = require( "lib.globalData" )
local loadsave 			= require( "lib.loadsave" )
local device 			= require( "lib.device" )
local levelData         = require( "sceneLevelData" )
bmf 					= require( "lib.bmf" )					-- This is to use bitmap fonts

---------------------------------------------------------------------------------
-- Setup Fonts to be used in game
---------------------------------------------------------------------------------
globals.FONT_DIR = "Fonts/"
globals.font1	 = bmf:load( '04b_19-hd',  globals.FONT_DIR )
globals.font2	 = bmf:load( 'avengeanceBlk-hd',  globals.FONT_DIR )
globals.font3	 = bmf:load( 'avengeanceWhite-hd', globals.FONT_DIR )
globals.font4	 = bmf:load( 'avengeanceWhiteBlackBorderShadow-hd', globals.FONT_DIR )
globals.font5	 = bmf:load( 'LuckiestGuy-hd', globals.FONT_DIR )
globals.font6	 = bmf:load( 'Romulan-hd', globals.FONT_DIR )

---------------------------------------------------------------------------------
-- Setup Game Global variables to share thoughout the game engine
---------------------------------------------------------------------------------
globals.audioPath			= "_Assets/Audio/"
globals.imagePath			= "_Assets/Images/"
globals.spritesPath			= "SpriteSheets."
globals.saveDataFileName	= "DodgyRobots_001"

globals._w 					= display.actualContentWidth  	    -- Get the devices Width
globals._h 					= display.actualContentHeight 		-- Get the devices Height
globals._cw 				= display.actualContentWidth * 0.5  -- Get the devices Width
globals._ch 				= display.actualContentHeight * 0.5 -- Get the devices Height
globals._dw 				= display.contentWidth  	        -- Get the devices Width
globals._dh 				= display.contentHeight 			-- Get the devices Height
globals._cdw 				= display.contentWidth * 0.5   	    -- Get the devices Width
globals._cdh 				= display.contentHeight * 0.5  		-- Get the devices Height

---------------------------------------------------------------------------------
-- Setup Reusable Smoke Puff effect / Animation
--------------------------------------------------------------------------------
globals.sheetPuffInfo1 = require(globals.spritesPath.."smokePuffSpritesheet")
globals.imagePuffSheet1 = graphics.newImageSheet( globals.imagePath.."smokePuffSpritesheet.png", globals.sheetPuffInfo1:getSheet() )
globals.animationSequencePuffData = {
  { name = "puffAnimation", sheet=imagePuffSheet1, frames={ 10,1,2,3,4,5,6,7,8,9,10 }, time=800, loopCount=1 },
}

globals.gameSprites = require(globals.spritesPath.."spriteSheet")
globals.imageSpriteSheet1 = graphics.newImageSheet( globals.imagePath.."spriteSheet.png", globals.gameSprites:getSheet() )

globals.gameSprites2 = require(globals.spritesPath.."spriteSheet2")
globals.imageSpriteSheet2 = graphics.newImageSheet( globals.imagePath.."spriteSheet2.png", globals.gameSprites2:getSheet() )

globals.spritesAnimation1 = require(globals.spritesPath.."spritesAnimation1")
globals.spritesAnimationSheet1 = graphics.newImageSheet( globals.imagePath.."spritesAnimation1.png", globals.spritesAnimation1:getSheet() )

globals.spritesAnimation2 = require(globals.spritesPath.."spritesAnimation2")
globals.spritesAnimationSheet2 = graphics.newImageSheet( globals.imagePath.."spritesAnimation2.png", globals.spritesAnimation2:getSheet() )

globals.spritesAnimation3 = require(globals.spritesPath.."spritesAnimation3")
globals.spritesAnimationSheet3 = graphics.newImageSheet( globals.imagePath.."spritesAnimation3.png", globals.spritesAnimation3:getSheet() )

globals.spriteCoin = require(globals.spritesPath.."spriteCoin")
globals.spriteCoinSheet = graphics.newImageSheet( globals.imagePath.."spriteCoin.png", globals.spriteCoin:getSheet() )

-----------------------------------------------------------------
-- Setup the various animation sequences used on the games scenes
-----------------------------------------------------------------
globals.animationData1 = {
   { name = "player1", start=1, count=11, time=1000 },
   { name = "player1x", frames={ 1,2,3,1,2,3,1,2,3,4,5,6,7,8,9,8,9,8,9,10,11 }, time=1700 },
}
globals.animationData2 = {
   { name = "player2", start=1, count=11, time=1000 },
   { name = "player2x", frames={ 1,2,3,1,2,3,1,2,3,4,5,6,7,8,9,8,9,8,9,10,11 }, time=1700 },
}
globals.animationData3 = {
   { name = "player3", start=1, count=11, time=1000 },
   { name = "player3x", frames={ 1,2,3,1,2,3,1,2,3,4,5,6,7,8,9,8,9,8,9,10,11 }, time=1700 },
}

globals.animationSequenceData = {
   { name = "coinCollect", frames={ 1,2,3,4,5,6 }, time=700 },
}

globals.animationSequenceData2 = {
   { name = "enemyType1", frames={ 1 } },
   { name = "enemyType2", frames={ 2,3,4,5 }, time=200 },
}


---------------------------------------------------------------------------------
-- Setup Audio Volumes and variables
--------------------------------------------------------------------------------
globals.volumeSFX			= 0.7		-- Define the SFX Volume
globals.volumeMusic			= 0.5		-- Define the Music Volume
globals.resetVolumeSFX		= 0.7		-- Define the SFX Volume Reset Value
globals.resetVolumeMusic	= 0.5		-- Define the Music Volume Reset Value
globals.soundON				= true		-- Is the sound ON or Off?
globals.musicON				= true		-- Is the sound ON or Off?
---------------------------------------------------------------------------------
-- Assign the volume to all our MUSIC Audio Channels
---------------------------------------------------------------------------------
audio.setVolume( globals.volumeMusic, 	{ channel=0 } ) -- set the volume on channel 1
audio.setVolume( globals.volumeMusic, 	{ channel=1 } ) -- set the volume on channel 1
audio.setVolume( globals.volumeMusic, 	{ channel=2 } ) -- set the volume on channel 2
audio.setVolume( globals.volumeMusic, 	{ channel=3 } ) -- set the volume on channel 3
---------------------------------------------------------------------------------
-- Assign the volume to all our SFX Audio Channels
---------------------------------------------------------------------------------
for i = 4, 32 do
	audio.setVolume( globals.volumeSFX, { channel=i } )
end 
---------------------------------------------------------------------------------
-- Reserve channels 1 - 4 for the Music. All Other channels can be used for SFX Audio
---------------------------------------------------------------------------------
audio.reserveChannels( 4 )

globals.debugShowText     = nil
globals.debugSequenceInfo = nil
globals.sequenceConfirmed = false

globals.doAudio			= false
globals.musicMenu		= nil
globals.musicGame		= nil

globals.music_Menu		= audio.loadSound( globals.audioPath.."BackToTheEightBitShort_64kbs.mp3" ) --music1, music2, music3
globals.music_Game		= audio.loadSound( globals.audioPath.."BackToTheEightBit_64kbs.mp3" )

globals.sfx_Collect1	= audio.loadSound( globals.audioPath.."Collect1.mp3" )
globals.sfx_Collect2	= audio.loadSound( globals.audioPath.."Collect2.mp3" )
globals.sfx_Collect3	= audio.loadSound( globals.audioPath.."Collect3.mp3" )
globals.sfx_Collect4	= audio.loadSound( globals.audioPath.."Collect4.mp3" )
globals.sfx_HitChoir	= audio.loadSound( globals.audioPath.."HitChoir.mp3" )
globals.sfx_HitDie		= audio.loadSound( globals.audioPath.."HitDie.mp3" )
globals.sfx_Tap1		= audio.loadSound( globals.audioPath.."Tap1.mp3" )
globals.sfx_Tap2		= audio.loadSound( globals.audioPath.."Tap2.mp3" )
globals.sfx_Move1		= audio.loadSound( globals.audioPath.."Move1.mp3" )
globals.sfx_Bling		= audio.loadSound( globals.audioPath.."Bling.mp3" )
globals.sfx_Drop		= audio.loadSound( globals.audioPath.."Drop.mp3" )
globals.sfx_Fail1		= audio.loadSound( globals.audioPath.."Fail1.mp3" )
globals.sfx_Choir1		= audio.loadSound( globals.audioPath.."Choir1.mp3" )

globals.sfx_Thump1		= audio.loadSound( globals.audioPath.."Thump1.mp3" )
globals.sfx_Thump2		= audio.loadSound( globals.audioPath.."Thump2.mp3" )
globals.sfx_thumpSounds = {
			thump1 = audio.loadSound(globals.audioPath.."Thump1.mp3"),
			thump2 = audio.loadSound(globals.audioPath.."Thump2.mp3"),
		}

globals.sfx_Slash1		= audio.loadSound( globals.audioPath.."Slash1.mp3" )
globals.sfx_Slash2		= audio.loadSound( globals.audioPath.."Slash2.mp3" )
globals.sfx_Slash3		= audio.loadSound( globals.audioPath.."Slash3.mp3" )
globals.sfx_slashSounds = {
			slash1 = audio.loadSound(globals.audioPath.."Slash1.mp3"),
			slash2 = audio.loadSound(globals.audioPath.."Slash2.mp3"),
			slash3 = audio.loadSound(globals.audioPath.."Slash3.mp3") 
		}


---------------------------------------------------------------------------------
-- Setup Scaling factors if required.
--------------------------------------------------------------------------------
globals.hudExtraY			= 0
globals.factorX				= 0.4166	
globals.factorY				= 0.46875	
globals.coinTextX			= 0
globals.coinTextY			= 0
globals.coinX				= 0	
globals.coin				= nil
globals.coinOnScreen		= false
globals.minRandom			= 2
globals.coinRandomFrom		= 1
globals.coinRandomTo		= 3 -- setting a higher number reduces chances
globals.coinNamePosition	= "Left"

---------------------------------------------------------------------------------
-- Save / Load game data
--------------------------------------------------------------------------------
_G.saveDataTable					= {} -- Define the Save/Load base Table to hold our data
---------------------------------------------------------------------------------
-- Load in the saved data to our game table
-- Check the files exists before !
---------------------------------------------------------------------------------
if loadsave.fileExists(globals.saveDataFileName..".json", system.DocumentsDirectory) then
	saveDataTable = loadsave.loadTable(globals.saveDataFileName..".json")
else
	saveDataTable.level 				= 1
	saveDataTable.highScore				= 0
	saveDataTable.playerSelect 			= 1
	saveDataTable.coins		 			= 0
	saveDataTable.player1Unlocked		= true
	saveDataTable.player2Unlocked		= false
	saveDataTable.player3Unlocked		= false
	saveDataTable.level1Unlocked		= true
	saveDataTable.level2Unlocked		= false
	saveDataTable.level3Unlocked		= false

	---------------------------------------------------------------------------------
	-- Save the new json file, for referencing later..
	---------------------------------------------------------------------------------
	loadsave.saveTable(saveDataTable, globals.saveDataFileName..".json")
end
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Load in the Data
---------------------------------------------------------------------------------
saveDataTable = loadsave.loadTable(globals.saveDataFileName..".json")
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Assign the Level and other variables to the game variables.
---------------------------------------------------------------------------------
globals.levelStartIndex  	= 1 	                     -- Level Select start position
globals.unlockCoinsLevel1	= levelData.coinsRequired[1] -- How many Coimns to unlock Level 1?
globals.unlockCoinsLevel2	= levelData.coinsRequired[2] -- How many Coimns to unlock Level 2?
globals.unlockCoinsLevel3	= levelData.coinsRequired[3] -- How many Coimns to unlock Level 3?
globals.numberOfLevels		= 3 	                     -- How many levels does our game have?
globals.level				= saveDataTable.level 	     -- Level the player is at
globals.highScore			= saveDataTable.highScore 	 -- Saved High Score
globals.playerSelect		= saveDataTable.playerSelect -- Which player enabled ?
globals.coins				= saveDataTable.coins        -- Coins collected ?
globals.player1Unlocked		= saveDataTable.player1Unlocked -- is player 1 unlocked
globals.player2Unlocked		= saveDataTable.player2Unlocked -- is player 2 unlocked
globals.player3Unlocked		= saveDataTable.player3Unlocked -- is player 3 unlocked
globals.level1Unlocked		= saveDataTable.level1Unlocked -- is level 1 unlocked
globals.level2Unlocked		= saveDataTable.level2Unlocked -- is level 1 unlocked
globals.level3Unlocked		= saveDataTable.level3Unlocked -- is level 1 unlocked


---------------------------------------------------------------------------------
-- Surpress the print statements?
---------------------------------------------------------------------------------
globals.supressPrint 				= false
if (globals.supressPrint) then
	_G.print = function() end 
end

---------------------------------------------------------------------------------
-- Enable debug by setting to [true] to see FPS and Memory usage.
---------------------------------------------------------------------------------
globals.doDebug 					= false

if (globals.doDebug) then
	composer.isDebug = true
	local fps = require("lib.fps")
	local performance = fps.PerformanceOutput.new();
	performance.group.x, performance.group.y = (display.contentWidth/2)-50,  display.contentWidth/2-70;
	performance.alpha = 0.3; -- So it doesn't get in the way of the rest of the scene
end


---------------------------------------------------------------------------------
-- Establish which device the game is being run on.
---------------------------------------------------------------------------------
if ( device.isApple ) then
	globals.Android	= false
	print("Running on iOS")	
	if ( device.is_iPad ) then
		globals.iPad = true
		print("Device Type: iPad")
	else
		globals.iPad = false
		if (display.pixelHeight > 960) then
			globals.iPhone5 = true
			print("Device Type: iPhone 5-6")
		else
			globals.iPhone5 = false
			print("Device Type: iPhone 3-4")
		end
	end
else
	globals.Android = true
	globals.iPad = false
	globals.iPhone5 = false
	print("Running on Android")
end

-- Gather insets (function returns these in the order of top, left, bottom, right)
globals.topInset, globals.leftInset, globals.bottomInset, globals.rightInset = display.getSafeAreaInsets()

------------------------------------------------------------------------------------------------------------------------------------
-- Function to load the initial scene
------------------------------------------------------------------------------------------------------------------------------------
local function startApp()
	composer.gotoScene( levelData.sceneStart )	--This is our main menu
end


------------------------------------------------------------------------------------------------------------------------------------
--Start Game after a short delay.
------------------------------------------------------------------------------------------------------------------------------------
timer.performWithDelay(5, startApp )
