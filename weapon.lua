
local Weapon = {}
local Player = require("player")
local Enemy = require("enemy")
local Enemy1 = require("enemy1")
local Map = require("map")

Weapon.cheatCount = 0
Weapon.damage = 1
Weapon.cheatDamage = Weapon.damage

function Weapon:load(dt)
	self.x, self.y = Player.physics.body:getPosition()
	self.width = 40
	self.height = 20
	self.direction = Player.direction
	self.collision = false
	self.scaleX = 1
	self.level = Map.currentLevel
	self.cheat = false
	self.attack = true
	
	self.attackTimer = 0.6
	
	self:loadAssets()
	
	x1, y1, w1, h1 = self.x, self.y, self.width, self.height	
	x2, y2, w2, h2 = Enemy.x, Enemy.y, Enemy.width, Enemy.height
	x3, y3, w3, h3 = Enemy1.x, Enemy1.y, Enemy1.width, Enemy1.height
	
end

function Weapon:update(dt)
	self.level = Map.currentLevel
	self:animate(dt)
	if self.direction == "left" then
		self.scaleX = -1
	end
	if self.attackTimer > 0 then
		self.attackTimer = self.attackTimer - dt
	end
	
	if Map.currentLevel == 2 then
	if self.attackTimer > 0 then
		if self.x + self.width > Enemy.x - Enemy.width/2 and self.x < Enemy.x + Enemy.width / 2 and self.y + self.height > Enemy.y - Enemy.height/2 and self.y < Enemy.y + Enemy.height / 2 then
			self.collision = true
			Enemy:takeDamage(self.cheatDamage)
			if Player.direction == "right" then
				Player.direction = "right"
			end
		else
			self.collision = false
		end
	else
		self.collision = false
	end
	end
	if Map.currentLevel == 3 then
	if self.attackTimer > 0 then
		if self.x + self.width > Enemy1.x - Enemy1.width/2 and self.x < Enemy1.x + Enemy1.width / 2 and self.y + self.height > Enemy1.y - Enemy1.height/2 and self.y < Enemy1.y + Enemy1.height / 2 then
			self.collision = true
			Enemy1:takeDamage(self.cheatDamage)
			if Player.direction == "right" then
				Player.direction = "right"
			end
		else
			self.collision = false
		end
	else
		self.collision = false
	end
	end
end

function Weapon:loadAssets()
	self.animation = {timer = 0, rate = 0.1}
	self.animation.cut = {total = 8, current = 1, img = {}}
	for i = 1, self.animation.cut.total do
		self.animation.cut.img[i] = love.graphics.newImage("assets/weapon/cut/cut"..i..".png")
	end
	
	self.animation.draw = self.animation.cut.img[1]
	self.animation.width = self.animation.draw:getWidth()
	self.animation.height = self.animation.draw:getHeight()

end

function Weapon:cut(key, Enemy)
	if key == "space" then
		Player.isAttacking = 0.5
		
		self:load()
		--print(string.format("%.0f > %.0f", x1 + w1, x2 - w2/2))
		--print(string.format("%.0f < %.0f", x1 - w1, x2 + w2/2))
		--print(string.format("%.0f > %.0f", y1 + h1, y2 - h2/2))
		--print(string.format("%.0f < %.0f", y1, y2 + h2 / 2))
		--print(collisionCheck(x1, y1, w1, h1, x2, y2, w2, h2))
		if Map.currentLevel == 2 or Map.currentLevel == 3 then
			print(Enemy.physics.body:isDestroyed())
			print(Enemy.y)
			print(Map.currentLevel)
		end
		if Map.currentLevel == 3 then
			Enemy:takeDamage(self.damage*1000)
			--print(Enemy1.physics.body:isDestroyed())
		end
		if Player.direction == "right" then
			self.x, self.y = Player.physics.body:getPosition()
		elseif Player.direction == "left" then
			self.x = Player.x - 40
			self.y = Player.y
		end
		if collisionCheck(x1, y1, w1, h1, x2, y2, w2, h2) then
			if self.attackTimer > 0 then 
				self.collision = true
			else
				self.collision = false
			end
		end
		if collisionCheck(x1, y1, w1, h1, x3, y3, w3, h3) then
			if self.attackTimer > 0 then 
				self.collision = true
			else
				self.collision = false
			end
		end
		
	end
end

function Weapon:sizeCheat(key)
	if key == "o" and self.cheat == false then
		if Player.coins > 0 then
			self.cheatDamage = self.cheatDamage + 1
			Player.coins = Player.coins - 1
			self.cheatCount = self.cheatCount + 1
			print(self.cheatDamage)
			print(Player.coins)
			print(self.cheatCount)
		end
	elseif key == "l" then
		if self.cheatCount > 0 then
			self.cheatDamage = self.cheatDamage - 1
			self.cheatCount = self.cheatCount - 1
			Player.coins = Player.coins + 1
			print(self.cheatDamage)
			print(Player.coins)
			print(self.cheatCount)
		end
	end
end

function Weapon:animate(dt)
	self.animation.timer = self.animation.timer + dt
	if self.animation.timer > self.animation.rate then 
		self.animation.timer = 0
		self:setNewFrame()
	end
end

function Weapon:setNewFrame()
	local anim = self.animation.cut
	if anim.current < anim.total then
		anim.current = anim.current + 1
	else
		anim.current = 1
	end
	self.animation.draw = anim.img[anim.current]
end

function collisionCheck(x1, y1, w1, h1, x2, y2, w2, h2)
	--x1, y1, w1, h1 = self.x, self.y, self.width, self.height	
	--x2, y2, w2, h2 = Enemy.x, Enemy.y, Enemy.width, Enemy.height
    return x1 + w1 > x2 - w2 / 2  and
           x1 - w1 < x2 + w2/2 and
           y1 + h1  > y2 - h2 / 2  and
           y1 < y2 + h2/2
end

function Weapon:beginContact(a, b, collision)
	if Map.currentLevel == 2 then
		if self.collision then
			Enemy:takeDamage(self.cheatDamage)
		end
	end
	if Map.currentLevel == 3 then
		if self.collision then
			Enemy1:takeDamage(self.cheatDamage)
		end
	end
end


function Weapon:draw()
	
	
	
	if self.attackTimer > 0 then
		--if self.x + self.width > Enemy.x - Enemy.width/2 and self.x < Enemy.x + Enemy.width / 2 and self.y + self.height > Enemy.y - Enemy.height/2 and self.y < Enemy.y + Enemy.height / 2 then
		--	love.graphics.setColor(1,0,0)
		--else
		--	love.graphics.setColor(1,1,1)
		--end
		--love.graphics.rectangle("line", self.x, self.y, self.animation.width, self.animation.height)
		love.graphics.draw(self.animation.draw, self.x + 20, self.y + 10, 0, self.scaleX, 1, self.animation.width/2, self.animation.height/2)
	end
end


function Weapon:hit(collision)
	self.currentEnemyCollision = collision
	
end


return Weapon