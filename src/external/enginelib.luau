local platform = zune.platform

local libLocation = "./vendor/libEngineLib.so"
if platform.cpu.arch == "x86_64" then
    if platform.os == "windows" then
        libLocation = "./vendor/libEngineLib.dll"
    elseif platform.os == "linux" then
        libLocation = "./vendor/libEngineLib.so"
    else
        -- other platforms
    end
else
    -- other archs
end

return libLocation