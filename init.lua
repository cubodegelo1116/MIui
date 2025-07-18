local MIui = {}

function MIui:CreateWindow(config)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.Name or "MIui"
    ScreenGui.ResetOnSpawn = false

    local player = game:GetService("Players").LocalPlayer
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 480, 0, 300) -- largura aumentada
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- cor cinza escuro
    MainFrame.BorderSizePixel = 0
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Parent = ScreenGui
    MainFrame.Active = true
    MainFrame.Draggable = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    -- Barra superior (título + botões)
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- mesma cor da UI
    TitleBar.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "MIui"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    -- Botão Fechar
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 30, 1, 0)
    CloseBtn.Position = UDim2.new(1, -30, 0, 0)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- mesma cor da UI
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 18
    CloseBtn.Parent = TitleBar

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Botão Minimizar
    local MinBtn = Instance.new("TextButton")
    MinBtn.Name = "MinBtn"
    MinBtn.Size = UDim2.new(0, 30, 1, 0)
    MinBtn.Position = UDim2.new(1, -60, 0, 0)
    MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- mesma cor da UI
    MinBtn.Text = "–"
    MinBtn.TextColor3 = Color3.new(1, 1, 1)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 22
    MinBtn.Parent = TitleBar

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

    return MainFrame
end

return MIui
