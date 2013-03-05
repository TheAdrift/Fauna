March 4, 2013 *UPDATE*

v0.000___________________________________

Added a movement engine test as a Construct 2 project folder and as a compressed .capx file. Download either to preview them in Construct 2 (stable release 119).

The compressed file is: v0_00_test.capx

Test includes some colored boxes to represent collision detectors and a couple objects with the "Solid" property for funsies.

Relevant variables and event sheets are accessible through Construct 2.

For now, use space to jump and arrow keys to move. We'll hook these into a more flexible control scheme later.

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