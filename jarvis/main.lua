local config = dofile("/jarvis/config.lua")
local util = dofile("/jarvis/lib/util.lua")

local chatModule = dofile("/jarvis/modules/chat.lua")
local meModule = dofile("/jarvis/modules/me.lua")
local redstoneModule = dofile("/jarvis/modules/redstone.lua")
local manifest = dofile("/jarvis/manifest.lua")

local chatBox = peripheral.find("chatBox")
local me = peripheral.find("meBridge")

if not chatBox then
    print("Chat Box introuvable.")
    return
end

local ctx = {
    config = config,
    util = util,
    me = me
}

local function reply(player, msg)
    chatModule.reply(chatBox, player, config.chat.replyPrefix, msg)
end

local function removeAssistantPrefix(message)
    local assistant = util.lower(config.assistantName)
    local msg = util.trim(message)
    msg = util.removePrefixCaseInsensitive(msg, assistant)
    msg = msg:gsub("^[%s,:%-]+", "")
    return util.trim(msg)
end

local function isForAssistant(message)
    local msg = util.lower(util.trim(message))
    return util.startsWith(msg, util.lower(config.assistantName))
end

local function handleHelp(player)
    reply(player, "Commandes : combien j'ai au total, combien j'ai de fer, extrait 32 iron ingot, allume la lumiere, eteins la lumiere.")
end

print("Jarvis OS " .. manifest.version .. " en ligne.")

while true do
    local event, username, message = os.pullEvent("chat")

    if username and message then
        print(username .. " > " .. message)

        if isForAssistant(message) then
            local command = removeAssistantPrefix(message)

            if command == "" or util.lower(command) == "help" or util.lower(command) == "aide" then
                handleHelp(username)
            else
                local handled, response

                handled, response = meModule.handle(command, ctx)
                if handled then
                    reply(username, response)
                else
                    handled, response = redstoneModule.handle(command, ctx)
                    if handled then
                        reply(username, response)
                    else
                        reply(username, "Commande non comprise. Dis 'Jarvis aide'.")
                    end
                end
            end
        end
    end
end