push =
{
	up = "w",
	left = "a",
	down = "s",
	right = "d",
	crouch = "lshift",
	jump = " ",
	use = "j",
	hit = "k",
	dash = "rshift",
	dodge = "l"
}

default =
{
	accel = 1000,
	maxSpeed = 300, --player accelerates to this. Doubled when dashing, halved when crouched.
	gravity = 1600, --downward acceleration while player is inAir.
	jumpForce = 600, --upward force when player first jumps.
	frict = 1280
}


Body = Group:extend
{
	--values to initialize position.
	start_x = 0,
	start_y = 0,
	
	--Some private variables for movement calculations.
	altitude = 0,
	jumpSpeed = 0,
	
	state =
	{
		inAir = false,
		isCrouch = false,
		isDash = false,
		isDodge = false,
		isJump = false,
		isFall = false,
		isHurt = false,
		onWall = false,
		--queue represents the amount of time, in seconds, before another move can be entered.
		queue = 0,
		--faces takes one of eight string vals: "N", "NE", "E", "SE", "S", "SW", "W", "NW"
		faces = "S"
	},
	
	--[[cFloor = Fill:extend
	{
		width = 32,
		height = 32,
		drag = {x = default.frict, y = default.frict},
		maxSpeed = default.maxSpeed
	},

	cBody = Fill:extend
	{
		width = 32,
		height = 64
	},

	onNew = function (self)
		self.cFloor = Body.cBody:new{x = self.start_x, y = self.start_y }
		self.cBody = Body.cBody:new()
		self:add(self.cFloor)
		self:add(self.cBody)
	end,--]]
	
	accelerate = function ( spr, dir, accel )
	--[[ A function that accelerates a sprite in the direction passed.
	spr: Target Sprite to be accelerated.
	dir: Compass direction to accelerate. May only take string values of "N", "NE", "E", "SE", "S", "SW", "W", "NW"
	accel: Acceleration value, in pixels per second per second. ]]
	
		if dir == "NE" then
			--accelerate NE
			spr.maxVelocity.x = math.sqrt((spr.maxSpeed^2)/2)
			spr.minVelocity.y = -(math.sqrt((spr.maxSpeed^2)/2))
			spr.acceleration = {x = math.sqrt((accel^2)/2), y = -(math.sqrt((accel^2)/2))}

		elseif dir == "NW" then
			--accelerate NW
			spr.minVelocity = {x = -(math.sqrt((spr.maxSpeed^2)/2)), y = -(math.sqrt((spr.maxSpeed^2)/2))}
			spr.acceleration = {x = -(math.sqrt((accel^2)/2)), y = -(math.sqrt((accel^2)/2))}

		elseif dir == "N" then
			--accelerate due North
			spr.minVelocity.y = -(spr.maxSpeed)
			spr.acceleration.y = -(accel)
			spr.acceleration.x = 0
			
		elseif dir == "SE" then
			--accelerate SE
			spr.maxVelocity = {x = math.sqrt((spr.maxSpeed^2)/2), y = math.sqrt((spr.maxSpeed^2)/2)}
			spr.acceleration = {x = math.sqrt((accel^2)/2), y = math.sqrt((accel^2)/2)}

		elseif dir == "SW" then
			--accelerate SW
			spr.minVelocity.x = -(math.sqrt((spr.maxSpeed^2)/2))
			spr.maxVelocity.y = math.sqrt((spr.maxSpeed^2)/2)
			spr.acceleration = {x = -(math.sqrt((accel^2)/2)), y = math.sqrt((accel^2)/2)}

		elseif dir == "S" then
			--accelerate due South
			spr.maxVelocity.y = spr.maxSpeed
			spr.acceleration.y = accel
			spr.acceleration.x = 0

		elseif dir == "E" then
			--accelerate due East
			spr.maxVelocity.x = spr.maxSpeed
			spr.acceleration.x = accel
			spr.acceleration.y = 0

		elseif dir == "W" then
			--accelerate due West
			spr.minVelocity.x = -(spr.maxSpeed)
			spr.acceleration.x = -(accel)
			spr.acceleration.y = 0
		
		end
	end,
	
	move = function ( spr, dir, vel )
		--[[Directly alter a sprite's velocity in the direction passed.
		This is mostly for convenience.
		*N.B.: This will also change the Max velocity values accordingly.
		spr: Sprite to be moved.
		dir: Compass direction of movement change. Must take a string value of "N", "NE", "E", "SE", "S", "SW", "W", or "NW".
		vel: Unsigned amount, in pixels per second, by which the sprite's current velocity will change.]]
		if dir == "N" then
			self.minVelocity.y = self.minVelocity.y - vel
			self.velocity.y = self.velocity.y - vel

		elseif dir == "S" then
			self.maxVelocity.y = self.maxVelocity.y + vel
			self.velocity.y = self.velocity.y + vel

		elseif dir == "W" then
			self.minVelocity.x = self.minVelocity.x - vel
			self.velocity.x = self.velocity.x - vel
		
		elseif dir == "E" then
			self.maxVelocity.x = self.maxVelocity.x + vel
			self.velocity.x = self.velocity.x + vel
		
		elseif dir == "NW" then
			self.minVelocity = {x = self.minVelocity.x -math.sqrt((vel^2)/2), y = self.minVelocity.y -math.sqrt((vel^2)/2)}
			self.velocity = {x = self.velocity.x -math.sqrt((vel^2)/2), y = self.velocity.y -math.sqrt((vel^2)/2)}
		
		elseif dir == "NE" then
			self.minVelocity.y = self.minVelocity.y -math.sqrt((vel^2)/2)
			self.maxVelocity.x = self.maxVelocity.y + math.sqrt((vel^2)/2)
			self.velocity = {x = self.velocity.x + math.sqrt((vel^2)/2), y = self.velocity.y -math.sqrt((vel^2)/2)}
		
		elseif dir == "SE" then
			self.maxVelocity = {x = self.maxVelocity.x + math.sqrt((vel^2)/2), y = self.maxVelocity.x + math.sqrt((vel^2)/2)}
			self.velocity = {x = self.velocity.x + math.sqrt((vel^2)/2), y = self.velocity.y + math.sqrt((vel^2)/2)}
		
		elseif dir == "SW" then
			self.minVelocity.x = self.minVelocity.x -math.sqrt((vel^2)/2)
			self.maxVelocity.y = self.maxVelocity.y + math.sqrt((vel^2)/2)
			self.velocity = {x = self.velocity.x -math.sqrt((vel^2)/2), y = self.velocity.y + math.sqrt((vel^2)/2)}
		
		end
	
	end,

	onEndFrame = function (self, elapsed)
		--Position the body collider relative to the floor collider.
		self.cBody.x = self.cFloor.x
		self.cBody.y = self.cFloor.y - (self.cBody.height - (self.cFloor.height/2)) - self.altitude
		self.altitude = self.altitude + self.jumpSpeed*elapsed
		--Falling.
		if self.state.inAir then
			self.jumpSpeed = self.jumpSpeed - default.gravity*elapsed
		else
			self.jumpSpeed = 0
		end

	end
}


Player = Body: extend
{
	accel = default.accel,
	dodge = default.jumpForce,
	maxSpeed = default.maxSpeed,
	
	onNew = function (self)
		self.cFloor = Player.cFloor:new{x = self.start_x, y = self.start_y }
		self.cBody = Player.cBody:new()
		self:add(self.cFloor)
		self:add(self.cBody)
	end,
	
	cFloor = Fill:extend
	{
		width = 32,
		height = 32,
		fill = {0, 0, 255, 255},
		drag = {x = default.frict, y = default.frict},
		maxVelocity = {x = default.maxSpeed, y = default.maxSpeed},
		minVelocity = {x = -default.maxSpeed, y = -default.maxSpeed}
	},

	cBody = Fill:extend
	{
		width = 32,
		height = 64,
		fill = {0, 0, 255, 0},
		border = {0, 0, 255, 255}
	},
	
	onUpdate = function(self, dT)
		--change state based on button presses.
		if the.keys:pressed (push.crouch) then
			self.state.isCrouch = true
			self.state.isDash = false
		elseif the.keys:pressed (push.dash) and not self.state.isDodge then
			self.state.isDash = true
			self.state.isCrouch = false
		else
			self.state.isCrouch = false
			self.state.isDash = false
		end
		
		--Moving.
		if self.state.isDash then
			--double movement speed
			self.accel = default.accel * 2
			self.maxSpeed = default.maxSpeed * 2

		elseif self.state.isCrouch then
			--halve movement speed
			self.accel = default.accel / 2
			self.maxSpeed = default.maxSpeed / 2

		else
			--set movement speed to default
			self.accel = default.accel
			self.maxSpeed = default.maxSpeed
		end

		if self.state.isDodge then
			self.cFloor.acceleration = {x = 0, y = 0}
		end

		if the.keys:pressed (push.up)then
			if the.keys:pressed (push.right) and not the.keys:pressed (push.left) then
				--accelerate NE
				self:accelerate ( self.cFloor, "NE", self.accel )
				self.state.faces = "NE"

			elseif the.keys:pressed (push.left) and not the.keys:pressed (push.right) then
				--accelerate NW
				self:accelerate ( self.cFloor, "NW", self.accel )
				self.state.faces = "NW"

			else
				--accelerate due North
				self:accelerate ( self.cFloor, "N", self.accel )
				self.state.faces = "N"
			end

		elseif the.keys:pressed (push.down) then
			if the.keys:pressed (push.right) and not the.keys:pressed (push.left) then
				--accelerate SE
				self:accelerate ( self.cFloor, "SE", self.accel )
				self.state.faces = "SE"

			elseif the.keys:pressed (push.left) and not the.keys:pressed (push.right) then
				--accelerate SW
				self:accelerate ( self.cFloor, "SW", self.accel )
				self.state.faces = "SW"

			else
				--accelerate due South
				self:accelerate ( self.cFloor, "S", self.accel )
				self.state.faces = "S"
			end

		elseif the.keys:pressed (push.right) and not the.keys:pressed (push.left) then
			--accelerate due East
			self:accelerate ( self.cFloor, "E", self.accel )
			self.state.faces = "E"

		elseif the.keys:pressed (push.left) and not the.keys:pressed (push.right) then
			--accelerate due West
			self:accelerate ( self.cFloor, "W", self.accel )
			self.state.faces = "W"

		else
			--cancel x- and y-acceleration
			self.maxVelocity = {x = self.maxSpeed, y = self.maxSpeed}
			self.minVelocity = {x = -self.maxSpeed, y = -self.maxSpeed}
			self.acceleration = {x = 0, y = 0}
		end

		
		--Dodging
		---[[
		if self.state.isDodge then
			--decrease friction for the duration of the dodge.
			--decrement the queue.
			self.state.queue = self.state.queue - dT
			if self.state.queue <= 0 then
			--release control over velocity.
				self.state.queue = 0
				self.minVelocity = {x = -self.maxSpeed, y = -self.maxSpeed}
				self.maxVelocity = {x = self.maxSpeed, y = self.maxSpeed}
				self.state.isDodge = false
			end
		end
		--]]

		--For now, I'm implementing dodge as a simple leap into whatever direction the player is facing.
		--Later, I would like to try using key combinations for more robust behaviour.
		---[[
		if the.keys:justPressed (push.dodge) and not self.state.isDodge and not self.state.inAir then
			self.state.isDodge = true
			self.state.queue = .5
			self.jumpSpeed = default.jumpForce/3
			self.state.inAir = true
			
			--Dodge in direction player is facing.
			self:move (self.cFloor, self.state.faces, self.dodge)
		end
		--]]
	end,

	--[[
	onEndFrame = function (self, elapsed)
		self:align (self, elapsed)
	end--]]
}
