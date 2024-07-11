
local GUI = {}
local Player = require("player")
local Weapon = require("weapon")
local Map = require("map")


function GUI:load()
	self.coins = {}
	self.coins.img = love.graphics.newImage("assets/coin.png")
	self.coins.width = self.coins.img:getWidth()
	self.coins.height = self.coins.img:getHeight()
	self.coins.scale = 2.5
	self.coins.x = love.graphics.getWidth() - 200
	self.coins.y = 50

	self.inventoryWidth = 640
	self.inventoryHeight = 360
	
	self.hearts = {}
	self.hearts.img = love.graphics.newImage("assets/heart.png")
	self.hearts.width = self.hearts.img:getWidth()
	self.hearts.height = self.hearts.img:getHeight()
	self.hearts.x = 0
	self.hearts.y = 50
	self.hearts.scale = 2
	self.hearts.spacing = self.hearts.width *self.hearts.scale + 30

	self.invOpen = false
	
	self.font = love.graphics.newFont("assets/bit.ttf", 36)
	self.font2 = love.graphics.newFont("assets/PixelOperator.ttf", 24)
	self.font3 = love.graphics.newFont("assets/arial.ttf", 24)
end

function GUI:update(dt)

end

function GUI:draw()
	self:displayCoins()
	self:displayCoinText()
	self:displayHearts()
end

function GUI:cheatInv(key)
	if key == "z" and self.invOpen == false then
		self.invOpen = true
	elseif key == "z" and self.invOpen == true then
		self.invOpen = false
	end
end

function GUI:inventory()
	if self.invOpen then
		love.graphics.setFont(self.font2)
		love.graphics.setColor(0,0,0,1)
		love.graphics.setLineWidth(3)
		love.graphics.rectangle("line", self.inventoryWidth/2, self.inventoryHeight/2, 640, 360)
		love.graphics.setColor(0,0,0,0.5)
		love.graphics.rectangle("fill", self.inventoryWidth/2, self.inventoryHeight/2, 640, 360)
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("U : + PULOS", self.inventoryWidth/2 + 10, self.inventoryHeight/2 + 10)
		love.graphics.print("J : REEMBOLSO", self.inventoryWidth/2 + 10, self.inventoryHeight/2 + 40)
		love.graphics.print("PULOS: "..Player.moreJump, self.inventoryWidth/2 + 10, self.inventoryHeight/2 + 70)
		love.graphics.print("I : + VIDA", self.inventoryWidth + 10, self.inventoryHeight/2 + 10)
		love.graphics.print("K : REEMBOLSO", self.inventoryWidth + 10, self.inventoryHeight/2 + 40)
		love.graphics.print("VIDAS: "..Player.lifeCheats, self.inventoryWidth + 10, self.inventoryHeight/2 + 70)
		love.graphics.print("O : + DANO", self.inventoryWidth/2 + 10, self.inventoryHeight/2 + 140)
		love.graphics.print("L : REEMBOLSO", self.inventoryWidth/2 + 10, self.inventoryHeight/2 + 170)
		love.graphics.print("DANO: "..Weapon.cheatDamage, self.inventoryWidth/2 + 10, self.inventoryHeight/2 + 200)
	end
end


function GUI:drawTutorialMessage()
	if Map.currentLevel == 1 then
    	if Player.x > 258 and Player.x < 320 and Player.y > 140 then
			local y = 360
        	love.graphics.setFont(self.font2)
        	love.graphics.setColor(1, 1, 1, 1)
        	love.graphics.print("Bem-vindo ao jogo!", 460, y + 20)
			love.graphics.print("Pressione 'A' para mover para a esquerda", 360, y + 40)
			love.graphics.print("e 'D' para mover para a direita.", 360, y + 60)
			love.graphics.print("Use 'W' para pular", 360, y + 80)
			love.graphics.print("Use 'W' novamente no ar para pulo duplo", 360, y + 100)
    	end
	end
	if Map.currentLevel == 1 then
    	if Player.x > 752 and Player.x < 816 and Player.y > 140 then
        	love.graphics.setFont(self.font2)
        	love.graphics.setColor(1, 1, 1, 1)
        	love.graphics.print("Você coletou uma moeda!", 460, 360)
			love.graphics.print("Aperte a tecla 'Z' para ver o que pode melhorar.", 460, 380)
			--love.graphics.print("Aperte 'J' para reembolsar a moeda (e o pulo extra).", 460, 400)
    	end
	end
	if Map.currentLevel == 2 then
    	if Player.x > 2848 and Player.x < 2944 and Player.y > 140 then
        	love.graphics.setFont(self.font2)
        	love.graphics.setColor(1, 1, 1, 1)
        	love.graphics.print("Você encontrou um inimigo, é o cobrão do Python!", 460, 320)
			love.graphics.print("Você terá que batalhar contra ele para prosseguir.", 460, 340)
			love.graphics.print("Aperte a tecla 'spacebar' para executar um ataque.", 460, 360)
			--love.graphics.print("Aperte 'J' para reembolsar a moeda (e o pulo extra).", 460, 400)
    	end
	end		
end

function GUI:endMessage()
	if Map.currentLevel == 4 then
		love.graphics.setFont(self.font3)
        	love.graphics.setColor(1, 1, 1, 1)
        	love.graphics.print("VŎCÊ DE͍R̸̼͖R̯̪O̺TͭO̐Uͦ̑̅ JAV̵͆͘Ā̕, MȀ̮S͊ͭ A̲̋ǸT̫ͦ͞E͙͜S DE̮ P̨̧͡A̺ͤRT̖ͨ͊I̽̕R̠͛ͦ E͎L̙E͔̔ͬ A͌M̥ͣA̮LDÌÇ̃ͥO̗ͬ͌ỌÚ", 240, 200)
			love.graphics.setColor(1, 1, 0, 1)
			love.graphics.print("S̩U̇ͥĂ̫̜ M̧ͯ̑Áͭ̌Q͝Ù̹IN̮̓͜A E̊ͧ C͔͊O͛N̓͜T̏͆Î̹ͤNͧOͪͤ͟U͛̋ R̆O͙͜͟D̝̏AN̮͓͛D̦̀ͬO̎ E̬̬͆M̐͋ S̥͇͊EGU̽ǸDO͆ͥ P̈́̂L̰̗̲A̩NO͇͚͌ ", 250, 280)
			love.graphics.print("T̢̀͝R̂A̐̿̇VA͉N͌D̨̯̊Oͤ TͭUD͈O E͈ͧ Ả͖CAB͙A͉N͙͓DO̹ C̉OM͕͓ͯ T̡͚ͪO̪͊D͖O̭ SͦȆ̔Uͪͬ͜ P̻R̟͡O͚̥GRE̖ͅS̜͐̓S͖ͧ̅O̿͝.̸͑̚ ", 250, 350)
			love.graphics.setColor(0, 1, 1, 1)
			love.graphics.print(" A̷ PARͪT͒Iͦ͗ͫR͓̤͑ DAQU̬Ǐ S̷͇Û̙͌A̢ Ú͘NI͚͌͘C̨̓ͪA̩ ", 350, 410)
			love.graphics.setColor(1, 0, 1, 1)
			love.graphics.print("É̊͘S͂͌C̩͆AP͖̝A͔ͩT̹Ó̻R̸̐̈I̸͊͗A̻̪͐ Éͧ FͦIN̷̨̿AL̸I̽ͪZ̒AR̽̓ D͊Eͬ̅́ UMA̛ V̴ͭ̌EZ̽ P͎ͨ͟OR T̳O̠̙D̥́AS̀͢ E̻SS̼ͦE̋ PR̘͛̄O̊̊G̫̖͘RǍ̙̣M̯̌A A̳MͣͧĄͤL͉ͮ̓D͡I̞̔ÇŌȀ̝̖DO̭̙͌", 150, 490)
	end
end

function GUI:displayHearts()
	for i=1, Player.health.current do
		local x = self.hearts.x + self.hearts.spacing * i
		love.graphics.setColor(0,0,0,0.5)
		love.graphics.draw(self.hearts.img, x + 2, self.hearts.y + 2, 0, self.hearts.scale)
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(self.hearts.img, x, self.hearts.y, 0, self.hearts.scale)
	end

end

function GUI:displayCoins()
	love.graphics.setColor(0,0,0,0.5)
	love.graphics.draw(self.coins.img, self.coins.x + 2, self.coins.y + 2, 0, self.coins.scale, self.coins.scale)
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)
end

function GUI:displayCoinText()
	love.graphics.setFont(self.font)
	local x = self.coins.x + self.coins.width * self.coins.scale 
	local y = self.coins.y + self.coins.height / 2 * self.coins.scale - self.font:getHeight() / 2
	love.graphics.setColor(0,0,0,0.5)
	love.graphics.print(" : "..Player.coins, x + 2, y + 2)
	love.graphics.setColor(1,1,1,1)
	love.graphics.print(" : "..Player.coins, x, y)
end

return GUI