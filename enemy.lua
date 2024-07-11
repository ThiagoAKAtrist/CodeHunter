local Enemy = {}
local Player = require("player")
local Map = require("map")

function Enemy:load()
    self.x = 3360
    self.y = 200
    self.width = 100
    self.height = 100
	self.damage = 1
    self.speed = 100
    self.speedMod = 1
    self.xVel = self.speed
	self.font2 = love.graphics.newFont("assets/PixelOperator.ttf", 15)

    self.color = {
        red = 1,
        green = 1,
        blue = 1,
        speed = 3,
    }

    self.life = 5000
    self.isDead = false
	self.deadTime = 5
	
	self:loadAssets()

    self.physics = {}
end

function Enemy:loadAssets()
	self.animation = {timer = 0, rate = 0.1}
	self.animation.walk = {total = 2, current = 1, img = {}}
	
	for i = 1, self.animation.walk.total do
		self.animation.walk.img[i] = love.graphics.newImage("assets/enemy/enemy"..i..".png")
	end
	
	self.animation.draw = self.animation.walk.img[1]
	self.animation.width = self.animation.draw:getWidth()
	self.animation.height = self.animation.draw:getHeight()
end

function Enemy:animate(dt)
	self.animation.timer = self.animation.timer + dt
	if self.animation.timer > self.animation.rate then 
		self.animation.timer = 0
		self:setNewFrame()
	end
end

function Enemy:setNewFrame()
	local anim = self.animation.walk
	if anim.current < anim.total then
		anim.current = anim.current + 1
	else
		anim.current = 1
	end
	self.animation.draw = anim.img[anim.current]
end


function Enemy:takeDamage(amount)
    self:tintRed()
    print(self.life)
    if self.life - amount > 0 then
        self.life = self.life - amount
    else
        self.life = 0
        self.isDead = true
    end
end

function Enemy:tintRed()
    self.color.green = 0
    self.color.blue = 0
end

function Enemy:unTint(dt)
    self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
    self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
    self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
end

function Enemy:update(dt)
	self.currentLevel = Map.currentLevel
    self:unTint(dt)
	self:animate(dt)
    --self:resetPosition()
    -- Verifique se o inimigo está morto antes de atualizar
    if not self.isDead and self.currentLevel == 2 then
        self:syncPhysics()
    end
    if Map.currentLevel == 3 then
        self.y = 800
    end
    self:remove()
    
end

function Enemy:syncPhysics()
    if Map.currentLevel == 2 then
        -- Crie o corpo físico apenas no Map 2
        if self.physics.body == nil then
            self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
            self.physics.body:setFixedRotation(true)
            self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
            self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
            self.physics.fixture:setCategory(2)
            self.physics.fixture:setMask(2)
        end

        if not self.physics.body:isDestroyed() then
            self.x, self.y = self.physics.body:getPosition()
            self.physics.body:setLinearVelocity(self.xVel * self.speedMod, 100)
        end
    end
end

function Enemy:remove()
	if self.isDead then
		self.x = 0
		self.y = 0
		self.width = 0
		self.height = 0
        if self.physics.body:isDestroyed() == false then
            self.physics.body:destroy()
        end
    end
	if self.currentLevel == 3 then
		self.x = 0
		self.y = 0
		self.width = 0
		self.height = 0
        if self.physics.body:isDestroyed() == false then
            self.physics.body:destroy()
        end
	end
end


function Enemy:flipDirection()
    self.xVel = -self.xVel

end

function Enemy:incrementRage()
	if self.life < 1500 then
		--self.state = "run"
		self.speedMod = 3
		--self.rageCounter = 0
    end
end

function Enemy:beginContact(a, b, collision)
	if a == self.physics.fixture or b == self.physics.fixture then
		if a == Player.physics.fixture or b == Player.physics.fixture then
			Player:takeDamage(self.damage)
			return true
		end
        self:flipDirection()
        self:incrementRage()
	end
end

function Enemy:draw()
    local scaleX = -1
	if self.xVel < 0 then
		scaleX = 1
	end 
    if not self.isDead then
        love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
        --love.graphics.rectangle("line", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
        love.graphics.setFont(self.font2)
        love.graphics.print(self.life, self.x - self.width/2, self.y - self.height + 30)
		love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, 1, self.width /2, self.height /2)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return Enemy
