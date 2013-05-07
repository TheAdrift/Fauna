require 'zoetrope'
require 'Player' 
require 'Dragon' 
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
	gameView:loadLayers(mapName)
    gameView.focus = the.hero
    gameView:clampTo(gameView.map)
end

-- The overall game logic. 
-- The game is characterized as a view to which we will load one or more stages into.
 
Game = View:extend
{

	-- Create the view, load the initial map. 
    onNew = function (self)
        LoadMap ( self, 'map_' .. gameStage .. '.lua' ) 
    end,

	-- Update the view, handle colision, etc. 
	onUpdate = function (self)
		self.map:displace(the.hero)
		self.objects:collide(self.objects)

		if not the.hero.active then
			the.app.view = EndingView:new{ won = false }
		end
		
		-- if we have slain the dragon
		if not the.dragon.active then
			-- if we are at the final stage we win
			if gameStage == finalStage then 
				the.app.view = EndingView:new{ won = true }
			-- otherwise, move on to the next stage
			else 
				gameStage = gameStage + 1
				LoadMap ( self, 'map_' .. gameStage .. '.lua' , the.hero )
			end
		end
	end
}



