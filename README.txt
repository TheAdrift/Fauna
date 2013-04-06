April 6, 2013 *UPDATE*

v0.000___________________________________

Going forward, we are no longer using the Construct2 engine, so I have removed the relevant files. 

As of now the team is deciding between Unity3D with a 2-d toolkit such as Orthello, and the LÖVE framework. I've created empty "../assets" and "../maps" directories since both of the above solutions can leverage similar assets, including the TILED map editor.

Added Zoetrope library files ( http://libzoetrope.org ) for development with LÖVE engine ( http://love2d.org ). "main.lua" is ready for editing, though not edited yet. I'll write a movement script to replace it for the next update.

_________________________________________TheAdrift


February 23, 2013

v0.000___________________________________

Hello, World, and welcome to (working title) Fauna. Fauna is an experimental game collaboration, with an ecosystem "hook." At time of writing, we are using Scirra's Construct2 engine for prototyping.

Our intentions are to make this an action-platform game with a rudimentary ecological simulation running behind the scenes. There will be entities to represent a "native" and an "invasive" ecosystem that must be managed for the player to survive, divided as follows:

	Native:				|	Invasive:
	-Flora-		Passive		|	-Fungi-		Passive
					|
	   Plants that generate oxygen	|	   Toxic overgrowth. Will infect
	   and feed herbivores.		|	   and damage player. Will infect
	   They reproduce steadily to 	|	   adjacent tiles and vulnerable
	   claim territory.		|	   Flora to claim territory.
					|	
	-Herbivores-	Active		|	-Infected-	Active
					|	
	   Eat Flora, preferring less	|	   Fauna that carry Fungal spores.
	   sturdy specimens. Reproduce	|	   May infect tiles as they pass.
	   quickly and in great numbers.|	   May attack other fauna. Will
	   Can damage player.		|	   spawn 1 tile of Fungi on death.
					|	
	-Predators-	Active		|
					|
	   Solitary hunters. Eat	|
	   herbivores, may hunt player.	|
	   Reproduce slowly to manage	|
	   food supply. Very dangerous.	|

_________________________________________TheAdrift