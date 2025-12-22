local imgui = require("@rimgui")
local window = require("@window")
local rl = require("@raylib")

local registry = require("@registry")

local services = {
	"Workspace",
	"ServerScriptService",
	"ServerStorage",
	"StarterGui",
	"Debris",
	"HttpService",
	"LogService",
	"RunService",
	"Selection",
	"TweenService",
	"UserInputService",
}


registry.getNameList()

local self
self = window.Create(function()
	local engineState = self.renderer().EngineState
	local game = engineState.game

	local Selection = game:GetService("Selection")

	local function GetServices()
		local servs = {}
		for _, name in ipairs(services) do
			local serv = game:FindService(name)
			if serv then
				table.insert(servs, serv)
			end
		end

		return servs
	end

	local function TreeRender(obj)
		local flags = bit32.bor(imgui.IMGUI_TREENODEFLAGS_OPENONDOUBLECLICK, imgui.IMGUI_TREENODEFLAGS_OPENONARROW)

		local children = obj:GetChildren()
		if #children == 0 then
			flags = bit32.bor(flags, imgui.IMGUI_TREENODEFLAGS_LEAF)
		end

		local isSelected = Selection:_IsSelected(obj)
		if isSelected then
			flags = bit32.bor(flags, imgui.IMGUI_TREENODEFLAGS_SELECTED)
		end

		if imgui.SmallButton("+##" .. obj.ClassName .. obj.UniqueId) == 1 then
			
		end

		imgui.SameLine()
		if imgui.TreeNodeEx(obj.Name, flags) == 1 then
			if imgui.IsItemClicked() == 1 then
				if Selection:_IsSelected(obj) then
					if rl.IsKeyDown(rl.KEY_LEFT_SHIFT) == 1 then
						Selection:Remove({ obj })
					else
						Selection:Set({})
					end
				else
					if rl.IsKeyDown(rl.KEY_LEFT_SHIFT) == 1 then
						Selection:Add(obj)
					else
						Selection:Set({ obj })
					end
				end
			end

			if rl.IsKeyPressed(rl.KEY_DELETE) == 1 and isSelected then
				Selection:Remove({ obj })
				obj:Destroy()
			end

			--[[ TODO: somehow `obj` is always UserInputService???
			if imgui.BeginPopupContextWindow() == 1 then
				if imgui.Selectable("Select Children") == 1 then
					Selection:Set(obj:GetChildren())
				end

				if imgui.Selectable("Select Parent") == 1 then
					local parent = obj.Parent
					if parent.ClassName ~= "DataModel" then
						Selection:Remove({obj})
						Selection:Add(parent)
					end
				end

				imgui.EndPopup()
			end
			]]

			if #children > 0 then
				for _, child in ipairs(children) do
					TreeRender(child)
				end
			end

			imgui.TreePop()
		end
	end

	if imgui.Begin("Explorer", self.visible, imgui.IMGUI_WINDOWFLAGS_HORIZONTAL_SCROLLBAR) == 1 then
		for _, serv in ipairs(GetServices()) do
			TreeRender(serv)
		end
	end
	imgui.End()
end)

return self
