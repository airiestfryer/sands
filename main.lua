function love.load()
    -- modules
    require "modules/grid"
    require "modules/particle"
    require "modules/cursor"

    -- setting window size
    windowWidth, windowHeight = love.window.getDesktopDimensions()
    love.window.setMode(windowWidth, windowHeight)

    -- setting up grid
    gridInitialize()
    grid:clear()

    -- initializing all particles
    dynamicParticlesInitialzie()
    staticParticlesInitialize()

    -- initializing cursor
    cursorInitialize()
end

function love.update(dt)
    grid:update(dt)

    -- cursor update
    cursor:move()
    cursor:drop()
end

function love.draw()
    grid:draw()
    grid:drawBorder()
    cursor:draw()

    -- instructions
    love.graphics.printf("arrows to move cursor\nspace to drop material\n1, 2 to select materials\nx to clear\nescape to exit", 0, 0, windowWidth, "center")
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "x" then
        grid:clear()
    end

    cursor:selectMaterial(key)
end