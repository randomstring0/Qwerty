--[=[
 d888b  db    db d888888b      .d888b.      db      db    db  .d8b.  
88' Y8b 88    88   `88'        VP  `8D      88      88    88 d8' `8b 
88      88    88    88            odD'      88      88    88 88ooo88 
88  ooo 88    88    88          .88'        88      88    88 88~~~88 
88. ~8~ 88b  d88   .88.        j88.         88booo. 88b  d88 88   88    @uniquadev
 Y888P  ~Y8888P' Y888888P      888888D      Y88888P ~Y8888P' YP   YP  CONVERTER 

designed using localmaze gui creator
]=]

local CollectionService = game:GetService("CollectionService");
local G2L = {};

G2L["ScreenGui_1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
G2L["ScreenGui_1"]["IgnoreGuiInset"] = true;
G2L["ScreenGui_1"]["Enabled"] = false;
G2L["ScreenGui_1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
G2L["ScreenGui_1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;

CollectionService:AddTag(G2L["ScreenGui_1"], [[main]]);

G2L["main_2"] = Instance.new("Frame", G2L["ScreenGui_1"]);
G2L["main_2"]["BorderSizePixel"] = 0;
G2L["main_2"]["BackgroundColor3"] = Color3.fromRGB(197, 197, 197);
G2L["main_2"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["main_2"]["Size"] = UDim2.new(0.46053, 0, 0.6705, 0);
G2L["main_2"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
G2L["main_2"]["Name"] = [[main]];
G2L["main_2"]["BackgroundTransparency"] = 0.65;

G2L["UIDRAG"] = Instance.new("UIDragDetector", G2L["main_2"]);

G2L["UICorner_3"] = Instance.new("UICorner", G2L["main_2"]);
G2L["UICorner_3"]["CornerRadius"] = UDim.new(0.05, 0);


G2L["Frame_4"] = Instance.new("Frame", G2L["main_2"]);
G2L["Frame_4"]["BorderSizePixel"] = 0;
G2L["Frame_4"]["BackgroundColor3"] = Color3.fromRGB(197, 197, 197);
G2L["Frame_4"]["Size"] = UDim2.new(0.94857, 0, 0.928, 0);
G2L["Frame_4"]["Position"] = UDim2.new(0.02857, 0, 0.04143, 0);
G2L["Frame_4"]["BackgroundTransparency"] = 0.5;


G2L["tab_5"] = Instance.new("Frame", G2L["Frame_4"]);
G2L["tab_5"]["BorderSizePixel"] = 0;
G2L["tab_5"]["BackgroundColor3"] = Color3.fromRGB(169, 169, 169);
G2L["tab_5"]["Size"] = UDim2.new(0.14458, 0, 0.75, 0);
G2L["tab_5"]["Position"] = UDim2.new(0.03614, 0, 0.1875, 0);
G2L["tab_5"]["Name"] = [[tab]];
G2L["tab_5"]["BackgroundTransparency"] = 0.3;


G2L["UICorner_6"] = Instance.new("UICorner", G2L["tab_5"]);
G2L["UICorner_6"]["CornerRadius"] = UDim.new(0.1, 0);


G2L["UICorner_7"] = Instance.new("UICorner", G2L["Frame_4"]);
G2L["UICorner_7"]["CornerRadius"] = UDim.new(0.05, 0);


G2L["page_8"] = Instance.new("Frame", G2L["Frame_4"]);
G2L["page_8"]["BorderSizePixel"] = 0;
G2L["page_8"]["BackgroundColor3"] = Color3.fromRGB(169, 169, 169);
G2L["page_8"]["Size"] = UDim2.new(0.76506, 0, 0.75, 0);
G2L["page_8"]["Position"] = UDim2.new(0.20482, 0, 0.1875, 0);
G2L["page_8"]["Name"] = [[page]];
G2L["page_8"]["BackgroundTransparency"] = 0.3;


G2L["UICorner_9"] = Instance.new("UICorner", G2L["page_8"]);
G2L["UICorner_9"]["CornerRadius"] = UDim.new(0.05, 0);


G2L["ScrollingFrame_a"] = Instance.new("ScrollingFrame", G2L["page_8"]);
G2L["ScrollingFrame_a"]["ScrollingDirection"] = Enum.ScrollingDirection.Y;
G2L["ScrollingFrame_a"]["BorderSizePixel"] = 0;
G2L["ScrollingFrame_a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["ScrollingFrame_a"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["ScrollingFrame_a"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["ScrollingFrame_a"]["Position"] = UDim2.new(0.01575, 0, 0.02381, 0);
G2L["ScrollingFrame_a"]["ScrollBarThickness"] = 0;
G2L["ScrollingFrame_a"]["BackgroundTransparency"] = 1;


G2L["UIListLayout_b"] = Instance.new("UIListLayout", G2L["ScrollingFrame_a"]);
G2L["UIListLayout_b"]["Padding"] = UDim.new(0.03, 0);


G2L["bar_c"] = Instance.new("Frame", G2L["Frame_4"]);
G2L["bar_c"]["BorderSizePixel"] = 0;
G2L["bar_c"]["BackgroundColor3"] = Color3.fromRGB(169, 169, 169);
G2L["bar_c"]["Size"] = UDim2.new(0.93976, 0, 0.11607, 0);
G2L["bar_c"]["Position"] = UDim2.new(0.03614, 0, 0.03571, 0);
G2L["bar_c"]["Name"] = [[bar]];
G2L["bar_c"]["BackgroundTransparency"] = 0.3;


G2L["close_d"] = Instance.new("TextButton", G2L["bar_c"]);
G2L["close_d"]["TextWrapped"] = true;
G2L["close_d"]["BorderSizePixel"] = 0;
G2L["close_d"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
G2L["close_d"]["TextScaled"] = true;
G2L["close_d"]["TextColor3"] = Color3.fromRGB(255, 0, 0);
G2L["close_d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["close_d"]["BackgroundTransparency"] = 1;
G2L["close_d"]["Size"] = UDim2.new(0.09615, 0, 1.15385, 0);
G2L["close_d"]["Text"] = [[x]];
G2L["close_d"]["Name"] = [[close]];
G2L["close_d"]["Position"] = UDim2.new(0.90385, 0, -0.07692, 0);


G2L["UICorner_e"] = Instance.new("UICorner", G2L["bar_c"]);
G2L["UICorner_e"]["CornerRadius"] = UDim.new(0.2, 0);


G2L["title _f"] = Instance.new("TextLabel", G2L["bar_c"]);
G2L["title _f"]["TextWrapped"] = true;
G2L["title _f"]["BorderSizePixel"] = 0;
G2L["title _f"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["title _f"]["TextScaled"] = true;
G2L["title _f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["title _f"]["FontFace"] = Font.new([[rbxasset://fonts/families/FredokaOne.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["title _f"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["title _f"]["BackgroundTransparency"] = 1;
G2L["title _f"]["Size"] = UDim2.new(0.54487, 0, 0.69231, 0);
G2L["title _f"]["Text"] = [[example]];
G2L["title _f"]["AutomaticSize"] = Enum.AutomaticSize.X;
G2L["title _f"]["Name"] = [[title]];
G2L["title _f"]["Position"] = UDim2.new(0.01923, 0, 0.07692, 0);


G2L["UIAspectRatioConstraint_10"] = Instance.new("UIAspectRatioConstraint", G2L["main_2"]);
G2L["UIAspectRatioConstraint_10"]["AspectRatio"] = 1.45;


G2L["LocalScript_11"] = Instance.new("LocalScript", G2L["ScreenGui_1"]);



G2L["element_12"] = Instance.new("Folder", G2L["ScreenGui_1"]);
G2L["element_12"]["Name"] = [[element]];


G2L["buttonsample_13"] = Instance.new("Frame", G2L["element_12"]);
G2L["buttonsample_13"]["Visible"] = false;
G2L["buttonsample_13"]["BorderSizePixel"] = 0;
G2L["buttonsample_13"]["BackgroundColor3"] = Color3.fromRGB(210, 210, 210);
G2L["buttonsample_13"]["Size"] = UDim2.new(1, 0, 0.18889, 0);
G2L["buttonsample_13"]["Name"] = [[buttonsample]];
G2L["buttonsample_13"]["BackgroundTransparency"] = 0.2;


G2L["UICorner_14"] = Instance.new("UICorner", G2L["buttonsample_13"]);
G2L["UICorner_14"]["CornerRadius"] = UDim.new(0.1, 0);


G2L["TextButton_15"] = Instance.new("TextButton", G2L["buttonsample_13"]);
G2L["TextButton_15"]["TextWrapped"] = true;
G2L["TextButton_15"]["BorderSizePixel"] = 0;
G2L["TextButton_15"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["TextButton_15"]["TextScaled"] = true;
G2L["TextButton_15"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["TextButton_15"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["TextButton_15"]["FontFace"] = Font.new([[rbxasset://fonts/families/FredokaOne.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["TextButton_15"]["BackgroundTransparency"] = 1;
G2L["TextButton_15"]["Size"] = UDim2.new(0.41842, 0, 0.75, 0);
G2L["TextButton_15"]["Text"] = [[Button sample]];
G2L["TextButton_15"]["Position"] = UDim2.new(0.00526, 0, 0.125, 0);


G2L["togglesample_16"] = Instance.new("Frame", G2L["element_12"]);
G2L["togglesample_16"]["Visible"] = false;
G2L["togglesample_16"]["BorderSizePixel"] = 0;
G2L["togglesample_16"]["BackgroundColor3"] = Color3.fromRGB(210, 210, 210);
G2L["togglesample_16"]["Size"] = UDim2.new(1, 0, 0.18889, 0);
G2L["togglesample_16"]["Name"] = [[togglesample]];
G2L["togglesample_16"]["BackgroundTransparency"] = 0.2;


G2L["UICorner_17"] = Instance.new("UICorner", G2L["togglesample_16"]);
G2L["UICorner_17"]["CornerRadius"] = UDim.new(0.1, 0);


G2L["TextButton_18"] = Instance.new("TextButton", G2L["togglesample_16"]);
G2L["TextButton_18"]["TextWrapped"] = true;
G2L["TextButton_18"]["BorderSizePixel"] = 0;
G2L["TextButton_18"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["TextButton_18"]["TextScaled"] = true;
G2L["TextButton_18"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["TextButton_18"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["TextButton_18"]["FontFace"] = Font.new([[rbxasset://fonts/families/FredokaOne.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["TextButton_18"]["BackgroundTransparency"] = 1;
G2L["TextButton_18"]["Size"] = UDim2.new(0.41842, 0, 0.75, 0);
G2L["TextButton_18"]["Text"] = [[toggle]];
G2L["TextButton_18"]["Position"] = UDim2.new(0.00526, 0, 0.125, 0);


G2L["Frame_19"] = Instance.new("Frame", G2L["togglesample_16"]);
G2L["Frame_19"]["BorderSizePixel"] = 0;
G2L["Frame_19"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["Frame_19"]["Size"] = UDim2.new(0.13684, 0, 0.875, 0);
G2L["Frame_19"]["Position"] = UDim2.new(0.85211, 0, 0.0625, 0);


G2L["UICorner_1a"] = Instance.new("UICorner", G2L["Frame_19"]);
G2L["UICorner_1a"]["CornerRadius"] = UDim.new(0.2, 0);


local function C_11()
	local script = G2L["LocalScript_11"];
	
	--I have added the explanation
	local gui = script.Parent	-- Get the GUI the script is a part of
	local element = gui.element	
	
	-- Function to create a new GUI window
	function create(name)	
	 local tables = {}	-- Table to hold the functions we will return
	 local gui = gui:Clone()	-- Clone the GUI template
	gui.Enabled = true	
	gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	gui.Name = name or "error"
	
	local frame = gui.main.Frame	
	frame.bar.title.Text = name or "untitled"	-- Set the window/bar title
	frame.bar.close.MouseButton1Down:Connect(function()	
	 gui:Destroy()	-- Destroy the GUI when close button is clicked
	end)	
	local page = frame.page.ScrollingFrame	
	
	-- Function to add a button to the GUI
	function tables:addbutton(name, call)	
	 local button = element.buttonsample:Clone()	-- Clone a button sample
	button.Parent = page	
	 button.Visible = true	
	 button.Name = name or "notitle"	
	 button.TextButton.Text = name or "error"	
	 button.TextButton.MouseButton1Down:Connect(function()	
	 if call then	
	 pcall(call)	-- Run the function when button is clicked
	end	
	end)	
	 return button	
	end	
	
	-- Function to add a toggle (on/off switch) to the GUI
	function tables:addtoggle(name, call, bool)	
	 local toggle = element.togglesample:Clone()	-- Clone a toggle sample
	 toggle.TextButton.Text = name or ""	
	 toggle.Visible = true	
	 toggle.Parent = page
	
	local boolean = false	-- Toggle state
	if bool then	
	boolean = true
	if call then
		call(boolean)
	end
	toggle.Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)	-- Set initial toggle color if 'bool' is true
	end	
	 
	toggle.TextButton.MouseButton1Down:Connect(function()	
	 boolean = not boolean	-- Change toggle state
	 if call then	
	 toggle.Frame.BackgroundColor3 = boolean and Color3.fromRGB(0,0,0) or Color3.fromRGB(255, 255, 255) -- Change color based on state
	 call(boolean)
	 end	
	end)	
	 return toggle	
	end	
	
	 return tables	-- Return the function or I mean method (addbutton, addtoggle) from tables
	end	
	
	-- call the function
	local main = create("example basics ui library")
	
	main:addbutton("this is button", function()
		print("button clicked")
	end)
	

	main:addtoggle("this one is toggle", function(a)
		 print("toggle", a)
	end)
	
	main:addtoggle("this one is toggle2", function(a)
		 print("toggle test", a)
	end)

end;
task.spawn(C_11);

return G2L["ScreenGui_1"], require;
