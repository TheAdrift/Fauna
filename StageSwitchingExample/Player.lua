require 'zoetrope'

-- A structure representing our intreped hero. Who is now just a door.
Hero = Tile:extend
{
    image = 'mapobjects.png',
    --[[
    onUpdate = function (self)
        self.velocity.x = 0
        self.velocity.y = 0

        if the.keys:pressed('up') then
            self.velocity.y = -200
        elseif the.keys:pressed('down') then
            self.velocity.y = 200
        end

        if the.keys:pressed('left') then
            self.velocity.x = -200
        elseif the.keys:pressed('right') then
            self.velocity.x = 200
        end
    end--]]
}
