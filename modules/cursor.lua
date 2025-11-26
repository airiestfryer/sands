function cursorInitialize()
    cursor = {}
    cursor.__index = cursor
    cursor.i = 1
    cursor.j = 1

    function cursor:draw()
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.rectangle("line", grid.tableOriginX+(self.i*10), grid.tableOriginY+(self.j*10), grid.cellSize, grid.cellSize)
        love.graphics.setColor(.5, .5, .5, 1)
    end
end