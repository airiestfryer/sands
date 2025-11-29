function particlesInitialzie()
    ----------------------- DYNAMIC PARTICLES --------------------------
    
    dynamicParticle = {}
    dynamicParticle.__index = dynamicParticle

    function dynamicParticle:moveDown(row, col, value, valueBelow)
        grid.table[row][col] = valueBelow or 0
        grid.table[row][col+1] = value

        grid.dataTable[row][col] = 1
        grid.dataTable[row][col+1] = 1
    end

    -------------- Solids -------------

    solid = {}
    solid.__index = solid
    setmetatable(solid, dynamicParticle)

    function solid:moveDownDiagonal(row, col, value)
        local r = math.random(1,2)                                  -- 1 is left, 2 is right
        if r == 1 then
            if row > 1 and grid.table[row-1][col+1] == 0 then
                grid.table[row][col] = 0
                grid.table[row-1][col+1] = value

                grid.dataTable[row][col] = 1
                grid.dataTable[row-1][col+1] = 1
            end
        else
            if row < grid.rows and grid.table[row+1][col+1] == 0 then
                grid.table[row][col] = 0
                grid.table[row+1][col+1] = value

                grid.dataTable[row][col] = 1
                grid.dataTable[row+1][col+1] = 1
            end
        end
    end

    sand = {}
    sand.__index = sand
    setmetatable(sand, solid)
    sand.value = 1
    sand.color = {}

    function sand:update(row, col)
        if grid.table[row][col+1] == 0 then
            sand:moveDown(row, col, sand.value)
        elseif grid.table[row][col+1] == nil then
            --nothing happens
        elseif grid.table[row][col+1] < 10 then
            sand:moveDownDiagonal(row, col, sand.value)
        elseif grid.table[row][col+1] < 20 then
            sand:moveDown(row, col, sand.value, grid.table[row][col+1])
        end
    end

    function sand:draw(i, j, originX, originY, cellSize)
        love.graphics.setColor(.9, .4, 0)
        love.graphics.rectangle("fill", originX+(i*cellSize), originY+(j*cellSize), cellSize, cellSize)
    end

    -------------- Liquids -------------

    liquid = {}
    liquid.__index = liquid
    setmetatable(liquid, dynamicParticle)

    function liquid:moveSide(row, col, value)
        local r = math.random(1,2)                                  -- 1 is left, 2 is right
        if r == 1 then
            if row > 1 and grid.table[row-1][col] == 0 then
                grid.table[row][col] = 0
                grid.table[row-1][col] = value

                grid.dataTable[row][col] = 1
                grid.dataTable[row-1][col] = 1
            end
        else
            if row < grid.rows and grid.table[row+1][col] == 0 then
                grid.table[row][col] = 0
                grid.table[row+1][col] = value

                grid.dataTable[row][col] = 1
                grid.dataTable[row+1][col] = 1
            end
        end
    end

    water = {}
    water.__index = water
    setmetatable(water, liquid)
    water.value = 10
    water.color = {}

    function water:update(row, col)
        if grid.table[row][col+1] == 0 then
            water:moveDown(row, col, water.value)
        elseif grid.table[row][col+1] ~= 0 then
            water:moveSide(row, col, water.value)
        end
    end

    function water:draw(i, j, originX, originY, cellSize)
        love.graphics.setColor(0, 0, 1, .2)
        love.graphics.rectangle("fill", originX+(i*cellSize), originY+(j*cellSize), cellSize, cellSize)
    end

    -------------- Gases -------------

    gas = {}
    gas.__index = gas
    setmetatable(gas, dynamicParticle)


end