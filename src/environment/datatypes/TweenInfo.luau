local TweenInfo = {}
TweenInfo.__index = TweenInfo
TweenInfo.__type = "TweenInfo"

function TweenInfo.new(time:number, easingStyle, easingDirection, repeatCount:number?, reverses:boolean?, delayTime:number?)
    return setmetatable({
        Time = time,
        EasingStyle = easingStyle or "linear",
        EsingDirection = easingDirection or "out",
        RepeatCount = repeatCount or 0,
        Reverses = (typeof(reverses) == "boolean" and reverses) or false,
        DelayTime = delayTime or 0
    }, TweenInfo)
end

return TweenInfo