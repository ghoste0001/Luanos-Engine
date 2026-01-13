export type vector4 = {
	x: number,
	y: number,
	z: number,
	w: number,
}

local vector4 = {}

function vector4.create(x: number, y: number, z: number, w: number): vector4
	return {
		x = x or 0,
		y = y or 0,
		z = z or 0,
		w = w or 0,
	}
end

function vector4.magnitude(vec: vector4): number
	return math.sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z + vec.w * vec.w)
end

function vector4.normalize(vec: vector4): vector4
	local magnitude = vector4.magnitude(vec)
	if magnitude > 0 then
		return vector4.create(vec.x / magnitude, vec.y / magnitude, vec.z / magnitude, vec.w / magnitude)
	end

	return vector4.create(0, 0, 0, 0)
end

-- sooo vector4 has no cross product & no angle

function vector4.dot(vec1: vector4, vec2: vector4): number
	return vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z + vec1.w * vec2.w
end

function vector4.floor(vec: vector4): vector4
	return vector4.create(math.floor(vec.x), math.floor(vec.y), math.floor(vec.z), math.floor(vec.w))
end

function vector4.ceil(vec: vector4): vector4
	return vector4.create(math.ceil(vec.x), math.ceil(vec.y), math.ceil(vec.z), math.ceil(vec.w))
end

function vector4.abs(vec: vector4): vector4
	return vector4.create(math.abs(vec.x), math.abs(vec.y), math.abs(vec.z), math.abs(vec.w))
end

function vector4.sign(vec: vector4): vector4
	return vector4.create(math.sign(vec.x), math.sign(vec.y), math.sign(vec.z), math.sign(vec.w))
end

function vector4.clamp(vec: vector4, min: vector4, max: vector4): vector4 
	return vector4.create(
		math.clamp(vec.x, min.x, max.x), 
		math.clamp(vec.y, min.y, max.y), 
		math.clamp(vec.z, min.z, max.z), 
		math.clamp(vec.w, min.w, max.w)
	)
end

vector4.zero = vector4.create(0, 0, 0, 0)
vector4.one = vector4.create(1, 1, 1, 1)
return vector4
