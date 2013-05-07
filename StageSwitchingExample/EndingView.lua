EndingView = View:extend
{
    onNew = function (self)
        local message

        if self.won then
            message = 'Congratulations! You have slain the dragon.'
        else
            message = 'Sorry! The dragon ate you. Try looking for a sword.'
        end

        self:add(Text:new{ x = 0, y = 300, width = the.app.width, text = message, align = 'center' })
    end
}
