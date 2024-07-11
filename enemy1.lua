local Enemy1 = {}
local Player = require("player")
local Map = require("map")

function Enemy1:load()
    self.x = 3520
    self.y = 200
    self.width = 160
    self.height = 200
	self.damage = 1
    self.speed = 100
    self.speedMod = 1
    self.xVel = self.speed
	self.font2 = love.graphics.newFont("assets/PixelOperator.ttf", 18)

    self.color = {
        red = 1,
        green = 1,
        blue = 1,
        speed = 3,
    }

    self.life = 30000
    self.isDead = false
	self.deadTime = 5
	
	self:loadAssets()

    self.physics = {}
    
end

function Enemy1:loadAssets()
	self.animation = {timer = 0, rate = 0.1}
	self.animation.walk = {total = 5, current = 1, img = {}}
	
	for i = 1, self.animation.walk.total do
		self.animation.walk.img[i] = love.graphics.newImage("assets/boss/boss"..i..".png")
	end
	
	self.animation.draw = self.animation.walk.img[1]
	self.animation.width = self.animation.draw:getWidth()
	self.animation.height = self.animation.draw:getHeight()
end

function Enemy1:animate(dt)
	self.animation.timer = self.animation.timer + dt
	if self.animation.timer > self.animation.rate then 
		self.animation.timer = 0
		self:setNewFrame()
	end
end

function Enemy1:setNewFrame()
	local anim = self.animation.walk
	if anim.current < anim.total then
		anim.current = anim.current + 1
	else
		anim.current = 1
	end
	self.animation.draw = anim.img[anim.current]
end


function Enemy1:takeDamage(amount)
    self:tintRed()
    if self.life - amount > 0 then
        self.life = self.life - amount
    else
        self.life = 0
        self.isDead = true
    end
end

function Enemy1:tintRed()
    self.color.green = 0
    self.color.blue = 0
end

function Enemy1:unTint(dt)
    self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
    self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
    self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
end

function Enemy1:update(dt)
	self.currentLevel = 
    self:unTint(dt)
	self:animate(dt)
    --print(self.x, self.y)
    --self:resetPosition()
    -- Verifique se o inimigo está morto antes de atualizar
    if Map.currentLevel == 3 then
        if not self.isDead then
            self:syncPhysics()
        end
    end
    self:remove()
    
end

function Enemy1:remove()
	if self.isDead then
		self.x = 0
		self.y = 0
		self.width = 0
		self.height = 0
        if self.physics.body:isDestroyed() == false then
            self.physics.body:destroy()
        end
    end
	if self.currentLevel == 2 then
		self.x = 0
		self.y = 0
		self.width = 0
		self.height = 0
        if self.physics.body:isDestroyed() == false then
            self.physics.body:destroy()
        end
	end
end

function Enemy1:syncPhysics()
    if Map.currentLevel == 3 then
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

function Enemy1:flipDirection()
    self.xVel = -self.xVel

end

function Enemy1:incrementRage()
	if self.life < 10000 then
		--self.state = "run"
		self.speedMod = 2
		--self.rageCounter = 0
    end
end

function Enemy1:beginContact(a, b, collision)
	if a == self.physics.fixture or b == self.physics.fixture then
		if a == Player.physics.fixture or b == Player.physics.fixture then
			Player:takeDamage(self.damage)
			return true
		end
        self:flipDirection()
        self:incrementRage()
	end
end

function Enemy1:draw()
    local scaleX = -1
	if self.xVel < 0 then
		scaleX = 1
	end 
    if not self.isDead then
        love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
        --love.graphics.rectangle("line", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
        love.graphics.setFont(self.font2)
        love.graphics.print(self.life, self.x - self.width/2, self.y - self.height/2 - 30)
		love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, 1, self.width /2, self.height /2)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return Enemy1
