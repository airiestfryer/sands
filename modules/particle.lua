function dynamicParticlesInitialzie()
    ----------------------- DYNAMIC PARTICLES --------------------------
    
    dynamicParticle = {}
    dynamicParticle.__index = dynamicParticle

    function dynamicParticle:moveDown(row, col, value)
        grid.table[row][col] = grid.table[row][col+1]
        grid.table[row][col+1] = value

        grid.dataTable[row][col] = 1
        grid.dataTable[row][col+1] = 1
    end

    function dynamicParticle:moveSide(row, col, value)
        local r = math.random(1,2)                                  -- 1 is left, 2 is right
        if r == 1 then
            if row > 1 and grid.densityTable[row-1][col] < self.density then
                grid.table[row][col] = grid.table[row-1][col]
                grid.table[row-1][col] = value

                grid.dataTable[row][col] = 1
                grid.dataTable[row-1][col] = 1
            end
        else
            if row < grid.rows and grid.densityTable[row+1][col] < self.density then
                grid.table[row][col] = grid.table[row+1][col]
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

    function solid:moveDownDiagonal(row, col, value)
        local r = math.random(1,2)                                  -- 1 is left, 2 is right
        if r == 1 then
            if row > 1 and grid.densityTable[row-1][col+1] < self.density then
                grid.table[row][col] = grid.table[row-1][col+1]
                grid.table[row-1][col+1] = value

                grid.dataTable[row][col] = 1
                grid.dataTable[row-1][col+1] = 1
            end
        else
            if row < grid.rows and grid.densityTable[row+1][col+1] < self.density then
                grid.table[row][col] = grid.table[row+1][col+1]
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
    sand.density = 25
    sand.color = {1, 0.7, 0}

    function sand:update(row, col)
        if grid.densityTable[row][col+1] == nil then
            -- nothing happens
        elseif grid.densityTable[row][col+1] < self.density then
            self:moveDown(row, col, self.value)
        elseif grid.densityTable[row][col+1] >= self.density then
            self:moveDownDiagonal(row, col, self.value)
        end
    end

    function sand:draw(i, j, originX, originY, cellSize)
        love.graphics.setColor(unpack(self.color))
        love.graphics.rectangle("fill", originX+(i*cellSize), originY+(j*cellSize), cellSize, cellSize)
    end

    -------------- Liquids --------------- (liquids are from 10 to 19)

    liquid = {}
    liquid.__index = liquid
    setmetatable(liquid, dynamicParticle)

    water = {}
    water.__index = water
    setmetatable(water, liquid)
    water.value = 11
    water.density = 15
    water.color = {0, 0, 1, 0.2}

    function water:update(row, col)
        if grid.densityTable[row][col+1] == nil then
            self:moveSide(row, col, self.value)
        elseif grid.densityTable[row][col+1] < self.density then
            self:moveDown(row, col, self.value)
        elseif grid.densityTable[row][col+1] >= self.density then
            self:moveSide(row, col, self.value)
        end
    end

    function water:draw(i, j, originX, originY, cellSize)
        love.graphics.setColor(unpack(self.color))
        love.graphics.rectangle("fill", originX+(i*cellSize), originY+(j*cellSize), cellSize, cellSize)
    end

    oil = {}
    oil.__index = oil
    setmetatable(oil, liquid)
    oil.value = 12
    oil.density = 13
    oil.color = {0.7, 0.7, 0, 0.2}

    function oil:update(row, col)
        if grid.densityTable[row][col+1] == nil then
            self:moveSide(row, col, self.value)
        elseif grid.densityTable[row][col+1] < self.density then
            self:moveDown(row, col, self.value)
        elseif grid.densityTable[row][col+1] >= self.density then
            self:moveSide(row, col, self.value)
        end
    end

    function oil:draw(i, j, originX, originY, cellSize)
        love.graphics.setColor(unpack(self.color))
        love.graphics.rectangle("fill", originX+(i*cellSize), originY+(j*cellSize), cellSize, cellSize)
    end

    -------------- Gases --------------- (gases are from 20 to 29)

    gas = {}
    gas.__index = gas
    setmetatable(gas, dynamicParticle)

    function gas:moveUp(row, col, value)
        if grid.densityTable[row][col-1] ~= nil and grid.densityTable[row][col-1] < self.density then 
            grid.table[row][col] = grid.table[row][col-1]
            grid.table[row][col-1] = value

            grid.dataTable[row][col] = 1
            grid.dataTable[row][col-1] = 1
        end
    end

    function gas:moveUpLeft(row, col, value)
        if row > 1 and col > 1 and grid.densityTable[row-1][col-1] < self.density then
            grid.table[row][col] = grid.table[row-1][col-1]
            grid.table[row-1][col-1] = value

            grid.dataTable[row][col] = 1
            grid.dataTable[row-1][col-1] = 1
        end
    end

    function gas:moveUpRight(row, col, value)
        if row < grid.rows and col > 1 and grid.densityTable[row+1][col-1] < self.density then
            grid.table[row][col] = grid.table[row+1][col-1]
            grid.table[row+1][col-1] = value

            grid.dataTable[row][col] = 1
            grid.dataTable[row+1][col-1] = 1
        end
    end

    cloud = {}
    cloud.__index = cloud
    setmetatable(cloud, gas)
    cloud.value = 21
    cloud.density = 5
    cloud.color = {0.7, 0.7, 1, 0.2}

    function cloud:update(row, col)
        local r = math.random(1, 6)                                 -- 1 is up, 2 is top-left, 3 is top-right, 4 is sides, 5 and above is no movement
        if r == 1 then
            self:moveUp(row, col, self.value)
        elseif r == 2 then  
            self:moveUpLeft(row, col, self.value)
        elseif r == 3 then
            self:moveUpRight(row, col, self.value)
        elseif r == 4 then
            self:moveSide(row, col, self.value)
        else
            --nothing ever happens
        end
    end

    function cloud:draw(i, j, originX, originY, cellSize)
        love.graphics.setColor(unpack(self.color))
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
    steel.value = 31
    steel.density = 40
    steel.color = {0.3, 0.3, 0.3, 1}

    function steel:draw(i, j, originX, originY, cellSize)
        love.graphics.setColor(unpack(self.color))
        love.graphics.rectangle("fill", originX+(i*cellSize), originY+(j*cellSize), cellSize, cellSize)
    end
end

--[[
    values for particles are:
        0 is nothing
        1-10 is solid
        11-20 is liquid
        21-30 is gas
        31-40 is static material

    densities for particles are:
        1-10 is density for gases (average is 5)
        11-20 is density for liquids (average is 15)
        21-30 is density for solids (average is 25)
        above that is static particles (use 40 as density to be safe)
]]