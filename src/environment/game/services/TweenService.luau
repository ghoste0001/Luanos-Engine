local Instance = require("@Instance")
local Signal = require("@signal")

local Enum = require("@Enum")

local TweenService = Instance.new("TweenService")

local activeTweens = {}

local function lerp(a, b, t)
    return math.lerp(a, b, t)
end

local function lerpVector3(a, b, t)
    return a:Lerp(b, t)
end

local function ModifyLerpTime(t, tweenInfo)
    if tweenInfo.EasingStyle == Enum.EasingStyle.Linear then
        return t
    elseif tweenInfo.EasingStyle == Enum.EasingStyle.Sine then
        if tweenInfo.EasingDirection == "in" then
            return math.sin(((t*math.pi)/2)-(math.pi/2))+1
        elseif tweenInfo.EasingDirection == "out" then
            return math.sin((t*math.pi)/2)
        elseif tweenInfo.EasingDirection == "inout" then
            return (math.sin((t*math.pi)-(math.pi/2))/2)+0.5
        end
    elseif tweenInfo.EasingStyle == Enum.EasingStyle.Quad then
        if tweenInfo.EasingDirection == "in" then
            return -(t-1)^2 + 1
        elseif tweenInfo.EasingDirection == "out" then
            return t^2
        elseif tweenInfo.EasingDirection == "inout" then
            return math.lerp(t^2, -(t-1)^2+1, t)
        end
    elseif tweenInfo.EasingStyle == Enum.EasingStyle.Cubic then
        if tweenInfo.EasingDirection == "in" then
            return t^3
        elseif tweenInfo.EasingDirection == "out" then
            return (t-1)^3+1
        elseif tweenInfo.EasingDirection == "inout" then
            return math.lerp(t^3, (t-1)^3+1, t)
        end
    elseif tweenInfo.EasingStyle == Enum.EasingStyle.Quart then
        if tweenInfo.EasingDirection == "in" then
            return -(t-1)^4 + 1
        elseif tweenInfo.EasingDirection == "out" then
            return t^4
        elseif tweenInfo.EasingDirection == "inout" then
            return math.lerp(t^4, -(t-1)^4+1, t)
        end
    elseif tweenInfo.EasingStyle == Enum.EasingStyle.Quint then
        if tweenInfo.EasingDirection == "in" then
            return t^5
        elseif tweenInfo.EasingDirection == "out" then
            return (t-1)^5+1
        elseif tweenInfo.EasingDirection == "inout" then
            return math.lerp(t^5, (t-1)^5+1, t)
        end
    end

    return t
end

function TweenService:Create(instance, tweenInfo, propertyTable)
    local tween = Instance.new("Tween")

    local startProps = {}
    for prop, value in pairs(propertyTable) do
        startProps[prop] = instance[prop]
    end

    tween.Completed = Signal.new()
    tween:SetProperties({
        Instance = instance,
        TweenInfo = tweenInfo,
        StartProperties = startProps,
        EndProperties = propertyTable,
        Playing = false,
        Elapsed = 0,
    })

    function tween:Play()
        if self.Playing then return end
        activeTweens[self] = true
    end

    function tween:Cancel()
        if not self.Playing then return end
        self.Playing = false
        activeTweens[self] = nil
    end
    
    tween.Parent = instance
    return tween
end

TweenService.InitRenderer = function(renderer)
    renderer.MainSignal:Connect(function(route, dt)
        if route == "Heartbeat" or route == "PostSimulation" then
            for tween in pairs(activeTweens) do
                tween.Elapsed += dt

                local alpha = tween.Elapsed / tween.TweenInfo.Time
                if alpha > 1 then
                    alpha = 1
                end
                
                local lerpTime = ModifyLerpTime(alpha, tween.TweenInfo)
                for prop, target in pairs(tween.EndProperties) do
                    if type(target) == "number" then
                        
                    else   

                    end
                end

                if alpha >= 1 then
                    activeTweens[tween] = nil
                    tween.Playing = false
                    tween.Completed:Fire()
                    tween:Destroy()
                end
            end
        end
    end)
end

return TweenService