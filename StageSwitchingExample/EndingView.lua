EndingView = View:extend
{
    onNew = function (self)
        local message

        if self.won then
            message = 'Congratulations! You reached the goal!'
        else
            message = 'You fell to your death. :c'
        end

        self:add(Text:new{ x = 0, y = 300, width = the.app.width, text = message, align = 'center' })
    end
}
