Paleta = Class {}

function Paleta:init(x,y, ancho, alto)
    self.x = x
    self.y = y
    self.ancho = ancho
    self.alto = alto
    self.dy = 0
end 

function Paleta:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.alto, self.y + self.dy * dt)
    end
end

function Paleta:render()
    love.graphics.rectangle('fill', self.x, self.y, self.ancho, self.alto)
end