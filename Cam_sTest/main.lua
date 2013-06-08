STRICT = true
DEBUG = true

require 'zoetrope'
---[[
require 'Body'
--]]
--a dictionary for KeyConstant strings. Not elegant, since the.keys:pressed
--handles these directly, but a dictionary can be configured at runtime and passed to the.keys

--[[
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
--]]

--[[
--a dictionary for player state information.
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
}
--]]

--a dictionary for some default values we may like to reference.
--[[
default =
{
	accel = 1000,
	maxSpeed = 300, --player accelerates to this. Doubled when dashing, halved when crouched.
	gravity = 1600, --downward acceleration while player is inAir.
	jumpForce = 600, --upward force when player first jumps.
	frict = 1280
} --]]
--[[
FloorCollider = Fill:extend
{
	width = 32,
	height = 32,
	fill = {0, 0, 255, 255},
	drag = {x = default.frict, y = default.frict},
	maxVelocity = {x = default.maxSpeed, y = default.maxSpeed},
	minVelocity = {x = -default.maxSpeed, y = -default.maxSpeed},
	--Some new private variables.
	accel = default.accel,
	dodge = default.jumpForce,
	maxSpeed = default.maxSpeed,
	
	onUpdate = function(self, dT)
		--change state based on button presses.
		if the.keys:pressed (push.crouch) then
			state.isCrouch = true
			state.isDash = false
		elseif the.keys:pressed (push.dash) and not state.isDodge then
			state.isDash = true
			state.isCrouch = false
		else
			state.isCrouch = false
			state.isDash = false
		end
		
		--Moving.
		if state.isDash then
			--double movement speed
			self.accel = default.accel * 2
			self.maxSpeed = default.maxSpeed * 2

		elseif state.isCrouch then
			--halve movement speed
			self.accel = default.accel / 2
			self.maxSpeed = default.maxSpeed / 2

		else
			--set movement speed to default
			self.accel = default.accel
			self.maxSpeed = default.maxSpeed
		end

		if state.isDodge then
            self.acceleration = {x = 0, y = 0}
            
        else
        
			if the.keys:pressed (push.up)then
				if the.keys:pressed (push.right) and not the.keys:pressed (push.left) then
					--accelerate NE
					self.maxVelocity.x = math.sqrt((self.maxSpeed^2)/2)
					self.minVelocity.y = -(math.sqrt((self.maxSpeed^2)/2))
					self.acceleration = {x = math.sqrt((self.accel^2)/2), y = -(math.sqrt((self.accel^2)/2))}
					state.faces = "NE"

				elseif the.keys:pressed (push.left) and not the.keys:pressed (push.right) then
					--accelerate NW
					self.minVelocity = {x = -(math.sqrt((self.maxSpeed^2)/2)), y = -(math.sqrt((self.maxSpeed^2)/2))}
					self.acceleration = {x = -(math.sqrt((self.accel^2)/2)), y = -(math.sqrt((self.accel^2)/2))}
					state.faces = "NW"

				else
					--accelerate due North
					self.minVelocity.y = -(self.maxSpeed)
					self.acceleration.y = -(self.accel)
                    self.acceleration.x = 0
					state.faces = "N"
				end

			elseif the.keys:pressed (push.down) then
				if the.keys:pressed (push.right) and not the.keys:pressed (push.left) then
					--accelerate SE
					self.maxVelocity = {x = math.sqrt((self.maxSpeed^2)/2), y = math.sqrt((self.maxSpeed^2)/2)}
					self.acceleration = {x = math.sqrt((self.accel^2)/2), y = math.sqrt((self.accel^2)/2)}
					state.faces = "SE"

				elseif the.keys:pressed (push.left) and not the.keys:pressed (push.right) then
					--accelerate SW
					self.minVelocity.x = -(math.sqrt((self.maxSpeed^2)/2))
					self.maxVelocity.y = math.sqrt((self.maxSpeed^2)/2)
					self.acceleration = {x = -(math.sqrt((self.accel^2)/2)), y = math.sqrt((self.accel^2)/2)}
					state.faces = "SW"

				else
					--accelerate due South
					self.maxVelocity.y = self.maxSpeed
					self.acceleration.y = self.accel
                    self.acceleration.x = 0
					state.faces = "S"
				end

			elseif the.keys:pressed (push.right) and not the.keys:pressed (push.left) then
				--accelerate due East
				self.maxVelocity.x = self.maxSpeed
				self.acceleration.x = self.accel
                self.acceleration.y = 0
				state.faces = "E"

			elseif the.keys:pressed (push.left) and not the.keys:pressed (push.right) then
				--accelerate due West
				self.minVelocity.x = -(self.maxSpeed)
				self.acceleration.x = -(self.accel)
                self.acceleration.y = 0
				state.faces = "W"

			else
				--cancel x- and y-acceleration
				self.maxVelocity = {x = self.maxSpeed, y = self.maxSpeed}
				self.minVelocity = {x = -self.maxSpeed, y = -self.maxSpeed}
				self.acceleration = {x = 0, y = 0}
			end
		end
		
		--Dodging
		---
		if state.isDodge then
			--decrease friction for the duration of the dodge.
			--self.drag = {x = self.drag.x*0.8, y = self.drag.y*0.8}
			--decrement the queue.
			state.queue = state.queue - dT
			if state.queue <= 0 then
			--release control over velocity.
				state.queue = 0
				self.minVelocity = {x = -self.maxSpeed, y = -self.maxSpeed}
				self.maxVelocity = {x = self.maxSpeed, y = self.maxSpeed}
				--self.drag = {x = default.frict, y = default.frict}
				state.isDodge = false
			end
		end
		--

		--For now, I'm implementing dodge as a simple leap into whatever direction the player is facing.
		--Later, I would like to try using key combinations for more robust behaviour.
		---
		if the.keys:justPressed (push.dodge) and not state.isDodge and not state.inAir then
			state.isDodge = true
			state.queue = .5
			the.app.pBody.jumpSpeed = default.jumpForce/3
			state.inAir = true
			
			--get direction player is facing.
			if state.faces == "N" then
				--dodge appropriately.
				self.minVelocity.y = self.minVelocity.y - self.dodge
				self.velocity.y = self.velocity.y - self.dodge

			elseif state.faces == "S" then
				self.maxVelocity.y = self.maxVelocity.y + self.dodge
				self.velocity.y = self.velocity.y + self.dodge

			elseif state.faces == "W" then
				self.minVelocity.x = self.minVelocity.x - self.dodge
				self.velocity.x = self.velocity.x - self.dodge
			
			elseif state.faces == "E" then
				self.maxVelocity.x = self.maxVelocity.x + self.dodge
				self.velocity.x = self.velocity.x + self.dodge
			
			elseif state.faces == "NW" then
				self.minVelocity = {x = self.minVelocity.x -math.sqrt((self.dodge^2)/2), y = self.minVelocity.y -math.sqrt((self.dodge^2)/2)}
				self.velocity = {x = self.velocity.x -math.sqrt((self.dodge^2)/2), y = self.velocity.y -math.sqrt((self.dodge^2)/2)}
			
			elseif state.faces == "NE" then
				self.minVelocity.y = self.minVelocity.y -math.sqrt((self.dodge^2)/2)
				self.maxVelocity.x = self.maxVelocity.y + math.sqrt((self.dodge^2)/2)
				self.velocity = {x = self.velocity.x + math.sqrt((self.dodge^2)/2), y = self.velocity.y -math.sqrt((self.dodge^2)/2)}
			
			elseif state.faces == "SE" then
				self.maxVelocity = {x = self.maxVelocity.x + math.sqrt((self.dodge^2)/2), y = self.maxVelocity.x + math.sqrt((self.dodge^2)/2)}
				self.velocity = {x = self.velocity.x + math.sqrt((self.dodge^2)/2), y = self.velocity.y + math.sqrt((self.dodge^2)/2)}
			
			elseif state.faces == "SW" then
				self.minVelocity.x = self.minVelocity.x -math.sqrt((self.dodge^2)/2)
				self.maxVelocity.y = self.maxVelocity.y + math.sqrt((self.dodge^2)/2)
				self.velocity = {x = self.velocity.x -math.sqrt((self.dodge^2)/2), y = self.velocity.y + math.sqrt((self.dodge^2)/2)}
			
			end
		end
		--
	end
}

BodyCollider = Fill:extend
{
	width = 32,
	height = 64,
	fill = {0, 0, 255, 0},
	border = {0, 0, 255, 255},
	altitude = 0,
	jumpSpeed = 0,
	
	onUpdate = function (self, dT)
		--Move the player collider relative to the floor collider.
		self.x = the.app.pFloor.x
		self.y = the.app.pFloor.y - (self.height - (the.app.pFloor.height/2)) - self.altitude
		self.altitude = self.altitude + self.jumpSpeed*dT
		--Falling.
		if state.inAir then
			self.jumpSpeed = self.jumpSpeed - default.gravity*dT
		else
			self.jumpSpeed = 0
		end
		
		if self.jumpSpeed < 0 then
			state.isFall = true
		else
			state.isFall = false
		end
		
		if self.altitude <= 0 then
			self.altitude = 0
			state.inAir = false
			state.isFall = false
		end
		--Jumping
		if the.keys:justPressed (push.jump) and not state.inAir then --removing "and not state.inAir" results in infinite air-jumping.
			self.jumpSpeed = default.jumpForce
			state.inAir = true
		end
	end
}

the.app = App:new
{
	--create and draw all instances.
	onRun = function (self)
		self.pFloor = FloorCollider:new{x = 128, y = 128 }
		self:add(self.pFloor)
		self.pBody = BodyCollider:new{x = 0, y = 0}
		self:add(self.pBody)
	end
}
--]]

the.app = App:new
{
	onRun = function (self)
		self.player = Player:new{start_x = 128, start_y = 128 }
		self:add(self.player)
	end
}
