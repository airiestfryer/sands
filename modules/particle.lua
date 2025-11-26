function checkBelow(grid, i, j)
    if grid[i-1][j] == 0 then
        grid[i][j] = 0
        grid[i-1][j] = 1
    end
end

dynamicParticle = {}
dynamicParticle.__index = dynamicParticle

function dynamicParticle:new(name)
    name = {}
    setmetatable(name, self)
end

function dynamicParticle:fall()
    checkBelow()
end