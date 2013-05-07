STRICT = true
DEBUG = true

require 'zoetrope'
require 'game' 

the.app = App:new
{
    onRun = function (self)
         self.view = Game:new()
    end
}
