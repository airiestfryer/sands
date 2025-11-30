function gridInitialize()
    grid = {}
    grid.__index = grid
    grid.cellSize = 10
    grid.rows = 135
    grid.columns = 70

    grid.table = {}
    grid.dataTable = {}
    grid.tableOriginX = 0
    grid.tableOriginY = 55
    grid.timer = 0
    grid.timerEnd = 0

    grid.borderWidth = grid.cellSize * grid.rows
    grid.borderHeight = grid.cellSize * grid.columns

    function grid:clear()
        for i = 1, self.rows do 
            self.table[i] = {}
            self.dataTable[i] = {}
            for j = 1, self.columns do
                self.table[i][j] = 0
                self.dataTable[i][j] = 0
            end
        end
    end

    function grid:clearDataTable()
        for i = 1, self.rows do 
            self.dataTable[i] = {}
            for j = 1, self.columns do
                self.dataTable[i][j] = 0
            end
        end
    end

    function grid:update(dt)
        self.timer = self.timer + dt
        if self.timer > self.timerEnd then
            for i = 1, self.rows do
                for j = 1, self.columns do
                    if self.table [i][j] ~= 0 then
                        if self.dataTable[i][j] == 0 then
                            if self.table[i][j] == sand.value then
                                sand:update(i, j)
                            elseif self.table[i][j] == water.value then
                                water:update(i, j)
                            elseif self.table[i][j] == cloud.value then
                                cloud:update(i, j)
                            end
                        end
                    end
                end
            end
            self.timer = 0
            self:clearDataTable()
        end
    end

    function grid:draw()
        for i = 1, self.rows do
            for j = 1, self.columns do
                if self.table[i][j] == 0 then
                    --love.graphics.setColor(1, 1 ,1, .1)
                    --love.graphics.rectangle("line", self.tableOriginX+(i*self.cellSize), self.tableOriginY+(j*self.cellSize), self.cellSize, self.cellSize)
                elseif self.table[i][j] == sand.value then
                    sand:draw(i, j, self.tableOriginX, self.tableOriginY, self.cellSize)
                elseif self.table[i][j] == water.value then
                    water:draw(i, j, self.tableOriginX, self.tableOriginY, self.cellSize)
                elseif self.table[i][j] == cloud.value then
                    cloud:draw(i, j, self.tableOriginX, self.tableOriginY, self.cellSize)
                elseif self.table[i][j] == steel.value then
                    steel:draw(i, j, self.tableOriginX, self.tableOriginY, self.cellSize)
                end
            end
        end
    end

    function grid:drawBorder()
        love.graphics.setColor(1, 1, 1, 0.3)
        love.graphics.rectangle("line", self.tableOriginX+self.cellSize, self.tableOriginY+self.cellSize, self.borderWidth, self.borderHeight)
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