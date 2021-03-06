Tile = require 'Entities.tile'

local textBodies = {}

local Level = Class{
   MAP_NAMES = {
      "1",
      "demo",
      "subway",
   };
   init = function(self, mapIndex)
      mapName = self.MAP_NAMES[mapIndex]

      -- Pull in the .map file info
      self.map = {}
      local lineNum = 0
      for line in love.filesystem.lines("Levels/" .. mapName .. ".map") do
         lineNum = lineNum + 1
         self.map[lineNum] = {}
         for i = 1, #line do
            local c = line:sub(i,i)
            self.map[lineNum][i] = Tile(c, (i - 1) * 30, (lineNum - 1) * 30)
         end
      end
      
      -- Pull in the .text file info
      self.texts = {}
      local lineNum = 0
      for line in love.filesystem.lines("Levels/" .. mapName .. ".texts") do
         lineNum = lineNum + 1
         for i = 1, #line do
            local c = line:sub(i,i)
            local posX, posY = (i - 1) * Tile.SIZE, (lineNum - 1) * Tile.SIZE
            local text = {}
            if c ~= ' ' then
               textBody = textBodies[mapName][c]
               if textBody == nil then
                  print("WARN: unknown text index " .. c)
               else
                  text = Text(posX, posY, textBody)
                  table.insert(self.texts, text)
               end
            end
         end
      end

      -- Pull in the .characters file info
      self.characters = {}
      local lineNum = 0
      for line in love.filesystem.lines("Levels/" .. mapName .. ".characters") do
         lineNum = lineNum + 1
         for i = 1, #line do
            local c = line:sub(i,i)
            if c ~= ' ' then
               local posX, posY = (i - 1) * 30, (lineNum - 1) * 30
               local char = {}
               if c == 'P' then
                  char = Player(posX, posY)
               elseif c == 'm' then
                  char = Monster(posX, posY)
               elseif c == 'c' then
                  char = Civilian(posX, posY)
               elseif c == 'p' then
                  char = Pill(posX, posY)
               elseif c == 'x' then
                  char = Exit(posX, posY)
               elseif c ~= ' ' then
                  print("WARN: unknown character tile " .. key)
               end
               if char ~= {} then
                  table.insert(self.characters, char)
               end
            end
         end
      end
   end;

   draw = function(self, time)
      for x=1, #self.map do
         for y=1, #self.map[x] do
            self.map[x][y]:draw(time)
         end
      end
   end;
}

for _, level in ipairs(Level.MAP_NAMES) do
   textBodies[level] = require ('Levels.' .. level .. 'text-bodies')
end

return Level
