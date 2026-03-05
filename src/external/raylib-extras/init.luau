local raylib = require("@raylib")
local engineLib = require("./enginelib")

local ffi = zune.ffi

local void = ffi.types.void
local int = ffi.types.i32
local bool = ffi.types.u8
local float = ffi.types.float
local pointer = zune.ffi.types.pointer
type int = number
type bool = number
type float = number
type cstring = string | buffer | FFIPointer

local Vector3 = raylib.Vector3
local Vector4 = raylib.Vector4

local function fn(returns: any, args: { any })
	return {
		returns = returns,
		args = args,
	}
end

-- C Functions:
-- RLFrustum* CreateFrustum(void);

-- void ExtractFrustum(RLFrustum* frustum);

-- bool FrustumPointIn(const RLFrustum* frustum, Vector3 position);
-- bool FrustumPointInXYZ(const RLFrustum* frustum, float x, float y, float z);
-- bool FrustumSphereIn(const RLFrustum* frustum, Vector3 position, float radius);
-- bool FrustumSphereInXYZ(const RLFrustum* frustum, float x, float y, float z, float radius);
-- bool FrustumAABBoxIn(const RLFrustum* frustum, Vector3 min, Vector3 max);

type functions = {
    CreateFrustum: () -> (FFIPointer),
    ExtractFrustum: (FFIPointer) -> (),
    FrustumPointIn: (FFIPointer, Vector3) -> bool,
    FrustumSphereIn: (FFIPointer, Vector3, float) -> bool,
    FrustumSphereInXYZ: (FFIPointer, float, float, float, float) -> bool,
}

definitions = {
    CreateFrustum = fn(pointer, {}),
    ExtractFrustum = fn(void, { pointer }),
    FrustumPointIn = fn(bool, { pointer, Vector3 }),
    FrustumSphereIn = fn(bool, { pointer, Vector3, float }),
    FrustumSphereInXYZ = fn(bool, { pointer, float, float, float, float }),
}

local lib = ffi.dlopen(engineLib, definitions) :: {
    GetSymbol: (self: FFILibrary, symbol: string) -> FFIPointer?,
} & functions

return lib