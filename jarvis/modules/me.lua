local meModule = {}

local function getItems(me)
    local items, err = me.listItems()
    if not items then
        return nil, err or "Erreur inconnue"
    end
    return items
end

local function findMatches(me, util, query)
    local items, err = getItems(me)
    if not items then
        return nil, err
    end

    local q = util.lower(util.trim(query))
    local matches = {}

    for _, item in pairs(items) do
        local name = util.lower(item.name)
        local displayName = util.lower(item.displayName)

        if string.find(name, q, 1, true) or string.find(displayName, q, 1, true) then
            table.insert(matches, item)
        end
    end

    table.sort(matches, function(a, b)
        return (a.amount or 0) > (b.amount or 0)
    end)

    return matches
end

function meModule.handle(command, ctx)
    local util = ctx.util
    local config = ctx.config
    local me = ctx.me

    if not me then
        return false
    end

    local cmd = util.lower(command)

    if string.find(cmd, "combien j'ai au total", 1, true)
        or string.find(cmd, "combien j ai au total", 1, true)
        or cmd == "total" then

        local items, err = getItems(me)
        if not items then
            return true, "Impossible de lire le stockage : " .. tostring(err)
        end

        local totalTypes = 0
        local totalAmount = 0

        for _, item in pairs(items) do
            totalTypes = totalTypes + 1
            totalAmount = totalAmount + (item.amount or 0)
        end

        return true, "Tu as " .. totalAmount .. " items au total, repartis sur " .. totalTypes .. " types d'objets."
    end

    do
        local query = command:match("^[Cc]ombien j[' ]?ai de (.+)$")
            or command:match("^[Cc]ombien j ai de (.+)$")
            or command:match("^[Cc]ombien de (.+)$")

        if query then
            local matches, err = findMatches(me, util, query)
            if not matches then
                return true, "Erreur de recherche : " .. tostring(err)
            end

            if #matches == 0 then
                return true, "Je n'ai trouve aucun item pour '" .. query .. "'."
            end

            if #matches == 1 then
                local item = matches[1]
                return true, "Tu as " .. item.amount .. " de " .. item.displayName .. "."
            end

            local shown = math.min(#matches, 5)
            local parts = {}
            for i = 1, shown do
                local item = matches[i]
                table.insert(parts, item.displayName .. " x" .. item.amount)
            end

            return true, "Plusieurs correspondances : " .. table.concat(parts, ", ") .. "."
        end
    end

    do
        local amount, query = command:match("^[Ee]xtrait%s+(%d+)%s+(.+)$")
        if amount and query then
            amount = tonumber(amount)

            local matches, err = findMatches(me, util, query)
            if not matches then
                return true, "Erreur de recherche : " .. tostring(err)
            end

            if #matches == 0 then
                return true, "Je n'ai trouve aucun item pour '" .. query .. "'."
            end

            if #matches > 1 then
                local shown = math.min(#matches, 5)
                local parts = {}
                for i = 1, shown do
                    local item = matches[i]
                    table.insert(parts, item.displayName .. " x" .. item.amount)
                end
                return true, "Extraction ambigue. J'ai trouve : " .. table.concat(parts, ", ") .. "."
            end

            local item = matches[1]
            local exported, exportErr = me.exportItem({
                name = item.name,
                count = amount
            }, config.me.exportDirection)

            if not exported then
                return true, "Echec de l'extraction : " .. tostring(exportErr)
            end

            if exported < amount then
                return true, "J'ai extrait " .. exported .. " de " .. item.displayName .. " sur " .. amount .. " demandes."
            end

            return true, "J'ai extrait " .. exported .. " de " .. item.displayName .. "."
        end
    end

    return false
end

return meModule