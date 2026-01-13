local properties = {
    Name = "ModuleScript",
    Source = [[local module = {}
	
return module]]
}

return {
    class = "ModuleScript",
    callback = function(instance)
		instance:SetProperties(properties)
		return instance
	end,
	
	inherit = function(tble)
		for prop, val in pairs(properties) do
			tble[prop] = val
		end
	end,
}
