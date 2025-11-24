--[[
    Liquid UI V5 - CORE MODULE
    Style: GTA V Internal / Liquid Reference
]]

local Library = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- [ COLORS & THEME ]
local Liquid = {
    Colors = {
        Main        = Color3.fromRGB(14, 14, 16),
        Sidebar     = Color3.fromRGB(18, 18, 21),
        Header      = Color3.fromRGB(20, 20, 23),
        Content     = Color3.fromRGB(22, 22, 25),
        Divider     = Color3.fromRGB(35, 35, 40),
        Element     = Color3.fromRGB(30, 30, 34),
        Stroke      = Color3.fromRGB(40, 40, 45),
        Text        = Color3.fromRGB(235, 235, 235),
        TextDark    = Color3.fromRGB(130, 130, 140),
        Accent      = Color3.fromRGB(255, 255, 255),
        Hover       = Color3.fromRGB(40, 40, 45),
        ValueBox    = Color3.fromRGB(12, 12, 14)
    },
    Font = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold
}

-- [ UTILS ]
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function MakeDraggable(dragObj, moveObj)
    local dragging, dragStart, startPos
    dragObj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = moveObj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            moveObj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- [ MAIN LIBRARY LOGIC ]
function Library:Window(Config)
    local Screen = Create("ScreenGui", {Name = "LiquidUI_V5", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true})
    
    local MainFrame = Create("Frame", {
        Name = "Main", Parent = Screen, BackgroundColor3 = Liquid.Colors.Main,
        Position = UDim2.new(0.5, -400, 0.5, -275), Size = UDim2.new(0, 800, 0, 550), ClipsDescendants = true
    })
    Create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 6)})
    Create("UIStroke", {Parent = MainFrame, Color = Liquid.Colors.Stroke, Thickness = 1})

    MakeDraggable(MainFrame, MainFrame)

    -- Header
    local Header = Create("Frame", {Parent = MainFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 65), ZIndex = 2})
    local LogoArea = Create("Frame", {Parent = Header, BackgroundTransparency = 1, Size = UDim2.new(0, 200, 1, 0)})
    Create("TextLabel", {Parent = LogoArea, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 14), Size = UDim2.new(1, 0, 0, 22), Font = Enum.Font.GothamBlack, Text = Config.Name or "Liquid", TextColor3 = Color3.fromRGB(110, 110, 120), TextSize = 22})
    
    local NavArea = Create("Frame", {Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0, 200, 0, 0), Size = UDim2.new(1, -200, 1, 0)})
    Create("UIListLayout", {Parent = NavArea, FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 20)})

    -- Sidebar & Lines
    local Sidebar = Create("Frame", {Parent = MainFrame, BackgroundColor3 = Liquid.Colors.Sidebar, Position = UDim2.new(0, 0, 0, 65), Size = UDim2.new(0, 200, 1, -65), BorderSizePixel = 0})
    Create("Frame", {Parent = MainFrame, BackgroundColor3 = Liquid.Colors.Stroke, Position = UDim2.new(0, 200, 0, 65), Size = UDim2.new(0, 1, 1, -65), BorderSizePixel = 0})

    local PageContainer = Create("Frame", {Parent = MainFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 201, 0, 65), Size = UDim2.new(1, -201, 1, -65), ClipsDescendants = true})

    local WinData = {ActiveTop = nil}

    function WinData:TopTab(Name)
        local Btn = Create("TextButton", {Parent = NavArea, BackgroundColor3 = Color3.fromRGB(30, 30, 35), BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 32), Font = Liquid.FontBold, Text = Name, TextColor3 = Liquid.Colors.TextDark, TextSize = 13, AutomaticSize = Enum.AutomaticSize.X})
        Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 4)}); Create("UIPadding", {Parent = Btn, PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16)})

        local SideContainer = Create("ScrollingFrame", {Parent = Sidebar, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false, ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0)})
        Create("UIListLayout", {Parent = SideContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}); Create("UIPadding", {Parent = SideContainer, PaddingTop = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15)})

        local function Activate()
            if WinData.ActiveTop then Tween(WinData.ActiveTop.Btn, {BackgroundTransparency = 1, TextColor3 = Liquid.Colors.TextDark}); WinData.ActiveTop.Container.Visible = false end
            WinData.ActiveTop = {Btn = Btn, Container = SideContainer}
            Tween(Btn, {BackgroundTransparency = 0, TextColor3 = Liquid.Colors.Text}); SideContainer.Visible = true
        end
        Btn.MouseButton1Click:Connect(Activate)
        if not WinData.ActiveTop then Activate() end

        local SideLib = {ActiveSide = nil}
        function SideLib:SideTab(Config)
            local SideBtn = Create("TextButton", {Parent = SideContainer, BackgroundColor3 = Color3.fromRGB(30, 30, 35), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 38), Text = "", AutoButtonColor = false}); Create("UICorner", {Parent = SideBtn, CornerRadius = UDim.new(0, 4)})
            local Icon = Create("ImageLabel", {Parent = SideBtn, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0.5, -9), Size = UDim2.new(0, 18, 0, 18), Image = Config.Icon or "", ImageColor3 = Liquid.Colors.TextDark})
            local Label = Create("TextLabel", {Parent = SideBtn, BackgroundTransparency = 1, Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -40, 1, 0), Font = Liquid.Font, Text = Config.Name, TextColor3 = Liquid.Colors.TextDark, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})

            local Page = Create("ScrollingFrame", {Parent = PageContainer, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = Liquid.Colors.Stroke, CanvasSize = UDim2.new(0,0,0,0), BorderSizePixel = 0}); Create("UIPadding", {Parent = Page, PaddingTop = UDim.new(0, 20), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20), PaddingBottom = UDim.new(0, 20)})
            local LeftCol = Create("Frame", {Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(0.485, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y})
            local RightCol = Create("Frame", {Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(0.485, 0, 0, 0), Position = UDim2.new(0.515, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y})
            local LList = Create("UIListLayout", {Parent = LeftCol, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 15)}); local RList = Create("UIListLayout", {Parent = RightCol, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 15)})
            local function UpdCanvas() Page.CanvasSize = UDim2.new(0,0,0, math.max(LList.AbsoluteContentSize.Y, RList.AbsoluteContentSize.Y) + 40) end; LList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdCanvas); RList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdCanvas)

            local function Open()
                if SideLib.ActiveSide then Tween(SideLib.ActiveSide.Btn, {BackgroundTransparency = 1}); Tween(SideLib.ActiveSide.Label, {TextColor3 = Liquid.Colors.TextDark}); Tween(SideLib.ActiveSide.Icon, {ImageColor3 = Liquid.Colors.TextDark}); SideLib.ActiveSide.Page.Visible = false end
                SideLib.ActiveSide = {Btn = SideBtn, Label = Label, Icon = Icon, Page = Page}
                Tween(SideBtn, {BackgroundTransparency = 0}); Tween(Label, {TextColor3 = Liquid.Colors.Text}); Tween(Icon, {ImageColor3 = Liquid.Colors.Text}); Page.Visible = true
            end
            SideBtn.MouseButton1Click:Connect(Open)
            if #SideContainer:GetChildren() == 2 then Open() end

            local SectionHandler = {}
            function SectionHandler:Section(SecConfig)
                local Col = (SecConfig.Side == "Right" and RightCol) or LeftCol
                local Groupbox = Create("Frame", {Parent = Col, BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y})
                local HeaderFrame = Create("Frame", {Parent = Groupbox, BackgroundColor3 = Liquid.Colors.Header, Size = UDim2.new(1, 0, 0, 40)}); Create("UICorner", {Parent = HeaderFrame, CornerRadius = UDim.new(0, 5)}); Create("Frame", {Parent = HeaderFrame, BackgroundColor3 = Liquid.Colors.Header, Position = UDim2.new(0,0,1,-5), Size = UDim2.new(1,0,0,5), BorderSizePixel=0})
                Create("TextLabel", {Parent = HeaderFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(1, -15, 1, 0), Font = Liquid.FontBold, Text = SecConfig.Name, TextColor3 = Liquid.Colors.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
                Create("Frame", {Parent = Groupbox, BackgroundColor3 = Liquid.Colors.Divider, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 40), Size = UDim2.new(1, 0, 0, 1), ZIndex = 2})
                local ContentFrame = Create("Frame", {Parent = Groupbox, BackgroundColor3 = Liquid.Colors.Content, Position = UDim2.new(0, 0, 0, 41), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y}); Create("UICorner", {Parent = ContentFrame, CornerRadius = UDim.new(0, 5)}); Create("Frame", {Parent = ContentFrame, BackgroundColor3 = Liquid.Colors.Content, Size = UDim2.new(1,0,0,5), BorderSizePixel=0})
                local ItemHolder = Create("UIListLayout", {Parent = ContentFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)}); Create("UIPadding", {Parent = ContentFrame, PaddingTop = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15)})

                local Elements = {}
                function Elements:Toggle(Cfg)
                    local Frame = Create("Frame", {Parent = ContentFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30)})
                    Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Size = UDim2.new(0.8, 0, 1, 0), Font = Liquid.Font, Text = Cfg.Name, TextColor3 = Liquid.Colors.TextDark, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})
                    local CheckBg = Create("TextButton", {Parent = Frame, BackgroundColor3 = Liquid.Colors.Element, Position = UDim2.new(1, -22, 0.5, -11), Size = UDim2.new(0, 22, 0, 22), Text = "", AutoButtonColor = false}); Create("UICorner", {Parent = CheckBg, CornerRadius = UDim.new(0, 4)})
                    local CheckIcon = Create("ImageLabel", {Parent = CheckBg, BackgroundTransparency = 1, Position = UDim2.new(0, 3, 0, 3), Size = UDim2.new(1, -6, 1, -6), Image = "rbxassetid://10709790644", ImageColor3 = Color3.new(0,0,0), ImageTransparency = 1})
                    local Toggled = Cfg.Default or false
                    local function Update() if Toggled then Tween(CheckBg, {BackgroundColor3 = Liquid.Colors.Accent}); Tween(CheckIcon, {ImageTransparency = 0}) else Tween(CheckBg, {BackgroundColor3 = Liquid.Colors.Element}); Tween(CheckIcon, {ImageTransparency = 1}) end; if Cfg.Callback then Cfg.Callback(Toggled) end end
                    CheckBg.MouseButton1Click:Connect(function() Toggled = not Toggled; Update() end); Update()
                end

                function Elements:Slider(Cfg)
                    local Frame = Create("Frame", {Parent = ContentFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 50)})
                    Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Font = Liquid.FontBold, Text = Cfg.Name, TextColor3 = Liquid.Colors.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})
                    local ValBox = Create("Frame", {Parent = Frame, BackgroundColor3 = Liquid.Colors.ValueBox, Position = UDim2.new(1, -40, 0, 0), Size = UDim2.new(0, 40, 0, 20)}); Create("UICorner", {Parent = ValBox, CornerRadius = UDim.new(0, 3)})
                    local ValLabel = Create("TextLabel", {Parent = ValBox, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Liquid.FontBold, Text = "0.00", TextColor3 = Liquid.Colors.TextDark, TextSize = 11})
                    local Rail = Create("Frame", {Parent = Frame, BackgroundColor3 = Liquid.Colors.Element, Position = UDim2.new(0, 0, 0, 35), Size = UDim2.new(1, 0, 0, 4)}); Create("UICorner", {Parent = Rail, CornerRadius = UDim.new(1, 0)})
                    local Fill = Create("Frame", {Parent = Rail, BackgroundColor3 = Liquid.Colors.TextDark, Size = UDim2.new(0, 0, 1, 0)}); Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})
                    local Trigger = Create("TextButton", {Parent = Frame, BackgroundTransparency = 1, Position = UDim2.new(0,0,0,25), Size = UDim2.new(1,0,0,25), Text = ""})
                    local Min, Max, Val = Cfg.Min or 0, Cfg.Max or 100, Cfg.Default or Min
                    local function Set(v) Val = math.clamp(v, Min, Max); local P = (Val - Min) / (Max - Min); Tween(Fill, {Size = UDim2.new(P, 0, 1, 0)}); ValLabel.Text = string.format("%."..(Cfg.Decimals or 0).."f", Val); if Cfg.Callback then Cfg.Callback(Val) end end
                    local Dragging = false
                    Trigger.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true; local x = math.clamp((i.Position.X - Rail.AbsolutePosition.X)/Rail.AbsoluteSize.X,0,1); Set(Min + (Max-Min)*x) end end)
                    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
                    UserInputService.InputChanged:Connect(function(i) if Dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local x = math.clamp((i.Position.X - Rail.AbsolutePosition.X)/Rail.AbsoluteSize.X,0,1); Set(Min + (Max-Min)*x) end end); Set(Val)
                end

                function Elements:Input(Cfg)
                    local Frame = Create("Frame", {Parent = ContentFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 55)})
                    Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Font = Liquid.FontBold, Text = Cfg.Name, TextColor3 = Liquid.Colors.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})
                    local InputContainer = Create("Frame", {Parent = Frame, BackgroundColor3 = Liquid.Colors.Main, Position = UDim2.new(0, 0, 0, 25), Size = UDim2.new(1, 0, 0, 30)}); Create("UICorner", {Parent = InputContainer, CornerRadius = UDim.new(0, 4)}); Create("UIStroke", {Parent = InputContainer, Color = Liquid.Colors.Stroke, Thickness = 1})
                    local Box = Create("TextBox", {Parent = InputContainer, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -20, 1, 0), Font = Liquid.Font, Text = "", PlaceholderText = Cfg.Placeholder or "Search...", TextColor3 = Liquid.Colors.Text, PlaceholderColor3 = Liquid.Colors.TextDark, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left})
                    Box:GetPropertyChangedSignal("Text"):Connect(function() if Cfg.Callback then Cfg.Callback(Box.Text) end end)
                end

                function Elements:List(Cfg)
                    local Frame = Create("Frame", {Parent = ContentFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, Cfg.Height or 150)})
                    local Scroll = Create("ScrollingFrame", {Parent = Frame, BackgroundColor3 = Liquid.Colors.Main, Size = UDim2.new(1, 0, 1, 0), ScrollBarThickness = 2, ScrollBarImageColor3 = Liquid.Colors.Stroke, CanvasSize = UDim2.new(0,0,0,0)}); Create("UICorner", {Parent = Scroll, CornerRadius = UDim.new(0, 4)}); Create("UIStroke", {Parent = Scroll, Color = Liquid.Colors.Stroke, Thickness = 1})
                    local ListLayout = Create("UIListLayout", {Parent = Scroll, SortOrder = Enum.SortOrder.LayoutOrder}); Create("UIPadding", {Parent = Scroll, PaddingLeft = UDim.new(0, 5)})
                    local Items = {}; local function Resize() Scroll.CanvasSize = UDim2.new(0,0,0, ListLayout.AbsoluteContentSize.Y) end; ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Resize)
                    for _, v in pairs(Cfg.Items) do
                        local Btn = Create("TextButton", {Parent = Scroll, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24), Font = Liquid.Font, Text = "  "..v, TextColor3 = Liquid.Colors.TextDark, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left})
                        Btn.MouseButton1Click:Connect(function() for _, b in pairs(Items) do b.Obj.TextColor3 = Liquid.Colors.TextDark end; Btn.TextColor3 = Liquid.Colors.Text; if Cfg.Callback then Cfg.Callback(v) end end)
                        table.insert(Items, {Obj = Btn, Val = v})
                    end
                    return {Filter = function(txt) for _, item in pairs(Items) do item.Obj.Visible = string.find(string.lower(item.Val), string.lower(txt)) ~= nil end; local Y = 0; for _, item in pairs(Items) do if item.Obj.Visible then Y = Y + 24 end end; Scroll.CanvasSize = UDim2.new(0,0,0, Y) end}
                end

                function Elements:Button(Cfg)
                    local Btn = Create("TextButton", {Parent = ContentFrame, BackgroundColor3 = Liquid.Colors.Element, Size = UDim2.new(1, 0, 0, 32), Font = Liquid.Font, Text = Cfg.Name, TextColor3 = Liquid.Colors.TextDark, TextSize = 12, AutoButtonColor = false}); Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 4)})
                    Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Liquid.Colors.Hover, TextColor3 = Liquid.Colors.Text}) end); Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = Liquid.Colors.Element, TextColor3 = Liquid.Colors.TextDark}) end)
                    Btn.MouseButton1Click:Connect(function() if Cfg.Callback then Cfg.Callback() end end)
                end
                return Elements
            end
            return SectionHandler
        end
        return SideLib
    end
    return WinData
end

return Library
