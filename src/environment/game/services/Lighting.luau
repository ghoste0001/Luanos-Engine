local Instance = require("@Instance")
local Color3 = require("@Color3")
local Vector3 = require("@Vector3")
local Enum = require("@Enum")

local Lighting = Instance.new("Lighting")

Lighting.Ambient = Color3.fromRGB(0, 0, 0)
Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)

Lighting.Brightness = 2.0
Lighting.ColorShift_Top = Color3.new(1, 1, 1)
Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
Lighting.EnvironmentDiffuseScale = 1
Lighting.EnvironmentSpecularScale = 1
Lighting.ExposureCompensation = 0
Lighting.GlobalShadows = true
Lighting.ShadowSoftness = 0.2

Lighting.ClockTime = 13
Lighting.TimeOfDay = "13:00:00"
Lighting.GeographicLatitude = 0

Lighting.FogColor = Color3.new(1, 1, 1)
Lighting.FogEnd = 100000
Lighting.FogStart = 0

function Lighting:GetMinutesAfterMidnight(): number
	return self.ClockTime * 360
end
Lighting.getMinutesAfterMidnight = Lighting.GetMinutesAfterMidnight

function Lighting:SetMinutesAfterMidnight(minutes: number)
	self.ClockTime = (minutes * 60)
end
Lighting.setMinutesAfterMidnight = Lighting.SetMinutesAfterMidnight

function Lighting:GetMoonDirection() end

function Lighting:GetSunDirection() end

function Lighting:GetMoonPhase(): number
	return 0.75
end

return Lighting
