function love.load()
    -- modules
    require "modules/grid"
    require "modules/particle"
    require "modules/cursor"

    -- setting window size
    windowWidth, windowHeight = love.window.getDesktopDimensions()
    love.window.setMode(windowWidth, windowHeight)

    -- gamestate
    gamePaused = false

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

    -- setting background color
    love.graphics.setBackgroundColor(0, 0.3, 0.1)
end

function love.update(dt)
    -- cursor updates
    cursor:move()
    cursor:drop()

    -- game grid updates
    if gamePaused == false then
        grid:update(dt)
        grid:updateDensityTable()
    else
        --nothing happens
    end
end

function love.draw()
    grid:draw()
    grid:drawBorder()
    --grid:drawDensities()
    
    cursor:draw()
    cursor:displaySelectedMaterial()

    if gamePaused then
        love.graphics.printf("Paused >", windowWidth-(windowWidth/12), 10, 100, "right")
    end

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

    if key == "tab" then
        gamePaused = not gamePaused
    end

    cursor:selectMaterial(key)
end