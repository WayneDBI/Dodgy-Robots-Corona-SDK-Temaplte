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
            x=912,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot1_02@2x
            x=821,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot1_03@2x
            x=730,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot1_04@2x
            x=639,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot1_05@2x
            x=548,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot1_06@2x
            x=457,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot1_07@2x
            x=366,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot1_08@2x
            x=275,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot1_09@2x
            x=184,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot1_10@2x
            x=93,
            y=2,
            width=89,
            height=129,

        },
        {
            -- Robot1_11@2x
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
