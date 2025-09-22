-- KaiPvPHub v1.1
-- Auto TP + Auto Attack PvP Players + Auto Enable PVP + Rainbow UI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0,12)

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Thickness = 3

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1,0,1,0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(255,255,255)
InfoLabel.Font = Enum.Font.SourceSansBold
InfoLabel.TextScaled = true
InfoLabel.Text = "Kai PvP Hub v1.1\nFPS: 0 | Ping: 0\nServer: ..."
InfoLabel.Parent = Frame

local RainbowText = Instance.new("TextLabel")
RainbowText.Size = UDim2.new(0,300,0,40)
RainbowText.Position = UDim2.new(0,10,1,-50)
RainbowText.BackgroundTransparency = 1
RainbowText.Text = "KaiPvPHub1.1"
RainbowText.TextSize = 32
RainbowText.Font = Enum.Font.SourceSansBold
RainbowText.Parent = ScreenGui

-- Rainbow
local function rainbowColor(h)
    return Color3.fromHSV(h,1,1)
end

local hue = 0
RunService.RenderStepped:Connect(function()
    hue = (hue + 0.005) % 1
    UIStroke.Color = rainbowColor(hue)
    RainbowText.TextColor3 = rainbowColor(hue)
    local x = math.sin(tick()*2) * 10
    RainbowText.Position = UDim2.new(0,10 + x,1,-50)

    -- Update Info
    local fps = math.floor(1/RunService.RenderStepped:Wait())
    local ping = math.floor(tonumber(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()))
    InfoLabel.Text = "Kai PvP Hub v1.1\nFPS: "..fps.." | Ping: "..ping.."\nServer: "..game.JobId
end)

-- Auto Enable PvP cho mình
task.spawn(function()
    while task.wait(2) do
        local stats = LocalPlayer:FindFirstChild("Data")
        local myPvp = LocalPlayer:FindFirstChild("PVP") or (stats and stats:FindFirstChild("PVP"))
        if myPvp and myPvp.Value == false then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("EnablePVP") -- lệnh bật PvP
            end)
        end
    end
end)

-- Auto TP + Attack PvP Players
task.spawn(function()
    while task.wait(0.3) do
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local stats = plr:FindFirstChild("Data")
                local pvpEnabled = plr:FindFirstChild("PVP") or (stats and stats:FindFirstChild("PVP"))
                if pvpEnabled and pvpEnabled.Value == true then
                    LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0,3,0))
                    local tool = LocalPlayer.Backpack:FindFirstChild("Combat") or LocalPlayer.Character:FindFirstChild("Combat")
                    if tool then
                        tool.Parent = LocalPlayer.Character
                        game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                    end
                end
            end
        end
    end
end)
