local util = {}

function util.lower(s)
    return string.lower(tostring(s or ""))
end

function util.trim(s)
    return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

function util.startsWith(str, prefix)
    return string.sub(str, 1, #prefix) == prefix
end

function util.splitWords(input)
    local t = {}
    for word in string.gmatch(input, "%S+") do
        table.insert(t, word)
    end
    return t
end

function util.removePrefixCaseInsensitive(text, prefix)
    local t = tostring(text or "")
    local p = tostring(prefix or "")

    local tl = string.lower(t)
    local pl = string.lower(p)

    if string.sub(tl, 1, #pl) == pl then
        return util.trim(string.sub(t, #p + 1))
    end

    return t
end

return util