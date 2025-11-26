function love.load()
    -- modules
    require "modules/grid"
    require "modules/particle"
    require "modules/cursor"

    -- setting window size
    local windowWidth, windowHeight = love.window.getDesktopDimensions()
    love.window.setMode(windowWidth, windowHeight)

    -- setting up grid
    gridInitialize()
    cursorInitialize()
    grid:clear()
end

function love.update(dt)
    grid:update(dt)
end

function love.draw()
    grid:draw()
    cursor:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "space" then
        grid.table[cursor.i][cursor.j] = 1
    end

    if key == "x" then
        grid:clear()
    end

    if key == "up" then
        cursor.j = cursor.j - 1
    end

    if key == "down" then
        cursor.j = cursor.j + 1
    end

    if key == "left" then
        cursor.i = cursor.i - 1
    end

    if key == "right" then
        cursor.i = cursor.i + 1
    end
end