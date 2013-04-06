STRICT = true
DEBUG = true

require 'zoetrope'

the.app = App:new
{
	onNew = function (self)
		self:add(Text:new
		{
			y = 300, width = the.app.width, align = 'center',
			text = 'Welcome to Zoetrope! Edit main.lua to get started.'
		})
	end
}
