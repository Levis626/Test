local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local Workspace = workspace

local LocalPlayer = Players.LocalPlayer

local Config = {
	Version = "1.0.1",
	WindowSize = UDim2.new(0, 540, 0, 340),
	BgColor = Color3.fromRGB(14, 15, 18),
	SidebarColor = Color3.fromRGB(20, 22, 26),
	ContainerColor = Color3.fromRGB(28, 30, 36),
	ContainerActive = Color3.fromRGB(44, 48, 58),
	Accent = Color3.fromRGB(255, 255, 255),
	BlueGlow = Color3.fromRGB(85, 165, 255),
	TextPrimary = Color3.fromRGB(242, 246, 255),
	TextSecondary = Color3.fromRGB(145, 152, 165),
	CloseRed = Color3.fromRGB(255, 75, 75),
	DeveloperUserId = 11298109458,
	DeveloperProfileUrl = "https://www.roblox.com/users/11298109458/profile",
	DiscordInviteUrl = "https://discord.gg/R5awAM2YFb"
}
local function DetectExecutor()
	local name, ver = "Unknown Executor", ""
	if type(identifyexecutor) == "function" then
		local ok, n, v = pcall(identifyexecutor)
		if ok and n and tostring(n) ~= "" then
			name = tostring(n)
			if v and tostring(v) ~= "" then ver = tostring(v) end
		end
	elseif type(getexecutorname) == "function" then
		local ok, n, v = pcall(getexecutorname)
		if ok and n and tostring(n) ~= "" then
			name = tostring(n)
			if v and tostring(v) ~= "" then ver = tostring(v) end
		end
	end
	if ver ~= "" then
		return name .. " (" .. ver .. ")"
	end
	return name
end

local function FetchGameInfo()
	local info = {
		Name = "Roblox Experience",
		Thumbnail = "rbxthumb://type=GameIcon&id=" .. tostring(game.GameId) .. "&w=256&h=256"
	}
	pcall(function()
		local productInfo = MarketplaceService:GetProductInfoAsync(game.PlaceId, Enum.InfoType.Asset)
		if productInfo and productInfo.Name and tostring(productInfo.Name) ~= "" then
			info.Name = tostring(productInfo.Name)
		end
	end)
	if info.Name == "Roblox Experience" then
		pcall(function()
			local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
			if productInfo and productInfo.Name and tostring(productInfo.Name) ~= "" then
				info.Name = tostring(productInfo.Name)
			end
		end)
	end
	return info
end

local function MakeDraggable(obj)
	local dragging, dragStart, startPos
	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = obj.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	obj.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

local function ApplyBlueWhiteGradient(guiObject, speed)
	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 155, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 190, 255))
	})
	grad.Parent = guiObject

	local angle = 0
	RunService.RenderStepped:Connect(function(dt)
		if not grad.Parent then return end
		angle = (angle + dt * (speed or 45)) % 360
		grad.Rotation = angle
	end)
	return grad
end
local function CreateDrawnMegaphoneIcon(parent, pos, zIndex)
	local icon = Instance.new("Frame", parent)
	icon.Name = "DrawnMegaphone"
	icon.Size = UDim2.fromOffset(18, 14)
	icon.Position = pos
	icon.BackgroundTransparency = 1
	icon.ZIndex = zIndex or 6

	local handle = Instance.new("Frame", icon)
	handle.Size = UDim2.fromOffset(3, 6)
	handle.Position = UDim2.fromOffset(4, 7)
	handle.Rotation = -18
	handle.BackgroundColor3 = Config.TextPrimary
	handle.BorderSizePixel = 0
	handle.ZIndex = zIndex or 6
	Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)

	local body = Instance.new("Frame", icon)
	body.Size = UDim2.fromOffset(6, 6)
	body.Position = UDim2.fromOffset(2, 4)
	body.BackgroundColor3 = Config.TextPrimary
	body.BorderSizePixel = 0
	body.ZIndex = zIndex or 6
	Instance.new("UICorner", body).CornerRadius = UDim.new(0, 2)

	local horn = Instance.new("Frame", icon)
	horn.Size = UDim2.fromOffset(5, 10)
	horn.Position = UDim2.fromOffset(7, 2)
	horn.BackgroundColor3 = Config.BlueGlow
	horn.BorderSizePixel = 0
	horn.ZIndex = zIndex or 6
	Instance.new("UICorner", horn).CornerRadius = UDim.new(0, 2)

	local wave1 = Instance.new("Frame", icon)
	wave1.Size = UDim2.fromOffset(2, 6)
	wave1.Position = UDim2.fromOffset(14, 4)
	wave1.BackgroundColor3 = Config.TextPrimary
	wave1.BorderSizePixel = 0
	wave1.ZIndex = zIndex or 6
	Instance.new("UICorner", wave1).CornerRadius = UDim.new(1, 0)

	local wave2 = Instance.new("Frame", icon)
	wave2.Size = UDim2.fromOffset(2, 10)
	wave2.Position = UDim2.fromOffset(17, 2)
	wave2.BackgroundColor3 = Config.BlueGlow
	wave2.BorderSizePixel = 0
	wave2.ZIndex = zIndex or 6
	Instance.new("UICorner", wave2).CornerRadius = UDim.new(1, 0)

	return icon
end

local function CreateDrawnDiscordIcon(parent, pos, zIndex)
	local icon = Instance.new("Frame", parent)
	icon.Name = "DrawnDiscordIcon"
	icon.Size = UDim2.fromOffset(20, 16)
	icon.Position = pos
	icon.BackgroundColor3 = Config.BlueGlow
	icon.BorderSizePixel = 0
	icon.ZIndex = zIndex or 6
	Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 6)

	local innerShell = Instance.new("Frame", icon)
	innerShell.Size = UDim2.new(1, -2, 1, -2)
	innerShell.Position = UDim2.fromOffset(1, 1)
	innerShell.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
	innerShell.BorderSizePixel = 0
	innerShell.ZIndex = (zIndex or 6) + 1
	Instance.new("UICorner", innerShell).CornerRadius = UDim.new(0, 5)

	local leftEye = Instance.new("Frame", innerShell)
	leftEye.Size = UDim2.fromOffset(4, 4)
	leftEye.Position = UDim2.fromOffset(4, 5)
	leftEye.BackgroundColor3 = Config.TextPrimary
	leftEye.BorderSizePixel = 0
	leftEye.ZIndex = (zIndex or 6) + 2
	Instance.new("UICorner", leftEye).CornerRadius = UDim.new(1, 0)

	local rightEye = Instance.new("Frame", innerShell)
	rightEye.Size = UDim2.fromOffset(4, 4)
	rightEye.Position = UDim2.fromOffset(10, 5)
	rightEye.BackgroundColor3 = Config.TextPrimary
	rightEye.BorderSizePixel = 0
	rightEye.ZIndex = (zIndex or 6) + 2
	Instance.new("UICorner", rightEye).CornerRadius = UDim.new(1, 0)

	local footLeft = Instance.new("Frame", icon)
	footLeft.Size = UDim2.fromOffset(4, 2)
	footLeft.Position = UDim2.fromOffset(3, 15)
	footLeft.Rotation = -12
	footLeft.BackgroundColor3 = Config.BlueGlow
	footLeft.BorderSizePixel = 0
	footLeft.ZIndex = (zIndex or 6) + 1
	Instance.new("UICorner", footLeft).CornerRadius = UDim.new(1, 0)

	local footRight = Instance.new("Frame", icon)
	footRight.Size = UDim2.fromOffset(4, 2)
	footRight.Position = UDim2.fromOffset(13, 15)
	footRight.Rotation = 12
	footRight.BackgroundColor3 = Config.BlueGlow
	footRight.BorderSizePixel = 0
	footRight.ZIndex = (zIndex or 6) + 1
	Instance.new("UICorner", footRight).CornerRadius = UDim.new(1, 0)

	return icon
end
local function CreateDrawnTikTokIcon(parent, pos, zIndex)
	local z = zIndex or 6
	local icon = Instance.new("Frame", parent)
	icon.Name = "DrawnTikTokIcon"
	icon.Size = UDim2.fromOffset(18, 18)
	icon.Position = pos
	icon.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
	icon.BorderSizePixel = 0
	icon.ZIndex = z
	Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 5)

	local stroke = Instance.new("UIStroke", icon)
	stroke.Thickness = 1
	stroke.Transparency = 0.45
	ApplyBlueWhiteGradient(stroke, 70)

	local stem = Instance.new("Frame", icon)
	stem.Size = UDim2.fromOffset(2.5, 9)
	stem.Position = UDim2.fromOffset(9, 4)
	stem.BackgroundColor3 = Config.TextPrimary
	stem.BorderSizePixel = 0
	stem.ZIndex = z + 2
	Instance.new("UICorner", stem).CornerRadius = UDim.new(1, 0)

	local topCurve = Instance.new("Frame", icon)
	topCurve.Size = UDim2.fromOffset(5, 2.5)
	topCurve.Position = UDim2.fromOffset(10, 4)
	topCurve.Rotation = 18
	topCurve.BackgroundColor3 = Config.BlueGlow
	topCurve.BorderSizePixel = 0
	topCurve.ZIndex = z + 2
	Instance.new("UICorner", topCurve).CornerRadius = UDim.new(1, 0)

	local noteHead = Instance.new("Frame", icon)
	noteHead.Size = UDim2.fromOffset(6, 6)
	noteHead.Position = UDim2.fromOffset(5, 10)
	noteHead.BackgroundColor3 = Config.TextPrimary
	noteHead.BorderSizePixel = 0
	noteHead.ZIndex = z + 2
	Instance.new("UICorner", noteHead).CornerRadius = UDim.new(1, 0)

	return icon
end

local function CreateDrawnYouTubeIcon(parent, pos, zIndex)
	local z = zIndex or 6
	local icon = Instance.new("Frame", parent)
	icon.Name = "DrawnYouTubeIcon"
	icon.Size = UDim2.fromOffset(20, 15)
	icon.Position = pos
	icon.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
	icon.BorderSizePixel = 0
	icon.ZIndex = z
	Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 4)

	local stroke = Instance.new("UIStroke", icon)
	stroke.Thickness = 1
	stroke.Transparency = 0.4
	ApplyBlueWhiteGradient(stroke, 70)

	local playBase = Instance.new("Frame", icon)
	playBase.Size = UDim2.fromOffset(3, 7)
	playBase.Position = UDim2.fromOffset(8, 4)
	playBase.BackgroundColor3 = Config.BlueGlow
	playBase.BorderSizePixel = 0
	playBase.ZIndex = z + 2
	Instance.new("UICorner", playBase).CornerRadius = UDim.new(1, 0)

	local playTip = Instance.new("Frame", icon)
	playTip.Size = UDim2.fromOffset(5, 4)
	playTip.Position = UDim2.fromOffset(9.5, 5.5)
	playTip.BackgroundColor3 = Config.TextPrimary
	playTip.BorderSizePixel = 0
	playTip.ZIndex = z + 2
	Instance.new("UICorner", playTip).CornerRadius = UDim.new(0, 2)

	return icon
end

local function BuildRivalsHub()
	if CoreGui:FindFirstChild("RivalsHubUI") then
		CoreGui:FindFirstChild("RivalsHubUI"):Destroy()
	end
	if CoreGui:FindFirstChild("InfStaminaUI") then
		CoreGui:FindFirstChild("InfStaminaUI"):Destroy()
	end
	if CoreGui:FindFirstChild("BLR_BallHitbox") then
		CoreGui:FindFirstChild("BLR_BallHitbox"):Destroy()
	end

	local MainGui = Instance.new("ScreenGui")
	MainGui.Name = "RivalsHubUI"
	MainGui.ResetOnSpawn = false
	MainGui.IgnoreGuiInset = true
	MainGui.DisplayOrder = 999999
	MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	MainGui.Parent = CoreGui

	local TopPill = Instance.new("TextButton", MainGui)
	TopPill.Name = "TopPill"
	TopPill.Size = UDim2.new(0, 156, 0, 32)
	TopPill.Position = UDim2.new(0.5, 0, 0, 10)
	TopPill.AnchorPoint = Vector2.new(0.5, 0)
	TopPill.BackgroundColor3 = Config.SidebarColor
	TopPill.BackgroundTransparency = 0.08
	TopPill.Text = "Rivals Hub"
	TopPill.TextColor3 = Config.TextPrimary
	TopPill.Font = Enum.Font.GothamBold
	TopPill.TextSize = 13
	TopPill.Visible = false
	Instance.new("UICorner", TopPill).CornerRadius = UDim.new(0, 8)
	ApplyBlueWhiteGradient(TopPill, 55)

	local PillStroke = Instance.new("UIStroke", TopPill)
	PillStroke.Thickness = 1.4
	PillStroke.Transparency = 0.25
	ApplyBlueWhiteGradient(PillStroke, 70)
	local MainFrame = Instance.new("Frame", MainGui)
	MainFrame.Name = "MainFrame"
	MainFrame.Size = Config.WindowSize
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Config.BgColor
	MainFrame.BackgroundTransparency = 0.06
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Visible = false
	Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

	local MainScale = Instance.new("UIScale", MainFrame)
	MainScale.Scale = 1.0

	local MainStroke = Instance.new("UIStroke", MainFrame)
	MainStroke.Thickness = 1.6
	MainStroke.Transparency = 0.2
	ApplyBlueWhiteGradient(MainStroke, 40)

	local SparkleHolder = Instance.new("Frame", MainFrame)
	SparkleHolder.Name = "FallingDots"
	SparkleHolder.Size = UDim2.new(1, 0, 1, 0)
	SparkleHolder.BackgroundTransparency = 1
	SparkleHolder.BorderSizePixel = 0
	SparkleHolder.ZIndex = 1
	SparkleHolder.ClipsDescendants = true

	local rng = Random.new()
	for i = 1, 24 do
		local dot = Instance.new("Frame", SparkleHolder)
		local size = rng:NextInteger(2, 4)
		dot.Size = UDim2.fromOffset(size, size)
		dot.Position = UDim2.new(rng:NextNumber(0.03, 0.97), 0, rng:NextNumber(0, 1), 0)
		dot.BackgroundColor3 = (i % 2 == 0) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(115, 185, 255)
		dot.BackgroundTransparency = rng:NextNumber(0.55, 0.82)
		dot.BorderSizePixel = 0
		dot.ZIndex = 1
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

		local speed = rng:NextNumber(14, 28)
		local driftX = rng:NextNumber(-8, 8)
		task.spawn(function()
			while dot.Parent and MainGui.Parent do
				local startX = dot.Position.X.Scale
				local startY = dot.Position.Y.Scale
				if startY >= 1.03 then
					startX = rng:NextNumber(0.03, 0.97)
					startY = -0.03
					dot.Position = UDim2.new(startX, 0, startY, 0)
					dot.BackgroundTransparency = rng:NextNumber(0.55, 0.82)
				end
				local dt = RunService.RenderStepped:Wait()
				if dot.Parent then
					local nextY = startY + (speed * 0.015) * dt
					local nextXOffset = math.sin(os.clock() * 1.5 + i) * (driftX * 0.15)
					dot.Position = UDim2.new(startX, nextXOffset, nextY, 0)
				end
			end
		end)
	end

	local TopBar = Instance.new("Frame", MainFrame)
	TopBar.Size = UDim2.new(1, 0, 0, 36)
	TopBar.BackgroundTransparency = 1
	TopBar.ZIndex = 3

	local Title = Instance.new("TextLabel", TopBar)
	Title.Text = "Rivals Hub"
	Title.Size = UDim2.new(0, 220, 1, 0)
	Title.Position = UDim2.new(0, 14, 0, 0)
	Title.BackgroundTransparency = 1
	Title.TextColor3 = Config.TextPrimary
	Title.Font = Enum.Font.GothamBlack
	Title.TextSize = 15
	Title.TextXAlignment = Enum.TextXAlignment.Left
	ApplyBlueWhiteGradient(Title, 50)

	local CloseBtn = Instance.new("TextButton", TopBar)
	CloseBtn.Size = UDim2.new(0, 28, 0, 28)
	CloseBtn.Position = UDim2.new(1, -34, 0, 4)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Text = "×"
	CloseBtn.TextColor3 = Config.CloseRed
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 21

	local MinimizeBtn = Instance.new("TextButton", TopBar)
	MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
	MinimizeBtn.Position = UDim2.new(1, -62, 0, 4)
	MinimizeBtn.BackgroundTransparency = 1
	MinimizeBtn.Text = "-"
	MinimizeBtn.TextColor3 = Config.TextSecondary
	MinimizeBtn.Font = Enum.Font.GothamBold
	MinimizeBtn.TextSize = 20

	local Sidebar = Instance.new("Frame", MainFrame)
	Sidebar.Size = UDim2.new(0, 138, 0, 212)
	Sidebar.Position = UDim2.new(0, 10, 0, 38)
	Sidebar.BackgroundColor3 = Config.SidebarColor
	Sidebar.BackgroundTransparency = 0.15
	Sidebar.ZIndex = 2
	Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

	local SidebarStroke = Instance.new("UIStroke", Sidebar)
	SidebarStroke.Thickness = 1
	SidebarStroke.Transparency = 0.65
	ApplyBlueWhiteGradient(SidebarStroke, 60)

	local TabContainer = Instance.new("Frame", Sidebar)
	TabContainer.Size = UDim2.new(1, -12, 1, -12)
	TabContainer.Position = UDim2.new(0, 6, 0, 6)
	TabContainer.BackgroundTransparency = 1
	TabContainer.ZIndex = 3

	local TabList = Instance.new("UIListLayout", TabContainer)
	TabList.SortOrder = Enum.SortOrder.LayoutOrder
	TabList.Padding = UDim.new(0, 3)

	local PagesContainer = Instance.new("Frame", MainFrame)
	PagesContainer.Size = UDim2.new(1, -166, 1, -48)
	PagesContainer.Position = UDim2.new(0, 156, 0, 38)
	PagesContainer.BackgroundTransparency = 1
	PagesContainer.ZIndex = 2
	local Tabs, Pages = {}, {}

	local function CreateTab(name, layoutOrder)
		local TabBtn = Instance.new("TextButton", TabContainer)
		TabBtn.Size = UDim2.new(1, 0, 0, 26)
		TabBtn.BackgroundColor3 = (layoutOrder == 1) and Config.ContainerActive or Config.ContainerColor
		TabBtn.BackgroundTransparency = 0.15
		TabBtn.Text = "  " .. name
		TabBtn.TextColor3 = Config.TextPrimary
		TabBtn.Font = Enum.Font.GothamBold
		TabBtn.TextSize = 11
		TabBtn.TextXAlignment = Enum.TextXAlignment.Left
		TabBtn.LayoutOrder = layoutOrder
		TabBtn.AutoButtonColor = false
		TabBtn.ZIndex = 4
		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

		local tabScale = Instance.new("UIScale", TabBtn)
		tabScale.Scale = 1
		ApplyBlueWhiteGradient(TabBtn, 50)

		local tabStroke = Instance.new("UIStroke", TabBtn)
		tabStroke.Thickness = 1
		tabStroke.Transparency = (layoutOrder == 1) and 0.35 or 0.85
		ApplyBlueWhiteGradient(tabStroke, 65)

		local Page = Instance.new("ScrollingFrame", PagesContainer)
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.ScrollBarThickness = 2
		Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		Page.Visible = (layoutOrder == 1)
		Page.ZIndex = 3

		local PageLayout = Instance.new("UIListLayout", Page)
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Padding = UDim.new(0, 6)

		Tabs[name] = {Button = TabBtn, Stroke = tabStroke, Scale = tabScale}
		Pages[name] = Page

		TabBtn.MouseEnter:Connect(function()
			TweenService:Create(tabScale, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1.03}):Play()
		end)
		TabBtn.MouseLeave:Connect(function()
			TweenService:Create(tabScale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
		end)
		TabBtn.MouseButton1Click:Connect(function()
			TweenService:Create(tabScale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.96}):Play()
			task.delay(0.08, function()
				if tabScale and tabScale.Parent then
					TweenService:Create(tabScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
				end
			end)
			for _, item in pairs(Tabs) do
				TweenService:Create(item.Button, TweenInfo.new(0.22), {BackgroundColor3 = Config.ContainerColor}):Play()
				TweenService:Create(item.Stroke, TweenInfo.new(0.22), {Transparency = 0.85}):Play()
			end
			for _, p in pairs(Pages) do
				p.Visible = false
			end
			TweenService:Create(TabBtn, TweenInfo.new(0.22), {BackgroundColor3 = Config.ContainerActive}):Play()
			TweenService:Create(tabStroke, TweenInfo.new(0.22), {Transparency = 0.35}):Play()
			Page.Visible = true
			Page.CanvasPosition = Vector2.zero
		end)

		return Page
	end

	local function CreateSectionHeader(parent, text)
		local Header = Instance.new("TextLabel", parent)
		Header.Size = UDim2.new(1, -6, 0, 18)
		Header.BackgroundTransparency = 1
		Header.Text = string.upper(text)
		Header.TextColor3 = Config.TextPrimary
		Header.Font = Enum.Font.GothamBold
		Header.TextSize = 9.5
		Header.TextXAlignment = Enum.TextXAlignment.Left
		Header.ZIndex = 4
		ApplyBlueWhiteGradient(Header, 55)
		return Header
	end

	local function CreateStatBox(parent, titleText, valueText)
		local Box = Instance.new("Frame", parent)
		Box.BackgroundColor3 = Config.ContainerColor
		Box.BackgroundTransparency = 0.14
		Box.BorderSizePixel = 0
		Box.ZIndex = 4
		Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 7)

		local stroke = Instance.new("UIStroke", Box)
		stroke.Thickness = 1
		stroke.Transparency = 0.76
		ApplyBlueWhiteGradient(stroke, 75)

		local Tbl = Instance.new("TextLabel", Box)
		Tbl.Size = UDim2.new(1, -14, 0, 13)
		Tbl.Position = UDim2.fromOffset(8, 5)
		Tbl.BackgroundTransparency = 1
		Tbl.Text = string.upper(titleText)
		Tbl.TextColor3 = Config.TextSecondary
		Tbl.Font = Enum.Font.GothamBold
		Tbl.TextSize = 8
		Tbl.TextXAlignment = Enum.TextXAlignment.Left
		Tbl.ZIndex = 5

		local Vbl = Instance.new("TextLabel", Box)
		Vbl.Size = UDim2.new(1, -14, 0, 18)
		Vbl.Position = UDim2.fromOffset(8, 20)
		Vbl.BackgroundTransparency = 1
		Vbl.Text = valueText
		Vbl.TextColor3 = Config.TextPrimary
		Vbl.Font = Enum.Font.GothamBold
		Vbl.TextSize = 11
		Vbl.TextXAlignment = Enum.TextXAlignment.Left
		Vbl.TextTruncate = Enum.TextTruncate.AtEnd
		Vbl.ZIndex = 5

		return Box, Vbl
	end
	local function CreateButton(parent, text, callback)
		local Btn = Instance.new("TextButton", parent)
		Btn.Size = UDim2.new(1, -6, 0, 30)
		Btn.BackgroundColor3 = Config.ContainerColor
		Btn.BackgroundTransparency = 0.15
		Btn.Text = text
		Btn.TextColor3 = Config.TextPrimary
		Btn.Font = Enum.Font.GothamBold
		Btn.TextSize = 10.5
		Btn.AutoButtonColor = false
		Btn.ZIndex = 4
		Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

		local btnScale = Instance.new("UIScale", Btn)
		btnScale.Scale = 1

		local stroke = Instance.new("UIStroke", Btn)
		stroke.Thickness = 1
		stroke.Transparency = 0.72
		ApplyBlueWhiteGradient(stroke, 75)

		Btn.MouseEnter:Connect(function()
			TweenService:Create(btnScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1.02}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.35}):Play()
		end)
		Btn.MouseLeave:Connect(function()
			TweenService:Create(btnScale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.18), {Transparency = 0.72}):Play()
		end)
		Btn.MouseButton1Click:Connect(function()
			TweenService:Create(btnScale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.96}):Play()
			task.delay(0.08, function()
				if btnScale and btnScale.Parent then
					TweenService:Create(btnScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
				end
			end)
			if callback then callback() end
		end)
		return Btn
	end

	local function CreateToggle(parent, text, defaultState, callback)
		local state = defaultState
		local Frame = Instance.new("Frame", parent)
		Frame.Size = UDim2.new(1, -6, 0, 30)
		Frame.BackgroundColor3 = Config.ContainerColor
		Frame.BackgroundTransparency = 0.15
		Frame.ZIndex = 4
		Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

		local stroke = Instance.new("UIStroke", Frame)
		stroke.Thickness = 1
		stroke.Transparency = 0.78
		ApplyBlueWhiteGradient(stroke, 75)

		local Label = Instance.new("TextLabel", Frame)
		Label.Size = UDim2.new(0.76, 0, 1, 0)
		Label.Position = UDim2.fromOffset(10, 0)
		Label.BackgroundTransparency = 1
		Label.Text = text
		Label.TextColor3 = Config.TextPrimary
		Label.Font = Enum.Font.GothamMedium
		Label.TextSize = 10.5
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.TextTruncate = Enum.TextTruncate.AtEnd
		Label.ZIndex = 5

		local Ind = Instance.new("TextButton", Frame)
		Ind.Size = UDim2.fromOffset(36, 18)
		Ind.Position = UDim2.new(1, -44, 0.5, -9)
		Ind.BackgroundColor3 = state and Color3.fromRGB(65, 155, 255) or Color3.fromRGB(40, 43, 50)
		Ind.Text = state and "ON" or "OFF"
		Ind.TextColor3 = Config.Accent
		Ind.Font = Enum.Font.GothamBold
		Ind.TextSize = 9
		Ind.AutoButtonColor = false
		Ind.ZIndex = 5
		Instance.new("UICorner", Ind).CornerRadius = UDim.new(0, 9)

		local indScale = Instance.new("UIScale", Ind)
		indScale.Scale = 1

		local function setState(v, silent)
			state = v
			TweenService:Create(indScale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.88}):Play()
			task.delay(0.08, function()
				if indScale and indScale.Parent then
					TweenService:Create(indScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
				end
			end)
			TweenService:Create(Ind, TweenInfo.new(0.18), {
				BackgroundColor3 = state and Color3.fromRGB(65, 155, 255) or Color3.fromRGB(40, 43, 50)
			}):Play()
			Ind.Text = state and "ON" or "OFF"
			if not silent and callback then callback(state) end
		end

		Ind.MouseButton1Click:Connect(function()
			setState(not state, false)
		end)

		return Frame, setState
	end

	local function CreateStepper(parent, labelText, initialText, onMinus, onPlus)
		local Frame = Instance.new("Frame", parent)
		Frame.Size = UDim2.new(1, -6, 0, 32)
		Frame.BackgroundColor3 = Config.ContainerColor
		Frame.BackgroundTransparency = 0.15
		Frame.ZIndex = 4
		Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

		local stroke = Instance.new("UIStroke", Frame)
		stroke.Thickness = 1
		stroke.Transparency = 0.78
		ApplyBlueWhiteGradient(stroke, 75)

		local Lbl = Instance.new("TextLabel", Frame)
		Lbl.Size = UDim2.new(1, -78, 1, 0)
		Lbl.Position = UDim2.fromOffset(10, 0)
		Lbl.BackgroundTransparency = 1
		Lbl.Text = labelText .. ": " .. initialText
		Lbl.TextColor3 = Config.TextPrimary
		Lbl.Font = Enum.Font.GothamMedium
		Lbl.TextSize = 10.5
		Lbl.TextXAlignment = Enum.TextXAlignment.Left
		Lbl.TextTruncate = Enum.TextTruncate.AtEnd
		Lbl.ZIndex = 5

		local minusBtn = Instance.new("TextButton", Frame)
		minusBtn.Size = UDim2.fromOffset(24, 22)
		minusBtn.Position = UDim2.new(1, -58, 0.5, -11)
		minusBtn.BackgroundColor3 = Config.SidebarColor
		minusBtn.Text = "-"
		minusBtn.TextColor3 = Config.TextPrimary
		minusBtn.Font = Enum.Font.GothamBold
		minusBtn.TextSize = 12
		minusBtn.AutoButtonColor = false
		minusBtn.ZIndex = 6
		Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 5)

		local plusBtn = Instance.new("TextButton", Frame)
		plusBtn.Size = UDim2.fromOffset(24, 22)
		plusBtn.Position = UDim2.new(1, -30, 0.5, -11)
		plusBtn.BackgroundColor3 = Config.ContainerActive
		plusBtn.Text = "+"
		plusBtn.TextColor3 = Config.TextPrimary
		plusBtn.Font = Enum.Font.GothamBold
		plusBtn.TextSize = 12
		plusBtn.AutoButtonColor = false
		plusBtn.ZIndex = 6
		Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 5)
		ApplyBlueWhiteGradient(plusBtn, 60)

		minusBtn.MouseButton1Click:Connect(function()
			if onMinus then
				local newVal = onMinus()
				if newVal then Lbl.Text = labelText .. ": " .. tostring(newVal) end
			end
		end)
		plusBtn.MouseButton1Click:Connect(function()
			if onPlus then
				local newVal = onPlus()
				if newVal then Lbl.Text = labelText .. ": " .. tostring(newVal) end
			end
		end)

		return Frame, Lbl
	end
	local DashboardPage = CreateTab("Dashboard", 1)
	local MainPage      = CreateTab("Main", 2)
	local BallPage      = CreateTab("Ball", 3)
	local DribblePage   = CreateTab("Dribble", 4)
	local VisualPage    = CreateTab("Visual", 5)
	local PlayerPage    = CreateTab("Player", 6)
	local SettingsPage  = CreateTab("Settings", 7)

	CreateSectionHeader(MainPage, "Main Features")

	local MainUpcomingCard = Instance.new("Frame", MainPage)
	MainUpcomingCard.Name = "UpcomingUpdateCard"
	MainUpcomingCard.Size = UDim2.new(1, -6, 0, 74)
	MainUpcomingCard.BackgroundColor3 = Config.ContainerColor
	MainUpcomingCard.BackgroundTransparency = 0.12
	MainUpcomingCard.ZIndex = 4
	Instance.new("UICorner", MainUpcomingCard).CornerRadius = UDim.new(0, 8)
	local muStroke = Instance.new("UIStroke", MainUpcomingCard)
	muStroke.Thickness = 1.1
	muStroke.Transparency = 0.62
	ApplyBlueWhiteGradient(muStroke, 60)

	local MainUpcomingTitle = Instance.new("TextLabel", MainUpcomingCard)
	MainUpcomingTitle.Size = UDim2.new(1, -20, 0, 20)
	MainUpcomingTitle.Position = UDim2.fromOffset(10, 10)
	MainUpcomingTitle.BackgroundTransparency = 1
	MainUpcomingTitle.Text = "VERSION 1.0.1"
	MainUpcomingTitle.TextColor3 = Config.TextPrimary
	MainUpcomingTitle.Font = Enum.Font.GothamBold
	MainUpcomingTitle.TextSize = 11
	MainUpcomingTitle.TextXAlignment = Enum.TextXAlignment.Left
	MainUpcomingTitle.ZIndex = 5
	ApplyBlueWhiteGradient(MainUpcomingTitle, 55)

	local MainUpcomingDesc = Instance.new("TextLabel", MainUpcomingCard)
	MainUpcomingDesc.Size = UDim2.new(1, -20, 0, 32)
	MainUpcomingDesc.Position = UDim2.fromOffset(10, 32)
	MainUpcomingDesc.BackgroundTransparency = 1
	MainUpcomingDesc.Text = "Coming in the 1.0.1 update."
	MainUpcomingDesc.TextColor3 = Config.TextSecondary
	MainUpcomingDesc.Font = Enum.Font.GothamMedium
	MainUpcomingDesc.TextSize = 10
	MainUpcomingDesc.TextXAlignment = Enum.TextXAlignment.Left
	MainUpcomingDesc.TextWrapped = true
	MainUpcomingDesc.ZIndex = 5

	local BottomRightToast = Instance.new("Frame", MainGui)
	BottomRightToast.Name = "BottomRightLoaderToast"
	BottomRightToast.Size = UDim2.fromOffset(252, 62)
	BottomRightToast.Position = UDim2.new(1, 270, 1, -18)
	BottomRightToast.AnchorPoint = Vector2.new(1, 1)
	BottomRightToast.BackgroundColor3 = Config.BgColor
	BottomRightToast.BackgroundTransparency = 0.06
	BottomRightToast.BorderSizePixel = 0
	BottomRightToast.ZIndex = 120
	Instance.new("UICorner", BottomRightToast).CornerRadius = UDim.new(0, 10)

	local toastStroke = Instance.new("UIStroke", BottomRightToast)
	toastStroke.Thickness = 1.5
	toastStroke.Transparency = 0.2
	ApplyBlueWhiteGradient(toastStroke, 55)

	local ToastRBox = Instance.new("Frame", BottomRightToast)
	ToastRBox.Size = UDim2.fromOffset(38, 38)
	ToastRBox.Position = UDim2.fromOffset(10, 12)
	ToastRBox.BackgroundColor3 = Config.ContainerColor
	ToastRBox.BorderSizePixel = 0
	ToastRBox.ZIndex = 121
	Instance.new("UICorner", ToastRBox).CornerRadius = UDim.new(0, 8)

	local toastRStroke = Instance.new("UIStroke", ToastRBox)
	toastRStroke.Thickness = 1.4
	toastRStroke.Transparency = 0.15
	ApplyBlueWhiteGradient(toastRStroke, 150)

	local ToastRLetter = Instance.new("TextLabel", ToastRBox)
	ToastRLetter.Size = UDim2.fromScale(1, 1)
	ToastRLetter.BackgroundTransparency = 1
	ToastRLetter.Text = "R"
	ToastRLetter.TextColor3 = Config.TextPrimary
	ToastRLetter.Font = Enum.Font.GothamBlack
	ToastRLetter.TextSize = 20
	ToastRLetter.ZIndex = 122
	ApplyBlueWhiteGradient(ToastRLetter, 80)

	local ToastTitle = Instance.new("TextLabel", BottomRightToast)
	ToastTitle.Size = UDim2.new(1, -62, 0, 18)
	ToastTitle.Position = UDim2.fromOffset(55, 11)
	ToastTitle.BackgroundTransparency = 1
	ToastTitle.Text = "Rivals hub is loading."
	ToastTitle.TextColor3 = Config.TextPrimary
	ToastTitle.Font = Enum.Font.GothamBold
	ToastTitle.TextSize = 11.5
	ToastTitle.TextXAlignment = Enum.TextXAlignment.Left
	ToastTitle.ZIndex = 122
	ApplyBlueWhiteGradient(ToastTitle, 60)

	local ToastSub = Instance.new("TextLabel", BottomRightToast)
	ToastSub.Size = UDim2.new(1, -62, 0, 15)
	ToastSub.Position = UDim2.fromOffset(55, 31)
	ToastSub.BackgroundTransparency = 1
	ToastSub.Text = "Checking game & executor..."
	ToastSub.TextColor3 = Config.TextSecondary
	ToastSub.Font = Enum.Font.GothamMedium
	ToastSub.TextSize = 9
	ToastSub.TextXAlignment = Enum.TextXAlignment.Left
	ToastSub.TextTruncate = Enum.TextTruncate.AtEnd
	ToastSub.ZIndex = 122

	local ToastProgressTrack = Instance.new("Frame", BottomRightToast)
	ToastProgressTrack.Size = UDim2.new(1, -16, 0, 3)
	ToastProgressTrack.Position = UDim2.new(0, 8, 1, -6)
	ToastProgressTrack.BackgroundColor3 = Config.SidebarColor
	ToastProgressTrack.BorderSizePixel = 0
	ToastProgressTrack.ZIndex = 121
	Instance.new("UICorner", ToastProgressTrack).CornerRadius = UDim.new(1, 0)

	local ToastProgressFill = Instance.new("Frame", ToastProgressTrack)
	ToastProgressFill.Size = UDim2.new(0.1, 0, 1, 0)
	ToastProgressFill.BackgroundColor3 = Config.BlueGlow
	ToastProgressFill.BorderSizePixel = 0
	ToastProgressFill.ZIndex = 122
	Instance.new("UICorner", ToastProgressFill).CornerRadius = UDim.new(1, 0)
	ApplyBlueWhiteGradient(ToastProgressFill, 90)
	local BannerCard = Instance.new("Frame", DashboardPage)
	BannerCard.Size = UDim2.new(1, -6, 0, 56)
	BannerCard.BackgroundColor3 = Config.ContainerColor
	BannerCard.BackgroundTransparency = 0.12
	BannerCard.ZIndex = 4
	Instance.new("UICorner", BannerCard).CornerRadius = UDim.new(0, 8)
	local bStroke = Instance.new("UIStroke", BannerCard)
	bStroke.Thickness = 1.1
	bStroke.Transparency = 0.62
	ApplyBlueWhiteGradient(bStroke, 60)

	local AvatarImg = Instance.new("ImageLabel", BannerCard)
	AvatarImg.Size = UDim2.fromOffset(40, 40)
	AvatarImg.Position = UDim2.fromOffset(8, 8)
	AvatarImg.BackgroundColor3 = Config.SidebarColor
	AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
	AvatarImg.ZIndex = 5
	Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

	local PlayerTitle = Instance.new("TextLabel", BannerCard)
	PlayerTitle.Size = UDim2.new(1, -138, 0, 17)
	PlayerTitle.Position = UDim2.fromOffset(55, 9)
	PlayerTitle.BackgroundTransparency = 1
	PlayerTitle.Text = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")"
	PlayerTitle.TextColor3 = Config.TextPrimary
	PlayerTitle.Font = Enum.Font.GothamBold
	PlayerTitle.TextSize = 11
	PlayerTitle.TextXAlignment = Enum.TextXAlignment.Left
	PlayerTitle.TextTruncate = Enum.TextTruncate.AtEnd
	PlayerTitle.ZIndex = 5

	local MatchInfoLbl = Instance.new("TextLabel", BannerCard)
	MatchInfoLbl.Size = UDim2.new(1, -138, 0, 15)
	MatchInfoLbl.Position = UDim2.fromOffset(55, 29)
	MatchInfoLbl.BackgroundTransparency = 1
	MatchInfoLbl.Text = "Match / Team: " .. (LocalPlayer.Team and LocalPlayer.Team.Name or "Lobby / None")
	MatchInfoLbl.TextColor3 = Config.TextSecondary
	MatchInfoLbl.Font = Enum.Font.GothamMedium
	MatchInfoLbl.TextSize = 9
	MatchInfoLbl.TextXAlignment = Enum.TextXAlignment.Left
	MatchInfoLbl.TextTruncate = Enum.TextTruncate.AtEnd
	MatchInfoLbl.ZIndex = 5

	local RejoinBtn = Instance.new("TextButton", BannerCard)
	RejoinBtn.Size = UDim2.fromOffset(68, 22)
	RejoinBtn.Position = UDim2.new(1, -76, 0, 7)
	RejoinBtn.BackgroundColor3 = Config.ContainerActive
	RejoinBtn.Text = "Rejoin"
	RejoinBtn.TextColor3 = Config.TextPrimary
	RejoinBtn.Font = Enum.Font.GothamBold
	RejoinBtn.TextSize = 9.5
	RejoinBtn.ZIndex = 5
	Instance.new("UICorner", RejoinBtn).CornerRadius = UDim.new(0, 6)
	ApplyBlueWhiteGradient(RejoinBtn, 65)
	RejoinBtn.MouseButton1Click:Connect(function()
		RejoinBtn.Text = "Joining..."
		pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
	end)

	local CopyJobBtn = Instance.new("TextButton", BannerCard)
	CopyJobBtn.Size = UDim2.fromOffset(68, 18)
	CopyJobBtn.Position = UDim2.new(1, -76, 0, 31)
	CopyJobBtn.BackgroundColor3 = Config.SidebarColor
	CopyJobBtn.Text = "Copy JobId"
	CopyJobBtn.TextColor3 = Config.TextSecondary
	CopyJobBtn.Font = Enum.Font.GothamBold
	CopyJobBtn.TextSize = 8
	CopyJobBtn.ZIndex = 5
	Instance.new("UICorner", CopyJobBtn).CornerRadius = UDim.new(0, 5)
	CopyJobBtn.MouseButton1Click:Connect(function()
		if setclipboard then
			pcall(function() setclipboard(tostring(game.JobId)) end)
			CopyJobBtn.Text = "Copied"
			task.delay(1.2, function()
				if CopyJobBtn and CopyJobBtn.Parent then CopyJobBtn.Text = "Copy JobId" end
			end)
		end
	end)

	local VersionCard = Instance.new("Frame", DashboardPage)
	VersionCard.Name = "ScriptVersionCard"
	VersionCard.Size = UDim2.new(1, -6, 0, 62)
	VersionCard.BackgroundColor3 = Config.ContainerColor
	VersionCard.BackgroundTransparency = 0.12
	VersionCard.ZIndex = 4
	Instance.new("UICorner", VersionCard).CornerRadius = UDim.new(0, 8)
	local verStroke = Instance.new("UIStroke", VersionCard)
	verStroke.Thickness = 1.1
	verStroke.Transparency = 0.62
	ApplyBlueWhiteGradient(verStroke, 60)

	local verBadge = Instance.new("TextLabel", VersionCard)
	verBadge.Size = UDim2.fromOffset(62, 24)
	verBadge.Position = UDim2.fromOffset(9, 19)
	verBadge.BackgroundColor3 = Config.ContainerActive
	verBadge.Text = "v" .. Config.Version
	verBadge.TextColor3 = Config.TextPrimary
	verBadge.Font = Enum.Font.GothamBlack
	verBadge.TextSize = 12
	verBadge.ZIndex = 5
	Instance.new("UICorner", verBadge).CornerRadius = UDim.new(0, 6)
	ApplyBlueWhiteGradient(verBadge, 70)

	local verHeader = Instance.new("TextLabel", VersionCard)
	verHeader.Size = UDim2.new(1, -86, 0, 16)
	verHeader.Position = UDim2.fromOffset(78, 8)
	verHeader.BackgroundTransparency = 1
	verHeader.Text = "SCRIPT VERSION  •  " .. Config.Version
	verHeader.TextColor3 = Config.TextPrimary
	verHeader.Font = Enum.Font.GothamBold
	verHeader.TextSize = 10
	verHeader.TextXAlignment = Enum.TextXAlignment.Left
	verHeader.ZIndex = 5
	ApplyBlueWhiteGradient(verHeader, 50)

	local verDesc = Instance.new("TextLabel", VersionCard)
	verDesc.Size = UDim2.new(1, -86, 0, 28)
	verDesc.Position = UDim2.fromOffset(78, 25)
	verDesc.BackgroundTransparency = 1
	verDesc.Text = "Build 1.0.1 includes integrated Inf Stamina, transparent Ball Hitbox, Ball Control mini panel, and UI scaling."
	verDesc.TextColor3 = Config.TextSecondary
	verDesc.Font = Enum.Font.GothamMedium
	verDesc.TextSize = 8.5
	verDesc.TextXAlignment = Enum.TextXAlignment.Left
	verDesc.TextWrapped = true
	verDesc.ZIndex = 5

	local GameExecCard = Instance.new("Frame", DashboardPage)
	GameExecCard.Name = "GameAndExecutorCard"
	GameExecCard.Size = UDim2.new(1, -6, 0, 58)
	GameExecCard.BackgroundColor3 = Config.ContainerColor
	GameExecCard.BackgroundTransparency = 0.12
	GameExecCard.ZIndex = 4
	Instance.new("UICorner", GameExecCard).CornerRadius = UDim.new(0, 8)
	local geStroke = Instance.new("UIStroke", GameExecCard)
	geStroke.Thickness = 1.1
	geStroke.Transparency = 0.65
	ApplyBlueWhiteGradient(geStroke, 62)

	local GameThumb = Instance.new("ImageLabel", GameExecCard)
	GameThumb.Size = UDim2.fromOffset(42, 42)
	GameThumb.Position = UDim2.fromOffset(8, 8)
	GameThumb.BackgroundColor3 = Config.SidebarColor
	GameThumb.Image = "rbxthumb://type=GameIcon&id=" .. tostring(game.GameId) .. "&w=256&h=256"
	GameThumb.ZIndex = 5
	Instance.new("UICorner", GameThumb).CornerRadius = UDim.new(0, 8)

	local GameNameLbl = Instance.new("TextLabel", GameExecCard)
	GameNameLbl.Size = UDim2.new(1, -62, 0, 17)
	GameNameLbl.Position = UDim2.fromOffset(56, 9)
	GameNameLbl.BackgroundTransparency = 1
	GameNameLbl.Text = "GAME  •  Detecting..."
	GameNameLbl.TextColor3 = Config.TextPrimary
	GameNameLbl.Font = Enum.Font.GothamBold
	GameNameLbl.TextSize = 10.5
	GameNameLbl.TextXAlignment = Enum.TextXAlignment.Left
	GameNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
	GameNameLbl.ZIndex = 5
	ApplyBlueWhiteGradient(GameNameLbl, 50)

	local ExecutorLbl = Instance.new("TextLabel", GameExecCard)
	ExecutorLbl.Size = UDim2.new(1, -62, 0, 16)
	ExecutorLbl.Position = UDim2.fromOffset(56, 28)
	ExecutorLbl.BackgroundTransparency = 1
	ExecutorLbl.Text = "EXECUTOR  •  Detecting..."
	ExecutorLbl.TextColor3 = Config.TextSecondary
	ExecutorLbl.Font = Enum.Font.GothamMedium
	ExecutorLbl.TextSize = 9
	ExecutorLbl.TextXAlignment = Enum.TextXAlignment.Left
	ExecutorLbl.TextTruncate = Enum.TextTruncate.AtEnd
	ExecutorLbl.ZIndex = 5

	local StatsGrid = Instance.new("Frame", DashboardPage)
	StatsGrid.Size = UDim2.new(1, -6, 0, 92)
	StatsGrid.BackgroundTransparency = 1
	StatsGrid.ZIndex = 4
	local GridLayout = Instance.new("UIGridLayout", StatsGrid)
	GridLayout.CellSize = UDim2.new(0.494, 0, 0, 43)
	GridLayout.CellPadding = UDim2.new(0.012, 0, 0, 6)
	GridLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local _, PlayersVal = CreateStatBox(StatsGrid, "Players / Match", "0 / 0")
	local _, FriendsVal = CreateStatBox(StatsGrid, "Friends in Server", "0")
	local _, PingVal    = CreateStatBox(StatsGrid, "Ping / FPS", "0 ms | 0")
	local _, TimeVal    = CreateStatBox(StatsGrid, "Server / Session", "00:00")
	local DiscordCard = Instance.new("Frame", DashboardPage)
	DiscordCard.Name = "CommunityServerCard"
	DiscordCard.Size = UDim2.new(1, -6, 0, 48)
	DiscordCard.BackgroundColor3 = Config.ContainerColor
	DiscordCard.BackgroundTransparency = 0.12
	DiscordCard.ZIndex = 4
	Instance.new("UICorner", DiscordCard).CornerRadius = UDim.new(0, 8)
	local dStroke = Instance.new("UIStroke", DiscordCard)
	dStroke.Thickness = 1.1
	dStroke.Transparency = 0.68
	ApplyBlueWhiteGradient(dStroke, 70)

	CreateDrawnDiscordIcon(DiscordCard, UDim2.fromOffset(9, 16), 6)

	local DiscordTitle = Instance.new("TextLabel", DiscordCard)
	DiscordTitle.Size = UDim2.new(1, -124, 0, 16)
	DiscordTitle.Position = UDim2.fromOffset(36, 6)
	DiscordTitle.BackgroundTransparency = 1
	DiscordTitle.Text = "Community Server  •  Discord"
	DiscordTitle.TextColor3 = Config.TextPrimary
	DiscordTitle.Font = Enum.Font.GothamBold
	DiscordTitle.TextSize = 10.5
	DiscordTitle.TextXAlignment = Enum.TextXAlignment.Left
	DiscordTitle.ZIndex = 5
	ApplyBlueWhiteGradient(DiscordTitle, 55)

	local DiscordSub = Instance.new("TextLabel", DiscordCard)
	DiscordSub.Size = UDim2.new(1, -124, 0, 15)
	DiscordSub.Position = UDim2.fromOffset(36, 25)
	DiscordSub.BackgroundTransparency = 1
	DiscordSub.Text = Config.DiscordInviteUrl
	DiscordSub.TextColor3 = Config.BlueGlow
	DiscordSub.Font = Enum.Font.GothamMedium
	DiscordSub.TextSize = 8.5
	DiscordSub.TextXAlignment = Enum.TextXAlignment.Left
	DiscordSub.TextTruncate = Enum.TextTruncate.AtEnd
	DiscordSub.ZIndex = 5

	local CopyDiscordBtn = Instance.new("TextButton", DiscordCard)
	CopyDiscordBtn.Size = UDim2.fromOffset(74, 24)
	CopyDiscordBtn.Position = UDim2.new(1, -82, 0.5, -12)
	CopyDiscordBtn.BackgroundColor3 = Config.ContainerActive
	CopyDiscordBtn.Text = "Copy Invite"
	CopyDiscordBtn.TextColor3 = Config.TextPrimary
	CopyDiscordBtn.Font = Enum.Font.GothamBold
	CopyDiscordBtn.TextSize = 9
	CopyDiscordBtn.AutoButtonColor = false
	CopyDiscordBtn.ZIndex = 6
	Instance.new("UICorner", CopyDiscordBtn).CornerRadius = UDim.new(0, 6)
	ApplyBlueWhiteGradient(CopyDiscordBtn, 65)
	CopyDiscordBtn.MouseButton1Click:Connect(function()
		if setclipboard then
			pcall(function() setclipboard(Config.DiscordInviteUrl) end)
		end
		CopyDiscordBtn.Text = "Copied!"
		task.delay(1.2, function()
			if CopyDiscordBtn and CopyDiscordBtn.Parent then
				CopyDiscordBtn.Text = "Copy Invite"
			end
		end)
	end)

	local SocialCard = Instance.new("Frame", DashboardPage)
	SocialCard.Name = "SocialMediaAccountsCard"
	SocialCard.Size = UDim2.new(1, -6, 0, 86)
	SocialCard.BackgroundColor3 = Config.ContainerColor
	SocialCard.BackgroundTransparency = 0.12
	SocialCard.ZIndex = 4
	Instance.new("UICorner", SocialCard).CornerRadius = UDim.new(0, 8)
	local socStroke = Instance.new("UIStroke", SocialCard)
	socStroke.Thickness = 1.1
	socStroke.Transparency = 0.68
	ApplyBlueWhiteGradient(socStroke, 68)

	local SocialHeader = Instance.new("TextLabel", SocialCard)
	SocialHeader.Size = UDim2.new(1, -16, 0, 16)
	SocialHeader.Position = UDim2.fromOffset(9, 6)
	SocialHeader.BackgroundTransparency = 1
	SocialHeader.Text = "OUR SOCIAL MEDIA ACCOUNTS"
	SocialHeader.TextColor3 = Config.TextPrimary
	SocialHeader.Font = Enum.Font.GothamBold
	SocialHeader.TextSize = 9.5
	SocialHeader.TextXAlignment = Enum.TextXAlignment.Left
	SocialHeader.ZIndex = 5
	ApplyBlueWhiteGradient(SocialHeader, 55)

	local TikTokRow = Instance.new("Frame", SocialCard)
	TikTokRow.Size = UDim2.new(1, -16, 0, 27)
	TikTokRow.Position = UDim2.fromOffset(8, 24)
	TikTokRow.BackgroundColor3 = Config.SidebarColor
	TikTokRow.BackgroundTransparency = 0.2
	TikTokRow.BorderSizePixel = 0
	TikTokRow.ZIndex = 5
	Instance.new("UICorner", TikTokRow).CornerRadius = UDim.new(0, 6)

	CreateDrawnTikTokIcon(TikTokRow, UDim2.fromOffset(7, 4.5), 6)

	local TikTokLbl = Instance.new("TextLabel", TikTokRow)
	TikTokLbl.Size = UDim2.new(1, -110, 1, 0)
	TikTokLbl.Position = UDim2.fromOffset(32, 0)
	TikTokLbl.BackgroundTransparency = 1
	TikTokLbl.Text = "TikTok  •  Link not added yet"
	TikTokLbl.TextColor3 = Config.TextPrimary
	TikTokLbl.Font = Enum.Font.GothamBold
	TikTokLbl.TextSize = 9.5
	TikTokLbl.TextXAlignment = Enum.TextXAlignment.Left
	TikTokLbl.TextTruncate = Enum.TextTruncate.AtEnd
	TikTokLbl.ZIndex = 6

	local TikTokStatus = Instance.new("TextLabel", TikTokRow)
	TikTokStatus.Size = UDim2.fromOffset(64, 18)
	TikTokStatus.Position = UDim2.new(1, -70, 0.5, -9)
	TikTokStatus.BackgroundColor3 = Config.ContainerColor
	TikTokStatus.Text = "SOON"
	TikTokStatus.TextColor3 = Config.TextSecondary
	TikTokStatus.Font = Enum.Font.GothamBold
	TikTokStatus.TextSize = 8.5
	TikTokStatus.ZIndex = 6
	Instance.new("UICorner", TikTokStatus).CornerRadius = UDim.new(0, 5)

	local YouTubeRow = Instance.new("Frame", SocialCard)
	YouTubeRow.Size = UDim2.new(1, -16, 0, 27)
	YouTubeRow.Position = UDim2.fromOffset(8, 54)
	YouTubeRow.BackgroundColor3 = Config.SidebarColor
	YouTubeRow.BackgroundTransparency = 0.2
	YouTubeRow.BorderSizePixel = 0
	YouTubeRow.ZIndex = 5
	Instance.new("UICorner", YouTubeRow).CornerRadius = UDim.new(0, 6)

	CreateDrawnYouTubeIcon(YouTubeRow, UDim2.fromOffset(6, 6), 6)

	local YouTubeLbl = Instance.new("TextLabel", YouTubeRow)
	YouTubeLbl.Size = UDim2.new(1, -110, 1, 0)
	YouTubeLbl.Position = UDim2.fromOffset(32, 0)
	YouTubeLbl.BackgroundTransparency = 1
	YouTubeLbl.Text = "YouTube  •  Link not added yet"
	YouTubeLbl.TextColor3 = Config.TextPrimary
	YouTubeLbl.Font = Enum.Font.GothamBold
	YouTubeLbl.TextSize = 9.5
	YouTubeLbl.TextXAlignment = Enum.TextXAlignment.Left
	YouTubeLbl.TextTruncate = Enum.TextTruncate.AtEnd
	YouTubeLbl.ZIndex = 6

	local YouTubeStatus = Instance.new("TextLabel", YouTubeRow)
	YouTubeStatus.Size = UDim2.fromOffset(64, 18)
	YouTubeStatus.Position = UDim2.new(1, -70, 0.5, -9)
	YouTubeStatus.BackgroundColor3 = Config.ContainerColor
	YouTubeStatus.Text = "SOON"
	YouTubeStatus.TextColor3 = Config.TextSecondary
	YouTubeStatus.Font = Enum.Font.GothamBold
	YouTubeStatus.TextSize = 8.5
	YouTubeStatus.ZIndex = 6
	Instance.new("UICorner", YouTubeStatus).CornerRadius = UDim.new(0, 5)

	local InformPanel = Instance.new("Frame", DashboardPage)
	InformPanel.Name = "UpdateLogsToInform"
	InformPanel.Size = UDim2.new(1, -6, 0, 54)
	InformPanel.BackgroundColor3 = Config.ContainerColor
	InformPanel.BackgroundTransparency = 0.12
	InformPanel.ZIndex = 4
	Instance.new("UICorner", InformPanel).CornerRadius = UDim.new(0, 8)
	local infStroke = Instance.new("UIStroke", InformPanel)
	infStroke.Thickness = 1.1
	infStroke.Transparency = 0.65
	ApplyBlueWhiteGradient(infStroke, 70)

	CreateDrawnMegaphoneIcon(InformPanel, UDim2.fromOffset(8, 8), 6)

	local InformHeader = Instance.new("TextLabel", InformPanel)
	InformHeader.Size = UDim2.new(1, -40, 0, 16)
	InformHeader.Position = UDim2.fromOffset(32, 7)
	InformHeader.BackgroundTransparency = 1
	InformHeader.Text = "Update logs/To inform"
	InformHeader.TextColor3 = Config.TextPrimary
	InformHeader.Font = Enum.Font.GothamBold
	InformHeader.TextSize = 9.5
	InformHeader.TextXAlignment = Enum.TextXAlignment.Left
	InformHeader.ZIndex = 5
	ApplyBlueWhiteGradient(InformHeader, 55)

	local InformBody = Instance.new("TextLabel", InformPanel)
	InformBody.Size = UDim2.new(1, -18, 0, 18)
	InformBody.Position = UDim2.fromOffset(10, 27)
	InformBody.BackgroundTransparency = 1
	InformBody.Text = "This script is in beta."
	InformBody.TextColor3 = Config.TextSecondary
	InformBody.Font = Enum.Font.GothamMedium
	InformBody.TextSize = 9.5
	InformBody.TextXAlignment = Enum.TextXAlignment.Left
	InformBody.ZIndex = 5

	local UpdateLogsPanel = Instance.new("Frame", DashboardPage)
	UpdateLogsPanel.Name = "UpdateLogs"
	UpdateLogsPanel.Size = UDim2.new(1, -6, 0, 74)
	UpdateLogsPanel.BackgroundColor3 = Config.ContainerColor
	UpdateLogsPanel.BackgroundTransparency = 0.12
	UpdateLogsPanel.ZIndex = 4
	Instance.new("UICorner", UpdateLogsPanel).CornerRadius = UDim.new(0, 8)
	local uStroke = Instance.new("UIStroke", UpdateLogsPanel)
	uStroke.Thickness = 1.1
	uStroke.Transparency = 0.7
	ApplyBlueWhiteGradient(uStroke, 75)

	CreateDrawnMegaphoneIcon(UpdateLogsPanel, UDim2.fromOffset(8, 7), 6)

	local UpdateLogsHeader = Instance.new("TextLabel", UpdateLogsPanel)
	UpdateLogsHeader.Size = UDim2.new(1, -40, 0, 16)
	UpdateLogsHeader.Position = UDim2.fromOffset(32, 6)
	UpdateLogsHeader.BackgroundTransparency = 1
	UpdateLogsHeader.Text = "UPDATELOGS"
	UpdateLogsHeader.TextColor3 = Config.TextPrimary
	UpdateLogsHeader.Font = Enum.Font.GothamBold
	UpdateLogsHeader.TextSize = 9.5
	UpdateLogsHeader.TextXAlignment = Enum.TextXAlignment.Left
	UpdateLogsHeader.ZIndex = 5
	ApplyBlueWhiteGradient(UpdateLogsHeader, 55)

	local UpdateLogsBody = Instance.new("TextLabel", UpdateLogsPanel)
	UpdateLogsBody.Size = UDim2.new(1, -18, 1, -28)
	UpdateLogsBody.Position = UDim2.fromOffset(10, 25)
	UpdateLogsBody.BackgroundTransparency = 1
	UpdateLogsBody.Text = ""
	UpdateLogsBody.TextColor3 = Config.TextSecondary
	UpdateLogsBody.Font = Enum.Font.GothamMedium
	UpdateLogsBody.TextSize = 9.5
	UpdateLogsBody.TextWrapped = true
	UpdateLogsBody.TextXAlignment = Enum.TextXAlignment.Left
	UpdateLogsBody.TextYAlignment = Enum.TextYAlignment.Top
	UpdateLogsBody.ZIndex = 5

	local DevCard = Instance.new("Frame", DashboardPage)
	DevCard.Name = "DeveloperCard"
	DevCard.Size = UDim2.new(1, -6, 0, 74)
	DevCard.BackgroundColor3 = Config.ContainerColor
	DevCard.BackgroundTransparency = 0.12
	DevCard.ZIndex = 4
	Instance.new("UICorner", DevCard).CornerRadius = UDim.new(0, 8)
	local devStroke = Instance.new("UIStroke", DevCard)
	devStroke.Thickness = 1.1
	devStroke.Transparency = 0.65
	ApplyBlueWhiteGradient(devStroke, 65)

	local DevAvatar = Instance.new("ImageLabel", DevCard)
	DevAvatar.Size = UDim2.fromOffset(42, 42)
	DevAvatar.Position = UDim2.fromOffset(9, 9)
	DevAvatar.BackgroundColor3 = Config.SidebarColor
	DevAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(Config.DeveloperUserId) .. "&w=150&h=150"
	DevAvatar.ZIndex = 5
	Instance.new("UICorner", DevAvatar).CornerRadius = UDim.new(1, 0)

	local DevHeader = Instance.new("TextLabel", DevCard)
	DevHeader.Size = UDim2.new(1, -138, 0, 15)
	DevHeader.Position = UDim2.fromOffset(58, 7)
	DevHeader.BackgroundTransparency = 1
	DevHeader.Text = "DEVELOPER  •  Loading..."
	DevHeader.TextColor3 = Config.TextPrimary
	DevHeader.Font = Enum.Font.GothamBold
	DevHeader.TextSize = 10
	DevHeader.TextXAlignment = Enum.TextXAlignment.Left
	DevHeader.TextTruncate = Enum.TextTruncate.AtEnd
	DevHeader.ZIndex = 5
	ApplyBlueWhiteGradient(DevHeader, 50)

	local DevLinkLbl = Instance.new("TextLabel", DevCard)
	DevLinkLbl.Size = UDim2.new(1, -138, 0, 13)
	DevLinkLbl.Position = UDim2.fromOffset(58, 22)
	DevLinkLbl.BackgroundTransparency = 1
	DevLinkLbl.Text = Config.DeveloperProfileUrl
	DevLinkLbl.TextColor3 = Config.BlueGlow
	DevLinkLbl.Font = Enum.Font.GothamMedium
	DevLinkLbl.TextSize = 8
	DevLinkLbl.TextXAlignment = Enum.TextXAlignment.Left
	DevLinkLbl.TextTruncate = Enum.TextTruncate.AtEnd
	DevLinkLbl.ZIndex = 5

	local DevThanksLbl = Instance.new("TextLabel", DevCard)
	DevThanksLbl.Size = UDim2.new(1, -18, 0, 16)
	DevThanksLbl.Position = UDim2.fromOffset(9, 54)
	DevThanksLbl.BackgroundTransparency = 1
	DevThanksLbl.Text = "Geliştiriciye teşekkür etmek için onu takip edebilirsiniz."
	DevThanksLbl.TextColor3 = Config.TextSecondary
	DevThanksLbl.Font = Enum.Font.GothamMedium
	DevThanksLbl.TextSize = 8.5
	DevThanksLbl.TextXAlignment = Enum.TextXAlignment.Left
	DevThanksLbl.TextTruncate = Enum.TextTruncate.AtEnd
	DevThanksLbl.ZIndex = 5

	local CopyDevBtn = Instance.new("TextButton", DevCard)
	CopyDevBtn.Size = UDim2.fromOffset(74, 24)
	CopyDevBtn.Position = UDim2.new(1, -82, 0, 12)
	CopyDevBtn.BackgroundColor3 = Config.ContainerActive
	CopyDevBtn.Text = "Copy Profile"
	CopyDevBtn.TextColor3 = Config.TextPrimary
	CopyDevBtn.Font = Enum.Font.GothamBold
	CopyDevBtn.TextSize = 9
	CopyDevBtn.AutoButtonColor = false
	CopyDevBtn.ZIndex = 5
	Instance.new("UICorner", CopyDevBtn).CornerRadius = UDim.new(0, 6)
	ApplyBlueWhiteGradient(CopyDevBtn, 65)
	CopyDevBtn.MouseButton1Click:Connect(function()
		if setclipboard then pcall(function() setclipboard(Config.DeveloperProfileUrl) end) end
		CopyDevBtn.Text = "Copied!"
		task.delay(1.2, function()
			if CopyDevBtn and CopyDevBtn.Parent then CopyDevBtn.Text = "Copy Profile" end
		end)
	end)

	task.spawn(function()
		local ok, name = pcall(function() return Players:GetNameFromUserIdAsync(Config.DeveloperUserId) end)
		if ok and name and DevHeader and DevHeader.Parent then
			DevHeader.Text = "DEVELOPER  •  @" .. tostring(name) .. " (" .. tostring(Config.DeveloperUserId) .. ")"
		elseif DevHeader and DevHeader.Parent then
			DevHeader.Text = "DEVELOPER  •  ID: " .. tostring(Config.DeveloperUserId)
		end
	end)

	local lastResetClick = 0
	local ResetScriptBtn = CreateButton(DashboardPage, "Reset Script (Double Click)", function()
		local now = os.clock()
		if now - lastResetClick <= 0.65 then
			lastResetClick = 0
			BuildRivalsHub()
		else
			lastResetClick = now
			task.delay(0.7, function()
				if lastResetClick ~= 0 then
					lastResetClick = 0
				end
			end)
		end
	end)
	ResetScriptBtn.MouseButton1Click:Connect(function()
		if os.clock() - lastResetClick <= 0.7 then
			ResetScriptBtn.Text = "Click Again to Reset"
			task.delay(0.7, function()
				if ResetScriptBtn and ResetScriptBtn.Parent then
					ResetScriptBtn.Text = "Reset Script (Double Click)"
				end
			end)
		end
	end)
	CreateSectionHeader(PlayerPage, "Player Movement & Mods")

	local PlayerState = {
		InfStamina = false,
		SpeedEnabled = false,
		SpeedValue = 28,
		JumpEnabled = false,
		JumpPowerValue = 75,
		Noclip = false,
		Fly = false,
		FlySpeed = 65
	}

	local staminaChangedConn = nil
	local staminaHeartbeatConn = nil

	local function GetHumanoid()
		local char = LocalPlayer.Character
		return char and char:FindFirstChildOfClass("Humanoid")
	end

	local function GetRootPart()
		local char = LocalPlayer.Character
		return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
	end

	local function FindStaminaValueBase()
		local playerStats = LocalPlayer:FindFirstChild("PlayerStats")
		if playerStats then
			local stamina = playerStats:FindFirstChild("Stamina")
			if stamina and stamina:IsA("ValueBase") then
				return stamina
			end
		end
		local char = LocalPlayer.Character
		if char then
			local charStats = char:FindFirstChild("PlayerStats")
			if charStats then
				local stamina = charStats:FindFirstChild("Stamina")
				if stamina and stamina:IsA("ValueBase") then
					return stamina
				end
			end
		end
		return nil
	end

	local function LockStaminaValue()
		if not PlayerState.InfStamina then return end
		local staminaObj = FindStaminaValueBase()
		if staminaObj then
			pcall(function()
				if staminaObj.Value < 100 then
					staminaObj.Value = 100
				end
			end)
		end
		pcall(function()
			for _, attrName in ipairs({ "Stamina", "Energy", "Sprint", "Dash" }) do
				if LocalPlayer:GetAttribute(attrName) ~= nil then
					LocalPlayer:SetAttribute(attrName, 100)
				end
			end
		end)
	end

	local function BindInfStamina(enable)
		PlayerState.InfStamina = enable
		if staminaChangedConn then staminaChangedConn:Disconnect() staminaChangedConn = nil end
		if staminaHeartbeatConn then staminaHeartbeatConn:Disconnect() staminaHeartbeatConn = nil end

		if enable then
			LockStaminaValue()
			local staminaObj = FindStaminaValueBase()
			if staminaObj then
				staminaChangedConn = staminaObj.Changed:Connect(function()
					if PlayerState.InfStamina and staminaObj.Value < 100 then
						pcall(function() staminaObj.Value = 100 end)
					end
				end)
			end
			staminaHeartbeatConn = RunService.Heartbeat:Connect(function()
				if PlayerState.InfStamina then
					LockStaminaValue()
				end
			end)
		end
	end

	CreateToggle(PlayerPage, "Inf Stamina [Safe]", false, function(v)
		BindInfStamina(v)
	end)

	CreateToggle(PlayerPage, "Speed [Risk]", false, function(v)
		PlayerState.SpeedEnabled = v
		local hum = GetHumanoid()
		if hum and not v then
			pcall(function() hum.WalkSpeed = 16 end)
		end
	end)

	CreateStepper(PlayerPage, "WalkSpeed", tostring(PlayerState.SpeedValue), function()
		PlayerState.SpeedValue = math.max(16, PlayerState.SpeedValue - 4)
		return tostring(PlayerState.SpeedValue)
	end, function()
		PlayerState.SpeedValue = math.min(120, PlayerState.SpeedValue + 4)
		return tostring(PlayerState.SpeedValue)
	end)

	CreateToggle(PlayerPage, "Jump [Risk]", false, function(v)
		PlayerState.JumpEnabled = v
		local hum = GetHumanoid()
		if hum and not v then
			pcall(function()
				hum.UseJumpPower = true
				hum.JumpPower = 50
			end)
		end
	end)

	CreateStepper(PlayerPage, "JumpPower", tostring(PlayerState.JumpPowerValue), function()
		PlayerState.JumpPowerValue = math.max(50, PlayerState.JumpPowerValue - 10)
		return tostring(PlayerState.JumpPowerValue)
	end, function()
		PlayerState.JumpPowerValue = math.min(200, PlayerState.JumpPowerValue + 10)
		return tostring(PlayerState.JumpPowerValue)
	end)

	local noclipOriginalState = {}
	CreateToggle(PlayerPage, "Noclip [Risk]", false, function(v)
		PlayerState.Noclip = v
		if not v then
			local char = LocalPlayer.Character
			if char then
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") and noclipOriginalState[part] ~= nil then
						part.CanCollide = noclipOriginalState[part]
					end
				end
			end
			table.clear(noclipOriginalState)
		end
	end)

	CreateSectionHeader(PlayerPage, "Flight Controls")

	local flyBV, flyBG
	local function StopFly()
		if flyBV then flyBV:Destroy() flyBV = nil end
		if flyBG then flyBG:Destroy() flyBG = nil end
		local hum = GetHumanoid()
		if hum then pcall(function() hum.PlatformStand = false end) end
	end

	local _, setFlyToggleUI = CreateToggle(PlayerPage, "Fly [Risk]", false, function(v)
		PlayerState.Fly = v
		if v then
			local root = GetRootPart()
			local hum = GetHumanoid()
			if root then
				StopFly()
				flyBV = Instance.new("BodyVelocity")
				flyBV.MaxForce = Vector3.new(1e6, 1e6, 1e6)
				flyBV.Velocity = Vector3.zero
				flyBV.Parent = root

				flyBG = Instance.new("BodyGyro")
				flyBG.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
				flyBG.P = 50000
				flyBG.CFrame = root.CFrame
				flyBG.Parent = root

				if hum then pcall(function() hum.PlatformStand = true end) end
			end
		else
			StopFly()
		end
	end)

	local FlySpeedCard = Instance.new("Frame", PlayerPage)
	FlySpeedCard.Name = "FlySpeedCard"
	FlySpeedCard.Size = UDim2.new(1, -6, 0, 44)
	FlySpeedCard.BackgroundColor3 = Config.ContainerColor
	FlySpeedCard.BackgroundTransparency = 0.14
	FlySpeedCard.ZIndex = 4
	Instance.new("UICorner", FlySpeedCard).CornerRadius = UDim.new(0, 6)
	local fsStroke = Instance.new("UIStroke", FlySpeedCard)
	fsStroke.Thickness = 1
	fsStroke.Transparency = 0.72
	ApplyBlueWhiteGradient(fsStroke, 70)

	local FlySpeedTitle = Instance.new("TextLabel", FlySpeedCard)
	FlySpeedTitle.Size = UDim2.new(1, -135, 0, 14)
	FlySpeedTitle.Position = UDim2.fromOffset(10, 6)
	FlySpeedTitle.BackgroundTransparency = 1
	FlySpeedTitle.Text = "FLY SPEED"
	FlySpeedTitle.TextColor3 = Config.TextSecondary
	FlySpeedTitle.Font = Enum.Font.GothamBold
	FlySpeedTitle.TextSize = 8.5
	FlySpeedTitle.TextXAlignment = Enum.TextXAlignment.Left
	FlySpeedTitle.ZIndex = 5

	local FlySpeedValLbl = Instance.new("TextLabel", FlySpeedCard)
	FlySpeedValLbl.Size = UDim2.new(1, -135, 0, 16)
	FlySpeedValLbl.Position = UDim2.fromOffset(10, 21)
	FlySpeedValLbl.BackgroundTransparency = 1
	FlySpeedValLbl.Text = tostring(PlayerState.FlySpeed) .. " studs/s"
	FlySpeedValLbl.TextColor3 = Config.TextPrimary
	FlySpeedValLbl.Font = Enum.Font.GothamBold
	FlySpeedValLbl.TextSize = 11
	FlySpeedValLbl.TextXAlignment = Enum.TextXAlignment.Left
	FlySpeedValLbl.ZIndex = 5

	local flyDownBtn = Instance.new("TextButton", FlySpeedCard)
	flyDownBtn.Size = UDim2.fromOffset(26, 26)
	flyDownBtn.Position = UDim2.new(1, -94, 0.5, -13)
	flyDownBtn.BackgroundColor3 = Config.SidebarColor
	flyDownBtn.Text = "-"
	flyDownBtn.TextColor3 = Config.TextPrimary
	flyDownBtn.Font = Enum.Font.GothamBold
	flyDownBtn.TextSize = 13
	flyDownBtn.AutoButtonColor = false
	flyDownBtn.ZIndex = 6
	Instance.new("UICorner", flyDownBtn).CornerRadius = UDim.new(0, 6)

	local flyUpBtn = Instance.new("TextButton", FlySpeedCard)
	flyUpBtn.Size = UDim2.fromOffset(26, 26)
	flyUpBtn.Position = UDim2.new(1, -64, 0.5, -13)
	flyUpBtn.BackgroundColor3 = Config.ContainerActive
	flyUpBtn.Text = "+"
	flyUpBtn.TextColor3 = Config.TextPrimary
	flyUpBtn.Font = Enum.Font.GothamBold
	flyUpBtn.TextSize = 13
	flyUpBtn.AutoButtonColor = false
	flyUpBtn.ZIndex = 6
	Instance.new("UICorner", flyUpBtn).CornerRadius = UDim.new(0, 6)
	ApplyBlueWhiteGradient(flyUpBtn, 60)

	local flyResetBtn = Instance.new("TextButton", FlySpeedCard)
	flyResetBtn.Size = UDim2.fromOffset(28, 26)
	flyResetBtn.Position = UDim2.new(1, -34, 0.5, -13)
	flyResetBtn.BackgroundColor3 = Config.SidebarColor
	flyResetBtn.Text = "65"
	flyResetBtn.TextColor3 = Config.BlueGlow
	flyResetBtn.Font = Enum.Font.GothamBold
	flyResetBtn.TextSize = 9.5
	flyResetBtn.AutoButtonColor = false
	flyResetBtn.ZIndex = 6
	Instance.new("UICorner", flyResetBtn).CornerRadius = UDim.new(0, 6)

	local function RefreshFlySpeedLabel()
		FlySpeedValLbl.Text = tostring(PlayerState.FlySpeed) .. " studs/s"
	end

	flyDownBtn.MouseButton1Click:Connect(function()
		PlayerState.FlySpeed = math.max(20, PlayerState.FlySpeed - 10)
		RefreshFlySpeedLabel()
	end)
	flyUpBtn.MouseButton1Click:Connect(function()
		PlayerState.FlySpeed = math.min(220, PlayerState.FlySpeed + 10)
		RefreshFlySpeedLabel()
	end)
	flyResetBtn.MouseButton1Click:Connect(function()
		PlayerState.FlySpeed = 65
		RefreshFlySpeedLabel()
	end)

	RunService.Stepped:Connect(function()
		if not MainGui.Parent then return end
		local hum = GetHumanoid()
		if hum then
			if PlayerState.SpeedEnabled then
				pcall(function() hum.WalkSpeed = PlayerState.SpeedValue end)
			end
			if PlayerState.JumpEnabled then
				pcall(function()
					hum.UseJumpPower = true
					hum.JumpPower = PlayerState.JumpPowerValue
				end)
			end
		end

		if PlayerState.Noclip and LocalPlayer.Character then
			for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					if noclipOriginalState[part] == nil then
						noclipOriginalState[part] = part.CanCollide
					end
					part.CanCollide = false
				end
			end
		end
	end)

	RunService.RenderStepped:Connect(function()
		if not MainGui.Parent then return end
		if PlayerState.Fly then
			local root = GetRootPart()
			local hum = GetHumanoid()
			local cam = Workspace.CurrentCamera
			if root and cam and flyBV and flyBG then
				local moveVec = Vector3.zero
				if hum and hum.MoveDirection.Magnitude > 0 then
					local forward = cam.CFrame.LookVector
					local right = cam.CFrame.RightVector
					moveVec = (forward * hum.MoveDirection.Z + right * hum.MoveDirection.X)
					if moveVec.Magnitude > 0 then
						moveVec = moveVec.Unit
					end
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0, 1, 0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec -= Vector3.new(0, 1, 0) end

				if moveVec.Magnitude > 1 then moveVec = moveVec.Unit end
				flyBV.Velocity = moveVec * PlayerState.FlySpeed
				flyBG.CFrame = CFrame.lookAt(root.Position, root.Position + cam.CFrame.LookVector)
			end
		end
	end)

	local autoResetUISetter = nil
	LocalPlayer.CharacterAdded:Connect(function()
		table.clear(noclipOriginalState)
		if PlayerState.Fly then
			PlayerState.Fly = false
			StopFly()
			if setFlyToggleUI then setFlyToggleUI(false, true) end
		end
		if PlayerState.InfStamina then
			task.wait(1)
			if PlayerState.InfStamina then
				BindInfStamina(true)
			end
		end
		if autoResetUISetter and autoResetUISetter() then
			MainScale.Scale = 1.0
		end
	end)
	CreateSectionHeader(BallPage, "Ball Hitbox")

	local BallNames = { "Football", "SoccerBall", "Ball", "BLBall", "Soccer_Ball", "BLR_Ball" }
	local function FindBall()
		for _, n in ipairs(BallNames) do
			local b = Workspace:FindFirstChild(n)
			if b and b:IsA("BasePart") then return b end
		end
		for _, f in ipairs(Workspace:GetChildren()) do
			if f:IsA("BasePart") and string.find(string.lower(f.Name), "ball") then
				return f
			end
		end
		return nil
	end

	local HitboxState = {
		Enabled = false,
		Scale = 2.0,
		MinScale = 1.0,
		MaxScale = 6.0,
		Step = 0.5,
		Transparent = true,
		Ball = nil,
		OriginalSize = nil,
		Conn = nil
	}

	local function ApplyBallHitbox(ball)
		if not ball then return end
		if HitboxState.OriginalSize == nil then
			HitboxState.OriginalSize = ball.Size
		end

		pcall(function()
			ball.Size = HitboxState.OriginalSize * HitboxState.Scale
			if HitboxState.Transparent then
				ball.Transparency = 0.5
				ball.Material = Enum.Material.ForceField
				ball.Color = Color3.fromRGB(0, 255, 255)
			else
				ball.Transparency = 0
				ball.Material = Enum.Material.Plastic
				ball.Color = Color3.fromRGB(255, 255, 255)
			end
			ball.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5, 1, 1)
		end)
	end

	local function RestoreBallHitbox(ball)
		if ball and HitboxState.OriginalSize then
			pcall(function()
				ball.Size = HitboxState.OriginalSize
				ball.Transparency = 0
				ball.Material = Enum.Material.Plastic
				ball.Color = Color3.fromRGB(255, 255, 255)
			end)
		end
		HitboxState.OriginalSize = nil
	end

	local function SetHitboxEnabled(v)
		HitboxState.Enabled = v
		if HitboxState.Conn then
			task.cancel(HitboxState.Conn)
			HitboxState.Conn = nil
		end
		if v then
			local ball = FindBall()
			if not ball then return end
			HitboxState.Ball = ball
			ApplyBallHitbox(ball)

			HitboxState.Conn = task.spawn(function()
				while HitboxState.Enabled and MainGui.Parent do
					task.wait(1)
					local b = FindBall()
					if b and HitboxState.Enabled then
						HitboxState.Ball = b
						if HitboxState.OriginalSize and math.abs(b.Size.X - (HitboxState.OriginalSize.X * HitboxState.Scale)) > 0.1 then
							ApplyBallHitbox(b)
						end
					end
				end
			end)
		else
			if HitboxState.Ball then
				RestoreBallHitbox(HitboxState.Ball)
				HitboxState.Ball = nil
			end
		end
	end

	CreateToggle(BallPage, "Ball Hitbox (Transparent)", false, function(v)
		SetHitboxEnabled(v)
	end)

	CreateStepper(BallPage, "Size Scale", string.format("%.1fx", HitboxState.Scale), function()
		HitboxState.Scale = math.max(HitboxState.MinScale, HitboxState.Scale - HitboxState.Step)
		if HitboxState.Enabled and HitboxState.Ball then ApplyBallHitbox(HitboxState.Ball) end
		return string.format("%.1fx", HitboxState.Scale)
	end, function()
		HitboxState.Scale = math.min(HitboxState.MaxScale, HitboxState.Scale + HitboxState.Step)
		if HitboxState.Enabled and HitboxState.Ball then ApplyBallHitbox(HitboxState.Ball) end
		return string.format("%.1fx", HitboxState.Scale)
	end)

	CreateToggle(BallPage, "Transparent Neon Visual", true, function(v)
		HitboxState.Transparent = v
		if HitboxState.Enabled and HitboxState.Ball then ApplyBallHitbox(HitboxState.Ball) end
	end)

	CreateButton(BallPage, "Reset Ball Size", function()
		local b = HitboxState.Ball or FindBall()
		RestoreBallHitbox(b)
	end)

	CreateSectionHeader(BallPage, "Ball Control")

	local ControlState = {
		Enabled = false,
		Speed = 200,
		MinS = 50,
		MaxS = 600,
		Step = 25,
		Freeze = false,
		Key = Enum.KeyCode.L,
		Ball = nil,
		BV = nil,
		BG = nil,
		Conn = nil
	}

	local function AttachBallControl(ball)
		for _, c in ipairs(ball:GetChildren()) do
			if c:IsA("BodyVelocity") or c:IsA("BodyGyro") or c:IsA("LinearVelocity") or c:IsA("AlignOrientation") then
				c:Destroy()
			end
		end
		local bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		bv.Velocity = Vector3.zero
		bv.Parent = ball

		local bg = Instance.new("BodyGyro")
		bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
		bg.P = 100000
		bg.Parent = ball
		return bv, bg
	end

	local function DetachBallControl()
		if ControlState.Conn then ControlState.Conn:Disconnect() ControlState.Conn = nil end
		if ControlState.BV then ControlState.BV:Destroy() ControlState.BV = nil end
		if ControlState.BG then ControlState.BG:Destroy() ControlState.BG = nil end
		if ControlState.Ball then
			pcall(function() ControlState.Ball:SetNetworkOwnershipAuto() end)
			ControlState.Ball = nil
		end
		local hum = GetHumanoid()
		if hum and Workspace.CurrentCamera then
			Workspace.CurrentCamera.CameraSubject = hum
		end
	end

	local function SetBallControlEnabled(v)
		ControlState.Enabled = v
		if v then
			local ball = FindBall()
			if not ball then
				ControlState.Enabled = false
				return
			end
			ControlState.Ball = ball
			pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
			ControlState.BV, ControlState.BG = AttachBallControl(ball)
			if Workspace.CurrentCamera then
				Workspace.CurrentCamera.CameraSubject = ball
			end
			ControlState.Conn = RunService.RenderStepped:Connect(function()
				if not ControlState.Enabled then return end
				local b = ControlState.Ball
				if not b or not b.Parent then
					b = FindBall()
					ControlState.Ball = b
					if not b then return end
					if ControlState.BV and ControlState.BV.Parent ~= b then ControlState.BV.Parent = b end
					if ControlState.BG and ControlState.BG.Parent ~= b then ControlState.BG.Parent = b end
				end
				local cam = Workspace.CurrentCamera
				if not cam or not ControlState.BV or not ControlState.BG then return end
				local look = cam.CFrame.LookVector
				ControlState.BV.Velocity = ControlState.Freeze and Vector3.zero or (look * ControlState.Speed)
				ControlState.BG.CFrame = CFrame.lookAt(b.Position, b.Position + look)
			end)
		else
			DetachBallControl()
		end
	end

	local _, setControlToggleUI = CreateToggle(BallPage, "Ball Control [Key: L]", false, function(v)
		SetBallControlEnabled(v)
	end)

	CreateStepper(BallPage, "Control Speed", tostring(ControlState.Speed), function()
		ControlState.Speed = math.max(ControlState.MinS, ControlState.Speed - ControlState.Step)
		return tostring(ControlState.Speed)
	end, function()
		ControlState.Speed = math.min(ControlState.MaxS, ControlState.Speed + ControlState.Step)
		return tostring(ControlState.Speed)
	end)

	CreateToggle(BallPage, "Freeze Ball", false, function(v)
		ControlState.Freeze = v
	end)

	local MiniControlWindow = Instance.new("Frame", MainGui)
	MiniControlWindow.Name = "RivalsBallControlMini"
	MiniControlWindow.Size = UDim2.fromOffset(186, 114)
	MiniControlWindow.Position = UDim2.new(0, 18, 0.5, -57)
	MiniControlWindow.BackgroundColor3 = Config.BgColor
	MiniControlWindow.BackgroundTransparency = 0.06
	MiniControlWindow.BorderSizePixel = 0
	MiniControlWindow.Visible = false
	MiniControlWindow.ZIndex = 80
	Instance.new("UICorner", MiniControlWindow).CornerRadius = UDim.new(0, 8)
	local miniStroke = Instance.new("UIStroke", MiniControlWindow)
	miniStroke.Thickness = 1.4
	miniStroke.Transparency = 0.25
	ApplyBlueWhiteGradient(miniStroke, 60)
	MakeDraggable(MiniControlWindow)

	local miniHeader = Instance.new("TextLabel", MiniControlWindow)
	miniHeader.Size = UDim2.new(1, -50, 0, 24)
	miniHeader.Position = UDim2.fromOffset(8, 0)
	miniHeader.BackgroundTransparency = 1
	miniHeader.Text = "Ball Control"
	miniHeader.TextColor3 = Config.TextPrimary
	miniHeader.Font = Enum.Font.GothamBold
	miniHeader.TextSize = 10.5
	miniHeader.TextXAlignment = Enum.TextXAlignment.Left
	miniHeader.ZIndex = 81
	ApplyBlueWhiteGradient(miniHeader, 50)

	local miniCollapseBtn = Instance.new("TextButton", MiniControlWindow)
	miniCollapseBtn.Size = UDim2.fromOffset(20, 20)
	miniCollapseBtn.Position = UDim2.new(1, -44, 0, 2)
	miniCollapseBtn.BackgroundTransparency = 1
	miniCollapseBtn.Text = "-"
	miniCollapseBtn.TextColor3 = Config.TextSecondary
	miniCollapseBtn.Font = Enum.Font.GothamBold
	miniCollapseBtn.TextSize = 16
	miniCollapseBtn.ZIndex = 82

	local miniClose = Instance.new("TextButton", MiniControlWindow)
	miniClose.Size = UDim2.fromOffset(20, 20)
	miniClose.Position = UDim2.new(1, -24, 0, 2)
	miniClose.BackgroundTransparency = 1
	miniClose.Text = "×"
	miniClose.TextColor3 = Config.CloseRed
	miniClose.Font = Enum.Font.GothamBold
	miniClose.TextSize = 15
	miniClose.ZIndex = 82
	miniClose.MouseButton1Click:Connect(function()
		MiniControlWindow.Visible = false
	end)

	local miniBody = Instance.new("Frame", MiniControlWindow)
	miniBody.Name = "MiniBody"
	miniBody.Size = UDim2.new(1, 0, 1, -24)
	miniBody.Position = UDim2.fromOffset(0, 24)
	miniBody.BackgroundTransparency = 1
	miniBody.ZIndex = 81

	local miniCollapsed = false
	miniCollapseBtn.MouseButton1Click:Connect(function()
		miniCollapsed = not miniCollapsed
		miniBody.Visible = not miniCollapsed
		miniCollapseBtn.Text = miniCollapsed and "+" or "-"
		MiniControlWindow.Size = miniCollapsed and UDim2.fromOffset(186, 26) or UDim2.fromOffset(186, 114)
	end)

	local miniToggleBtn = Instance.new("TextButton", miniBody)
	miniToggleBtn.Size = UDim2.new(1, -16, 0, 24)
	miniToggleBtn.Position = UDim2.fromOffset(8, 2)
	miniToggleBtn.BackgroundColor3 = Config.ContainerColor
	miniToggleBtn.Text = "OFF"
	miniToggleBtn.TextColor3 = Config.TextPrimary
	miniToggleBtn.Font = Enum.Font.GothamBold
	miniToggleBtn.TextSize = 10
	miniToggleBtn.ZIndex = 82
	Instance.new("UICorner", miniToggleBtn).CornerRadius = UDim.new(0, 6)

	local miniSpeedLbl = Instance.new("TextLabel", miniBody)
	miniSpeedLbl.Size = UDim2.new(1, -66, 0, 24)
	miniSpeedLbl.Position = UDim2.fromOffset(8, 32)
	miniSpeedLbl.BackgroundTransparency = 1
	miniSpeedLbl.Text = "Spd: " .. tostring(ControlState.Speed)
	miniSpeedLbl.TextColor3 = Config.TextSecondary
	miniSpeedLbl.Font = Enum.Font.GothamBold
	miniSpeedLbl.TextSize = 9.5
	miniSpeedLbl.TextXAlignment = Enum.TextXAlignment.Left
	miniSpeedLbl.ZIndex = 82

	local miniMinus = Instance.new("TextButton", miniBody)
	miniMinus.Size = UDim2.fromOffset(22, 22)
	miniMinus.Position = UDim2.new(1, -54, 0, 33)
	miniMinus.BackgroundColor3 = Config.SidebarColor
	miniMinus.Text = "-"
	miniMinus.TextColor3 = Config.TextPrimary
	miniMinus.Font = Enum.Font.GothamBold
	miniMinus.TextSize = 11
	miniMinus.ZIndex = 82
	Instance.new("UICorner", miniMinus).CornerRadius = UDim.new(0, 5)

	local miniPlus = Instance.new("TextButton", miniBody)
	miniPlus.Size = UDim2.fromOffset(22, 22)
	miniPlus.Position = UDim2.new(1, -28, 0, 33)
	miniPlus.BackgroundColor3 = Config.ContainerActive
	miniPlus.Text = "+"
	miniPlus.TextColor3 = Config.TextPrimary
	miniPlus.Font = Enum.Font.GothamBold
	miniPlus.TextSize = 11
	miniPlus.ZIndex = 82
	Instance.new("UICorner", miniPlus).CornerRadius = UDim.new(0, 5)

	local function SyncControlUI()
		miniToggleBtn.Text = ControlState.Enabled and "ON" or "OFF"
		miniToggleBtn.BackgroundColor3 = ControlState.Enabled and Color3.fromRGB(65, 155, 255) or Config.ContainerColor
		miniSpeedLbl.Text = "Spd: " .. tostring(ControlState.Speed)
		if setControlToggleUI then setControlToggleUI(ControlState.Enabled, true) end
	end

	miniToggleBtn.MouseButton1Click:Connect(function()
		SetBallControlEnabled(not ControlState.Enabled)
		SyncControlUI()
	end)
	miniMinus.MouseButton1Click:Connect(function()
		ControlState.Speed = math.max(ControlState.MinS, ControlState.Speed - ControlState.Step)
		SyncControlUI()
	end)
	miniPlus.MouseButton1Click:Connect(function()
		ControlState.Speed = math.min(ControlState.MaxS, ControlState.Speed + ControlState.Step)
		SyncControlUI()
	end)

	CreateButton(BallPage, "Toggle Mini Ball Control Window", function()
		MiniControlWindow.Visible = not MiniControlWindow.Visible
	end)

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == ControlState.Key then
			SetBallControlEnabled(not ControlState.Enabled)
			SyncControlUI()
		end
	end)
	CreateSectionHeader(VisualPage, "ESP & Visuals")

	local VisualState = {
		PlayerESP = false,
		TeamESP = false,
		BallESP = false,
		BallDistanceESP = false
	}

	local PlayerHighlights = {}
	local BallHighlight = nil
	local BallDistanceGui = nil
	local BallDistanceLbl = nil

	local function ClearPlayerHighlight(plr)
		local hl = PlayerHighlights[plr]
		if hl then
			pcall(function() hl:Destroy() end)
			PlayerHighlights[plr] = nil
		end
	end

	local function RefreshPlayerHighlights()
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local isTeammate = (LocalPlayer.Team ~= nil and plr.Team == LocalPlayer.Team)
				local shouldShow = (VisualState.PlayerESP and not isTeammate) or (VisualState.TeamESP and isTeammate)
				local char = plr.Character

				if shouldShow and char then
					local hl = PlayerHighlights[plr]
					if not hl or not hl.Parent then
						hl = Instance.new("Highlight")
						hl.Name = "RivalsGlowESP"
						hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						hl.FillTransparency = 0.55
						hl.OutlineTransparency = 0
						hl.FillColor = Color3.fromRGB(95, 175, 255)
						hl.OutlineColor = Color3.fromRGB(255, 255, 255)
						hl.Adornee = char
						hl.Parent = CoreGui
						PlayerHighlights[plr] = hl
					else
						hl.Adornee = char
					end
				else
					ClearPlayerHighlight(plr)
				end
			end
		end
	end

	local function RefreshBallVisuals()
		local ball = FindBall()

		if VisualState.BallESP and ball then
			if not BallHighlight or not BallHighlight.Parent then
				BallHighlight = Instance.new("Highlight")
				BallHighlight.Name = "RivalsBallESP"
				BallHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				BallHighlight.FillTransparency = 0.45
				BallHighlight.OutlineTransparency = 0
				BallHighlight.Parent = CoreGui
			end
			BallHighlight.Adornee = ball
		elseif BallHighlight then
			pcall(function() BallHighlight:Destroy() end)
			BallHighlight = nil
		end

		if VisualState.BallDistanceESP and ball then
			if not BallDistanceGui or not BallDistanceGui.Parent then
				BallDistanceGui = Instance.new("BillboardGui")
				BallDistanceGui.Name = "RivalsBallDistanceESP"
				BallDistanceGui.Size = UDim2.fromOffset(110, 24)
				BallDistanceGui.StudsOffset = Vector3.new(0, 2.5, 0)
				BallDistanceGui.AlwaysOnTop = true
				BallDistanceGui.Parent = CoreGui

				BallDistanceLbl = Instance.new("TextLabel", BallDistanceGui)
				BallDistanceLbl.Size = UDim2.fromScale(1, 1)
				BallDistanceLbl.BackgroundColor3 = Config.BgColor
				BallDistanceLbl.BackgroundTransparency = 0.25
				BallDistanceLbl.TextColor3 = Config.TextPrimary
				BallDistanceLbl.Font = Enum.Font.GothamBold
				BallDistanceLbl.TextSize = 10
				Instance.new("UICorner", BallDistanceLbl).CornerRadius = UDim.new(0, 6)
				local dStroke = Instance.new("UIStroke", BallDistanceLbl)
				dStroke.Thickness = 1
				dStroke.Transparency = 0.3
				ApplyBlueWhiteGradient(dStroke, 65)
			end
			BallDistanceGui.Adornee = ball
			local root = GetRootPart()
			if root and BallDistanceLbl then
				local dist = math.floor((root.Position - ball.Position).Magnitude)
				BallDistanceLbl.Text = "Ball • " .. tostring(dist) .. "m"
			end
		elseif BallDistanceGui then
			pcall(function() BallDistanceGui:Destroy() end)
			BallDistanceGui = nil
			BallDistanceLbl = nil
		end
	end

	CreateToggle(VisualPage, "Player ESP (Blue-White Glow)", false, function(v)
		VisualState.PlayerESP = v
		RefreshPlayerHighlights()
	end)

	CreateToggle(VisualPage, "Team ESP (Blue-White Glow)", false, function(v)
		VisualState.TeamESP = v
		RefreshPlayerHighlights()
	end)

	CreateToggle(VisualPage, "Ball ESP", false, function(v)
		VisualState.BallESP = v
		RefreshBallVisuals()
	end)

	CreateToggle(VisualPage, "Ball Distance ESP", false, function(v)
		VisualState.BallDistanceESP = v
		RefreshBallVisuals()
	end)

	Players.PlayerRemoving:Connect(function(plr)
		ClearPlayerHighlight(plr)
	end)

	local lastEspTick = 0
	RunService.RenderStepped:Connect(function()
		if not MainGui.Parent then return end
		local now = os.clock()
		if now - lastEspTick >= 0.15 then
			lastEspTick = now
			if VisualState.PlayerESP or VisualState.TeamESP then
				RefreshPlayerHighlights()
			end
			if VisualState.BallESP or VisualState.BallDistanceESP then
				RefreshBallVisuals()
			end
		end
	end)

	CreateSectionHeader(SettingsPage, "UI size")

	local sizeButtons = {}
	local function SetUISizeChoice(choiceName, scaleVal)
		TweenService:Create(MainScale, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Scale = scaleVal
		}):Play()
		for name, btn in pairs(sizeButtons) do
			if name == choiceName then
				btn.BackgroundColor3 = Config.ContainerActive
				btn.TextColor3 = Config.TextPrimary
			else
				btn.BackgroundColor3 = Config.ContainerColor
				btn.TextColor3 = Config.TextSecondary
			end
		end
	end

	local SizeRow = Instance.new("Frame", SettingsPage)
	SizeRow.Name = "UISizeSelectorRow"
	SizeRow.Size = UDim2.new(1, -6, 0, 34)
	SizeRow.BackgroundColor3 = Config.ContainerColor
	SizeRow.BackgroundTransparency = 0.15
	SizeRow.ZIndex = 4
	Instance.new("UICorner", SizeRow).CornerRadius = UDim.new(0, 6)
	local szStroke = Instance.new("UIStroke", SizeRow)
	szStroke.Thickness = 1
	szStroke.Transparency = 0.72
	ApplyBlueWhiteGradient(szStroke, 75)

	local function MakeSizeChoiceBtn(label, xOffset, widthOffset, scaleVal)
		local b = Instance.new("TextButton", SizeRow)
		b.Size = UDim2.new(0.333, widthOffset, 0, 24)
		b.Position = UDim2.new(0, xOffset, 0.5, -12)
		b.BackgroundColor3 = Config.ContainerColor
		b.Text = "[" .. label .. "]"
		b.TextColor3 = Config.TextSecondary
		b.Font = Enum.Font.GothamBold
		b.TextSize = 10
		b.AutoButtonColor = false
		b.ZIndex = 5
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
		b.MouseButton1Click:Connect(function()
			SetUISizeChoice(label, scaleVal)
		end)
		sizeButtons[label] = b
		return b
	end

	MakeSizeChoiceBtn("Small", 4, -6, 0.82)
	MakeSizeChoiceBtn("Middle", 118, -8, 1.0)
	MakeSizeChoiceBtn("Big", 232, -10, 1.18)
	SetUISizeChoice("Middle", 1.0)

	CreateSectionHeader(SettingsPage, "Hub & Session Options")

	local antiAfkEnabled = false
	LocalPlayer.Idled:Connect(function()
		if antiAfkEnabled then
			pcall(function()
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end)
		end
	end)

	local _, setAntiAfkUI = CreateToggle(SettingsPage, "Anti-AFK Protection", false, function(v)
		antiAfkEnabled = v
	end)

	local _, setDotsUI = CreateToggle(SettingsPage, "Falling Particles Background", true, function(v)
		SparkleHolder.Visible = v
	end)

	local autoResetSizeOnSpawn = true
	autoResetUISetter = function()
		return autoResetSizeOnSpawn
	end

	local _, setAutoResetUI = CreateToggle(SettingsPage, "Auto Reset Size on Respawn", true, function(v)
		autoResetSizeOnSpawn = v
	end)

	CreateButton(SettingsPage, "Reset UI Size to [Middle]", function()
		SetUISizeChoice("Middle", 1.0)
	end)

	CreateButton(SettingsPage, "Reset All Hub Settings", function()
		SetUISizeChoice("Middle", 1.0)
		setAntiAfkUI(false, false)
		setDotsUI(true, false)
		setAutoResetUI(true, false)
	end)

	local startClock = os.clock()
	local fpsCounter, fpsTick = 0, os.clock()
	local currentFps = 60

	RunService.RenderStepped:Connect(function()
		fpsCounter += 1
		local now = os.clock()
		if now - fpsTick >= 1 then
			currentFps = fpsCounter
			fpsCounter = 0
			fpsTick = now
		end
	end)

	task.spawn(function()
		while MainGui.Parent do
			task.wait(1)
			local allPlrs = Players:GetPlayers()
			local friendCount = 0
			for _, p in ipairs(allPlrs) do
				if p ~= LocalPlayer then
					local ok, isFriend = pcall(function() return LocalPlayer:IsFriendsWith(p.UserId) end)
					if ok and isFriend then friendCount += 1 end
				end
			end

			local ping = 0
			pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)

			local elapsed = math.floor(os.clock() - startClock)
			local mins = math.floor(elapsed / 60)
			local secs = elapsed % 60

			PlayersVal.Text = tostring(#allPlrs) .. " / " .. tostring(Players.MaxPlayers)
			FriendsVal.Text = tostring(friendCount)
			PingVal.Text = tostring(ping) .. " ms | " .. tostring(currentFps) .. " FPS"
			TimeVal.Text = string.format("%02d:%02d", mins, secs)
			MatchInfoLbl.Text = "Match / Team: " .. (LocalPlayer.Team and LocalPlayer.Team.Name or "Lobby / None") .. "  •  PlaceId: " .. tostring(game.PlaceId)
		end
	end)

	task.spawn(function()
		local spinActive = true
		task.spawn(function()
			while spinActive and ToastRBox.Parent do
				local t = TweenService:Create(ToastRBox, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
					Rotation = ToastRBox.Rotation + 360
				})
				t:Play()
				t.Completed:Wait()
			end
		end)

		TweenService:Create(BottomRightToast, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(1, -16, 1, -18)
		}):Play()

		TweenService:Create(ToastProgressFill, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.35, 0, 1, 0)
		}):Play()
		task.wait(0.45)

		ToastSub.Text = "Detecting game info..."
		local gameInfo = FetchGameInfo()
		GameNameLbl.Text = "GAME  •  " .. gameInfo.Name
		GameThumb.Image = gameInfo.Thumbnail

		TweenService:Create(ToastProgressFill, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.7, 0, 1, 0)
		}):Play()
		task.wait(0.45)

		ToastSub.Text = "Detecting executor..."
		local execName = DetectExecutor()
		ExecutorLbl.Text = "EXECUTOR  •  " .. execName

		TweenService:Create(ToastProgressFill, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 1, 0)
		}):Play()
		ToastSub.Text = "Ready! Opening Rivals Hub..."
		task.wait(0.65)

		spinActive = false
		local hideToast = TweenService:Create(BottomRightToast, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 270, 1, -18)
		})
		hideToast:Play()
		hideToast.Completed:Wait()
		if BottomRightToast and BottomRightToast.Parent then BottomRightToast:Destroy() end

		MainFrame.Visible = true
		MainScale.Scale = 0.84
		TweenService:Create(MainScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Scale = 1.0
		}):Play()
	end)

	MinimizeBtn.MouseButton1Click:Connect(function()
		local shrink = TweenService:Create(MainScale, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Scale = 0.88})
		shrink:Play()
		shrink.Completed:Connect(function()
			MainFrame.Visible = false
			TopPill.Visible = true
		end)
	end)

	TopPill.MouseButton1Click:Connect(function()
		MainFrame.Visible = true
		TopPill.Visible = false
		MainScale.Scale = 0.88
		TweenService:Create(MainScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.0}):Play()
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		BindInfStamina(false)
		SetHitboxEnabled(false)
		DetachBallControl()
		StopFly()
		local closeAnim = TweenService:Create(MainScale, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Scale = 0.8})
		closeAnim:Play()
		closeAnim.Completed:Connect(function() MainGui:Destroy() end)
	end)

	MakeDraggable(MainFrame)
	MakeDraggable(TopPill)
end

BuildRivalsHub()
