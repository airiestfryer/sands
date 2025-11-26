function gridInitialize()
    grid = {}
    grid.__index = grid
    grid.cellSize = 10
    grid.rows = 30
    grid.columns = 30

    grid.table = {}
    grid.tableOriginX = 500
    grid.tableOriginY = 200
    grid.timer = 0
    grid.timerEnd = 0.5

    function grid:clear()
        for i = 1, self.rows do 
            self.table[i] = {}
            for j = 1, self.columns do
                self.table[i][j] = 0
            end
        end
    end

    function grid:update(dt)
        self.timer = self.timer + dt
        if self.timer > self.timerEnd then
            for i = 1, self.rows do
                for j = 1, self.columns do
                    if self.table[i][j] == 1 and self.table[i][j+1] == 0 then
                        self.table[i][j] = 0
                        self.table[i][j+1] = 1
                    end
                end
            end
            self.timer = 0
        end
    end

    function grid:draw()
        for i = 1, self.rows do
            for j = 1, self.columns do
                if self.table[i][j] == 0 then
                    love.graphics.rectangle("line", self.tableOriginX+(i*10), self.tableOriginY+(j*10), self.cellSize, self.cellSize)
                else
                    --love.graphics.setColor(0, 0, 0)
                    love.graphics.rectangle("fill", self.tableOriginX+(i*10), self.tableOriginY+(j*10), self.cellSize, self.cellSize)
                end
            end
        end
    end
end




--[[
table = {
          j  j  j   
       i {0, 0, 0},  
       i {0, 0, 0},  
       i {0, 0, 0},  
    }
]]