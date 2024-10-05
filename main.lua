local visualiser = require("visualiser")

-- The current game state
ALL_STATES = {"VISUALISER", "SETTINGS", "HELP"}
CURRENT_STATE = ALL_STATES[1]

-- Window dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
    love.window.setTitle("Function Visualiser")
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {resizable=true})
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
end

function love.update(dt)
    -- update window dimensions
    WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()

    if CURRENT_STATE == "VISUALISER" then
        visualiser.update(dt)
    end
end

function love.keypressed(key)
    if CURRENT_STATE == "VISUALISER" then
        visualiser.handle_input(key)
    end
end

function love.mousepressed(x, y, button)
    if CURRENT_STATE == "VISUALISER" then
        visualiser.handle_mouse_press(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    if CURRENT_STATE == "VISUALISER" then
        visualiser.handle_mouse_release(x, y, button)
    end
end

function love.mousemoved(x, y)
    if CURRENT_STATE == "VISUALISER" then
        visualiser.handle_mouse_move(x, y)
    end
end

function love.wheelmoved(x, y)
    if CURRENT_STATE == "VISUALISER" then
        visualiser.handle_scroll(x, y)
    end
end

function love.draw()
    if CURRENT_STATE == "VISUALISER" then
        visualiser.draw()
    end
end
