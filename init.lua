-- MIui/init.lua
local MIui = {}

local Core = require(script.Modules.Core)
local Elements = require(script.Modules.Elements)

function MIui:CreateWindow(config)
    return Core:CreateWindow(config)
end

return MIui
