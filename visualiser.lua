local visualiser = {}

-- time
local time = 0

-- Window dimensions
local x_min = -10
local x_max = 10
local y_min = -10
local y_max = 10

-- The current position of the mouse
local x_pos, y_pos = 0, 0

-- The range and scale of the graph
local x_min_scale, x_max_scale, y_min_scale, y_max_scale = 0, 0, 0, 0
local x_range, y_range = 0, 0

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
    -- return math.cos(math.pi * x) * math.sin(a - x)
    return math.sin(x + time) + math.sin(2 * x + time) + math.sin(3 * x + time) + math.sin(4 * x + time) + math.sin(5 * x + time) + math.sin(6 * x + time) + math.sin(7 * x + time) + math.sin(8 * x + time) + math.sin(9 * x + time) + math.sin(10 * x + time)
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
end

function visualiser.load()
    -- Load the visualiser
end

function visualiser.update(dt)
    -- Update the visualiser
    -- update the step size based on the zoom level and the window size
    step = 0.1 * (x_max - x_min) / love.graphics.getWidth()


    -- update the time
    time = time + dt
    if time > 6.28318530718 then
        time = 0
    end
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
