local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "GameFun.cc | Alpha ", HidePremium = true ,  SaveConfig = true, ConfigFolder = "GameFun"})


local function aimbot()
    local Area = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local MyCharacter = LocalPlayer.Character
    local MyRoot = MyCharacter:FindFirstChild("HumanoidRootPart")
    local MyHumanoid = MyCharacter:FindFirstChild("Humanoid")
    local Mouse = LocalPlayer:GetMouse()
    local MyView = Area.CurrentCamera
    local MyTeamColor = LocalPlayer.TeamColor
    local HoldingM2 = false
    local Active = false
    local Lock = false
    local Epitaph = .187 ---Note: The Bigger The Number, The More Prediction.
    local HeadOffset = Vector3.new(0, .1, 0)
    
    _G.TeamCheck = false
    _G.AimPart = "HumanoidRootPart"
    _G.Sensitivity = 0
    _G.CircleSides = 64
    _G.CircleColor = Color3.fromRGB(255, 0, 130)
    _G.CircleTransparency = 0
    _G.CircleRadius = 200
    _G.CircleFilled = false
    _G.CircleVisible = true
    _G.CircleThickness = 1
    
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Position = Vector2.new(MyView.ViewportSize.X / 2, MyView.ViewportSize.Y / 2)
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Filled = _G.CircleFilled
    FOVCircle.Color = _G.CircleColor
    FOVCircle.Visible = _G.CircleVisible
    FOVCircle.Transparency = _G.CircleTransparency
    FOVCircle.NumSides = _G.CircleSides
    FOVCircle.Thickness = _G.CircleThickness
    
    local function CursorLock()
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
    local function UnLockCursor()
        HoldingM2 = false Active = false Lock = false 
        UIS.MouseBehavior = Enum.MouseBehavior.Default
    end
    function FindNearestPlayer()
        local dist = math.huge
        local Target = nil
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") and v then
                local TheirCharacter = v.Character
                local CharacterRoot, Visible = MyView:WorldToViewportPoint(TheirCharacter[_G.AimPart].Position)
                if Visible then
                    local RealMag = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(CharacterRoot.X, CharacterRoot.Y)).Magnitude
                    if RealMag < dist and RealMag < FOVCircle.Radius then
                        dist = RealMag
                        Target = TheirCharacter
                    end
                end
            end
        end
        return Target
    end
    
    UIS.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton2 then
            HoldingM2 = true
            Active = true
            Lock = true
            if Active then
                local The_Enemy = FindNearestPlayer()
                while HoldingM2 do task.wait(.000001)
                    if Lock and The_Enemy ~= nil then
                        local Future = The_Enemy.HumanoidRootPart.CFrame + (The_Enemy.HumanoidRootPart.Velocity * Epitaph + HeadOffset)
                        MyView.CFrame = CFrame.lookAt(MyView.CFrame.Position, Future.Position)
                        CursorLock()
                    end
                end
            end
        end
    end)
    UIS.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton2 then
            UnLockCursor()
        end
    end)
    game.StarterGui:SetCore("SendNotification", {Title = "Working.", Text = "Success, Script Loaded.", Duration = 4,})
end

local function WallHack()
    local color = BrickColor.new(50,0,250)
    local transparency = .8
    
    local Players = game:GetService("Players")
    local function _ESP(c)
      repeat wait() until c.PrimaryPart ~= nil
      for i,p in pairs(c:GetChildren()) do
        if p.ClassName == "Part" or p.ClassName == "MeshPart" then
          if p:FindFirstChild("shit") then p.shit:Destroy() end
          local a = Instance.new("BoxHandleAdornment",p)
          a.Name = "shit"
          a.Size = p.Size
          a.Color = color
          a.Transparency = transparency
          a.AlwaysOnTop = true    
          a.Visible = true    
          a.Adornee = p
          a.ZIndex = true    
    
        end
      end
    end
    local function ESP()
      for i,v in pairs(Players:GetChildren()) do
        if v ~= game.Players.LocalPlayer then
          if v.Character then
            _ESP(v.Character)
          end
          v.CharacterAdded:Connect(function(chr)
            _ESP(chr)
          end)
        end
      end
      Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(chr)
          _ESP(chr)
        end)  
      end)
    end
    ESP()
end
local function box()
    local settings = {
        defaultcolor = Color3.fromRGB(255,0,0),
        teamcheck = false,
        teamcolor = true
     };
     
     -- services
     local runService = game:GetService("RunService");
     local players = game:GetService("Players");
     
     -- variables
     local localPlayer = players.LocalPlayer;
     local camera = workspace.CurrentCamera;
     
     -- functions
     local newVector2, newColor3, newDrawing = Vector2.new, Color3.new, Drawing.new;
     local tan, rad = math.tan, math.rad;
     local round = function(...) local a = {}; for i,v in next, table.pack(...) do a[i] = math.round(v); end return unpack(a); end;
     local wtvp = function(...) local a, b = camera.WorldToViewportPoint(camera, ...) return newVector2(a.X, a.Y), b, a.Z end;
     
     local espCache = {};
     local function createEsp(player)
        local drawings = {};
        
        drawings.box = newDrawing("Square");
        drawings.box.Thickness = 1;
        drawings.box.Filled = false;
        drawings.box.Color = settings.defaultcolor;
        drawings.box.Visible = false;
        drawings.box.ZIndex = 2;
     
        drawings.boxoutline = newDrawing("Square");
        drawings.boxoutline.Thickness = 3;
        drawings.boxoutline.Filled = false;
        drawings.boxoutline.Color = newColor3();
        drawings.boxoutline.Visible = false;
        drawings.boxoutline.ZIndex = 1;
     
        espCache[player] = drawings;
     end
     
     local function removeEsp(player)
        if rawget(espCache, player) then
            for _, drawing in next, espCache[player] do
                drawing:Remove();
            end
            espCache[player] = nil;
        end
     end
     
     local function updateEsp(player, esp)
        local character = player and player.Character;
        if character then
            local cframe = character:GetModelCFrame();
            local position, visible, depth = wtvp(cframe.Position);
            esp.box.Visible = visible;
            esp.boxoutline.Visible = visible;
     
            if cframe and visible then
                local scaleFactor = 1 / (depth * tan(rad(camera.FieldOfView / 2)) * 2) * 1000;
                local width, height = round(4 * scaleFactor, 5 * scaleFactor);
                local x, y = round(position.X, position.Y);
     
                esp.box.Size = newVector2(width, height);
                esp.box.Position = newVector2(round(x - width / 2, y - height / 2));
                esp.box.Color = settings.teamcolor and player.TeamColor.Color or settings.defaultcolor;
     
                esp.boxoutline.Size = esp.box.Size;
                esp.boxoutline.Position = esp.box.Position;
            end
        else
            esp.box.Visible = false;
            esp.boxoutline.Visible = false;
        end
     end
     
     -- main
     for _, player in next, players:GetPlayers() do
        if player ~= localPlayer then
            createEsp(player);
        end
     end
     
     players.PlayerAdded:Connect(function(player)
        createEsp(player);
     end);
     
     players.PlayerRemoving:Connect(function(player)
        removeEsp(player);
     end)
     
     runService:BindToRenderStep("esp", Enum.RenderPriority.Camera.Value, function()
        for player, drawings in next, espCache do
            if settings.teamcheck and player.Team == localPlayer.Team then
                continue;
            end
     
            if drawings and player ~= localPlayer then
                updateEsp(player, drawings);
            end
        end
     end)
end
local function spinbot()
    while game:GetService("RunService").RenderStepped:Wait() do
        -- Script generated by R2Sv2
        -- R2Sv2 developed by Luckyxero
        -- Remote Path: game:GetService("ReplicatedStorage").Events.RemoteEvent
        
        local A_1 =
        {
        [1] = "Turn",
        [2] = math.random(math.huge,1000000000),
        [3] = true
        }
        local Event = game:GetService("ReplicatedStorage").Events.RemoteEvent
        Event:FireServer(A_1)
        end
end

local Tab = Window:MakeTab({
	Name = "AimBot",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Tab_2 = Window:MakeTab({
	Name = "Box",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
Tab_2:AddButton({
    Name = "Chams",
    Callback = function ()
        WallHack()
    end
})
Tab_2:AddButton({
    Name = "Box",
    Callback = function ()
        box()
    end
})
Tab:AddButton({
    Name = "Spin-Bot",
    Callback = function ()
        spinbot()
    end
})
Tab:AddButton({
	Name = "aimbot",
	Callback = function()
      		aimbot()
  	end    
})