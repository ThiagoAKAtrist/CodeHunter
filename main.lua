love.graphics.setDefaultFilter("nearest", "nearest")
local Player = require("player")
local Coin = require("coin")
local GUI = require("gui")
local Spike = require("spike")
local Stone = require("stone")
local Camera = require("camera")
local Enemy = require("enemy")
local Enemy1 = require("enemy1")
local Map = require("map")
local Weapon = require("weapon")


function love.load()
	
	Map:load()
	background = love.graphics.newImage("assets/background.png")
	background2 = love.graphics.newImage("assets/glitch.png")
	GUI:load()
	Player:load()
	Weapon:load()
	Enemy:load()
	Enemy1:load()
	--World:setCallbacks(Weapon.beginContact)
end

function love.update(dt)
	World:update(dt)
	Player:update(dt)
	Coin.updateAll(dt)
	Spike.updateAll(dt)
	Stone.updateAll(dt)
	if Map.currentLevel == 2 then
		Enemy:update(dt)
	end
	if Map.currentLevel == 3 then
		Enemy.isDead = true
		Enemy1:update(dt)
	end
	Weapon:update(dt)
	GUI:update(dt)
	Camera:setPosition(Player.x, 0)
	Map:update(dt)
end


function love.draw()
	if Map.currentLevel <= 3 then
		love.graphics.draw(background)
	elseif Map.currentLevel > 3 then
		love.graphics.draw(background2)
	end
	Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
	GUI:drawTutorialMessage()
	GUI:endMessage()
	GUI:inventory()
	Camera:apply()
	Player:draw()
	if Map.currentLevel == 2 then
		Enemy:draw()
	end
	if Map.currentLevel == 3 then
		Enemy1:draw()
	end
	Coin.drawAll()
	Spike.drawAll()
	Stone.drawAll()
	Weapon:draw("space")
	
	Camera:clear()
	
	
	GUI:draw()
end

function love.keypressed(key)
	Player:jump(key)
	Player:jumpCheat(key)
	Player:lifeCheat(key)
	Player:setState(key)
	GUI:cheatInv(key)
	Weapon:sizeCheat(key)
	Weapon:cut(key, Enemy)
end

function collisionCheck(x1, y1, w1, h1, x2, y2, w2, h2)
	--x1, y1, w1, h1 = self.x, self.y, self.width, self.height	
	--x2, y2, w2, h2 = Enemy.x, Enemy.y, Enemy.width, Enemy.height
    return x1 + w1 > x2 - w2 / 2  and
           x1 - w1 < x2 + w2/2 and
           y1 + h1  > y2 - h2 / 2  and
           y1 < y2 + h2/2
end

function collisionCheck(x1, y1, w1, h1, x3, y3, w3, h3)
	--x1, y1, w1, h1 = self.x, self.y, self.width, self.height	
	--x2, y2, w2, h2 = Enemy.x, Enemy.y, Enemy.width, Enemy.height
    return x1 + w1 > x2 - w2 / 2  and
           x1 - w1 < x2 + w2/2 and
           y1 + h1  > y2 - h2 / 2  and
           y1 < y2 + h2/2
end

function beginContact(a, b, collision)
	if Coin.beginContact(a, b, collision) then return end
	if Spike.beginContact(a, b, collision) then return end
	
	if Map.currentLevel == 2 then
		Enemy:beginContact(a, b, collision)
	end
	if Map.currentLevel == 3 then
		Enemy1:beginContact(a, b, collision)
	end
	Player:beginContact(a, b, collision)
	Weapon:beginContact(a, b, collision)
end

function weaponCollision(Weapon, Enemy)
	Weapon.checkCollision(Weapon, Enemy)

end

function endContact(a, b, collision)
	Player:endContact(a, b, collision)
end

