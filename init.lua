local MIui = {}

local Core = require(script.Modules.Core)
local Elements = require(script.Modules.Elements)

-- Expõe as funções principais, delegando para Core e Elements

function MIui:CreateWindow(config)
    return Core.CreateWindow(config)
end

function MIui:CreateTab(name)
    return Core.CreateTab(name)
end

function MIui:AddButton(tab, text, callback)
    return Elements.CreateButton(tab, text, callback)
end

function MIui:AddToggle(tab, text, callback)
    return Elements.CreateToggle(tab, text, callback)
end

function MIui:AddSlider(tab, text, min, max, default, callback)
    return Elements.CreateSlider(tab, text, min, max, default, callback)
end

function MIui:AddParagraph(tab, text)
    return Elements.CreateParagraph(tab, text)
end

return MIui
