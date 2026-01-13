local imgui = require("@rimgui")
local window = require("@window")

local Enum = require("@Enum")

local self = {}
self = window.Create(function()
	local engineState = self.renderer().EngineState
	local game = engineState.game

	local LogService = game:GetService("LogService")

	if imgui.Begin("Output", self.visible) == 1 then
		local availSize = imgui.FromImVec2(imgui.GetContentRegionAvail())
		if imgui.BeginChild(
				"OutputScrolling",
				imgui.NewImVec2(availSize.x, availSize.y),
				false,
				imgui.IMGUI_WINDOWFLAGS_HORIZONTAL_SCROLLBAR
			) then
			local logList = LogService:GetLogHistory()

			local count = #logList
			for i, log in logList do
				if i >= (count - 5000) then
					local text = ("[ %010i ]: %s"):format(log.timestamp, log.message)
					
					local pushedColor = false
					if log.messageType == Enum.MessageType.MessageInfo then
						imgui.PushStyleColor(imgui.IMGUI_COL_TEXT, imgui.NewImVec4(0, 0, 1, 1))
						pushedColor = true
					elseif log.messageType == Enum.MessageType.MessageWarning then
						imgui.PushStyleColor(imgui.IMGUI_COL_TEXT, imgui.NewImVec4(1, 1, 0, 1))
						pushedColor = true
					elseif log.messageType == Enum.MessageType.MessageError then
						imgui.PushStyleColor(imgui.IMGUI_COL_TEXT, imgui.NewImVec4(1, 0, 0, 1))
						pushedColor = true
					end

					imgui.TextUnformatted(text)

					if pushedColor then
						imgui.PopStyleColor()
					end
				end
			end

			if imgui.GetScrollY() >= imgui.GetScrollMaxY() - 1 then
				imgui.SetScrollHereY(1)
			end
		end
		imgui.EndChild()
	end
	imgui.End()
end)

self.title = "Output"
return self
