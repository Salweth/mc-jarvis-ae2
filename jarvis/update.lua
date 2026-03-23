local BASE_URL = "https://github.com/Salweth/mc-jarvis-ae2"

local files = {
    {url = BASE_URL .. "/jarvis.lua", path = "/jarvis.lua"},
    {url = BASE_URL .. "/update.lua", path = "/update.lua"},

    {url = BASE_URL .. "/jarvis/main.lua", path = "/jarvis/main.lua"},
    {url = BASE_URL .. "/jarvis/config.lua", path = "/jarvis/config.lua"},
    {url = BASE_URL .. "/jarvis/manifest.lua", path = "/jarvis/manifest.lua"},

    {url = BASE_URL .. "/jarvis/lib/util.lua", path = "/jarvis/lib/util.lua"},

    {url = BASE_URL .. "/jarvis/modules/chat.lua", path = "/jarvis/modules/chat.lua"},
    {url = BASE_URL .. "/jarvis/modules/me.lua", path = "/jarvis/modules/me.lua"},
    {url = BASE_URL .. "/jarvis/modules/redstone.lua", path = "/jarvis/modules/redstone.lua"},
}

local function ensureDir(path)
    local dir = fs.getDir(path)
    if dir and dir ~= "" and not fs.exists(dir) then
        fs.makeDir(dir)
    end
end

for _, file in ipairs(files) do
    print("Telechargement : " .. file.path)
    ensureDir(file.path)

    if fs.exists(file.path) then
        fs.delete(file.path)
    end

    local ok = shell.run("wget", file.url, file.path)
    if not ok then
        print("Echec : " .. file.url)
    end
end

print("Mise a jour terminee.")