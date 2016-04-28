local common = {}

function common.clamp(x, x1, x2)
    return math.min(math.max(x, x1), x2)
end

function common.round2(x, y)
    return math.floor(x + 0.5), math.floor(y + 0.5)
end

function common.length2(x, y)
    return math.sqrt(x * x + y * y)
end

function common.distance2(x1, y1, x2, y2)
    return common.length2(x2 - x1, y2 - y1)
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
