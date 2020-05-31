--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:68d6923928c9863e9359a450382c2749:9bbfa52daa9a1a91e7366deb4334028c:7c71d81f93f204ee629656d3bcc857ae$
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
            -- CoinCollect_01@2x
            x=484,
            y=4,
            width=92,
            height=92,

        },
        {
            -- CoinCollect_02@2x
            x=388,
            y=4,
            width=92,
            height=92,

        },
        {
            -- CoinCollect_03@2x
            x=292,
            y=4,
            width=92,
            height=92,

        },
        {
            -- CoinCollect_04@2x
            x=196,
            y=4,
            width=92,
            height=92,

        },
        {
            -- CoinCollect_05@2x
            x=100,
            y=4,
            width=92,
            height=92,

        },
        {
            -- CoinCollect_06@2x
            x=4,
            y=4,
            width=92,
            height=92,

        },
    },
    
    sheetContentWidth = 580,
    sheetContentHeight = 100
}

SheetInfo.frameIndex =
{

    ["CoinCollect_01@2x"] = 1,
    ["CoinCollect_02@2x"] = 2,
    ["CoinCollect_03@2x"] = 3,
    ["CoinCollect_04@2x"] = 4,
    ["CoinCollect_05@2x"] = 5,
    ["CoinCollect_06@2x"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
