-- https://github.com/Ulydev/push
push = require "push"
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'
-- Importar clase Pelota
require 'Pelota'
-- Importar clase Paleta
require 'Paleta'

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

PADDLE_SPEED = 200

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    -- Configurar titulo de ventana
    love.window.setTitle('Clone Pong')
    --"seed" RNG
    math.randomseed(os.time())
    
    largeFont = love.graphics.newFont('font.ttf', 32)
    smallFont = love.graphics.newFont('font.ttf', 8)

    player1Score = 0
    player2Score = 0

    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH, 
        WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- Crear objeto pelota usando clase Pelota
    pelota = Pelota(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    -- Crear objetos jugador con clase Paleta
    jugador1 = Paleta(10, 30, 5, 20)
    jugador2 = Paleta(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    gameState = 'start'
end

function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            -- Reiniciar Pelota
            pelota:reset()
        end
    end
end

function love.update(dt)
    if gameState == 'play' then
        -- Verificar colisiones entre pelota y jugador 1
        if pelota:colision(jugador1) then
            pelota.dx = -pelota.dx * 1.03
            pelota.x = jugador1.x + 5

            if pelota.dy < 0 then
                pelota.dy = -math.random(10, 150)
            else
                pelota.dy = math.random(10, 150)
            end
        end
        -- Verificar colisiones entre pelota y jugador 2
        if pelota:colision(jugador2) then
            pelota.dx = -pelota.dx * 1.03
            pelota.x = jugador2.x - 4

            if pelota.dy < 0 then
                pelota.dy = -math.random(10, 150)
            else
                pelota.dy = math.random(10, 150)
            end
        end
        -- Detectar bordes y cambiar direccion
        if pelota.y <= 0 then
            pelota.y = 0
            pelota.dy = -pelota.dy
        end

        if pelota.y >= VIRTUAL_HEIGHT - 4 then
            pelota.y = VIRTUAL_HEIGHT - 4
            pelota.dy = -pelota.dy
        end
    end

    -- movimiento jugador 1
    if love.keyboard.isDown('w') then
        jugador1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        jugador1.dy = PADDLE_SPEED
    else
        jugador1.dy = 0
    end
    -- movimiento jugador 2
    if love.keyboard.isDown('up') then
        jugador2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        jugador2.dy = PADDLE_SPEED
    else
        jugador2.dy = 0
    end
   
    if gameState == 'play' then
        pelota:update(dt)
    end
    -- Actualizar objetos jugador
    jugador1:update(dt)
    jugador2:update(dt)
end

function love.draw()

    push:start()
    love.graphics.clear(40/255, 45/255, 52/255,1)
    -- texto
    love.graphics.setFont(largeFont)
    love.graphics.printf(" Hola, Pong! ", 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 + 80)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 2 + 80)
    
    love.graphics.setFont(smallFont)
    -- Ver Estado
    if gameState == 'start' then
        love.graphics.printf('Estado Start!', 0, 60, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Estado Play!', 0, 60, VIRTUAL_WIDTH, 'center')
    end
    
    -- paleta 1
    jugador1:render()
    -- paleta 2
    jugador2:render()
    -- ball
    pelota:render()
    -- llamada a ver FPS
    verFPS()

    push:finish()
end

function verFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0,1,0,1)
    love.graphics.print('FPS: '..tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1,1,1,1)
end

