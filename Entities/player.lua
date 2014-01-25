Tile = require 'Entities.tile'

local Player = Class{
   init = function(self, x, y)
      if self.player then
         print("ERR: player already created!!")
      end
      -- self.position is hardcoded. What we really want is something passed
      -- in from the level that says the player's starting position (and
      -- that can be fairly easily done)
      self.position = Vector(x, y)
      self.image = love.graphics.newImage('Assets/player.png')
      self.direction = Vector(0, 0) -- Start off standing still.

      self.boundingBox = Collider:addRectangle(
         self.position.x - Tile.SIZE / 2,
         self.position.y - Tile.SIZE / 2,
         Tile.SIZE,
         Tile.SIZE)

      Player.player = self
   end;
   
   update = function(self, dt)
      player.position.x = player.position.x + player.direction.x
      player.position.y = player.position.y + player.direction.y
      self.boundingBox:moveTo(self.position.x, self.position.y)
   end;

   draw = function(self, time)
      love.graphics.draw(self.image, self.position.x - Tile.SIZE / 2, self.position.y - Tile.SIZE, 0, 1, 1, Tile.SIZE / 2, Tile.SIZE)
   end;
   
   fire = function(self, targetX, targetY)
      local target = Vector(targetX, targetY)
      local direction = target - self.position
      return Missile(self.position.x, self.position.y - Tile.SIZE, direction)
   end;
   MOVE_DISTANCE = 1;
   player = nil;
}

return Player

