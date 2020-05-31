--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:53db6969118039f976935041d6d0e347:a3d52316b91d261a731a67d168835e9f:470e5159c4f7714b27002a0964fd74b8$
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
            -- Robot2_01@2x
            x=912,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot2_02@2x
            x=821,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot2_03@2x
            x=730,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot2_04@2x
            x=639,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot2_05@2x
            x=548,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot2_06@2x
            x=457,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot2_07@2x
            x=366,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot2_08@2x
            x=275,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot2_09@2x
            x=184,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot2_10@2x
            x=93,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot2_11@2x
            x=2,
            y=2,
            width=89,
            height=129,

        },
    },
    
    sheetContentWidth = 1003,
    sheetContentHeight = 133
}

SheetInfo.frameIndex =
{

    ["Robot2_01@2x"] = 1,
    ["Robot2_02@2x"] = 2,
    ["Robot2_03@2x"] = 3,
    ["Robot2_04@2x"] = 4,
    ["Robot2_05@2x"] = 5,
    ["Robot2_06@2x"] = 6,
    ["Robot2_07@2x"] = 7,
    ["Robot2_08@2x"] = 8,
    ["Robot2_09@2x"] = 9,
    ["Robot2_10@2x"] = 10,
    ["Robot2_11@2x"] = 11,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
