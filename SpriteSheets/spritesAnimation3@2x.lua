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
            x=1824,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot3_02@2x
            x=1642,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot3_03@2x
            x=1460,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot3_04@2x
            x=1278,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot3_05@2x
            x=1096,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot3_06@2x
            x=914,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot3_07@2x
            x=732,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot3_08@2x
            x=550,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot3_09@2x
            x=368,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot3_10@2x
            x=186,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot3_11@2x
            x=4,
            y=4,
            width=178,
            height=258,

        },
    },
    
    sheetContentWidth = 2006,
    sheetContentHeight = 266
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
