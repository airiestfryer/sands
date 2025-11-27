function particlesInitialzie()
    dynamicParticle = {}
    dynamicParticle.__index = dynamicParticle

    function dynamicParticle:moveDown(row, col, value)
        grid.table[row][col] = 0
        grid.table[row][col+1] = value
    end

    function dynamicParticle:moveSide(row, col, value)
        local r = math.random(1,2)                                  -- 1 is left, 2 is right
        if r == 1 then
            if row > 1 and grid.table[row-1][col] == 0 then
                grid.table[row][col] = 0
                grid.table[row-1][col] = value
            end
        else
            if row < grid.rows and grid.table[row+1][col] == 0 then
                grid.table[row][col] = 0
                grid.table[row+1][col] = value
            end
        end
    end

    function dynamicParticle:moveDownDiagonal(row, col, value)
        local r = math.random(1,2)                                  -- 1 is left, 2 is right
        if r == 1 then
            if row > 1 and grid.table[row-1][col+1] == 0 then
                grid.table[row][col] = 0
                grid.table[row-1][col+1] = value
            end
        else
            if row < grid.rows and grid.table[row+1][col+1] == 0 then
                grid.table[row][col] = 0
                grid.table[row+1][col+1] = value
            end
        end
    end

    sand = {}
    sand.__index = sand
    setmetatable(sand, dynamicParticle)
    sand.value = 1
    sand.color = {}

    function sand:update(row, col)
        if grid.table[row][col+1] == 0 then
            sand:moveDown(row, col, sand.value)
        elseif grid.table[row][col+1] ~= 0 then
            sand:moveDownDiagonal(row, col, sand.value)
        end
    end

    function sand:draw(i, j, originX, originY, cellSize)
        love.graphics.setColor(.9, .4, 0)
        love.graphics.rectangle("fill", originX+(i*cellSize), originY+(j*cellSize), cellSize, cellSize)
    end

    water = {}
    water.__index = water
    setmetatable(water, dynamicParticle)
    water.value = 2
    water.color = {}

    function water:update(row, col)
        if grid.table[row][col+1] == 0 then
            water:moveDown(row, col, water.value)
        elseif grid.table[row][col+1] ~= 0 then
            water:moveSide(row, col, water.value)
        end
    end

    function water:draw(i, j, originX, originY, cellSize)
        love.graphics.setColor(0, 0, 1, .3)
        love.graphics.rectangle("fill", originX+(i*cellSize), originY+(j*cellSize), cellSize, cellSize)
    end
end