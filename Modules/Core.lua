local Core = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

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

function Core.CreateWindow(config)
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

    -- Barra superior com título e botões
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

function Core.CreateTab(name)
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

return Core
