function cursorInitialize()
    cursor = {}
    cursor.__index = cursor
    cursor.i = 1
    cursor.j = 1
    cursor.material = 1

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

    function cursor:drop()                          -- drops a pixel of selected material
        if love.keyboard.isDown("space") then
            grid.table[self.i][self.j] = cursor.material
        end
    end

    function cursor:selectMaterial(key)                -- select material you want to drop
        if key == "1" then
            self.material = 1
        end

        if key == "2" then
            self.material = 2
        end
    end

    function cursor:draw()
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.rectangle("line", grid.tableOriginX+(self.i*10), grid.tableOriginY+(self.j*10), grid.cellSize, grid.cellSize)
    end
end