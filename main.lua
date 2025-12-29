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

    servingPlayer = 1
    winningPlayer = 0

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
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'
            pelota:reset()

            player1Score = 0
            player2Score = 0
            
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

function love.update(dt)
    if gameState == 'serve' then
        pelota.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            pelota.dx = math.random(140, 200)
        else
            pelota.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then
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

        -- Score Jugador 2
        if pelota.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1

            if player2Score == 2 then
                winningPlayer = 2
                gameState = 'done'
            else
                pelota:reset()
                gameState = 'serve'
            end
        end  
        -- Score Jugador 1
        if pelota.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1

            if player1Score == 2 then
                winningPlayer = 1
                gameState = 'done'
            else
                pelota:reset()
                gameState = 'serve'
            end
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
    -- llamada a ver Puntaje
    verPuntaje()
    
    love.graphics.setFont(smallFont)
    -- Dibujar segun Estado
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Bienvenido a Pong Clone!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Enter para Empezar', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Jugador ' .. tostring(servingPlayer) .. " sirviendo ", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Enter para Jugar!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- jugar
    elseif gameState == 'done' then
        -- UI messages
        love.graphics.setFont(largeFont)
        love.graphics.printf('Jugador ' .. tostring(winningPlayer) .. ' Gano!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Enter para Reiniciar!', 0, 50, VIRTUAL_WIDTH, 'center')
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

function verPuntaje()
    love.graphics.setFont(largeFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end

function verFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0,1,0,1)
    love.graphics.print('FPS: '..tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1,1,1,1)
end

