--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:b5600cf7119ef45171990fd5639607fa:07f8ee7e885376be044f9d5f1f106c9a:fcb605d6be80dcd0d2ba80d58e5358ee$
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
            -- Robot3_01@2x
            x=912,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot3_02@2x
            x=821,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot3_03@2x
            x=730,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot3_04@2x
            x=639,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot3_05@2x
            x=548,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot3_06@2x
            x=457,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot3_07@2x
            x=366,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot3_08@2x
            x=275,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot3_09@2x
            x=184,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot3_10@2x
            x=93,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot3_11@2x
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

    ["Robot3_01@2x"] = 1,
    ["Robot3_02@2x"] = 2,
    ["Robot3_03@2x"] = 3,
    ["Robot3_04@2x"] = 4,
    ["Robot3_05@2x"] = 5,
    ["Robot3_06@2x"] = 6,
    ["Robot3_07@2x"] = 7,
    ["Robot3_08@2x"] = 8,
    ["Robot3_09@2x"] = 9,
    ["Robot3_10@2x"] = 10,
    ["Robot3_11@2x"] = 11,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
