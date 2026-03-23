local red = {}

function red.handle(command, ctx)
    local config = ctx.config
    local util = ctx.util

    local cmd = util.lower(command)
    local side = config.redstone.lightSide

    if string.find(cmd, "allume la lumiere", 1, true)
        or string.find(cmd, "allume lumiere", 1, true) then
        redstone.setOutput(side, true)
        return true, "Lumiere activee."
    end

    if string.find(cmd, "eteins la lumiere", 1, true)
        or string.find(cmd, "eteins lumiere", 1, true) then
        redstone.setOutput(side, false)
        return true, "Lumiere desactivee."
    end

    return false
end

return red