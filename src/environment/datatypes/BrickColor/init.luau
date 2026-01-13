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
            local brickColorMap

			for _, map in ColorMap do
				if map.Number == val then
					brickColorMap = table.clone(map)
					break
				end
			end

			if not brickColorMap then
				brickColorMap = {
					Name = "Medium stone grey",
					Number = val,
					Color = Color3.fromRGB(163, 162, 165),
					r = 163,
					g = 162,
					b = 165
				}
			end

			return table.freeze(brickColorMap)
        elseif type(val) == "string" then
			local brickColorMap

			for _, map in ColorMap do
				if map.Name == val then
					brickColorMap = table.clone(map)
					break
				end
			end

			if not brickColorMap then
				brickColorMap = {
					Name = "Medium stone grey",
					Number = val,
					Color = Color3.fromRGB(163, 162, 165),
					r = 163,
					g = 162,
					b = 165
				}
			end

			return table.freeze(brickColorMap)
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
    return BrickColor.new("White")
end

function BrickColor.Gray()
    return BrickColor.new("Medium stone grey")
end

function BrickColor.DarkGray()
    return BrickColor.new("Dark grey")
end

function BrickColor.Black()
    return BrickColor.new("Black")
end

function BrickColor.Red()
    return BrickColor.new("Bright red")
end

function BrickColor.Yellow()
    return BrickColor.new("Bright yellow")
end

function BrickColor.Green()
    return BrickColor.new("Bright green")
end

function BrickColor.Blue()
    return BrickColor.new("Bright blue")
end

return BrickColor