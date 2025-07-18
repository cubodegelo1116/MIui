local MIui = {}

-- Código Core (funções básicas)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ScreenGui
local MainFrame
local TabsFrame
local ContentFrame

local tabs = {}
local selectedTab = nil

local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

function MIui.CreateWindow(config)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.Name or "MIui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 480, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    MainFrame.BorderSizePixel = 0
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Parent = ScreenGui
    MainFrame.Active = true
    MainFrame.Draggable = true
    createUICorner(MainFrame, 10)

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
    TitleBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = config.Title or "MIui"
    TitleLabel.TextColor3 = Color3.new(1,1,1)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 20
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local function createButton(text, posX)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 30, 1, 0)
        btn.Position = UDim2.new(1, posX, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        btn.Text = text
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = (text == "–") and 22 or 18
        btn.Parent = TitleBar
        return btn
    end

    local CloseBtn = createButton("X", -30)
    local MinBtn = createButton("–", -60)

    local isMinimized = false
    local storedSize = MainFrame.Size

    MinBtn.MouseButton1Click:Connect(function()
        if not isMinimized then
            storedSize = MainFrame.Size
            MainFrame.Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, 30)
            isMinimized = true
        else
            MainFrame.Size = storedSize
            isMinimized = false
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "TabsFrame"
    TabsFrame.Size = UDim2.new(1, 0, 0, 30)
    TabsFrame.Position = UDim2.new(0, 0, 0, 30)
    TabsFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    TabsFrame.Parent = MainFrame
    createUICorner(TabsFrame, 8)

    ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -20, 1, -70)
    ContentFrame.Position = UDim2.new(0, 10, 0, 65)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    createUICorner(ContentFrame, 8)

    tabs = {}
    selectedTab = nil

    return MainFrame
end

function MIui.CreateTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 100, 1, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
    tabButton.Text = name
    tabButton.TextColor3 = Color3.new(1,1,1)
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 16
    tabButton.Parent = TabsFrame

    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = ContentFrame

    tabButton.MouseButton1Click:Connect(function()
        for _, v in pairs(tabs) do
            v.Button.BackgroundColor3 = Color3.fromRGB(40,40,40)
            v.Content.Visible = false
        end
        tabButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
        tabContent.Visible = true
        selectedTab = tabContent
    end)

    local tabData = {
        Button = tabButton,
        Content = tabContent,
        Elements = {}
    }

    table.insert(tabs, tabData)

    if #tabs == 1 then
        tabButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
        tabContent.Visible = true
        selectedTab = tabContent
    end

    function tabData:UpdateLayout()
        local y = 0
        for _, elem in pairs(self.Elements) do
            elem.Position = UDim2.new(0, 0, 0, y)
            y = y + elem.Size.Y.Offset + 10
        end
    end

    return tabData
end

-- Código Elements (botão, toggle, slider, parágrafo)

local function createButton(tab, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text
    btn.Parent = tab.Content
    createUICorner(btn, 6)
    btn.MouseButton1Click:Connect(callback)
    table.insert(tab.Elements, btn)
    tab:UpdateLayout()
    return btn
end

local function createToggle(tab, text, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 30)
    container.BackgroundTransparency = 1
    container.Parent = tab.Content

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(0.85, 0, 0.15, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    toggleBtn.Parent = container

    createUICorner(toggleBtn, 6)

    local toggled = false
    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(100,200,100)
            toggleBtn.Text = "ON"
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
            toggleBtn.Text = "OFF"
        end
        if callback then
            callback(toggled)
        end
    end)

    table.insert(tab.Elements, container)
    tab:UpdateLayout()
    return container
end

local function createSlider(tab, text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = tab.Content

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, 0, 0, 15)
    sliderBar.Position = UDim2.new(0, 0, 0, 25)
    sliderBar.BackgroundColor3 = Color3.fromRGB(70,70,70)
    sliderBar.Parent = container
    createUICorner(sliderBar, 6)

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100,200,100)
    sliderFill.Parent = sliderBar
    createUICorner(sliderFill, 6)

    local UserInputService = game:GetService("UserInputService")
    local dragging = false

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            local value = math.floor(min + (max - min) * pos)
            label.Text = text .. ": " .. tostring(value)
            if callback then
                callback(value)
            end
        end
    end)

    table.insert(tab.Elements, container)
    tab:UpdateLayout()
    return container
end

local function createParagraph(tab, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 50)
    label.BackgroundTransparency = 1
    label.TextWrapped = true
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tab.Content

    table.insert(tab.Elements, label)
    tab:UpdateLayout()
    return label
end

-- Expõe funções

function MIui:CreateTab(name)
    return MIui.CreateTab(name)
end

function MIui:AddButton(tab, text, callback)
    return createButton(tab, text, callback)
end

function MIui:AddToggle(tab, text, callback)
    return createToggle(tab, text, callback)
end

function MIui:AddSlider(tab, text, min, max, default, callback)
    return createSlider(tab, text, min, max, default, callback)
end

function MIui:AddParagraph(tab, text)
    return createParagraph(tab, text)
end

return MIui
