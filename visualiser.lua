--[[

]]

local visualiser = {}

-- Font
local font
local font_size = 15

-- time
local time = 0
local time_cap = 2 * math.pi
local speed = 1

-- The range of the graph
-- the 2 units should have the same length depending on the window dimensions
local aspect_ratio = love.graphics.getWidth() / love.graphics.getHeight()
local x_min, x_max = -10, 10
local y_min, y_max = x_min / aspect_ratio, x_max / aspect_ratio

-- The current position of the mouse
local x_pos, y_pos = 0, 0

-- The range and scale of the graph
local x_min_scale, x_max_scale, y_min_scale, y_max_scale = 0, 0, 0, 0
local x_range, y_range = 0, 0
local zoom_factor = 1

-- Step size for the graph
-- the step between each point on the graph
local step = 0.1

-- moving the graph
local is_moving = false
local x_pos_start, y_pos_start = 0, 0
local dx, dy = 0, 0

-- points
local points = {}

function f(x)
    -- The function to be visualised
    -- overcomplicated function for demonstration purposes
    return math.cos(math.pi * x) * math.sin(time - x)
end

function visualiser.load()
    -- Load the visualiser
end

function visualiser.update_range()
    -- Update the range of the graph
    -- The range of the graph should be updated based on the window dimensions
    aspect_ratio = love.graphics.getWidth() / love.graphics.getHeight()
    y_min, y_max = x_min / aspect_ratio, x_max / aspect_ratio
end

function visualiser.handle_input(key)
    -- Handle input for the visualiser
end

function visualiser.handle_mouse_press(x, y, button)
    -- Handle mouse press for the visualiser
    -- change x_min, x_max, y_min, y_max based on the button pressed
    -- in order to move the graph
    x_pos_start, y_pos_start = x, y
    is_moving = true
end

function visualiser.handle_mouse_release(x, y, button)
    -- Handle mouse release for the visualiser
    is_moving = false
end

function visualiser.handle_mouse_move(x, y)
    -- Update the current position of the mouse
    -- and update x_min, x_max, y_min, y_max based on the movement
    if is_moving then
        dx = x - x_pos_start
        dy = y - y_pos_start

        x_range = x_max - x_min
        y_range = y_max - y_min

        x_min = x_min - dx * x_range / love.graphics.getWidth()
        x_max = x_max - dx * x_range / love.graphics.getWidth()
        y_min = y_min + dy * y_range / love.graphics.getHeight()
        y_max = y_max + dy * y_range / love.graphics.getHeight()

        x_pos_start, y_pos_start = x, y
    end
end

function visualiser.handle_scroll(x, y)
    -- Update x_min, x_max, y_min, y_max based on the scroll direction
    -- The zoom needs to be centered around the mouse position
    x_pos, y_pos = love.mouse.getPosition()

    x_min_scale = x_min + x_pos / WINDOW_WIDTH * (x_max - x_min)
    x_max_scale = x_max - (WINDOW_WIDTH - x_pos) / WINDOW_WIDTH * (x_max - x_min)
    y_min_scale = y_min + (WINDOW_HEIGHT - y_pos) / WINDOW_HEIGHT * (y_max - y_min)
    y_max_scale = y_max - y_pos / WINDOW_HEIGHT * (y_max - y_min)

    if y > 0 then
        x_min = x_min + (x_min_scale - x_min) / 10
        x_max = x_max - (x_max - x_max_scale) / 10
        y_min = y_min + (y_min_scale - y_min) / 10
        y_max = y_max - (y_max - y_max_scale) / 10
    else
        x_min = x_min - (x_min_scale - x_min) / 10
        x_max = x_max + (x_max - x_max_scale) / 10
        y_min = y_min - (y_min_scale - y_min) / 10
        y_max = y_max + (y_max - y_max_scale) / 10
    end

    -- update font size
    local temp_font_size = 15 / zoom_factor
    if temp_font_size < 1 then
        font_size = 1
    else
        font_size = temp_font_size
    end
end

function visualiser.load()
    -- Load the visualiser
end

function visualiser.update(dt)
    -- Update the visualiser
    -- update the step size based on the zoom level and the window size
    step = 0.1 * (x_max - x_min) / love.graphics.getWidth()

    -- font size
    font = love.graphics.newFont("assets/fonts/NotoSansMath-Regular.ttf", font_size)

    -- update zoom factor based on x_min, x_max, y_min, y_max
    zoom_factor = (x_max - x_min) / 20
    print(zoom_factor)

    -- update the time
    time = time + speed * dt
    if time > time_cap then
        time = 0
    end
end

function visualiser.resize()
    -- Resize the visualiser
    visualiser.update_range()
end

function visualiser.draw()
    -- Draw the visualiser
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    local x_scale = width / (x_max - x_min)
    local y_scale = height / (y_max - y_min)

    love.graphics.setColor(1, 1, 1)

    -- move the line if the graph is moved
    love.graphics.line(0, height - (-y_min * y_scale), width, height - (-y_min * y_scale))
    love.graphics.line((0 - x_min) * x_scale, 0, (0 - x_min) * x_scale, height)

    -- draw the unit line depending on the window dimensions, x_min, x_max, y_min, y_max
    -- draw vertical unit line
    if zoom_factor < 7 then
        love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
        for x = math.ceil(x_min), math.floor(x_max) do
            local x_pixel = (x - x_min) * x_scale
            love.graphics.line(x_pixel, 0, x_pixel, height)
        end

        -- Draw horizontal unit lines
        for y = math.ceil(y_min), math.floor(y_max) do
            local y_pixel = height - (y - y_min) * y_scale
            love.graphics.line(0, y_pixel, width, y_pixel)
        end
    end

    -- draw the number labels
    -- this piece of shit is a lag machine
    if font_size > 5 then
        love.graphics.setFont(font)
        love.graphics.setColor(1, 1, 1)
        for x = math.ceil(x_min), math.floor(x_max) do
            local x_pixel = (x - x_min) * x_scale
            love.graphics.print(x, x_pixel + 2, height - (-y_min * y_scale))
        end

        -- do not draw the 0 label
        for y = math.ceil(y_min), math.floor(y_max) do
            if y ~= 0 then
                local y_pixel = height - (y - y_min) * y_scale
                love.graphics.print(y, (0 - x_min) * x_scale, y_pixel - 10)
            end
        end
    end

    love.graphics.setColor(1, 0, 0)
    points = {}
    for x = x_min, x_max, step do
        local y = f(x)
        local x_pixel = (x - x_min) * x_scale
        local y_pixel = height - (y - y_min) * y_scale
        table.insert(points, x_pixel)
        table.insert(points, y_pixel)
    end
    love.graphics.line(points)
end

return visualiser
