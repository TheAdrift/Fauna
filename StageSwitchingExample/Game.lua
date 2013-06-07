require 'zoetrope'
require 'Player'  
require 'Chest'
require 'EndingView' 

-- Some useful global variables

gameStage = 1
finalStage = 2

-- A function which will load up a new stage in a view.
-- Arguments are: 
-- gameView: the view to have a new map loaded. 
-- mapName: the filename containing the map. 
-- focusObject: the object of focus (ideally the player)

function LoadMap( gameView, mapName )
	--clear the previously loaded map before drawing the new one.
	---[[NB: if you check the debugger trace, this apparently does nothing. Will want to address that at some point.
	if gameView:contains (gameView.map) then
		gameView:remove(gameView.map)
	end
	if gameView:contains (gameView.objects) then
		gameView:remove(gameView.objects)
	end--]]
	gameView:loadLayers(mapName)
	--gameView.focus = gameView.pBody
	gameView:clampTo(gameView.map)
end

-- The overall game logic. 
-- The game is characterized as a view to which we will load one or more stages into.

---[[
Game = View:extend
{

	-- Create the view, load the initial map. 
    onNew = function (self)
        LoadMap ( self, 'map_' .. gameStage .. '.lua' ) 
---[[	Add our player to the view in the appropriate spot.
        self.pFloor = FloorCollider:new{x = 288, y = 96}
        self.pBody = BodyCollider:new()
		self.stageWon = false
        self:add(self.pFloor)
        self:add(self.pBody)
        self.focus = self.pBody --]]
    end,

	-- Update the view, handle colision, etc. 
	onUpdate = function (self)

		--self.objects:collide(self.objects)
		self:collide(self.pFloor)
		--self.objects:collide(self.pBody)

		if not self.pBody.active then
			the.app.view = EndingView:new{ won = false }
		end
		
		if self.stageWon then 
			if gameStage == finalStage then 
				the.app.view = EndingView:new{ won = true }
			-- otherwise, move on to the next stage
			else 
				gameStage = gameStage + 1
				LoadMap ( self, 'map_' .. gameStage .. '.lua' )
				---[[ Move our player to the correct position and draw above the new map tiles.
				self.pFloor.x = 320
				self.pFloor.y = 96
				self:moveToFront (self.pFloor)
				self:moveToFront (self.pBody)
				self.stageWon = false
				--]]
				--[[ the above four lines are identical to these, except that here
				-- the references are explicit. I'm keeping these for now, for clarity's sake
				the.app.view.pFloor.x = the.hero.x
				the.app.view.pFloor.y = the.hero.y
				the.app.view:moveToFront (the.app.view.pFloor)
				the.app.view:moveToFront (the.app.view.pBody)--]]
			end
		end
	end
}
