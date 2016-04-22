local common = {}

function common.round2(x, y)
    return math.floor(x + 0.5), math.floor(y + 0.5)
end

function common.get2(t, x, y)
    return t[x] and t[x][y]
end

function common.set2(t, x, y, value)
    if value == nil then
        if t[x] then
            t[x][y] = nil

            if not next(t[x]) then
                t[x] = nil
            end
        end
    else
        if not t[x] then
            t[x] = {}
        end

        t[x][y] = value
    end
end

return common
