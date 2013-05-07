require 'zoetrope'

-- A structure representing a dragon. 
Dragon = Tile:extend
{
    image = 'dragon.png',
    onCollide = function (self, other)
        if other:instanceOf(Hero) then
            if other.hasSword then
                self:die()
            else
                other:die()
            end
        end
    end
}