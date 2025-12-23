Pelota = Class {}

function Pelota:init(x,y, ancho, alto)
    self.x = x
    self.y = y
    self.ancho = ancho
    self.alto = alto
    -- Pelota Direccion Random
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50,50)
end 

function Pelota:reset()
    self.x = VIRTUAL_WIDTH / 2-2
    self.y = VIRTUAL_HEIGHT / 2-2
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50,50)
end

function Pelota:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Pelota:render()
    love.graphics.rectangle('fill', self.x, self.y, self.ancho, self.alto)
end

function Pelota:colision(paleta)

    if self.x > paleta.x + paleta.ancho or paleta.x > self.x + self.ancho then
        return false
    end

    if self.y > paleta.y + paleta.alto or paleta.y > self.y + self.alto then
        return false
    end

    return true
end