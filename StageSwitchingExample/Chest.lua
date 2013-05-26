require 'zoetrope'

-- A structure representing a treasure chest. 
Chest = Tile:extend
{
    image = 'mapobjects.png',
    imageOffset = { x = 32, y = 0 },
    onCollide = function (self, other)
        if other:instanceOf(BodyCollider) then
            if self.hasSword then
                other.hasSword = true
                the.view:flash({0, 255, 0}, 1)
            end

            self:die()
        end
    end
}
