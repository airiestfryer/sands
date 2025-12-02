function cursorInitialize()
    cursor = {}
    cursor.__index = cursor
    cursor.i = 1
    cursor.j = 1
    cursor.material = 1
    cursor.density = 30
    cursor.color = {0, 1, 0, 0.5}

    function cursor:move()
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

    function cursor:drop()                              -- drops a pixel of selected material
        if love.keyboard.isDown("space") then
            grid.table[self.i][self.j] = cursor.material
            grid.densityTable[self.i][self.j] = cursor.density
        end
    end

    function cursor:selectMaterial(key)                 -- select material you want to drop
        if key == "1" then
            self.material = sand.value
            self.density = sand.density
        end

        if key == "2" then
            self.material = water.value
            self.density = water.density
        end

        if key == "3" then
            self.material = oil.value
            self.density = oil.density
        end

        if key == "4" then
            self.material = cloud.value
            self.density = cloud.density
        end

        if key == "5" then
            self.material = steel.value
            self.density = steel.density
        end
    end

    function cursor:draw()                              -- drawing cursor
        love.graphics.setColor(unpack(self.color))
        love.graphics.rectangle("line", grid.tableOriginX+(self.i*grid.cellSize), grid.tableOriginY+(self.j*grid.cellSize), grid.cellSize, grid.cellSize)
    end
end