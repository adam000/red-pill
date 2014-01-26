image = love.graphics.newImage('Assets/monster1.png')

local Civilian = Class{
   __includes = {Character};
   init = function(self, x, y)
      self:setPositionFromTopLeft(x, y)
      self.image = image
      self:addBoundingBox()
      self.health = 3
      self.damage = 0
		self.destination = self:randomNearbyPoint()
   end;
   
   update = function(self, dt)
      self:checkMissiles()
		
		local movementDirection = self.destination - self.position
		local newLocation = movementDirection:normalized() * self.MOVE_DISTANCE * dt
		if math.abs(movementDirection.x) < 2 and math.abs(movementDirection.y) < 2 then
			self.destination = self:randomNearbyPoint()
		end
		self:move(newLocation.x, newLocation.y)
   end;
   
   checkMissiles = function(self)
      for i, missile in ipairs(missiles) do
         if self.boundingBox:collidesWith(missile.boundingBox) then
            self.health = self.health - missile.damage
            table.remove(missiles, i)
         end
      end
   end;
	
	randomNearbyPoint = function(self)
		local maxDistance = 1 * self.MOVE_DISTANCE
		local destination = self.position + Vector(
			math.random(-maxDistance, maxDistance),
			math.random(-maxDistance, maxDistance))
		if DEBUG then
			print(string.format('Heading to (%s, %s) from (%s, %s)!',
				destination.x, destination.y,
				self.position.x, self.position.y))
		end
		return destination
	end;
   
   effect = function(self)
      return -self.damage
   end;

   VISION_DISTANCE = 3 * Tile.SIZE;
   MOVE_DISTANCE = 2 * Tile.SIZE;
}

return Civilian

