board = {
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {}
}

function initBoard()
    math.randomseed(os.time())
    for y = 1, 9 do
        for x = 1, 9 do
            board[y][x] = math.random(1, 6)
        end
    end
end

function move(row, col, dir) 
    local a = board[row][col]
    local swap = {row, col}

    if dir == 1 then -- up
        swap[1] = swap[1] - 1
    elseif dir == 2 then --down
        swap[1] = swap[1] + 1
    elseif dir == 3 then --left
        swap[2] = swap[2] - 1
    elseif dir == 4 then --right
        swap[2] = swap[2] + 1
    end

    if (swap[1] ~= 0) and (swap[2] ~= 0) then
        board[row][col] = board[swap[1]][swap[2]]
        board[swap[1]][swap[2]] = a
    end

    return checkMatches()
end

function deleteMatches(m)
    for index, value in ipairs(m) do
        for key, data in ipairs(value) do
            board[data[1]][data[2]] = nil
        end
    end
    shift()
end

function shift()
    for x = 1, 9 do
        local space = false
        local spaceY = 0

        local y = 9
        while y >= 1 do
            if space then 
                if board[y][x] ~= nil then
                    board[spaceY][x] = board[y][x]
                    board[y][x] = nil

                    space = false
                    y = spaceY
                    spaceY = 0
                end
            elseif board[y][x] == nil then
                space = true
                if spaceY == 0 then
                    spaceY = y 
                end
            end

            y = y - 1
        end
    end

    for x = 1, 9 do 
        for y = 9, 1, -1 do
            if board[y][x] == nil then
                board[y][x] = math.random(1, 6)
            end
        end
    end
end

function checkMatches()
    local matches = {}

    local matchNum = 1;
    
    for y = 1, 9 do
        local letterToMatch = board[y][1]
        matchNum = 1

        for x = 2, 9 do
            if board[y][x] == letterToMatch then
                matchNum = matchNum + 1
            else
                letterToMatch = board[y][x]

                if matchNum >= 3 then
                    local match = {}

                    for x2 = x - 1, x - matchNum, -1 do
                        table.insert(match, {y,x2})
                    end

                    table.insert(matches, match)
                end

                matchNum = 1
            end
        end
        if matchNum >= 3 then
            local match = {}
            
            for x = 9, 9 - matchNum + 1, -1 do
                table.insert(match, {y, x})
            end

            table.insert(matches, match)
        end
    end

    for x = 1, 9 do
        local letterToMatch = board[1][x]
        matchNum = 1

        for y = 2, 9 do
            if board[y][x] == letterToMatch then
                matchNum = matchNum + 1
            else
                letterToMatch = board[y][x]

                if matchNum >= 3 then
                    local match = {}
                    
                    
                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, {y2,x})
                    end

                    table.insert(matches, match)
                end

                matchNum = 1
            end
        end
        if matchNum >= 3 then
            local match = {}
            
            for y = 9, 9 - matchNum + 1, -1 do
                table.insert(match, {y, x})
            end

            table.insert(matches, match)
        end
    end

    local m = #matches
    deleteMatches(matches)

    return m
end