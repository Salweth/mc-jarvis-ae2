local chat = {}

function chat.reply(chatBox, player, prefix, message)
    local full = prefix .. message
    chatBox.sendMessage(full, player)
    print("-> " .. player .. " : " .. full)
end

return chat