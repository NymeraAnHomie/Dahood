local g = getinfo or debug.getinfo
local d, h, x, y = false, {}

setthreadidentity(2)

for i, v in getgc(true) do
    if typeof(v) == "table" then
        local a, b = rawget(v, "Detected"), rawget(v, "Kill")
        
        if typeof(a) == "function" and not x then
            x = a
            table.insert(h, hookfunction(x, function(c) return c ~= "_" and true end))
        end
        
        if rawget(v, "Variables") and rawget(v, "Process") and typeof(b) == "function" and not y then
            y = b
            table.insert(h, hookfunction(y, function() end))
        end
    end
end

local o
o = hookfunction(getrenv().debug.info, newcclosure(function(a, f)
    return (x and a == x) and coroutine.yield(coroutine.running()) or o(a, f)
end))

setthreadidentity(7)

if table.find({7213786345, 16033173781, 2788229376}, game.PlaceId) then
    local AntiCheatRemotes = {
        "BANREMOTE", "PERMAIDBAN", "KICKREMOTE", "BR_KICKPC", "BR_KICKMOBILE",
        "OneMoreTime", "CHECKER_1", "TeleportDetect", "CHECKER", "GUI_CHECK",
        "checkingSPEED", "PERMA-BAN", "PERMABAN", "BreathingHAMON", "JJARC",
        "TakePoisonDamage", "FORCEFIELD", "Christmas_Sock", "VirusCough",
        "Symbiote", "Symbioted", "RequestAFKDisplay"
    }

    local FireHook
    FireHook = hookmetamethod(game, "__namecall", function(self, ...)
        local Method, Arg = getnamecallmethod(), {...}
        return (Method == "FireServer" and table.find(AntiCheatRemotes, Arg[2])) and nil or FireHook(self, ...)
    end)

    local RemoteNames = {"MainEvent", "Bullets", "Remote", "MAINEVENT"}
    for _, remote in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") and table.find(RemoteNames, remote.Name) then
            return remote
        end
    end
end
