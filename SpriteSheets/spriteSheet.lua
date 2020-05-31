--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:d15499abf045326382c2bf8196a5c55d:229ccbd8dbf1d3c22173d5b1f42e5ebf:e3d0263a671641c2f54ff79ff798a04d$
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
            x=98,
            y=392,
            width=46,
            height=46,

        },
        {
            -- CoinCollect_02@2x
            x=50,
            y=392,
            width=46,
            height=46,

        },
        {
            -- CoinCollect_03@2x
            x=2,
            y=392,
            width=46,
            height=46,

        },
        {
            -- CoinCollect_04@2x
            x=272,
            y=358,
            width=46,
            height=46,

        },
        {
            -- CoinCollect_05@2x
            x=272,
            y=310,
            width=46,
            height=46,

        },
        {
            -- CoinCollect_06@2x
            x=272,
            y=262,
            width=46,
            height=46,

        },
        {
            -- Robot1_01@2x
            x=272,
            y=132,
            width=88,
            height=128,

        },
        {
            -- Robot1_02@2x
            x=272,
            y=2,
            width=88,
            height=128,

        },
        {
            -- Robot1_03@2x
            x=182,
            y=262,
            width=88,
            height=128,

        },
        {
            -- Robot1_04@2x
            x=182,
            y=132,
            width=88,
            height=128,

        },
        {
            -- Robot1_05@2x
            x=182,
            y=2,
            width=88,
            height=128,

        },
        {
            -- Robot1_06@2x
            x=92,
            y=262,
            width=88,
            height=128,

        },
        {
            -- Robot1_07@2x
            x=92,
            y=132,
            width=88,
            height=128,

        },
        {
            -- Robot1_08@2x
            x=92,
            y=2,
            width=88,
            height=128,

        },
        {
            -- Robot1_09@2x
            x=2,
            y=262,
            width=88,
            height=128,

        },
        {
            -- Robot1_10@2x
            x=2,
            y=132,
            width=88,
            height=128,

        },
        {
            -- Robot1_11@2x
            x=2,
            y=2,
            width=88,
            height=128,

        },
    },
    
    sheetContentWidth = 362,
    sheetContentHeight = 440
}

SheetInfo.frameIndex =
{

    ["CoinCollect_01@2x"] = 1,
    ["CoinCollect_02@2x"] = 2,
    ["CoinCollect_03@2x"] = 3,
    ["CoinCollect_04@2x"] = 4,
    ["CoinCollect_05@2x"] = 5,
    ["CoinCollect_06@2x"] = 6,
    ["Robot1_01@2x"] = 7,
    ["Robot1_02@2x"] = 8,
    ["Robot1_03@2x"] = 9,
    ["Robot1_04@2x"] = 10,
    ["Robot1_05@2x"] = 11,
    ["Robot1_06@2x"] = 12,
    ["Robot1_07@2x"] = 13,
    ["Robot1_08@2x"] = 14,
    ["Robot1_09@2x"] = 15,
    ["Robot1_10@2x"] = 16,
    ["Robot1_11@2x"] = 17,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
