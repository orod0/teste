--[[
    KEYSER UI V6 - CORRECTED STRUCTURE
    Structure: Sidebar (Main) -> Topbar (Sub) -> Content
    Added: Keybind & Scale Config
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- [ THEME ] - COLORS ADJUSTED TO MATCH THE SECOND IMAGE
local Keyser = {
    Colors = {
        Main        = Color3.fromRGB(22, 24, 29),    -- Darkest blue-gray background
        Sidebar     = Color3.fromRGB(28, 30, 36),    -- Left panel, slightly lighter
        Header      = Color3.fromRGB(32, 35, 42),    -- Section title background
        Content     = Color3.fromRGB(32, 35, 42),    -- Section content background (same as header)
        Divider     = Color3.fromRGB(44, 47, 56),    -- Line under section title
        Element     = Color3.fromRGB(38, 41, 48),    -- Buttons, toggles, sliders
        Stroke      = Color3.fromRGB(44, 47, 56),    -- Borders
        Text        = Color3.fromRGB(225, 226, 228), -- Main text
        TextDark    = Color3.fromRGB(118, 121, 130), -- Dimmed text
        Accent      = Color3.fromRGB(57, 117, 199),   -- The blue for checked toggles
        Hover       = Color3.fromRGB(44, 47, 56),    -- Hover/selected color
        ValueBox    = Color3.fromRGB(22, 24, 29)     -- Slider value box background (same as Main)
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

-- [ LIBRARY LOGIC ]
local Library = {}

function Library:Window(Config)
    local WindowName = Config.Name or "Keyser"
    local WindowScale = Config.Scale or UDim2.new(0, 800, 0, 550)
    local ToggleKey = Config.Keybind or Enum.KeyCode.RightControl

    local Screen = Create("ScreenGui", {Name = "KeyserUI_V6", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true})
    
    local MainFrame = Create("Frame", {
        Name = "Main", Parent = Screen, BackgroundColor3 = Keyser.Colors.Main,
        Position = UDim2.new(0.5, -WindowScale.X.Offset/2, 0.5, -WindowScale.Y.Offset/2), 
        Size = WindowScale,
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 6)})
    Create("UIStroke", {Parent = MainFrame, Color = Keyser.Colors.Stroke, Thickness = 1})

    MakeDraggable(MainFrame, MainFrame)

    -- Toggle Visibility
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == ToggleKey then
            Screen.Enabled = not Screen.Enabled
        end
    end)

    -- [ LAYOUT STRUCTURE ]
    -- Header Area (Top)
    local Header = Create("Frame", {Parent = MainFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 65), ZIndex = 2})
    
    -- Sidebar Area (Left)
    local Sidebar = Create("Frame", {
        Parent = MainFrame, BackgroundColor3 = Keyser.Colors.Sidebar,
        Position = UDim2.new(0, 0, 0, 65), Size = UDim2.new(0, 200, 1, -65), BorderSizePixel = 0
    })
    
    -- Logo (Top Left)
    local LogoArea = Create("Frame", {Parent = Header, BackgroundTransparency = 1, Size = UDim2.new(0, 200, 1, 0)})
    Create("TextLabel", {
        Parent = LogoArea, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 14), Size = UDim2.new(1, 0, 0, 22),
        Font = Enum.Font.GothamBlack, Text = WindowName, TextColor3 = Color3.fromRGB(110, 110, 120), TextSize = 22
    })
    Create("TextLabel", {
        Parent = LogoArea, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(1, 0, 0, 14),
        Font = Keyser.Font, Text = "discord.gg/keyser", TextColor3 = Keyser.Colors.TextDark, TextSize = 11
    })

    -- Top Navigation Container (Top Right)
    local NavContainer = Create("Frame", {Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0, 200, 0, 0), Size = UDim2.new(1, -200, 1, 0)})
    
    -- Sidebar List Container
    local SideContainer = Create("ScrollingFrame", {
        Parent = Sidebar, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
        ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0)
    })
    Create("UIListLayout", {Parent = SideContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)})
    Create("UIPadding", {Parent = SideContainer, PaddingTop = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15)})

    -- Page Content Container (Center/Right)
    local PageContainer = Create("Frame", {
        Parent = MainFrame, BackgroundTransparency = 1,
        Position = UDim2.new(0, 201, 0, 65), Size = UDim2.new(1, -201, 1, -65),
        ClipsDescendants = true
    })

    -- Separator Lines
    Create("Frame", {Parent = MainFrame, BackgroundColor3 = Keyser.Colors.Stroke, Position = UDim2.new(0, 200, 0, 65), Size = UDim2.new(0, 1, 1, -65), BorderSizePixel = 0})

    local WinData = {ActiveSidebar = nil}

    -- [ 1. TAB (SIDEBAR BUTTON) ]
    function WinData:Tab(Config)
        -- Container para os botões do Topo associados a essa aba lateral
        local TopButtonsFrame = Create("Frame", {
            Parent = NavContainer, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false
        })
        local TopList = Create("UIListLayout", {
            Parent = TopButtonsFrame, FillDirection = Enum.FillDirection.Horizontal, 
            HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, 
            Padding = UDim.new(0, 20)
        })

        -- Botão da Sidebar
        local SideBtn = Create("TextButton", {
            Parent = SideContainer, BackgroundColor3 = Keyser.Colors.Hover, BackgroundTransparency = 1, -- CORRECTED: Using theme color
            Size = UDim2.new(1, 0, 0, 38), Text = "", AutoButtonColor = false
        })
        Create("UICorner", {Parent = SideBtn, CornerRadius = UDim.new(0, 4)})

        local Icon = Create("ImageLabel", {
            Parent = SideBtn, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0.5, -9), Size = UDim2.new(0, 18, 0, 18),
            Image = Config.Icon or "", ImageColor3 = Keyser.Colors.TextDark
        })
        local Label = Create("TextLabel", {
            Parent = SideBtn, BackgroundTransparency = 1, Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -40, 1, 0),
            Font = Keyser.Font, Text = Config.Name, TextColor3 = Keyser.Colors.TextDark, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
        })

        local TabObj = {
            TopTabs = {},
            ActiveTop = nil
        }

        -- Ativar aba da Sidebar
        local function ActivateSidebar()
            if WinData.ActiveSidebar == TabObj then return end
            
            -- Resetar anterior
            if WinData.ActiveSidebar then
                Tween(WinData.ActiveSidebar.Btn, {BackgroundTransparency = 1})
                Tween(WinData.ActiveSidebar.Label, {TextColor3 = Keyser.Colors.TextDark})
                Tween(WinData.ActiveSidebar.Icon, {ImageColor3 = Keyser.Colors.TextDark})
                WinData.ActiveSidebar.TopButtonsFrame.Visible = false
                -- Esconder página ativa da aba anterior
                if WinData.ActiveSidebar.ActiveTop then
                    WinData.ActiveSidebar.ActiveTop.Page.Visible = false
                end
            end

            -- Ativar nova
            WinData.ActiveSidebar = TabObj
            Tween(SideBtn, {BackgroundTransparency = 0})
            Tween(Label, {TextColor3 = Keyser.Colors.Text})
            Tween(Icon, {ImageColor3 = Keyser.Colors.Text})
            TopButtonsFrame.Visible = true
            
            -- Mostrar página ativa da nova aba ou a primeira
            if TabObj.ActiveTop then
                TabObj.ActiveTop.Activate()
            elseif #TabObj.TopTabs > 0 then
                TabObj.TopTabs[1].Activate()
            end
        end

        SideBtn.MouseButton1Click:Connect(ActivateSidebar)
        TabObj.Btn = SideBtn
        TabObj.Label = Label
        TabObj.Icon = Icon
        TabObj.TopButtonsFrame = TopButtonsFrame

        -- [ 2. PAGE (TOPBAR BUTTON) ]
        function TabObj:Page(Name)
            local TopBtn = Create("TextButton", {
                Parent = TopButtonsFrame, BackgroundColor3 = Keyser.Colors.Hover, BackgroundTransparency = 1, -- CORRECTED: Using theme color
                Size = UDim2.new(0, 0, 0, 32), Font = Keyser.FontBold, Text = Name,
                TextColor3 = Keyser.Colors.TextDark, TextSize = 13, AutomaticSize = Enum.AutomaticSize.X
            })
            Create("UICorner", {Parent = TopBtn, CornerRadius = UDim.new(0, 4)})
            Create("UIPadding", {Parent = TopBtn, PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16)})

            -- Página de Conteúdo
            local PageScroll = Create("ScrollingFrame", {
                Parent = PageContainer, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
                Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = Keyser.Colors.Stroke,
                CanvasSize = UDim2.new(0,0,0,0), BorderSizePixel = 0
            })
            Create("UIPadding", {Parent = PageScroll, PaddingTop = UDim.new(0, 20), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20), PaddingBottom = UDim.new(0, 20)})

            local LeftCol = Create("Frame", {Parent = PageScroll, BackgroundTransparency = 1, Size = UDim2.new(0.485, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y})
            local RightCol = Create("Frame", {Parent = PageScroll, BackgroundTransparency = 1, Size = UDim2.new(0.485, 0, 0, 0), Position = UDim2.new(0.515, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y})
            local LList = Create("UIListLayout", {Parent = LeftCol, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 15)})
            local RList = Create("UIListLayout", {Parent = RightCol, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 15)})

            -- Auto Resize
            local function UpdCanvas() PageScroll.CanvasSize = UDim2.new(0,0,0, math.max(LList.AbsoluteContentSize.Y, RList.AbsoluteContentSize.Y) + 40) end
            LList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdCanvas)
            RList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdCanvas)

            local PageObj = {}

            function PageObj.Activate()
                if TabObj.ActiveTop then
                    Tween(TabObj.ActiveTop.Btn, {BackgroundTransparency = 1, TextColor3 = Keyser.Colors.TextDark})
                    TabObj.ActiveTop.Page.Visible = false
                end
                TabObj.ActiveTop = PageObj
                Tween(TopBtn, {BackgroundTransparency = 0, TextColor3 = Keyser.Colors.Text})
                PageScroll.Visible = true
            end

            TopBtn.MouseButton1Click:Connect(PageObj.Activate)
            PageObj.Btn = TopBtn
            PageObj.Page = PageScroll

            table.insert(TabObj.TopTabs, PageObj)

            -- [ 3. SECTION (GROUPBOX) ]
            local SectionLib = {}
            function SectionLib:Section(SecConfig)
                local Col = (SecConfig.Side == "Right" and RightCol) or LeftCol
                
                local Groupbox = Create("Frame", {
                    Parent = Col, BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y
                })

                local HeaderFrame = Create("Frame", {
                    Parent = Groupbox, BackgroundColor3 = Keyser.Colors.Header,
                    Size = UDim2.new(1, 0, 0, 40)
                })
                Create("UICorner", {Parent = HeaderFrame, CornerRadius = UDim.new(0, 5)})
                Create("Frame", {Parent = HeaderFrame, BackgroundColor3 = Keyser.Colors.Header, Position = UDim2.new(0,0,1,-5), Size = UDim2.new(1,0,0,5), BorderSizePixel=0})

                Create("TextLabel", {
                    Parent = HeaderFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(1, -15, 1, 0),
                    Font = Keyser.FontBold, Text = SecConfig.Name, TextColor3 = Keyser.Colors.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
                })

                Create("Frame", {
                    Parent = Groupbox, BackgroundColor3 = Keyser.Colors.Divider, BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 40), Size = UDim2.new(1, 0, 0, 1), ZIndex = 2
                })

                local ContentFrame = Create("Frame", {
                    Parent = Groupbox, BackgroundColor3 = Keyser.Colors.Content,
                    Position = UDim2.new(0, 0, 0, 41), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y
                })
                Create("UICorner", {Parent = ContentFrame, CornerRadius = UDim.new(0, 5)})
                Create("Frame", {Parent = ContentFrame, BackgroundColor3 = Keyser.Colors.Content, Size = UDim2.new(1,0,0,5), BorderSizePixel=0})

                local ItemHolder = Create("UIListLayout", {Parent = ContentFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
                Create("UIPadding", {Parent = ContentFrame, PaddingTop = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15)})

                local Elements = {}

                function Elements:Toggle(Cfg)
                    local Frame = Create("Frame", {Parent = ContentFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30)})
                    Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Size = UDim2.new(0.8, 0, 1, 0), Font = Keyser.Font, Text = Cfg.Name, TextColor3 = Keyser.Colors.TextDark, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})
                    local CheckBg = Create("TextButton", {Parent = Frame, BackgroundColor3 = Keyser.Colors.Element, Position = UDim2.new(1, -22, 0.5, -11), Size = UDim2.new(0, 22, 0, 22), Text = "", AutoButtonColor = false}); Create("UICorner", {Parent = CheckBg, CornerRadius = UDim.new(0, 4)})
                    local CheckIcon = Create("ImageLabel", {Parent = CheckBg, BackgroundTransparency = 1, Position = UDim2.new(0, 3, 0, 3), Size = UDim2.new(1, -6, 1, -6), Image = "rbxassetid://10709790644", ImageColor3 = Color3.new(1,1,1), ImageTransparency = 1}) -- CORRECTED: Checkmark is now white
                    local Toggled = Cfg.Default or false
                    local function Update() if Toggled then Tween(CheckBg, {BackgroundColor3 = Keyser.Colors.Accent}); Tween(CheckIcon, {ImageTransparency = 0}) else Tween(CheckBg, {BackgroundColor3 = Keyser.Colors.Element}); Tween(CheckIcon, {ImageTransparency = 1}) end; if Cfg.Callback then Cfg.Callback(Toggled) end end
                    CheckBg.MouseButton1Click:Connect(function() Toggled = not Toggled; Update() end); Update()
                end

                function Elements:Slider(Cfg)
                    local Frame = Create("Frame", {Parent = ContentFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 50)})
                    Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Font = Keyser.FontBold, Text = Cfg.Name, TextColor3 = Keyser.Colors.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})
                    local ValBox = Create("Frame", {Parent = Frame, BackgroundColor3 = Keyser.Colors.ValueBox, Position = UDim2.new(1, -40, 0, 0), Size = UDim2.new(0, 40, 0, 20)}); Create("UICorner", {Parent = ValBox, CornerRadius = UDim.new(0, 3)})
                    local ValLabel = Create("TextLabel", {Parent = ValBox, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Keyser.FontBold, Text = "0.00", TextColor3 = Keyser.Colors.TextDark, TextSize = 11})
                    local Rail = Create("Frame", {Parent = Frame, BackgroundColor3 = Keyser.Colors.Element, Position = UDim2.new(0, 0, 0, 35), Size = UDim2.new(1, 0, 0, 4)}); Create("UICorner", {Parent = Rail, CornerRadius = UDim.new(1, 0)})
                    local Fill = Create("Frame", {Parent = Rail, BackgroundColor3 = Keyser.Colors.TextDark, Size = UDim2.new(0, 0, 1, 0)}); Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})
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
                    Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Font = Keyser.FontBold, Text = Cfg.Name, TextColor3 = Keyser.Colors.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})
                    local InputContainer = Create("Frame", {Parent = Frame, BackgroundColor3 = Keyser.Colors.Main, Position = UDim2.new(0, 0, 0, 25), Size = UDim2.new(1, 0, 0, 30)}); Create("UICorner", {Parent = InputContainer, CornerRadius = UDim.new(0, 4)}); Create("UIStroke", {Parent = InputContainer, Color = Keyser.Colors.Stroke, Thickness = 1})
                    local Box = Create("TextBox", {Parent = InputContainer, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -20, 1, 0), Font = Keyser.Font, Text = "", PlaceholderText = Cfg.Placeholder or "Search...", TextColor3 = Keyser.Colors.Text, PlaceholderColor3 = Keyser.Colors.TextDark, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left})
                    Box:GetPropertyChangedSignal("Text"):Connect(function() if Cfg.Callback then Cfg.Callback(Box.Text) end end)
                end

                function Elements:List(Cfg)
                    local Frame = Create("Frame", {Parent = ContentFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, Cfg.Height or 150)})
                    local Scroll = Create("ScrollingFrame", {Parent = Frame, BackgroundColor3 = Keyser.Colors.Main, Size = UDim2.new(1, 0, 1, 0), ScrollBarThickness = 2, ScrollBarImageColor3 = Keyser.Colors.Stroke, CanvasSize = UDim2.new(0,0,0,0)}); Create("UICorner", {Parent = Scroll, CornerRadius = UDim.new(0, 4)}); Create("UIStroke", {Parent = Scroll, Color = Keyser.Colors.Stroke, Thickness = 1})
                    local ListLayout = Create("UIListLayout", {Parent = Scroll, SortOrder = Enum.SortOrder.LayoutOrder}); Create("UIPadding", {Parent = Scroll, PaddingLeft = UDim.new(0, 5)})
                    local Items = {}; local function Resize() Scroll.CanvasSize = UDim2.new(0,0,0, ListLayout.AbsoluteContentSize.Y) end; ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Resize)
                    for _, v in pairs(Cfg.Items) do
                        local Btn = Create("TextButton", {Parent = Scroll, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24), Font = Keyser.Font, Text = "  "..v, TextColor3 = Keyser.Colors.TextDark, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left})
                        Btn.MouseButton1Click:Connect(function() for _, b in pairs(Items) do b.Obj.TextColor3 = Keyser.Colors.TextDark end; Btn.TextColor3 = Keyser.Colors.Text; if Cfg.Callback then Cfg.Callback(v) end end)
                        table.insert(Items, {Obj = Btn, Val = v})
                    end
                    return {Filter = function(txt) for _, item in pairs(Items) do item.Obj.Visible = string.find(string.lower(item.Val), string.lower(txt)) ~= nil end; local Y = 0; for _, item in pairs(Items) do if item.Obj.Visible then Y = Y + 24 end end; Scroll.CanvasSize = UDim2.new(0,0,0, Y) end}
                end

                function Elements:Button(Cfg)
                    local Btn = Create("TextButton", {Parent = ContentFrame, BackgroundColor3 = Keyser.Colors.Element, Size = UDim2.new(1, 0, 0, 32), Font = Keyser.Font, Text = Cfg.Name, TextColor3 = Keyser.Colors.TextDark, TextSize = 12, AutoButtonColor = false}); Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 4)})
                    Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Keyser.Colors.Hover, TextColor3 = Keyser.Colors.Text}) end); Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = Keyser.Colors.Element, TextColor3 = Keyser.Colors.TextDark}) end)
                    Btn.MouseButton1Click:Connect(function() if Cfg.Callback then Cfg.Callback() end end)
                end
                return Elements
            end
            return SectionLib
        end
        
        if not WinData.ActiveSidebar then 
            -- Ativar primeira sidebar automaticamente
            task.delay(0.05, function() 
                if #SideContainer:GetChildren() > 1 then 
                    -- Simular clique no primeiro botão (index 2 por causa do layout/padding)
                    -- Método direto: chamar a função interna ActivateSidebar se for o primeiro
                end
            end)
        end
        
        return TabObj
    end
    
    return WinData
end

return Library
