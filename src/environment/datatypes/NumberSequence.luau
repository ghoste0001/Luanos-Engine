local NumberSequenceKeypoint = require("@NumberSequenceKeypoint")

local NumberSequence = {}
NumberSequence.__index = NumberSequence
NumberSequence.__type = "NumberSequence"

function NumberSequence.new(...)
    local args = {...}
	local keypoints = {}

	if #args == 1 then
		local var = args[1]

		if typeof(var) == "number" then
			keypoints = {
				NumberSequenceKeypoint.new(0, var),
				NumberSequenceKeypoint.new(1, var)
			}
		elseif typeof(var) == "table" then
			for i, keypoint in var do
				local t, v, e = keypoint.Time, keypoint.Value, keypoint.Envelope

				if not t and not v and not e then
					t = keypoint[1]
					v = keypoint[2]
					e = keypoint[3]
				end

				if (not t) or (not v) or (not e) then
					error("attempted to create NumberSequence with malformed keypoints, first malformed keypoint at " .. i)
				end
			end

			keypoints = var
		else
			error("attempted to create NumberSequence without using a number or array, got '" .. typeof(var) .. "'")
		end
	elseif #args == 2 then
		local n0 = args[1]
		local n1 = args[2]

		assert(typeof(n0) == "number", "attempted to create NumberSequence without using a number, got '" .. typeof(n0) .. "'")
		assert(typeof(n1) == "number", "attempted to create NumberSequence without using a number, got '" .. typeof(n1) .. "'")

		keypoints = {
			NumberSequenceKeypoint.new(0, n0),
			NumberSequenceKeypoint.new(1, n1)
		}
	end

	local numberSequence = {}
	numberSequence.Keypoints = keypoints

	return setmetatable(numberSequence, NumberSequence)
end

function NumberSequence:_Evaluate(time: number): NumberSequenceKeypoint
	if time == 0 then
		return NumberSequenceKeypoint.new(0, self.Keypoints[1].Value, self.Keypoints[1].Envelope)
	elseif time == 1 then
		return NumberSequenceKeypoint.new(1, self.Keypoints[#self.Keypoints].Value, self.Keypoints[#self.Keypoints].Envelope)
	end

	for i = 1, #self.Keypoints - 1 do
		local currentKeypoint = self.Keypoints[i]
		local nextKeypoint = self.Keypoints[i + 1]

		if (time >= currentKeypoint.Time) and (time < nextKeypoint.Time) then
			local alpha = (time - currentKeypoint.Time) / (nextKeypoint.Time - currentKeypoint.Time)
			local value = currentKeypoint.Value + (nextKeypoint.Value - currentKeypoint.Value) * alpha
			local envelope = currentKeypoint.Envelope + (nextKeypoint.Envlope - currentKeypoint.Envelope) * alpha

			return NumberSequenceKeypoint.new(time, value, envelope)
		end
	end

	-- backup return
	return NumberSequenceKeypoint.new(0, 0, 0)
end

return NumberSequence