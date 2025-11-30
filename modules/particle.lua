function dynamicParticlesInitialzie()
    ----------------------- DYNAMIC PARTICLES --------------------------
    
    dynamicParticle = {}
    dynamicParticle.__index = dynamicParticle

    function dynamicParticle:moveDown(row, col, value, valueToReplace)
        grid.table[row][col] = valueToReplace or 0
        grid.table[row][col+1] = value

        grid.dataTable[row][col] = 1
        grid.dataTable[row][col+1] = 1
    end

    function dynamicParticle:moveSide(row, col, value, valueToReplace)
        local r = math.random(1,2)                                  -- 1 is left, 2 is right
        if r == 1 then
            if row > 1 and grid.table[row-1][col] == 0 then
                grid.table[row][col] = valueToReplace or 0
                grid.table[row-1][col] = value

                grid.dataTable[row][col] = 1
                grid.dataTable[row-1][col] = 1
            end
        else
            if row < grid.rows and grid.table[row+1][col] == 0 then
                grid.table[row][col] = valueToReplace or 0
                grid.table[row+1][col] = value

                grid.dataTable[row][col] = 1
                grid.dataTable[row+1][col] = 1
            end
        end
    end

    -------------- Solids --------------- (solids are from 1 to 9)

    solid = {}                                                      
    solid.__index = solid
    setmetatable(solid, dynamicParticle)

    function solid:moveDownDiagonal(row, col, value, valueToReplace)
        local r = math.random(1,2)                                  -- 1 is left, 2 is right
        if r == 1 then
            if row > 1 and grid.table[row-1][col+1] == 0 then
                grid.table[row][col] = valueToReplace or 0
                grid.table[row-1][col+1] = value

                grid.dataTable[row][col] = 1
                grid.dataTable[row-1][col+1] = 1
            end
        else
            if row < grid.rows and grid.table[row+1][col+1] == 0 then
                grid.table[row][col] = valueToReplace or 0
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
        elseif grid.table[row][col+1] < 30 then
            sand:moveDown(row, col, sand.value, grid.table[row][col+1])
        end
    end

    function sand:draw(i, j, originX, originY, cellSize)
        love.graphics.setColor(.9, .4, 0)
        love.graphics.rectangle("fill", originX+(i*cellSize), originY+(j*cellSize), cellSize, cellSize)
    end

    -------------- Liquids --------------- (liquids are from 10 to 19)

    liquid = {}
    liquid.__index = liquid
    setmetatable(liquid, dynamicParticle)

    water = {}
    water.__index = water
    setmetatable(water, liquid)
    water.value = 10
    water.color = {}

    function water:update(row, col)
        if grid.table[row][col+1] == nil then
            -- nothing
        elseif grid.table[row][col+1] == 0 then
            water:moveDown(row, col, water.value)
        elseif grid.table[row][col+1] < 20 then
            water:moveSide(row, col, water.value)
        elseif grid.table[row][col+1] < 30 then
            water:moveDown(row, col, water.value, grid.table[row][col+1])
        end
    end

    function water:draw(i, j, originX, originY, cellSize)
        love.graphics.setColor(0, 0, 1, .2)
        love.graphics.rectangle("fill", originX+(i*cellSize), originY+(j*cellSize), cellSize, cellSize)
    end

    -------------- Gases --------------- (gases are from 20 to 29)

    gas = {}
    gas.__index = gas
    setmetatable(gas, dynamicParticle)

    function gas:moveUp(row, col, value, valueToReplace)
        if grid.table[row][col-1] ~= nil  and grid.table[row][col-1] == 0 then 
            grid.table[row][col] = valueToReplace or 0
            grid.table[row][col-1] = value

            grid.dataTable[row][col] = 1
            grid.dataTable[row][col-1] = 1
        end
    end

    function gas:moveUpLeft(row, col, value, valueToReplace)
        if row > 1 and grid.table[row-1][col-1] == 0 then
            grid.table[row][col] = valueToReplace or 0
            grid.table[row-1][col-1] = value

            grid.dataTable[row][col] = 1
            grid.dataTable[row-1][col-1] = 1
        end
    end

    function gas:moveUpRight(row, col, value, valueToReplace)
        if row < grid.rows and grid.table[row+1][col-1] == 0 then
            grid.table[row][col] = valueToReplace or 0
            grid.table[row+1][col-1] = value

            grid.dataTable[row][col] = 1
            grid.dataTable[row+1][col-1] = 1
        end
    end

    cloud = {}
    cloud.__index = cloud
    setmetatable(cloud, gas)
    cloud.value = 20
    cloud.color = {0.1, 0, 1, 0.1}

    function cloud:update(row, col)
        local r = math.random(1, 6)                                 -- 1 is up, 2 is left, 3 is right, 4 is no movement
        if r == 1 then
            self:moveUp(row, col, cloud.value)
        elseif r == 2 then  
            self:moveUpLeft(row, col, cloud.value)
        elseif r == 3 then
            self:moveUpRight(row, col, cloud.value)
        elseif r == 4 then
            self:moveSide(row, col, cloud.value)
        else
            --nothing ever happens
        end
    end

    function cloud:draw(i, j, originX, originY, cellSize)
        love.graphics.setColor(1, 1, 1, 0.2)
        love.graphics.rectangle("fill", originX+(i*cellSize), originY+(j*cellSize), cellSize, cellSize)
    end
end

function staticParticlesInitialize()
    ----------------------- STATIC PARTICLES -------------------------- (static particles are 30 and above)
    staticParticle = {}
    staticParticle.__index = staticParticle

    steel = {}
    steel.__index = steel
    setmetatable(steel, staticParticle)
    steel.value = 30

    function steel:draw(i, j, originX, originY, cellSize)
        love.graphics.setColor(0.3, 0.3, 0.3, 1)
        love.graphics.rectangle("fill", originX+(i*cellSize), originY+(j*cellSize), cellSize, cellSize)
    end
end