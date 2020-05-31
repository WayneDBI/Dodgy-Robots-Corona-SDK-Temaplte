--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:3edad88a168481a58777808cd172e151:f1bcdc9344d7d1ef04557898919cd383:2c783da5ccdef5a25b89b9452c6530fa$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- Squasher1@2x
            x=386,
            y=2,
            width=94,
            height=570,

        },
        {
            -- Squasher2_01@2x
            x=290,
            y=2,
            width=94,
            height=570,

        },
        {
            -- Squasher2_02@2x
            x=194,
            y=2,
            width=94,
            height=570,

        },
        {
            -- Squasher2_03@2x
            x=98,
            y=2,
            width=94,
            height=570,

        },
        {
            -- Squasher2_04@2x
            x=2,
            y=2,
            width=94,
            height=570,

        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 1024
}

SheetInfo.frameIndex =
{

    ["Squasher1@2x"] = 1,
    ["Squasher2_01@2x"] = 2,
    ["Squasher2_02@2x"] = 3,
    ["Squasher2_03@2x"] = 4,
    ["Squasher2_04@2x"] = 5,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
