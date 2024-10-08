--[[
    main.lua

    The main entry point for the application. This file is responsible for
    setting up the game window and loading the visualiser module.

    Authors:
    philzphaz

    Date:
    2024
]]

local visualiser = require("visualiser")

-- The current game state
ALL_STATES = {"VISUALISER", "SETTINGS", "HELP"}
CURRENT_STATE = ALL_STATES[1]

-- Window dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Music
local source
local source_index = 1

function love.load()
    love.window.setTitle("Function Visualiser")
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {resizable=true})
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    source = {
        love.audio.newSource("assets/music/derive-time.mp3", "stream"),
        love.audio.newSource("assets/music/graphical-dreams.mp3", "stream"),
        love.audio.newSource("assets/music/integrate-time.mp3", "stream"),
        love.audio.newSource("assets/music/ti-cs.mp3", "stream"),
    }

    -- Load the visualiser
    visualiser.load()
    visualiser.update_range()
end

function love.update(dt)
    -- update window dimensions
    WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()

    if CURRENT_STATE == "VISUALISER" then
        visualiser.update(dt)
    end

    -- music
    if not source[source_index]:isPlaying() then
        source_index = source_index + 1
        if source_index > #source then
            source_index = 1
        end
        source[source_index]:play()
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

function love.resize(w, h)
    -- update window dimensions
    if CURRENT_STATE == "VISUALISER" then
        visualiser.resize()
    end
end

function love.draw()
    if CURRENT_STATE == "VISUALISER" then
        visualiser.draw()
    end
end
