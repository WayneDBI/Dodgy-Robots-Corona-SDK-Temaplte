--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:076c69da6ffb0c6dc531a96c880bff8e:ecb10d834242707191fc1ccbb5ddeae4:b837c7cf4de6a3cddb04678ab9f2a028$
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
            -- Robot1_01@2x
            x=1824,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot1_02@2x
            x=1642,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot1_03@2x
            x=1460,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot1_04@2x
            x=1278,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot1_05@2x
            x=1096,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot1_06@2x
            x=914,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot1_07@2x
            x=732,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot1_08@2x
            x=550,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot1_09@2x
            x=368,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot1_10@2x
            x=186,
            y=4,
            width=178,
            height=258,

        },
        {
            -- Robot1_11@2x
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

    ["Robot1_01@2x"] = 1,
    ["Robot1_02@2x"] = 2,
    ["Robot1_03@2x"] = 3,
    ["Robot1_04@2x"] = 4,
    ["Robot1_05@2x"] = 5,
    ["Robot1_06@2x"] = 6,
    ["Robot1_07@2x"] = 7,
    ["Robot1_08@2x"] = 8,
    ["Robot1_09@2x"] = 9,
    ["Robot1_10@2x"] = 10,
    ["Robot1_11@2x"] = 11,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
