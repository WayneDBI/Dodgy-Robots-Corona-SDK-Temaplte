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
            x=1824,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot2_02@2x
            x=1642,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot2_03@2x
            x=1460,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot2_04@2x
            x=1278,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot2_05@2x
            x=1096,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot2_06@2x
            x=914,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot2_07@2x
            x=732,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot2_08@2x
            x=550,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot2_09@2x
            x=368,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot2_10@2x
            x=186,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot2_11@2x
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
