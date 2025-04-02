local GUI = {}

-- Helper function to apply properties
local function applyProps(instance, props)
	if not props then return end
	for prop, value in pairs(props) do
		pcall(function()
			instance[prop] = value
		end)
	end
end

-- Base creator
local function createInstance(className, name, parent, props)
	local instance = Instance.new(className)
	instance.Name = name or (className .. "_" .. tostring(math.random(1, 10000)))
	instance.Parent = parent
	applyProps(instance, props)
	return instance
end

-- GUI Containers
function GUI.CreateScreenGUI(plr, props)
	local ScreenGUI = createInstance("ScreenGui", "Bearium_GUI_" .. tostring(math.random(1, 10000)), plr, props)
	ScreenGUI:SetAttribute("Bearium", true)
	return ScreenGUI
end

function GUI.CreateBillboardGui(name, parent, props)
	return createInstance("BillboardGui", name, parent, props)
end

function GUI.CreateSurfaceGui(name, parent, props)
	return createInstance("SurfaceGui", name, parent, props)
end

-- Visual Elements
function GUI.CreateFrame(name, parent, props)
	return createInstance("Frame", name, parent, props)
end

function GUI.CreateTextLabel(name, parent, props)
	return createInstance("TextLabel", name, parent, props)
end

function GUI.CreateTextButton(name, parent, props)
	return createInstance("TextButton", name, parent, props)
end

function GUI.CreateImageLabel(name, parent, props)
	return createInstance("ImageLabel", name, parent, props)
end

function GUI.CreateImageButton(name, parent, props)
	return createInstance("ImageButton", name, parent, props)
end

function GUI.CreateTextBox(name, parent, props)
	return createInstance("TextBox", name, parent, props)
end

function GUI.CreateScrollingFrame(name, parent, props)
	return createInstance("ScrollingFrame", name, parent, props)
end

function GUI.CreateViewportFrame(name, parent, props)
	return createInstance("ViewportFrame", name, parent, props)
end

-- Layout & Constraints
function GUI.CreateUIListLayout(name, parent, props)
	return createInstance("UIListLayout", name, parent, props)
end

function GUI.CreateUIGridLayout(name, parent, props)
	return createInstance("UIGridLayout", name, parent, props)
end

function GUI.CreateUIPageLayout(name, parent, props)
	return createInstance("UIPageLayout", name, parent, props)
end

function GUI.CreateUIAspectRatioConstraint(name, parent, props)
	return createInstance("UIAspectRatioConstraint", name, parent, props)
end

function GUI.CreateUISizeConstraint(name, parent, props)
	return createInstance("UISizeConstraint", name, parent, props)
end

function GUI.CreateUICorner(name, parent, props)
	return createInstance("UICorner", name, parent, props)
end

function GUI.CreateUIStroke(name, parent, props)
	return createInstance("UIStroke", name, parent, props)
end

function GUI.CreateUIPadding(name, parent, props)
	return createInstance("UIPadding", name, parent, props)
end

return GUI