local BrickColor = {}
local ColorMap = require("./BrickColor/map")

local function ColorDistance(a, b)
	local dx = a.R - b.R
	local dy = a.G - b.G
	local dz = a.B - b.B
	return dx * dx + dy * dy + dz * dz
end

local function GetClosestColor(clr)
    local best
    local bestName
	local bestDist = math.huge

	for name, data in pairs(ColorMap) do
		local d = ColorDistance(clr, data.color)
		if d < bestDist then
			bestDist = d
			best = data
            bestName = name
		end
	end

	return bestName, best
end

local function SetupBrickColor(name, id, color)
    return table.freeze({
        Name = name,
        Number = id,
        Color = color
    })
end

local function BrickColorFromColor(color)
    local name, data = BrickColorFromColor(color)
    return SetupBrickColor(name, data.id, data.color)
end

function BrickColor.palette(id)
    for name, data in pairs(ColorMap) do
        if data.id == id then
            return SetupBrickColor(name, data.id, data.color)
        end
    end

    error(("could not find BrickColor with id '%i'!"):format(id))
end

function BrickColor.new(...)
    local args = {...}

    if #args == 1 then
        local val = args[1]
        
        if type(val) == "number" then
            
        elseif type(val) == "string" then
            local data = ColorMap[val]
            if not data then
                error(("could not find BrickColor with name '%s'!"):format(val))
            end

            return SetupBrickColor(val, data.id, data.color)
        end
    elseif #args == 3 then
        local r = args[1]
        local g = args[2]
        local b = args[3]
        
        if type(r) == "number" and type(g) == "number" and type(b) == "number" then
            local color = Color3.new(r, g, b)
            local name, data = GetClosestColor(color)
            
            return SetupBrickColor(name, data.id, data.color)
        end
    end

    error("invalid parameters for BrickColor.new")
end

function BrickColor.White()
    return ColorMap.White
end

function BrickColor.Gray()
    return ColorMap["Medium stone grey"]
end

function BrickColor.DarkGray()
    return ColorMap["Dark gray"]
end

function BrickColor.Black()
    return ColorMap.Black
end

function BrickColor.Red()
    return ColorMap["Bright red"]
end

function BrickColor.Yellow()
    return ColorMap["Bright yellow"]
end

function BrickColor.Green()
    return ColorMap["Bright green"]
end

function BrickColor.Blue()
    return ColorMap["Bright blue"]
end

return BrickColor