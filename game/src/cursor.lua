function cursorInitialize()
    cursor = {}
    cursor.__index = cursor
    cursor.i = 1
    cursor.j = 1
    cursor.material = 1
    cursor.name = sand.name
    cursor.density = 30
    cursor.mouseMovement = true
    cursor.color = {1, 1, 1, 1}

    local originX, originY = grid.tableOriginX, grid.tableOriginY
    local width, height = grid.borderWidth, grid.borderHeight
    local cellSize = grid.cellSize

    local materialFont = love.graphics.newFont(20)

    function cursor:move()
        if self.mouseMovement == true then
            self:moveWMouse()
        else
            self:moveWArrows()
        end
    end

    function cursor:moveWArrows()
        if love.keyboard.isDown("up") then
            if self.j > 1 then
                self.j = self.j - 1
            end
        end

        if love.keyboard.isDown("down") then
            if self.j < grid.columns then
                self.j = self.j + 1
            end
        end

        if love.keyboard.isDown("left") then
            if self.i > 1 then
                self.i = self.i - 1
            end
        end

        if love.keyboard.isDown("right") then
            if self.i < grid.rows then
                self.i = self.i + 1
            end
        end
    end

    function cursor:moveWMouse()
        local x, y = love.mouse.getPosition()

        if x > originX+cellSize and x < (originX+width)+cellSize and y > originY+cellSize and y < (originY+height)+cellSize then
            local mX, mY = (x - originX) / cellSize, (y - originY) / cellSize
            self.i = math.floor(mX)
            self.j = math.floor(mY)
        end
    end

    function cursor:drop()                              -- drops a pixel of selected material
        if self.mouseMovement == true then
            if grid.table[self.i][self.j] == 0 or self.material == 0 then
                if love.mouse.isDown('1') then
                    grid.table[self.i][self.j] = cursor.material
                    grid.densityTable[self.i][self.j] = cursor.density
                end
            end
        else
            if grid.table[self.i][self.j] == 0 or self.material == 0 then
                if love.keyboard.isDown("space") then
                    grid.table[self.i][self.j] = cursor.material
                    grid.densityTable[self.i][self.j] = cursor.density
                end
            end
        end
    end

    function cursor:selectMaterial(key)                 -- select material you want to drop
        if key == "1" then
            self.material = sand.value
            --self.density = sand.density
            self.name = sand.name
        elseif key == "2" then
            self.material = soil.value
            self.density = soil.density
            self.name = soil.name
        elseif key == "3" then
            self.material = water.value
            --self.density = water.density
            self.name = water.name
        elseif key == "4" then
            self.material = oil.value
            self.density = oil.density
            self.name = oil.name
        elseif key == "5" then
            self.material = cloud.value
            --self.density = cloud.density
            self.name = cloud.name
        elseif key == "6" then
            self.material = smoke.value
            self.density = smoke.density
            self.name = smoke.name
        elseif key == "7" then
            self.material = steel.value
            self.density = steel.density
            self.name = steel.name
        elseif key == "q" then
            self.material = 0
            self.density = 0
            self.name = "Eraser"
        end
    end

    function cursor:draw()                              -- drawing cursor
        love.graphics.setColor(unpack(self.color))
        love.graphics.rectangle("line", grid.tableOriginX+(self.i*grid.cellSize), grid.tableOriginY+(self.j*grid.cellSize), grid.cellSize, grid.cellSize)
    end

    function cursor:displaySelectedMaterial()
        love.graphics.setColor(unpack(self.color))
        love.graphics.setFont(materialFont)
        love.graphics.printf("Selected Material: " .. self.name, 10, 10, 200, "left")
    end
end
