

local Map = {}
local STI = require("sti")
local Spike = require("spike")
local Stone = require("stone")
local Coin = require("coin")

local Player = require("player")
--local Weapon = require("weapon")

function Map:load()
	self.currentLevel = 1
	World = love.physics.newWorld(0,1500)
	World:setCallbacks(beginContact, endContact)
	
	self:init()
end

function Map:init()
	self.level = STI("map/"..self.currentLevel..".lua", {"box2d"})
	self.level:box2d_init(World)
	self.solidLayer = self.level.layers.solid
	self.groundLayer = self.level.layers.ground
	self.entityLayer = self.level.layers.entity
	
	self.solidLayer.visible = false
	self.entityLayer.visible = false
	
	
	MapWidth = self.groundLayer.width * 16
	
	self:spawnEntities()
	
end

function Map:next()
	self:clean()
	self.currentLevel = self.currentLevel + 1
	self:init()
end

function Map:clean()
	self.level:box2d_removeLayer("solid")
	Coin.removeAll()
	Stone.removeAll()
	Spike.removeAll()
	Player:resetPosition()
end

function Map:update()
	if Player.x > MapWidth - 16 then
		self:next()
	end
end

function Map:draw()
	self:tutorial()
end

function Map:spawnEntities()
	for i,v in ipairs(self.entityLayer.objects) do
		if v.type == "spikes" then
			Spike.new(v.x + v.width / 2, v.y + v.height / 2)
		elseif v.type == "stone" then
			Stone.new(v.x + v.width / 2, v.y + v.height / 2)
		elseif v.type == "coin" then
			Coin.new(v.x, v.y)
		end
	end
end



--function Map:spawnEnemies()
--	for i,v in ipairs(self.enemyLayer.objects) do
--		if v.type == "enemy" then
--			Enemy.new(v.x + v.width / 2, v.y + v.height / 2)
--		end
--	end
--end

return Map