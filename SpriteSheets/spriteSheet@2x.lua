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
            x=196,
            y=784,
            width=92,
            height=92,

        },
        {
            -- CoinCollect_02@2x
            x=100,
            y=784,
            width=92,
            height=92,

        },
        {
            -- CoinCollect_03@2x
            x=4,
            y=784,
            width=92,
            height=92,

        },
        {
            -- CoinCollect_04@2x
            x=544,
            y=716,
            width=92,
            height=92,

        },
        {
            -- CoinCollect_05@2x
            x=544,
            y=620,
            width=92,
            height=92,

        },
        {
            -- CoinCollect_06@2x
            x=544,
            y=524,
            width=92,
            height=92,

        },
        {
            -- Robot1_01@2x
            x=544,
            y=264,
            width=176,
            height=256,

        },
        {
            -- Robot1_02@2x
            x=544,
            y=4,
            width=176,
            height=256,

        },
        {
            -- Robot1_03@2x
            x=364,
            y=524,
            width=176,
            height=256,

        },
        {
            -- Robot1_04@2x
            x=364,
            y=264,
            width=176,
            height=256,

        },
        {
            -- Robot1_05@2x
            x=364,
            y=4,
            width=176,
            height=256,

        },
        {
            -- Robot1_06@2x
            x=184,
            y=524,
            width=176,
            height=256,

        },
        {
            -- Robot1_07@2x
            x=184,
            y=264,
            width=176,
            height=256,

        },
        {
            -- Robot1_08@2x
            x=184,
            y=4,
            width=176,
            height=256,

        },
        {
            -- Robot1_09@2x
            x=4,
            y=524,
            width=176,
            height=256,

        },
        {
            -- Robot1_10@2x
            x=4,
            y=264,
            width=176,
            height=256,

        },
        {
            -- Robot1_11@2x
            x=4,
            y=4,
            width=176,
            height=256,

        },
    },
    
    sheetContentWidth = 724,
    sheetContentHeight = 880
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
