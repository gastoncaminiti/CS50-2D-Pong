push = require "push"

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

PADDLE_SPEED = 200

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    largeFont = love.graphics.newFont('font.ttf', 32)
    smallFont = love.graphics.newFont('font.ttf', 8)

    player1Score = 0
    player2Score = 0

    player1Y = 10
    player2Y = VIRTUAL_HEIGHT - 30

    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH, 
        WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)

    if love.keyboard.isDown('w') then
        player1Y = math.max(0,player1Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 20,player1Y + PADDLE_SPEED * dt)
    end

    if love.keyboard.isDown('up') then
        player2Y = math.max(0,player2Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20,player2Y + PADDLE_SPEED * dt)
    end
   
end

function love.draw()
    push:start()
    love.graphics.clear(40/255, 45/255, 52/255,1)
    -- texto
    love.graphics.setFont(largeFont)
    love.graphics.printf(" Hola, Pong! ", 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 + 80)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 2 + 80)
    -- paleta 1
    love.graphics.rectangle('fill', 10, player1Y, 5,20)
    -- paleta 2
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 15, player2Y, 5,20)
    -- ball
        love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2-2, 4,4)
    push:finish()
end
