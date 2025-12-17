local Instance = require("@Instance")
local Color3 = require("@Color3")
local Vector3 = require("@Vector3")

local Lighting = Instance.new("Lighting")

Lighting.Ambient = Color3.fromRGB(128, 128, 128)
Lighting.Brightness = 2.0
Lighting.ColorShift_Top = Color3.new(1, 1, 1)

return Lighting