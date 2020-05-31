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
            x=772,
            y=4,
            width=188,
            height=1140,

        },
        {
            -- Squasher2_01@2x
            x=580,
            y=4,
            width=188,
            height=1140,

        },
        {
            -- Squasher2_02@2x
            x=388,
            y=4,
            width=188,
            height=1140,

        },
        {
            -- Squasher2_03@2x
            x=196,
            y=4,
            width=188,
            height=1140,

        },
        {
            -- Squasher2_04@2x
            x=4,
            y=4,
            width=188,
            height=1140,

        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 2048
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
