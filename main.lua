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

    -- font
    defaultFont = love.graphics.newFont(12)
end

function love.update(dt)
    grid:update(dt)
    grid:updateDensityTable()

    -- cursor update
    cursor:move()
    cursor:drop()
end

function love.draw()
    grid:draw()
    grid:drawBorder()
    --grid:drawDensities()
    
    cursor:draw()
    cursor:displaySelectedMaterial()

    -- instructions
    love.graphics.setFont(defaultFont)
    love.graphics.printf("z to change cursor movement method (mouse and arrows)\nmouse 1 or space to drop material\n1, 2, 3, 4, 5 to select materials\nx to clear\nescape to exit", 0, 0, windowWidth, "center")
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "x" then
        grid:clear()
    end

    if key == "z" then
        cursor.mouseMovement = not cursor.mouseMovement
    end

    cursor:selectMaterial(key)
end